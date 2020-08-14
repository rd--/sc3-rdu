prefix=$(HOME)/opt

all:
	echo "sc3-rdu"

mk-cmd:
	echo "sc3-rdu - NIL"

mk-ugen:
	(cd cpp; make all install)

clean:
	rm -fR dist
	(cd cpp; make clean)

ln-sc:
	ln -s $(HOME)/sw/sc3-rdu/sc/rdu.sc $(HOME)/.local/share/SuperCollider/Extensions

push-rd:
	darcs push -a rd@rohandrape.net:sw/sc3-rdu

pull-rd:
	darcs pull -a http://rohandrape.net/sw/sc3-rdu
