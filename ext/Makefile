#===============================================================================
#
#     Filename: Makefile
#  Description: Makefile for building [PROJECT]
#
#     Synopsis: make              generate executable
# 				make TARGET		  makes the given target
#               make clean        remove objects, executable, prerequisits
#               make tarball      generate compressed archive
#               make zip          generate compressed archive
#
#      Version: 1.0
#      Created: [TIME]
#     Revision: ---
#
#       Author: [AUTHOR]
#      Company:
#        Email: [EMAIL]
#
#        Notes: This is a GNU make (gmake) makefile.
#               C   extension   :  c
#               C++ extensions  :  cc cpp C
#               C and C++ sources can be mixed.
#               Prerequisites are generated automatically; makedepend is not
#               needed (see documentation for GNU make Version 3.80, July 2002,
#               section 4.13). The utility sed is used.
#========================================== makefile template version 1.8 ======
#

include ../Makefile.inc

# BUILD can be set to DEBUG to include debugging info, or RELEASE otherwise
BUILD          := RELEASE
# PROFILE can be set to YES to include profiling info, or NO otherwise
PROFILE        := NO

all: sh.ext bash.ext zsh.ext darwin.ext linux.ext

sh.ext: $(sh_SOURCES)
	echo $(zsh_SOURCES)
	: > $@
	for file in $(sh_SOURCES); do	\
		echo $$file >> $@;			\
		cat $$file >> $@;			\
	done
	#$(CAT) $(CATFLAGS) $^ > $@

clean:
	$(RM) $(TARGET) $(TESTS)

.PHONY: clean
