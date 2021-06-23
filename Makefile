prefix=$(HOME)/opt

all:
	echo "sc3-rdu"

mk-cmd:
	echo "sc3-rdu - NIL"

mk-ugen:
	(cd cpp; make all install)

clean:
	rm -fR dist dist-newstyle *~
	(cd cpp; make clean)

push-all:
	git push git@gitlab.com:rd--/sc3-rdu.git
	git push git@github.com:rd--/sc3-rdu.git
	ssh rd@rohandrape.net "(cd sw/sc3-rdu; git pull https://gitlab.com/rd--/sc3-rdu.git)"

push-tags:
	git push git@gitlab.com:rd--/sc3-rdu.git --tags
