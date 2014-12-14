#===============================================================================
#
#     Filename: Makefile
#  Description: Makefile for building [PROJECT]
#
#     Synopsis: make              generate executable
# 				make TARGET		  makes the given target
#               make clean        remove objects, executable, prerequisits
#               make tarball      generate compressed archive
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
#========================================= [Makefile Template Version 1.8] =====

include Makefile.inc

# BUILD can be set to DEBUG to include debugging info, or RELEASE otherwise
BUILD          := RELEASE
# PROFILE can be set to YES to include profiling info, or NO otherwise
PROFILE        := NO

DIRS	= lib core ext custom
SOURCES	= core/utils.core	\
		  ext/utils.ext		\
		  lib/utils.lib		\
		  custom/utils.custom	\

RCFILES = var/obj/bashrc	\
		  var/obj/bash_profile	\
		  var/obj/profile	\
		  var/obj/zshrc	\
		  var/obj/zprofile	\

all:

sh.utils:
	@echo $(MFLAGS)
	#$(CAT) $(CATFLAGS) $^ > $@

clean:
	$(RM) $(TARGET) $(TESTS)

tarball:

.PHONY: clean tarball
