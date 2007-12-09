%.o : %.cpp
	g++ `pkg-config --cflags libscsynth` -c -shared $<

%.so : %.o
	ld $< -lm -shared -o $@

PLUGINS = DustR.so RDelayMap.so
SC3LIB  = ~/lib/SuperCollider

all: $(PLUGINS)

clean:
	rm -f $(PLUGINS)

install: $(PLUGINS)
	cp $(PLUGINS) $(SC3LIB)/plugins
