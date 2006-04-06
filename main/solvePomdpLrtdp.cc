/********** tell emacs we use -*- c++ -*- style comments *******************
 $Revision: 1.2 $  $Author: trey $  $Date: 2006-04-06 04:11:50 $

 @file    solvePomdpLrtdp.cc
 @brief   No brief

 Copyright (c) 2006, Trey Smith. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

 * The software may not be sold or incorporated into a commercial
   product without specific prior written permission.
 * The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 ***************************************************************************/

#include "PomdpSim.h"
#include "LRTDP.h"
#include "SawtoothUpperBound.h"

#define SP_EXTRA_ARGS        "<problem.pomdp>"
#define SP_REQUIRE_PROB_NAME (1)
#define SP_GENERATE_PROBLEM  Pomdp(prob_name, use_fast_parser)
#define SP_GENERATE_SOLVER   LRTDP(new SawtoothUpperBound(problem))
#define SP_GENERATE_SIM      PomdpSim((Pomdp*) problem)

#include "solveProblem.cc"
