prefix = $(HOME)/opt

CXX = g++ # g++ clang++
CPPFLAGS = -Wall -pedantic -O3 -fPIC -ffast-math -march=native
CXXFLAGS = -std=c++11

D = $(prefix)
T = $(D)/lib/SuperCollider/plugins
S = /usr/include/SuperCollider
I = -I$(S)/plugin_interface \
    -I$(S)/common
P = PV_Split.so \
    Bezier.so \
    BufMemCpy.so \
    DX7.so \
    DustRange.so \
    ExpRandN.so \
    Freezer.so \
    IRandN.so \
    LinRandN.so \
    ObxdFilter.so \
    RDL.so \
    RDX7Env.so \
    RDelayMap.so \
    RDelaySet.so \
    RDelaySetBuf.so \
    RLagC.so \
    RLoopSet.so \
    RPVDecayTbl.so \
    RShufflerL.so \
    RSmplrIndex.so \
    RTracePlay.so \
    RTraceRd.so \
    RandN.so \
    ShufflerB.so \
    SvfBp.so \
    SvfHp.so \
    SvfLp.so \
    TExpRandN.so \
    TLinRandN.so \
    TRandN.so \
    TScramble.so

L = r-common/c/lib-r-common.a

%.o : %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(I) -c $<

%.so : %.o
	ld $< -lm -shared -o $@

all:	$(P)

clean:
	rm -f $(P) *.orig *~ dx7/*.o dx7/*.a

install: $(P)
	mkdir -p $(T)
	cp $(P) $(T)

uninstall:
	(cd $(T) ; rm -f $(P))

indent:
	bcpp -yb -bcl RPVDecay.cpp

mk-rdx7-sf:
	$(CXX) -O0 -Wall -g rdx7-sf.cpp -lsndfile -o rdx7-sf

mk-rdx7-env-sf:
	$(CXX) -O0 -Wall -g rdx7-env-sf.cpp -lsndfile -o rdx7-env-sf

mk-robdx-sf:
	$(CXX) -O0 -Wall -g robdx-sf.cpp -lsndfile -o robdx-sf

