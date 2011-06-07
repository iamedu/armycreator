bin_PROGRAMS = armyc
lib_LTLIBRARIES = libarmyc.la
libarmyc_la_SOURCES = ARMInstruction.m ARMCore.m ARMDevice.m ARMPythonDevice.m ARMAddressing.m utils.m ARMCoproc.m
armyc_SOURCES = main.m ARMyFetcher.m python.m ARMPythonEvent.m
python_PYTHON = armycc.py
armyc_LDADD = libarmyc.la
library_includedir = $(includedir)/armyc
library_include_HEADERS = include/armyc/ARMInstruction.h include/armyc/ARMCore.h include/armyc/ARMDevice.h include/armyc/ARMAddressing.h include/armyc/utils.h include/armyc/ARMCoproc.h
OBJCFLAGS = -I@top_srcdir@/include -fconstant-string-class=ChConstantString -lchiles -O2 -lreadline -lpthread -lpython@PYTHON_VERSION@ -lm -L/usr/lib/python@PYTHON_VERSION@/config -I/usr/include/python@PYTHON_VERSION@
