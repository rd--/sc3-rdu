#include <stdio.h>
#include <FFT_UGens.h>

InterfaceTable *ft;

extern "C"
{
void load(InterfaceTable *inTable);
void PV_Split_Ctor(PV_Unit *unit);
void PV_Split_next(PV_Unit *unit, int inNumSamples);
}

void PV_Split_next(PV_Unit *unit, int inNumSamples)
{
	float fbufnum1 = ZIN0(0);
	float fbufnum2 = ZIN0(1);
	if (fbufnum1 < 0.f || fbufnum2 < 0.f) {
          ZOUT0(0) = -1.f;
          ZOUT0(1) = -1.f;
          return;
        }
	ZOUT0(0) = fbufnum1;
	ZOUT0(1) = fbufnum2;
	uint32 ibufnum1 = (int)fbufnum1;
	uint32 ibufnum2 = (int)fbufnum2;
	World *world = unit->mWorld;
	SndBuf *buf1;
	SndBuf *buf2;
	if (ibufnum1 >= world->mNumSndBufs) {
		int localBufNum = ibufnum1 - world->mNumSndBufs;
		Graph *parent = unit->mParent;
		if(localBufNum <= parent->localBufNum) {
			buf1 = parent->mLocalSndBufs + localBufNum;
		} else {
			buf1 = world->mSndBufs;
		}
	} else {
		buf1 = world->mSndBufs + ibufnum1;
	}
	if (ibufnum2 >= world->mNumSndBufs) {
		int localBufNum = ibufnum2 - world->mNumSndBufs;
		Graph *parent = unit->mParent;
		if(localBufNum <= parent->localBufNum) {
			buf2 = parent->mLocalSndBufs + localBufNum;
		} else {
			buf2 = world->mSndBufs;
		}
	} else {
		buf2 = world->mSndBufs + ibufnum2;
	}

	if (buf1->samples != buf2->samples) return;

	// copy to buf2
	LOCK_SNDBUF2_SHARED_EXCLUSIVE(buf1, buf2);
	buf2->coord = buf1->coord;
	memcpy(buf2->data, buf1->data, buf1->samples * sizeof(float));
}

void PV_Split_Ctor(PV_Unit *unit)
{
	SETCALC(PV_Split_next);
	ZOUT0(0) = ZIN0(0);
	ZOUT0(1) = ZIN0(1);
}

void init_SCComplex(InterfaceTable *inTable);

#define DefinePVUnit(name) (*ft->fDefineUnit)(#name, sizeof(PV_Unit), (UnitCtorFunc)&name##_Ctor, 0, 0);

PluginLoad(PV_Split)
{
  ft = inTable;
  init_SCComplex(inTable);
  DefinePVUnit(PV_Split);
}
