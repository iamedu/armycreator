lib_LTLIBRARIES = libchiles.la
libchiles_la_SOURCES = ChObject.m ChString.m ChConstantString.m ChList.m ChDictionary.m ChConf.m ChArray.m utils.m lexconf.m conf.m ChInteger.m
library_includedir = $(includedir)/Chiles
library_include_HEADERS = include/Chiles/ChObject.h include/Chiles/ChString.h include/Chiles/ChTypes.h include/Chiles/Utils.h include/Chiles/Hashable.h include/Chiles/ChDictionary.h include/Chiles/ChList.h include/Chiles/ChConf.h include/Chiles/Iterator.h include/Chiles/ChArray.h include/Chiles/ChInteger.h
bin_PROGRAMS = chtest
chtest_SOURCES = test.m
chtest_LDADD = libchiles.la
OBJCFLAGS = -I@top_srcdir@/include -fconstant-string-class=ChConstantString -lobjc -Werror -lfl 
