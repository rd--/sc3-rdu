prefix=$(HOME)/opt

all:
	(cd cpp; make all)

install:
	(cd cpp; make install)

clean:
	rm -fR dist
	(cd cpp; make clean)

ln-sc:
	ln -s $(HOME)/sw/sc3-rdu/sc/rdu.sc $(prefix)/share/SuperCollider/Extensions

push-sp:
	darcs push -a rd@slavepianos.org:sw/sc3-rdu

pull-sp:
	darcs pull -a http://rd.slavepianos.org/sw/sc3-rdu
