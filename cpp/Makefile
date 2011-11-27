PREFIX = $(HOME)
SC3_INCL = -I$(PREFIX)/include/SuperCollider/plugin_interface \
           -I$(PREFIX)/include/SuperCollider/common
CPP_OPT = -O2 -ffast-math -mmmx -msse -funroll-loops
PLUGINS = DustR.so RDelayMap.so RFreezer.so RLoopSet.so RShufflerB.so RShufflerL.so
LIB = c-common/lib-c-common.a

%.o : %.cpp
	g++ -Wall $(CPP_OPT) $(SC3_INCL) -c -shared $<

%.so : %.o
	ld $< -lm -shared -o $@

all:	$(PLUGINS)

clean:
	rm -f $(PLUGINS)

install: $(PLUGINS)
	cp $(PLUGINS) $(PREFIX)/lib/SuperCollider/plugins
