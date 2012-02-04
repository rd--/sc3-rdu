D = $(HOME)/opt
T = $(D)/lib/SuperCollider/plugins
I = -I$(D)/include/SuperCollider/plugin_interface \
    -I$(D)/include/SuperCollider/common
O = -O2 -ffast-math -mmmx -msse -funroll-loops
P = DustR.so \
    RDelayMap.so \
    RDelaySet.so RDelaySetB.so \
    RFreezer.so \
    RLoopSet.so \
    RShufflerB.so RShufflerL.so
L = c-common/lib-c-common.a

%.o : %.cpp
	g++ -Wall $(O) $(I) -c -shared $<

%.so : %.o
	ld $< -lm -shared -o $@

all:	$(P)

clean:
	rm -f $(P)

install: $(P)
	cp $(P) $(T)

uninstall:
	(cd $(T) ; rm -f $(P))
