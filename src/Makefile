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

# BUILD can be set to DEBUG to include debugging info, or RELEASE otherwise
BUILD          := RELEASE
# PROFILE can be set to YES to include profiling info, or NO otherwise
PROFILE        := NO


# ------------  compiler  ------------------------------------------------------
CC	:= gcc
CXX	:= g++
# Flags passed to the C++ compiler.
CFLAGS	:= -Wall -Wextra
CXXFLAGS:= -Wall -Wextra
LDFLAGS	:=
# -pthread -lgtest
ifeq (YES, ${DEBUG})
	CFLAGS	+= -g -O0
	CXXFLAGS+= -g -O0
	LDFLAGS	+= -g -O0
else
	CFLAGS	+= -O3
	CXXFLAGS+= -O3
	LDFLAGS	+= -O3
endif

ifeq (YES, ${PROFILE})
	CFLAGS	+= -pg -O3
	CXXFLAGS+= -pg -O3
	LDFLAGS += -pg
endif

INCDIR	=
INCIDR	= $(addprefix -I, $(INCDIR))

# ------------  name of the target  ----------------------------------------
TARGET	:= params
# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS =

# House-keeping build targets.

all: $(TARGET) $(TESTS)

hello:
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCDIR) $<

%.o: %.cc
	$(CXX) -c $(CXXFLAGS) $(INCDIR) $<

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(INCDIR) $<

%.o: %.C
	$(CXX) -c $(CXXFLAGS) $(INCDIR) $<

%.dep: %.c
	$(CC) -MM -MF $@ $(CFLAGS) $<

%.dep: %.cc
	$(CPP) -MM -MF $@ $(CFLAGS) $<

%.dep: %.cpp
	$(CPP) -MM -MF $@ $(CFLAGS) $<

%.dep: %.C
	$(CPP) -MM -MF $@ $(CFLAGS) $<

clean:
	rm -f $(TESTS) gtest.a gtest_main.a *.o

install:

tarball:

# Builds gtest.a and gtest_main.a.
# uncomment the nextline to include google test framework support
#include gtest/libgtest.mk
# Builds a sample test.  A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.

.PHONY: clean install tarball

