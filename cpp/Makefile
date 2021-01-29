prefix = $(HOME)/opt

D = $(prefix)
T = $(D)/lib/SuperCollider/plugins
S = /usr/include/SuperCollider
I = -I$(S)/plugin_interface \
    -I$(S)/common
# amd64: -msse2
O = -O2 -fPIC -ffast-math
P = DustR.so \
    PV_Split.so \
    RandN.so \
    RBezier.so \
    RDelayMap.so \
    RDelaySet.so RDelaySetB.so \
    RDL.so \
    RDX7.so RDX7Env.so \
    RFreezer.so \
    RLagC.so \
    RLoopSet.so \
    RObxdFilter.so \
    RPVDecay.so \
    RShufflerB.so RShufflerL.so RSmplr.so \
    RTrace.so \
    TScramble.so

L = c-common/lib-c-common.a

CXX=g++ # g++ clang++

%.o : %.cpp
	$(CXX) -Wall -std=c++11 $(O) $(I) -c $<

%.so : %.o
	ld $< -lm -shared -o $@

all:	$(P)

clean:
	rm -f $(P) *.orig

install: $(P)
	mkdir -p $(T)
	cp $(P) $(T)

uninstall:
	(cd $(T) ; rm -f $(P))

ln-c-common:
	rm -f c-common
	ln -s $(HOME)/sw/c-common .

indent:
	bcpp -yb -bcl RPVDecay.cpp

mk-rdx7-sf:
	$(CXX) -O0 -Wall -g rdx7-sf.cpp -lsndfile -o rdx7-sf

mk-rdx7-env-sf:
	$(CXX) -O0 -Wall -g rdx7-env-sf.cpp -lsndfile -o rdx7-env-sf

mk-robdx-sf:
	$(CXX) -O0 -Wall -g robdx-sf.cpp -lsndfile -o robdx-sf

