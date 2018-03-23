/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
 *                            K.U. Leuven. All rights reserved.
 *    Copyright (C) 2011-2014 Greg Horn
 *
 *    CasADi is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    CasADi is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with CasADi; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef CASADI_BINARY_MX_IMPL_HPP
#define CASADI_BINARY_MX_IMPL_HPP

#include "binary_mx.hpp"
#include <vector>
#include <sstream>
#include "../std_vector_tools.hpp"
#include "../casadi_options.hpp"

using namespace std;

namespace casadi {

  template<bool ScX, bool ScY>
  BinaryMX<ScX, ScY>::BinaryMX(Operation op, const MX& x, const MX& y) : op_(op) {
    setDependencies(x, y);
    if (ScX) {
      setSparsity(y.sparsity());
    } else {
      setSparsity(x.sparsity());
    }
  }

  template<bool ScX, bool ScY>
  BinaryMX<ScX, ScY>::~BinaryMX() {
  }

  template<bool ScX, bool ScY>
  std::string BinaryMX<ScX, ScY>::print(const std::vector<std::string>& arg) const {
    stringstream ss;
    casadi_math<double>::printPre(op_, ss);
    ss << arg.at(0);
    casadi_math<double>::printSep(op_, ss);
    ss << arg.at(1);
    casadi_math<double>::printPost(op_, ss);
    return ss.str();
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::evalMX(const std::vector<MX>& arg, std::vector<MX>& res) {
    casadi_math<MX>::fun(op_, arg[0], arg[1], res[0]);
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::evalFwd(const std::vector<std::vector<MX> >& fseed,
                                   std::vector<std::vector<MX> >& fsens) {
    // Get partial derivatives
    MX pd[2];
    casadi_math<MX>::der(op_, dep(0), dep(1), shared_from_this<MX>(), pd);

    // Propagate forward seeds
    for (int d=0; d<fsens.size(); ++d) {
      fsens[d][0] = pd[0]*fseed[d][0] + pd[1]*fseed[d][1];
    }
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::evalAdj(const std::vector<std::vector<MX> >& aseed,
                                   std::vector<std::vector<MX> >& asens) {
    // Get partial derivatives
    MX pd[2];
    casadi_math<MX>::der(op_, dep(0), dep(1), shared_from_this<MX>(), pd);

    // Propagate adjoint seeds
    for (int d=0; d<aseed.size(); ++d) {
      MX s = aseed[d][0];
      for (int c=0; c<2; ++c) {
        // Get increment of sensitivity c
        MX t = pd[c]*s;

        // If dimension mismatch (i.e. one argument is scalar), then sum all the entries
        if (!t.isscalar() && t.shape() != dep(c).shape()) {
          if (pd[c].shape()!=s.shape()) pd[c] = MX(s.sparsity(), pd[c]);
          t = inner_prod(pd[c], s);
        }

        // Propagate the seeds
        asens[d][c] += t;
      }
    }
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::generate(const std::vector<int>& arg, const std::vector<int>& res,
                                    CodeGenerator& g) const {
    // Quick return if nothing to do
    if (nnz()==0) return;

    // Check if inplace
    bool inplace;
    switch (op_) {
    case OP_ADD:
    case OP_SUB:
    case OP_MUL:
    case OP_DIV:
      inplace = res[0]==arg[0];
      break;
    default:
      inplace = false;
      break;
    }

    // Print indent
    g.body << "  ";

    // Scalar names of arguments (start assuming all scalars)
    string r = g.workel(res[0]);
    string x = g.workel(arg[0]);
    string y = g.workel(arg[1]);

    // Codegen loop, if needed
    if (nnz()>1) {
      // Iterate over result
      g.body << "for (i=0, " << "rr=" << g.work(res[0], nnz());
      r = "(*rr++)";

      // Iterate over first argument?
      if (!ScX && !inplace) {
        g.body << ", cr=" << g.work(arg[0], dep(0).nnz());
        x = "(*cr++)";
      }

      // Iterate over second argument?
      if (!ScY) {
        g.body << ", cs=" << g.work(arg[1], dep(1).nnz());
        y = "(*cs++)";
      }

      // Close loop
      g.body << "; i<" << nnz() << "; ++i) ";
    }

    // Perform operation
    g.body << r << " ";
    if (inplace) {
      casadi_math<double>::printSep(op_, g.body);
      g.body << "= " << y;
    } else {
      g.body << " = ";
      casadi_math<double>::printPre(op_, g.body);
      g.body << x;
      casadi_math<double>::printSep(op_, g.body);
      g.body << y;
      casadi_math<double>::printPost(op_, g.body);
    }
    g.body << ";" << endl;
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::evalD(const double** arg, double** res,
                                 int* iw, double* w) {
    evalGen<double>(arg, res, iw, w);
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::evalSX(const SXElement** arg, SXElement** res,
                                  int* iw, SXElement* w) {
    evalGen<SXElement>(arg, res, iw, w);
  }

  template<bool ScX, bool ScY>
  template<typename T>
  void BinaryMX<ScX, ScY>::evalGen(const T* const* arg, T* const* res,
                                   int* iw, T* w) {
    // Get data
    T* output0 = res[0];
    const T* input0 = arg[0];
    const T* input1 = arg[1];

    if (!ScX && !ScY) {
      casadi_math<T>::fun(op_, input0, input1, output0, nnz());
    } else if (ScX) {
      casadi_math<T>::fun(op_, *input0, input1, output0, nnz());
    } else {
      casadi_math<T>::fun(op_, input0, *input1, output0, nnz());
    }
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::spFwd(const bvec_t** arg,
                                 bvec_t** res,
                                 int* iw, bvec_t* w) {
    const bvec_t *a0=arg[0], *a1=arg[1];
    bvec_t *r=res[0];
    int n=nnz();
    for (int i=0; i<n; ++i) {
      if (ScX && ScY)
        *r++ = *a0 | *a1;
      else if (ScX && !ScY)
        *r++ = *a0 | *a1++;
      else if (!ScX && ScY)
        *r++ = *a0++ | *a1;
      else
        *r++ = *a0++ | *a1++;
    }
  }

  template<bool ScX, bool ScY>
  void BinaryMX<ScX, ScY>::spAdj(bvec_t** arg,
                                 bvec_t** res,
                                 int* iw, bvec_t* w) {
    bvec_t *a0=arg[0], *a1=arg[1], *r = res[0];
    int n=nnz();
    for (int i=0; i<n; ++i) {
      bvec_t s = *r;
      *r++ = 0;
      if (ScX)
        *a0 |= s;
      else
        *a0++ |= s;
      if (ScY)
        *a1 |= s;
      else
        *a1++ |= s;
    }
  }

  template<bool ScX, bool ScY>
  MX BinaryMX<ScX, ScY>::getUnary(int op) const {
    switch (op_) {
    default: break; // no rule
    }

    // Fallback to default implementation
    return MXNode::getUnary(op);
  }

  template<bool ScX, bool ScY>
  MX BinaryMX<ScX, ScY>::getBinary(int op, const MX& y, bool scX, bool scY) const {
    if (!CasadiOptions::simplification_on_the_fly) return MXNode::getBinary(op, y, scX, scY);

    switch (op_) {
    case OP_ADD:
      if (op==OP_SUB && isEqual(y, dep(0), maxDepth())) return dep(1);
      if (op==OP_SUB && isEqual(y, dep(1), maxDepth())) return dep(0);
      break;
    case OP_SUB:
      if (op==OP_SUB && isEqual(y, dep(0), maxDepth())) return -dep(1);
      if (op==OP_ADD && isEqual(y, dep(1), maxDepth())) return dep(0);
      break;
    default: break; // no rule
    }

    // Fallback to default implementation
    return MXNode::getBinary(op, y, scX, scY);
  }


} // namespace casadi

#endif // CASADI_BINARY_MX_IMPL_HPP
