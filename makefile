
QUARTUS_BIN_PATH 	= /home/tlatonf/altera/13.0sp1/quartus/bin
#QUARTUS_BIN_PATH 	= C:/altera/13.0sp1/quartus/bin

PROJNAME 		= wrapper
SOURCE_PATH 		= ../00_src

#DE2
DEVICEFAMILY 		= "Cyclone II"
DEVICEPART 		= EP2C35F672C6

#DE0NANO
#DEVICEFAMILY 		= "Cyclone IV E"
#DEVICEPART 		= EP4CE22F17C6

.PHONY: all
all: map fit sta asm pgm

.PHONY: help
help:
	@echo make [option]
	@echo \tmap    Analysis and Synthesis
	@echo \tfit    Fitter
	@echo \tsta    TimeQuest Timing Analyzer
	@echo \tasm    Assembler
	@echo \tpgm    Programmer
	@echo \trtl    RTL Viewer
	@echo \tclean  Clean the working directory

.PHONY: map
map:
	$(QUARTUS_BIN_PATH)/quartus_map $(PROJNAME) --source=$(PROJNAME).sv --lib_path=$(SOURCE_PATH) --family=$(DEVICEFAMILY)

.PHONY: fit
fit:
	$(QUARTUS_BIN_PATH)/quartus_fit $(PROJNAME) --part=$(DEVICEPART) --pack_register=minimize_area --read_settings_files=on

.PHONY: sta
sta:
	$(QUARTUS_BIN_PATH)/quartus_sta $(PROJNAME)

.PHONY: asm
asm:
	$(QUARTUS_BIN_PATH)/quartus_asm $(PROJNAME)

.PHONY: pgm
pgm:
	$(QUARTUS_BIN_PATH)/quartus_pgm -m JTAG -o "p;./output_files/$(PROJNAME).sof"

.PHONY: rtl
rtl:
	qnui $(PROJNAME)

.PHONY: clean
clean:
	@rm -rf db incremental_db *.done *.rpt *.summary *.smsg *.qpf *.jdi *.pin *.pof *.sof
