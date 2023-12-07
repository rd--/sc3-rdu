#include <SC_PlugIn.h>

extern void PV_Split_Load(InterfaceTable *table);
extern void RBezier_Load(InterfaceTable *table);
extern void RDelayMap_Load(InterfaceTable *table);
extern void RDelaySet_Load(InterfaceTable *table);
extern void RDelaySetBuf_Load(InterfaceTable *table);
extern void RDL_Load(InterfaceTable *table);
extern void RDustR_Load(InterfaceTable *table);
extern void RDX7_Load(InterfaceTable *table);
extern void RDX7Env_Load(InterfaceTable *table);
extern void RExpRandN_Load(InterfaceTable *table);
extern void RFreezer_Load(InterfaceTable *table);
extern void RIRandN_Load(InterfaceTable *table);
extern void RLagC_Load(InterfaceTable *table);
extern void RLinRandN_Load(InterfaceTable *table);
extern void RLoopSet_Load(InterfaceTable *table);
extern void RObxdFilter_Load(InterfaceTable *table);
extern void RPVDecayTbl_Load(InterfaceTable *table);
extern void RRandN_Load(InterfaceTable *table);
extern void RShufflerB_Load(InterfaceTable *table);
extern void RShufflerL_Load(InterfaceTable *table);
extern void RSmplrIndex_Load(InterfaceTable *table);
extern void RSVFBP_Load(InterfaceTable *table);
extern void RSVFHP_Load(InterfaceTable *table);
extern void RSVFLP_Load(InterfaceTable *table);
extern void RTExpRandN_Load(InterfaceTable *table);
extern void RTLinRandN_Load(InterfaceTable *table);
extern void RTracePlay_Load(InterfaceTable *table);
extern void RTraceRd_Load(InterfaceTable *table);
extern void RTRandN_Load(InterfaceTable *table);
extern void TScramble_Load(InterfaceTable *table);

void Rdu_Load(InterfaceTable *table)
{
	// PV_Split_Load(table);
	RBezier_Load(table);
	RDelayMap_Load(table);
	RDelaySet_Load(table);
	RDelaySetBuf_Load(table);
	RDL_Load(table);
	RDustR_Load(table);
	RDX7_Load(table);
	RDX7Env_Load(table);
	RExpRandN_Load(table);
	RFreezer_Load(table);
	RIRandN_Load(table);
	RLagC_Load(table);
	RLinRandN_Load(table);
	RLoopSet_Load(table);
	RObxdFilter_Load(table);
	RPVDecayTbl_Load(table);
	RRandN_Load(table);
	RShufflerB_Load(table);
	RShufflerL_Load(table);
	RSmplrIndex_Load(table);
	RSVFBP_Load(table);
	RSVFHP_Load(table);
	RSVFLP_Load(table);
	RTExpRandN_Load(table);
	RTLinRandN_Load(table);
	RTracePlay_Load(table);
	RTraceRd_Load(table);
	RTRandN_Load(table);
	TScramble_Load(table);
}
