/* Obxd : AudioUtils.h */
inline static float tptpc(float& state,float inp,float cutoff)
{
	double v = (inp - state) * cutoff / (1 + cutoff);
	double res = v + state;
	state = res + v;
	return res;
}
