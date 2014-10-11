#include <dlfcn.h>
#include <stdio.h>
#include "rdu.h"
#include "RDL.h"

static InterfaceTable *ft;

extern "C" {
  void RDL_next(RDL *unit, int inNumSamples);
  void RDL_Ctor(RDL* unit);
  void RDL_Dtor(RDL* unit);
}

struct RDL_Command {
  Unit *unit;
  char dl_name[512];
};

bool rdl_cmd_stage2(World* w, RDL_Command* cmd) {
  RDL *unit = (RDL *)cmd->unit;
  printf("rdl_cmd_stage2\n");
  unit->m_online = false;
  unit->m_dsp_step = NULL;
  if (unit->m_dsp_fd) {
    printf("->dlclose()\n");
    dlclose(unit->m_dsp_fd);
  }
  printf("->dlopen(%s)\n",cmd->dl_name);
  unit->m_dsp_fd = dlopen(cmd->dl_name, RTLD_LAZY);
  if (unit->m_dsp_fd == NULL) {
    printf("->dlerror=%s",dlerror());
    return false;
  }
  printf("->m_dsp_fd=%p\n",unit->m_dsp_fd);
  int (*memreq_f)() = (int(*)()) dlsym(unit->m_dsp_fd, "dsp_memreq");
  void (*init_f)(void *) = (void (*)(void *)) dlsym(unit->m_dsp_fd, "dsp_init");
  void *step_f = dlsym(unit->m_dsp_fd, "dsp_step");
  printf("->dlsym(memreq)=%p\n",memreq_f);
  printf("->dlsym(init)=%p\n",init_f);
  printf("->dlsym(step)=%p\n",step_f);
  if(memreq_f == NULL || init_f == NULL || step_f == NULL) {
    printf("->dlerror=%s",dlerror());
    return false;
  }
  printf("->memreq_f()\n");
  size_t k = memreq_f();
  printf("->k=%zd\n",k);
  if(unit->m_dsp_st) {
      RTFree(w, unit->m_dsp_st);
  }
  unit->m_dsp_st = (void*)RTAlloc(w, k);
  printf("->rtalloc=%p\n",unit->m_dsp_st);
  printf("->init_f()\n");
  init_f(unit->m_dsp_st);
  unit->m_dsp_step = (void (*)(void*, int)) step_f;
  return true;
}

bool rdl_cmd_stage3(World* world, RDL_Command* cmd) {
  printf("rdl_cmd_stage3\n");
  RDL* unit = (RDL *)cmd->unit;
  if(unit->m_dsp_step) {
    unit->m_online = true;
    printf("->online = true\n");
  } else {
    printf("->rdl_cmd_stage2 failed, offline...\n");
  }
  return true;
}

bool rdl_cmd_stage4(World* world, RDL_Command* cmd) {
  return true;
}

void rdl_cmd_cleanup(World* world, void* cmd) {
  RTFree(world, cmd);
}

/* stage2 = NRT, stage3 = RT, stage4 = NRT */
void rdl_g_load (Unit *unit, struct sc_msg_iter *args) {
  RDL *u = (RDL*)unit;
  const char *arg = args->gets();
  printf("rdl_g_load: %s\n",arg);
  u->m_online = false;
  RDL_Command* c = (RDL_Command*)RTAlloc(u->mWorld, sizeof(RDL_Command));
  c->unit = unit;
  strncpy(c->dl_name,arg,512);
  DoAsynchronousCommand(u->mWorld, 0, "", (void*)c,
                        (AsyncStageFn)rdl_cmd_stage2,
                        (AsyncStageFn)rdl_cmd_stage3,
                        (AsyncStageFn)rdl_cmd_stage4,
                        rdl_cmd_cleanup,
                        0, 0);
}

void RDL_Ctor(RDL* unit) {
  unit->m_online = false;
  unit->m_dsp_fd = NULL;
  unit->m_dsp_step = NULL;
  unit->m_dsp_st = NULL;
  DefineUnitCmd("RDL","/g_load",rdl_g_load);
  SETCALC(RDL_next);
}

void RDL_next(RDL *unit, int inNumSamples) {
  if(unit->m_online) {
    unit->m_dsp_step(unit,inNumSamples);
  } else {
    rdu_zero_outputs();
  }
}

void RDL_Dtor(RDL* unit) {
  unit->m_online = false;
}

PluginLoad(RDL) {
  ft = inTable;
  DefineDtorCantAliasUnit(RDL);
}
