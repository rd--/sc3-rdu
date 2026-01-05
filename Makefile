all:
	echo "sc3-rdu"

install:
	cabal v1-install --allow-newer

clean:
	rm -fR dist dist-newstyle *~
	( cd cpp; make clean )
	rm -fR build

update-submodules:
	git submodule foreach git pull

mk-cmd:
	echo "sc3-rdu - NIL"

mk-ugen:
	(cd cpp; make all install)

mk-ugen-cmake:
	(mkdir -p build ; cd build ; cmake -DSC_PATH=$(HOME)/opt/src/supercollider/supercollider .. ; make)

push-all:
	r.gitlab-push.sh sc3-rdu
	r.github-push.sh sc3-rdu

push-tags:
	r.gitlab-push.sh sc3-rdu --tags
	r.github-push.sh sc3-rdu --tags

indent:
	(cd cpp ; make indent)
	(cd hs ; make indent)
	spl-indent sc/*.sc

doctest:
	doctest -Wno-x-partial -Wno-incomplete-uni-patterns hs/Sound
