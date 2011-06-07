lib_LTLIBRARIES = libat91sam9260.la
SUBDIRS = instructions addressings
libat91sam9260_la_LIBADD = instructions/libinstructions.la addressings/libaddressings.la
libat91sam9260_la_SOURCES = core.m interface.m uart.m dataflash.m
OBJCFLAGS = -I@top_srcdir@/include -fconstant-string-class=ChConstantString -lchiles -O2 -Werror -larmyc
python_PYTHON = at91sam9260.py
