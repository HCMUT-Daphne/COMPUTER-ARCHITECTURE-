# Creator:        Hai Cao (cxhai.sdh221@hcmut.edu.vn)
# Description:    makefile
# Copyright (c) 2022 Hai Cao Xuan

# Project name = top level, usually we name it wrapper
PROJNAME = wrapper
DEVICEPART = EP2C35F672C6
#DEVICEPART = EP2C20F484C6
DEVICEFAMILY = "Cyclone II"
LIBPATH = ../00_src

.PHONY: all
all: map fit sta asm

.PHONY: help
help:
	@echo "make [option]"
	@echo "\tmap    Analysis and Synthesis"
	@echo "\tfit    Fitter"
	@echo "\tsta    TimeQuest Timing Analyzer"
	@echo "\tasm    Assembler"
	@echo "\tpgm    Programmer"
	@echo "\trtl    RTL Viewer"
	@echo "\tclean  Clean the working directory"

.PHONY: map
map:
	quartus_map "$(PROJNAME)" --source="$(PROJNAME).sv" --lib_path="$(LIBPATH)" --family=$(DEVICEFAMILY)

.PHONY: fit
fit:
	quartus_fit "$(PROJNAME)" --part="$(DEVICEPART)" --pack_register="minimize_area" --read_settings_files=on

.PHONY: sta
sta:
	quartus_sta "$(PROJNAME)"

.PHONY: asm
asm:
	quartus_asm "$(PROJNAME)"

.PHONY: pgm
pgm:
	quartus_pgm -m jtag -o "p;$(PROJNAME).sof"

.PHONY: rtl
rtl:
	qnui $(PROJNAME)

.PHONY: clean
clean:
	@rm -rf db incremental_db *.done *.rpt *.summary *.smsg *.qpf *.jdi *.pin *.pof *.sof
