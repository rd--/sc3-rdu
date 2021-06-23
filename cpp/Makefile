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
    RBezier.so \
    RDelayMap.so \
    RDelaySet.so \
    RDelaySetBuf.so \
    RDL.so \
    RDustR.so \
    RDX7.so \
    RDX7Env.so \
    RExpRandN.so \
    RFreezer.so \
    RIRandN.so \
    RLagC.so \
    RLinRandN.so \
    RLoopSet.so \
    RObxdFilter.so \
    RPVDecayTbl.so \
    RRandN.so \
    RShufflerB.so \
    RShufflerL.so \
    RSmplrIndex.so \
    RSVFBP.so \
    RSVFHP.so \
    RSVFLP.so \
    RTExpRandN.so \
    RTLinRandN.so \
    RTracePlay.so \
    RTraceRd.so \
    RTRandN.so \
    RTScramble.so

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

