all:
	echo "sc3-rdu"

update-submodules:
	git submodule foreach git pull

mk-cmd:
	echo "sc3-rdu - NIL"

mk-ugen:
	(cd cpp; make all install)

mk-ugen-cmake:
	(mkdir -p build ; cd build ; cmake -DSC_PATH=$(HOME)/opt/src/supercollider/supercollider .. ; make)

clean:
	rm -fR dist dist-newstyle *~
	( cd cpp; make clean )
	rm -fR build

push-all:
	r.gitlab-push.sh sc3-rdu
	r.github-push.sh sc3-rdu

push-tags:
	r.gitlab-push.sh sc3-rdu --tags
	r.github-push.sh sc3-rdu --tags

indent:
	(cd cpp ; make indent)
	(cd hs ; make indent)

doctest:
	doctest -Wno-x-partial -Wno-incomplete-uni-patterns hs/Sound
