prefix = $(HOME)/opt

D = $(prefix)
T = $(D)/lib/SuperCollider/plugins
S = $(D)/include/SuperCollider
I = -I$(S)/plugin_interface \
    -I$(S)/common
O = -O2 -fPIC -ffast-math -mmmx -msse -funroll-loops
P = DustR.so \
    PV_Split.so \
    RandN.so \
    RBezier.so \
    RDelayMap.so \
    RDelaySet.so RDelaySetB.so \
    RDL.so \
    RFreezer.so \
    RLoopSet.so \
    RShufflerB.so RShufflerL.so \
    RTrace.so \
    TScramble.so

L = c-common/lib-c-common.a

%.o : %.cpp
	g++ -Wall -std=c++11 $(O) $(I) -c -shared $<

%.so : %.o
	ld $< -lm -shared -o $@

all:	$(P)

clean:
	rm -f $(P)

install: $(P)
	cp $(P) $(T)

uninstall:
	(cd $(T) ; rm -f $(P))

ln-c-common:
	rm -f c-common
	ln -s $(HOME)/sw/c-common .

indent:
	indent -kr -nut -l96 -i2 -brf RBezier.cpp
