prefix=$(HOME)/opt

all:
	(cd cpp; make all)

install:
	(cd cpp; make install)

clean:
	rm -fR dist
	(cd cpp; make clean)

ln-sc:
	ln -s $(HOME)/sw/sc3-rdu/sc/rdu.sc $(HOME)/.local/share/SuperCollider/Extensions

push-rd:
	darcs push -a rd@rohandrape.net:sw/sc3-rdu

pull-rd:
	darcs pull -a http://rohandrape.net/sw/sc3-rdu
