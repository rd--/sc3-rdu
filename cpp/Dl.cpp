#include <dlfcn.h>
#include <stdio.h>

#include "Dl.h"
#include "rdu.h"

static InterfaceTable *ft;

#define Dl_NAME_MAX 512

struct Dl_Command {
	Unit *unit;
	char dl_name[Dl_NAME_MAX];
};

bool dl_cmd_stage2(World *w, Dl_Command *cmd)
{
	Dl *unit = (Dl *)cmd->unit;
	printf("dl_cmd_stage2\n");
	unit->m_online = false;
	unit->m_dsp_step = NULL;
	if (unit->m_dsp_fd) {
		printf("->dlclose()\n");
		dlclose(unit->m_dsp_fd);
	}
	printf("->dlopen(%s)\n", cmd->dl_name);
	unit->m_dsp_fd = dlopen(cmd->dl_name, RTLD_LAZY);
	if (unit->m_dsp_fd == NULL) {
		printf("->dlerror=%s", dlerror());
		return false;
	}
	printf("->m_dsp_fd=%p\n", unit->m_dsp_fd);
	int (*memreq_f)() = (int (*)())dlsym(unit->m_dsp_fd, "dsp_memreq");
	void (*init_f)(void *) = (void (*)(void *))dlsym(unit->m_dsp_fd, "dsp_init");
	void *step_f = dlsym(unit->m_dsp_fd, "dsp_step");
	printf("->dlsym(memreq)=%p\n", (void *)memreq_f);
	printf("->dlsym(init)=%p\n", (void *)init_f);
	printf("->dlsym(step)=%p\n", step_f);
	if (memreq_f == NULL || init_f == NULL || step_f == NULL) {
		printf("->dlerror=%s", dlerror());
		return false;
	}
	printf("->memreq_f()\n");
	size_t k = memreq_f();
	printf("->k=%zd\n", k);
	if (unit->m_dsp_st) {
		RTFree(w, unit->m_dsp_st);
	}
	unit->m_dsp_st = (void *)RTAlloc(w, k);
	printf("->rtalloc=%p\n", unit->m_dsp_st);
	printf("->init_f()\n");
	init_f(unit->m_dsp_st);
	unit->m_dsp_step = (void (*)(void *, int))step_f;
	return true;
}

bool dl_cmd_stage3(World *world, Dl_Command *cmd)
{
	printf("dl_cmd_stage3\n");
	Dl *unit = (Dl *)cmd->unit;
	if (unit->m_dsp_step) {
		unit->m_online = true;
		printf("->online = true\n");
	} else {
		printf("->dl_cmd_stage2 failed, offline...\n");
	}
	return true;
}

bool dl_cmd_stage4(World *world, Dl_Command *cmd)
{
	return true;
}

void dl_cmd_cleanup(World *world, void *cmd)
{
	RTFree(world, cmd);
}

/* stage2 = NRT, stage3 = RT, stage4 = NRT */
void dl_g_load(Unit *unit, struct sc_msg_iter *args)
{
	Dl *u = (Dl *)unit;
	const char *arg = args->gets();
	printf("dl_g_load: %s\n", arg);
	u->m_online = false;
	Dl_Command *c = (Dl_Command *)RTAlloc(u->mWorld, sizeof(Dl_Command));
	c->unit = unit;
	strncpy(c->dl_name, arg, Dl_NAME_MAX - 1);
	DoAsynchronousCommand(u->mWorld, 0, "", (void *)c,
		(AsyncStageFn)dl_cmd_stage2,
		(AsyncStageFn)dl_cmd_stage3,
		(AsyncStageFn)dl_cmd_stage4,
		dl_cmd_cleanup,
		0, 0);
}

void Dl_next(Dl *unit, int inNumSamples)
{
	if (unit->m_online) {
		unit->m_dsp_step(unit, inNumSamples);
	} else {
		rdu_zero_outputs();
	}
}

void Dl_Ctor(Dl *unit)
{
	unit->m_online = false;
	unit->m_dsp_fd = NULL;
	unit->m_dsp_step = NULL;
	unit->m_dsp_st = NULL;
	DefineUnitCmd("Dl", "/g_load", dl_g_load);
	SETCALC(Dl_next);
	Dl_next(unit, 1);
}

void Dl_Dtor(Dl *unit)
{
	unit->m_online = false;
}

rdu_load_dtor_noalias(Dl)
