GL_GIT=git@gitlab.com:rd--/sc3-rdu.git
GL_HTTP=https://gitlab.com/rd--/sc3-rdu.git

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

push-gl:
	git push $(GL_GIT)

pull-gl:
	git pull $(GL_HTTP)

push-tags:
	git push $(GL_GIT) --tags

update-rd:
	ssh rd@rohandrape.net "(cd sw/sc3-rdu; git pull $(GL_HTTP))"

push-all:
	make push-gl update-rd
