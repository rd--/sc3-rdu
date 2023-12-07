prefix = $(HOME)/opt

CXX = g++ # g++ clang++
CPPFLAGS = -Wall -pedantic -O3 -fPIC -ffast-math -march=native
CXXFLAGS = -std=c++11

D = $(prefix)
T = $(D)/lib/SuperCollider/plugins
S = $(D)/src/supercollider/supercollider/include
I = -I$(S)/plugin_interface \
    -I$(S)/common
P = Bezier.so \
    BufMemCpy.so \
    BufSort.so \
    DelayMap.so \
    DelaySet.so \
    DelaySetBuf.so \
    Demultiplexer.so \
    Dl.so \
    DustRange.so \
    Dx7.so \
    Dx7Env.so \
    EnvTrapezoid.so \
    ExpRandN.so \
    Freezer.so \
    IRandN.so \
    LagC.so \
    LinRandN.so \
    LoopSet.so \
    Multiplexer.so \
    MVerb.so \
    ObxdFilter.so \
    PV_Split.so \
    PV_DecayTable.so \
    PinkingFilterPk3.so \
    RandN.so \
    SamplerIndex.so \
    ShufflerB.so \
    ShufflerL.so \
    SvfBp.so \
    SvfHp.so \
    SvfLp.so \
    TableRand.so \
    TExpRandN.so \
    TLinRand.so \
    TLinRandN.so \
    TRandN.so \
    TrigAllocator.so \
    TrigRoundRobin.so \
    TScramble.so \
    TSort.so \
    TracePlay.so \
    TraceRead.so \
    WDistances.so \
    WkNearest.so

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
	clang-format -i *.cpp

diff-ignoring-whitespace:
	git diff --ignore-space-at-eol --ignore-space-change --ignore-all-space

mk-rdx7-sf:
	$(CXX) -O0 -Wall -g rdx7-sf.cpp -lsndfile -o rdx7-sf

mk-rdx7-env-sf:
	$(CXX) -O0 -Wall -g rdx7-env-sf.cpp -lsndfile -o rdx7-env-sf

mk-robdx-sf:
	$(CXX) -O0 -Wall -g robdx-sf.cpp -lsndfile -o robdx-sf

