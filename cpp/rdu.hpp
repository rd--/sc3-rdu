#include <functional>

#include <SC_PlugIn.h>

typedef std::function<float(int)> GetInput;

GetInput genGet(Unit *unit, int k)
{
	GetInput getInput;
	if (unit->mInput[k]->mCalcRate == calc_FullRate) {
		getInput = [&unit, k](int i) {
			return unit->mInBuf[k][i];
		};
	} else {
		getInput = [&unit, k](int i) {
			return unit->mInBuf[k][0];
		};
	}
	return getInput;
}

inline float getInput(Unit *unit, int k, int i)
{
	if (unit->mInput[k]->mCalcRate == calc_FullRate) {
		return unit->mInBuf[k][i];
	} else {
		return unit->mInBuf[k][0];
	}
}
