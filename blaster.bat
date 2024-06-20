@echo off

set QUARTUS_BIN_PATH=C:\altera\13.0sp1\quartus\bin
set SOF_FILE_PATH=./milestone2/21_quartus/output_files/wrapper.sof

"%QUARTUS_BIN_PATH%\quartus_pgm.exe" -c "USB-Blaster [USB-0]" -m JTAG -o "p;%SOF_FILE_PATH%"