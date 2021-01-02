#include <SC_PlugIn.h>

static InterfaceTable *ft;

/* ExpRandN */

struct ExpRandN : public Unit {};

void ExpRandN_Ctor(ExpRandN* unit)
{
  float l = IN0(0);
  float r = IN0(1);
  float z = r / l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    OUT0(i) = pow(z,rgen.frand()) * l;
  }
}

/* IRandN */

struct IRandN : public Unit {};

void IRandN_Ctor(IRandN* unit)
{
  int lo = (int)IN0(0);
  int hi = (int)IN0(1);
  int range = hi - lo + 1;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    OUT0(i) = (float)(rgen.irand(range) + lo);
  }
}

/* LinRandN */

struct LinRandN : public Unit {};

void LinRandN_Ctor(LinRandN* unit)
{
  float lo = IN0(0);
  float hi = IN0(1);
  int n = (int)IN0(2);
  float range = hi - lo;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    float a, b;
    a = rgen.frand();
    b = rgen.frand();
    if (n <= 0) {
      OUT0(i) = sc_min(a, b) * range + lo;
    } else {
      OUT0(i) = sc_max(a, b) * range + lo;
    }
  }
}

/* RandN */

struct RandN : public Unit {};

void RandN_Ctor(RandN* unit)
{
  float l = IN0(0);
  float r = IN0(1);
  float d = r - l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    OUT0(i) = rgen.frand() * d + l;
  }
}

/* TRandN */

struct TRandN : public Unit {float m_trig, *m_store;};

void TRandN_gen(TRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    float range = hi - lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
	unit->m_store[i] = rgen.frand() * range + lo;
    }
}

void TRandN_cpy(TRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void TRandN_next_k(TRandN* unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	TRandN_gen(unit);
    }
    TRandN_cpy(unit);
    unit->m_trig = trig;
}

void TRandN_Ctor(TRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    TRandN_gen(unit);
    TRandN_cpy(unit);
    SETCALC(TRandN_next_k);
    unit->m_trig = IN0(2);
    TRandN_next_k(unit, 1);
}

void TRandN_Dtor(TRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

/* TExpRandN */

struct TExpRandN : public Unit {float m_trig, *m_store;};

void TExpRandN_gen(TExpRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    float z = hi / lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
	unit->m_store[i] = pow(z,rgen.frand()) * lo;
    }
}

void TExpRandN_cpy(TExpRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void TExpRandN_next_k(TExpRandN* unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	TExpRandN_gen(unit);
    }
    TExpRandN_cpy(unit);
    unit->m_trig = trig;
}

void TExpRandN_Ctor(TExpRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    TExpRandN_gen(unit);
    TExpRandN_cpy(unit);
    SETCALC(TExpRandN_next_k);
    unit->m_trig = IN0(2);
    TExpRandN_next_k(unit, 1);
}

void TExpRandN_Dtor(TExpRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

/* LOAD */

PluginLoad(RandN)
{
  ft = inTable;
  DefineSimpleUnit(ExpRandN);
  DefineSimpleUnit(IRandN);
  DefineSimpleUnit(LinRandN);
  DefineSimpleUnit(RandN);
  DefineDtorUnit(TExpRandN);
  DefineDtorUnit(TRandN);
}
