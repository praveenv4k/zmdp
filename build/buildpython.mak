#!gmake 	# Tell emacs about this file: -*- Makefile -*-  
# $Id: buildpython.mak,v 1.2 2005-10-28 02:24:42 trey Exp $
#
# Copyright (c) 1996-2005, Carnegie Mellon University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * This code and derivatives may not be incorporated into commercial
#   products without specific prior written permission.
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * Neither the name of Carnegie Mellon University nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

######################################################################
# DESCRIPTION:  Include to build a C++ extension to python using SWIG.
#
# Input variables:
#
# BUILDPYTHON_MODULE
#   Python module to produce (e.g. cmu_ipc)
# BUILDPYTHON_HEADER
#   Header to pass to swig (e.g. cmu_ipc.i)
# BUILDPYTHON_SRCS
#   Source files to link against (e.g. cmu_ipc.cc)
# BUILDPYTHON_DEP_LIBS
#    Libraries to link against: specifically, ones that we should
#    include in dependency checking in case they are rebuilt
#    (e.g. -lctr)
# BUILDPYTHON_INDEP_LIBS
#    Libraries to link against: external libraries that are unlikely
#    to be rebuilt, so skip dependency checking (e.g. -lipc)

ifndef BUILDPYTHON_INCLUDED

# rules inside this ifndef are defined only once, whether or not
# buildpython.mak is included multiple times

$(TARGET_LIB_DIR)/%.py: $(LOCAL_INC_DIR)/%.py
	$(CP) $< $@

$(TARGET_LIB_DIR)/_%.so: $(TARGET_LIB_DIR)/_%.so
	$(LN) $*cmodule.so $@

# SWIG sometimes auto-generates functions that are not used, skip the warning
CFLAGS += -I/usr/include/python2.2 -I$(SWIG_LIB_DIR) -Wno-unused

# filter out compiler flags that SWIG doesn't understand
SWIG_CANT_TAKE_THESE_FLAGS := -Wall -Wno-unused -pipe -g -O2 -O3 -pg
SWIG_CFLAGS := $(filter-out $(SWIG_CANT_TAKE_THESE_FLAGS),$(CFLAGS))

BUILDPYTHON_INCLUDED := true

endif # BUILDPYTHON_INCLUDED

# process the input variables
#BUILDPYTHON_ALT_LIB := $(TARGET_LIB_DIR)/libpython_$(BUILDPYTHON_MODULE).so
BUILDPYTHON_TARGET_LIB := $(TARGET_LIB_DIR)/_$(BUILDPYTHON_MODULE).so
BUILDPYTHON_TARGET_PY := $(TARGET_LIB_DIR)/$(BUILDPYTHON_MODULE).py
BUILDPYTHON_TARGET_SWIG := $(TARGET_LIB_DIR)/swig.py
BUILDPYTHON_DEP_LIB_FILES := \
  $(shell $(PERL) $(BUILD_DIR)/findlibs.perl $(LDFLAGS) $(BUILDPYTHON_DEP_LIBS))

BUILDPYTHON_OBJS := $(BUILDPYTHON_SRCS)
BUILDPYTHON_OBJS := $(BUILDPYTHON_OBJS:%.c=$(OBJ_DIR)/%.o)
BUILDPYTHON_OBJS := $(BUILDPYTHON_OBJS:%.cc=$(OBJ_DIR)/%.o)
BUILDPYTHON_OBJS := $(BUILDPYTHON_OBJS:%.cpp=$(OBJ_DIR)/%.o)

_WR := $(LOCAL_INC_DIR)/$(BUILDPYTHON_MODULE)_wrap.cc
$(_WR)_MODULE := $(BUILDPYTHON_MODULE)

$(_WR) $(LOCAL_INC_DIR)/$(BUILDPYTHON_MODULE).py: $(BUILDPYTHON_HEADER)
	@[ -d $(LOCAL_INC_DIR) ] || mkdir -p $(LOCAL_INC_DIR)
	cd $(LOCAL_INC_DIR) && $(SWIG) $(SWIG_FLAGS) $(SWIG_CFLAGS) -I.. -module $($@_MODULE) -o $($@_MODULE)_wrap.cc ../$<

_BT := $(BUILDPYTHON_TARGET_LIB)
$(_BT)_OBJS := $(BUILDPYTHON_OBJS)
$(_BT)_DEP_LIBS := $(BUILDPYTHON_DEP_LIBS)
$(_BT)_INDEP_LIBS := $(BUILDPYTHON_INDEP_LIBS)

$(_BT): $(OBJ_DIR)/$(BUILDPYTHON_MODULE)_wrap.o $(BUILDPYTHON_OBJS) $(BUILDPYTHON_DEP_LIB_FILES)
	$(LD) $(LDFLAGS) -shared $< $($@_OBJS) $($@_DEP_LIBS) $($@_INDEP_LIBS) -o $@.tmp
	mv -f $@.tmp $@

# add to the same list of targets as buildlib.mak; these targets will be
#   built during the libinstall phase of 'gmake install'
INSTALLHEADERS_TARGETS += \
  $(LOCAL_INC_DIR)/$(BUILDPYTHON_MODULE)_wrap.cc \
  $(LOCAL_INC_DIR)/$(BUILDPYTHON_MODULE).py

# add to the same list of targets as buildbin.mak; these targets will be
#   build during the bininstall phase of 'gmake install'
BUILDBIN_TARGETS += \
  $(BUILDPYTHON_TARGET_LIB) \
  $(BUILDPYTHON_TARGET_PY) \
#  $(BUILDPYTHON_ALT_LIB)

# clear input variables
BUILDPYTHON_MODULE :=
BUILDPYTHON_HEADER :=
BUILDPYTHON_SRCS :=
BUILDPYTHON_DEP_LIBS :=
BUILDPYTHON_INDEP_LIBS :=

######################################################################
# $Log: not supported by cvs2svn $
# Revision 1.1.1.1  2004/11/09 16:18:57  trey
# imported hsvi into new repository
#
# Revision 1.2  2004/07/06 15:10:59  trey
# fixed problem which required running "make install" twice
#
# Revision 1.1  2004/05/13 20:25:50  trey
# synced up with atacama makefile system again
#
# Revision 1.2  2004/03/19 18:26:33  trey
# cleaned up some variables
#
# Revision 1.1  2003/12/01 04:01:01  trey
# initial check-in
#
#
