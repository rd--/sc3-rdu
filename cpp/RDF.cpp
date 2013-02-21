#include <dlfcn.h>
#include "RDF.h"

static InterfaceTable *ft;

struct RDF_Command {
  enum Type {RDF_Load};
  Type type;
  Unit *unit;
  char dl_name[512];
};

extern "C" {
  void RDF_next(RDF *unit, int inNumSamples);
  void RDF_Ctor(RDF* unit);
  void RDF_Dtor(RDF* unit);
}

/* stage2 = NRT */
bool rdf_cmd_stage2(World* inWorld, RDF_Command* cmd) {
  RDF *unit = (RDF *)cmd->unit;
  printf("rdf_cmd_stage2\n");
  switch (cmd->type) {
  case RDF_Command::RDF_Load:
    printf("->dlopen()\n");
    unit->m_rdf_fd = dlopen(cmd->dl_name, RTLD_LAZY);
    if (unit->m_rdf_fd) {
      printf("->dlsym(init)\n");
      void *init_f = dlsym(unit->m_rdf_fd, "dsp_init");
      printf("->dlsym(step)\n");
      void *step_f = dlsym(unit->m_rdf_fd, "dsp_step");
      unit->m_rdf_init = (void* (*)(void*, int)) init_f;
      unit->m_rdf_step = (void (*)(void*, int, int)) step_f;
      printf("->init\n");
      unit->m_rdf_st = unit->m_rdf_init(unit,0);
    } else {
      unit->m_rdf_step = NULL;
    }
    return true;
  }
  return false;
}

/* stage3 = RT */
bool rdf_cmd_stage3(World* world, RDF_Command* cmd) {
  printf("rdf_cmd_stage3\n");
  RDF* unit = (RDF *)cmd->unit;
  switch (cmd->type) {
  case RDF_Command::RDF_Load:
    if(unit->m_rdf_step) {
      unit->m_rdf_status = true;
    } else {
      printf("dlopen failed, offline...\n");
    }
    return true;
  }
  return true;
}

/* stage4 = NRT */
bool rdf_cmd_stage4(World* world, RDF_Command* cmd) {
  return true;
}

void rdf_cmd_cleanup(World* world, void* cmd) {
  RTFree(world, cmd);
}

void RDF_next(RDF *unit, int inNumSamples) {
  if(unit->m_rdf_st) {
    unit->m_rdf_step(unit,0,inNumSamples);
  }
}

void rdf_g_load (Unit *unit, struct sc_msg_iter *args) {
  RDF *u = (RDF*)unit;
  const char *arg = args->gets();
  printf("rdf_g_load: %s\n",arg);
  u->m_rdf_status = false;
  RDF_Command* c = (RDF_Command*)RTAlloc(u->mWorld, sizeof(RDF_Command));
  c->unit = unit;
  c->type = RDF_Command::RDF_Load;
  strncpy(c->dl_name,arg,512);
  DoAsynchronousCommand(u->mWorld, 0, "", (void*)c,
                        (AsyncStageFn)rdf_cmd_stage2,
                        (AsyncStageFn)rdf_cmd_stage3,
                        (AsyncStageFn)rdf_cmd_stage4,
                        rdf_cmd_cleanup,
                        0, 0);
}

void RDF_Ctor(RDF* unit) {
  unit->m_rdf_status = false;
  DefineUnitCmd("RDF","g_load",rdf_g_load);
  SETCALC(RDF_next);
}


void RDF_Dtor(RDF* unit) {
  unit->m_rdf_status = false;
}

PluginLoad(RDF) {
  ft = inTable;
  DefineDtorCantAliasUnit(RDF);
}
