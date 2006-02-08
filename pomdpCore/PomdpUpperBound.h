/********** tell emacs we use -*- c++ -*- style comments *******************
 $Revision: 1.3 $  $Author: trey $  $Date: 2006-02-01 01:09:38 $
   
 @file    PomdpUpperBound.h
 @brief   No brief

 Copyright (c) 2005, Trey Smith. All rights reserved.

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

#ifndef INCPomdpUpperBound_h
#define INCPomdpUpperBound_h

#include "MatrixUtils.h"
#include "AbstractBound.h"
#include "Pomdp.h"

namespace zmdp {

struct PomdpUpperBound : public AbstractBound {
  const Pomdp* pomdp;
  std::vector<alpha_vector> alphas;

  PomdpUpperBound(const MDP* problem);
  void initialize(void);
  double getValue(const belief_vector& s) const;

protected:
  void initMDP(void);
  void initFIB(void);
};

}; // namespace zmdp

#endif /* INCPomdpUpperBound_h */

/***************************************************************************
 * REVISION HISTORY:
 * $Log: not supported by cvs2svn $
 * Revision 1.2  2006/01/31 20:13:45  trey
 * changed when MDP* arguments are passed into bounds initialization
 *
 * Revision 1.1  2006/01/31 19:18:24  trey
 * initial check-in
 *
 *
 ***************************************************************************/