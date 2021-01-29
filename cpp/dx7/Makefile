DEXED_DIR = $(HOME)/opt/src/dexed-0.9.4/Source

DEXED_CPP = EngineMkI

MSFA_H = aligned_buf controllers module synth

MFSA_CC = dx7note env exp2 fm_core fm_op_kernel freqlut lfo pitchenv sin

MFSA_O = $(MFSA_CC:=.o)

DX7_DIR = $(HOME)/sw/sc3-rdu/cpp/dx7

AR = ar # llvm-ar

all:
	echo "SEE MAKEFILE (make dexed-patch dexed-copy dexed-patch-sc3 dexed-obj dexed-ar)"

dexed-patch:
	(cd $(DEXED_DIR) ; patch -p1 < $(HOME)/sw/sc3-rdu/ext/patch/dexed-tuning-0.9.4.patch)

dexed-copy:
	(cd $(DEXED_DIR); cp -f $(DEXED_CPP:=.cpp) $(DEXED_CPP:=.h) $(DX7_DIR))
	(cd $(DEXED_DIR)/msfa; cp -f $(MSFA_H:=.h) $(MFSA_CC:=.cc) $(MFSA_CC:=.h) $(DX7_DIR))

dexed-patch-sc3:
	patch < ../../ext/patch/dexed-sc3-separate-0.9.4.patch
	patch < ../../ext/patch/dexed-sc3-tuning-0.9.4.patch

dexed-obj: $(MFSA_O)

dexed-ar: $(MFSA_O)
	$(AR) -rcs lib-dx7.a $(MFSA_O)

dexed-diff:
	-diff -u $(DEXED_DIR)/msfa/controllers.h controllers.h
	-diff -u $(DEXED_DIR)/msfa/env.cc env.cc
	-diff -u $(DEXED_DIR)/msfa/exp2.h exp2.h
	-diff -u $(DEXED_DIR)/msfa/freqlut.h freqlut.h
	-diff -u $(DEXED_DIR)/msfa/lfo.h lfo.h
	-diff -u $(DEXED_DIR)/msfa/sin.h sin.h
	-diff -u $(DEXED_DIR)/EngineMkI.cpp EngineMkI.cpp
	-diff -u $(DEXED_DIR)/EngineMkI.h EngineMkI.h

dexed-rm:
	rm -f $(MSFA_H:=.h) $(MFSA_CC:=.cc) $(MFSA_CC:=.h)
	rm -f $(DEXED_CPP:=.cpp) $(DEXED_CPP:=.h)

dexed-all:
	make dexed-obj
	make dexed-ar

clean:
	make dexed-rm
	rm -f $(MFSA_O)
	rm -f *.orig *.rej
	rm -f lib-dx7.a
