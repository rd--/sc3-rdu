DEXED_DIR = $(HOME)/opt/src/dexed/Source/msfa

DEXED_H = aligned_buf controllers module synth

DEXED_CC = dx7note env exp2 fm_core fm_op_kernel freqlut lfo pitchenv sin

DEXED_O = $(DEXED_CC:=.o)

DX7_DIR = $(HOME)/sw/sc3-rdu/cpp/dx7

dexed-copy:
	(cd $(DEXED_DIR); cp -f $(DEXED_H:=.h) $(DEXED_CC:=.cc) $(DEXED_CC:=.h) $(DX7_DIR))

dexed-patch:
	patch < dexed.patch

dexed-obj: $(DEXED_O)

dexed-ar: $(DEXED_O)
	ar -rcs lib-dx7.a $(DEXED_O)

dexed-diff:
	-diff -u $(DEXED_DIR)/controllers.h controllers.h
	-diff -u $(DEXED_DIR)/env.cc env.cc
	-diff -u $(DEXED_DIR)/exp2.h exp2.h
	-diff -u $(DEXED_DIR)/freqlut.h freqlut.h
	-diff -u $(DEXED_DIR)/lfo.h lfo.h
	-diff -u $(DEXED_DIR)/sin.h sin.h

dexed-rm:
	rm -f $(DEXED_H:=.h) $(DEXED_CC:=.cc) $(DEXED_CC:=.h)

all:
	make dexed-obj
	make dexed-ar

clean:
	rm -f $(DEXED_O)
	rm -f lib-dx7.a
