#include <math.h>

#include <SC_PlugIn.h>

#include "rdu.h"

#define float_Pi ((float)M_PI)

/* Obxd : AudioUtils.h */
inline static float tptpc(float& state,float inp,float cutoff)
{
	double v = (inp - state) * cutoff / (1 + cutoff);
	double res = v + state;
	state = res + v;
	return res;
}

/* Obxd : Filter.h */
class Filter
{
private:
	float s1,s2,s3,s4;
	float R;
	float R24;
	float rcor,rcorInv;
	float rcor24,rcor24Inv;

	//24 db multimode
	float mmt;
	int mmch;
public:
	float SampleRate;
	float sampleRateInv;
	bool bandPassSw;
	float mm;
	bool selfOscPush;
	Filter()
	{
		selfOscPush = false;
		bandPassSw = false;
		mm=0;
		s1=s2=s3=s4=0;
		SampleRate = 44000;
		sampleRateInv = 1 / SampleRate;
		rcor =500.0 / 44000;
		rcorInv = 1 / rcor;
		rcor24 = 970.0 / 44000;
		rcor24Inv = 1 / rcor24;
		R=1;
		R24=0;
	}
	void setMultimode(float m)
	{
		mm = m;
		mmch = (int)(mm * 3);
		mmt = mm*3-mmch;
	}
	inline void setSampleRate(float sr)
	{
		SampleRate = sr;
		sampleRateInv = 1/SampleRate;
		float rcrate =sqrt((44000/SampleRate));
		rcor = (500.0 / 44000)*rcrate;
		rcor24 = (970.0 / 44000)*rcrate;
		rcorInv = 1 / rcor;
		rcor24Inv = 1 / rcor24;
	}
	inline void setResonance(float res)
	{
		R = 1-res;
		R24 =( 3.5 * res);
	}

	inline float diodePairResistanceApprox(float x)
	{
		return (((((0.0103592f)*x + 0.00920833f)*x + 0.185f)*x + 0.05f )*x + 1.0f);
		//Taylor approx of slightly mismatched diode pair
	}
	//resolve 0-delay feedback
	inline float NR(float sample, float g)
	{
		//calculating feedback non-linear transconducance and compensated for R (-1)
		//Boosting non-linearity
		float tCfb;
		if(!selfOscPush)
			tCfb = diodePairResistanceApprox(s1*0.0876f) - 1.0f;
		else
			tCfb = diodePairResistanceApprox(s1*0.0876f) - 1.035f;
		//float tCfb = 0;
		//disable non-linearity == digital filter

		//resolve linear feedback
		float y = ((sample - 2*(s1*(R+tCfb)) - g*s1  - s2)/(1+ g*(2*(R+tCfb)+ g)));

		//float y = ((sample - 2*(s1*(R+tCfb)) - g2*s1  - s2)/(1+ g1*(2*(R+tCfb)+ g2)));

		return y;
	}
	inline float Apply(float sample,float g)
        {

			float gpw = tanf(g *sampleRateInv * float_Pi);
			g = gpw;
            //float v = ((sample- R * s1*2 - g2*s1 - s2)/(1+ R*g1*2 + g1*g2));
			float v = NR(sample,g);

            float y1 = v*g + s1;
            s1 = v*g + y1;

			float y2 = y1*g + s2;
			s2 = y1*g + y2;

            float mc;
			if(!bandPassSw)
            mc = (1-mm)*y2 + (mm)*v;
			else
			{

				mc =2 * ( mm < 0.5 ?
					((0.5 - mm) * y2 + (mm) * y1):
					((1-mm) * y1 + (mm-0.5) * v)
						);
			}

			return mc;
        }
	inline float NR24(float sample,float g,float lpc)
	{
		float ml = 1 / (1+g);
		float S = (lpc*(lpc*(lpc*s1 + s2) + s3) +s4)*ml;
		float G = lpc*lpc*lpc*lpc;
		float y = (sample - R24 * S) / (1 + R24*G);
		return y;
	}
	inline float Apply4Pole(float sample,float g)
	{
			float g1 = (float)tan(g *sampleRateInv * float_Pi);
			g = g1;



			float lpc = g / (1 + g);
			float y0 = NR24(sample,g,lpc);
			//first low pass in cascade
			double v = (y0 - s1) * lpc;
			double res = v + s1;
			s1 = res + v;
			//damping
			s1 =atan(s1*rcor24)*rcor24Inv;

			float y1= res;
			float y2 = tptpc(s2,y1,g);
			float y3 = tptpc(s3,y2,g);
			float y4 = tptpc(s4,y3,g);
			float mc;
			switch(mmch)
			{
			case 0:
				mc = ((1 - mmt) * y4 + (mmt) * y3);
				break;
			case 1:
				mc = ((1 - mmt) * y3 + (mmt) * y2);
				break;
			case 2:
				mc = ((1 - mmt) * y2 + (mmt) * y1);
				break;
			case 3:
				mc = y1;
				break;
			default:
				mc=0;
				break;
			}
			//half volume comp
			return mc * (1 + R24 * 0.45);
	}
};

/* SC3 */
static InterfaceTable *ft;

struct RObxdFilter : public Unit
{
    Filter m_flt;
};

rdu_prototypes(RObxdFilter);

void RObxdFilter_Ctor(RObxdFilter *unit)
{
    unit->m_flt.setSampleRate(SAMPLERATE);
    SETCALC(RObxdFilter_next);
    RObxdFilter_next(unit, 1);
}

void RObxdFilter_next(RObxdFilter *unit,int inNumSamples)
{
    float *in = IN(0);
    float *out = OUT(0);
    float cutoff = IN0(1);
    unit->m_flt.setResonance(IN0(2));
    unit->m_flt.setMultimode(IN0(3));
    unit->m_flt.bandPassSw = (bool)(IN0(4) > 0.5);
    bool four_pole = (bool)(IN0(5) > 0.5);
    if(four_pole) {
        for(int i = 0; i < inNumSamples; i++) {
            out[i] = unit->m_flt.Apply4Pole(in[i],cutoff);
        }
    } else {
        for(int i = 0; i < inNumSamples; i++) {
            out[i] = unit->m_flt.Apply(in[i],cutoff);
        }
    }
}

rdu_load(RObxdFilter);
