clean:
	rm -fR dist
	(cd cpp; make clean)

push-sp:
	darcs push -a rd@slavepianos.org:sw/sc3-rdu

pull-sp:
	darcs pull -a http://rd.slavepianos.org/sw/sc3-rdu
