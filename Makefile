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
	r.gitlab-push.sh sc3-rdu
	r.github-push.sh sc3-rdu

push-tags:
	r.gitlab-push.sh sc3-rdu --tags
	r.github-push.sh sc3-rdu --tags
