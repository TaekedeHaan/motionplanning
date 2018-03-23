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


#ifndef CASADI_MX_FUNCTION_INTERNAL_HPP
#define CASADI_MX_FUNCTION_INTERNAL_HPP

#include <set>
#include <map>
#include <vector>
#include <iostream>

#include "mx_function.hpp"
#include "x_function_internal.hpp"
#include "../mx/mx_node.hpp"

/// \cond INTERNAL

namespace casadi {

#ifndef SWIG
  /** \brief  An element of the algorithm, namely an MX node */
  struct MXAlgEl {
    /// Operator index
    int op;

    /// Data associated with the operation
    MX data;

    /// Work vector indices of the arguments
    std::vector<int> arg;

    /// Work vector indices of the results
    std::vector<int> res;
  };
#endif // SWIG

  /** \brief  Internal node class for MXFunction
      \author Joel Andersson
      \date 2010-2015
  */
  class CASADI_EXPORT MXFunctionInternal :
        public XFunctionInternal<MXFunction, MXFunctionInternal, MX, MXNode>{
    friend class MXFunction;

  public:
    /** \brief  An element of the algorithm, namely an MX node */
    typedef MXAlgEl AlgEl;

    /** \brief  All the runtime elements in the order of evaluation */
    std::vector<AlgEl> algorithm_;

    /** \brief Offsets for elements in the w_ vector */
    std::vector<int> workloc_;

    /// Free variables
    std::vector<MX> free_vars_;

    /** \brief  Multiple input, multiple output constructor, only to be accessed from MXFunction,
        therefore protected */
    MXFunctionInternal(const std::vector<MX>& input, const std::vector<MX>& output);

    /** \brief  Make a deep copy */
    virtual MXFunctionInternal* clone() const;

    /** \brief  Deep copy data members */
    virtual void deepCopyMembers(std::map<SharedObjectNode*, SharedObject>& already_copied);

    /** \brief  Destructor */
    virtual ~MXFunctionInternal();

    /** \brief  Evaluate numerically, work vectors given */
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /** \brief  Print description */
    virtual void print(std::ostream &stream) const;

    /** \brief  Initialize */
    virtual void init();

    /** \brief Generate code for the declarations of the C function */
    virtual void generateDeclarations(CodeGenerator& g) const;

    /** \brief Generate code for the body of the C function */
    virtual void generateBody(CodeGenerator& g) const;

    /** \brief Extract the residual function G and the modified function Z out of an expression
     * (see Albersmeyer2010 paper) */
    void generateLiftingFunctions(MXFunction& vdef_fcn, MXFunction& vinit_fcn);

    /** \brief Generate a function that calculates a Jacobian function by operator overloading */
    virtual Function getNumericJacobian(const std::string& name, int iind, int oind,
                                        bool compact, bool symmetric, const Dict& opts);

    /** \brief Quickfix to avoid segfault, #1552 */
    virtual bool canEvalSX() const {return true;}

    /** \brief Evaluate symbolically, SX type*/
    virtual void evalSX(const SXElement** arg, SXElement** res,
                        int* iw, SXElement* w);

    /** \brief Evaluate symbolically, MX type */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fwdSeed,
                        std::vector<std::vector<MX> >& fwdSens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& adjSeed,
                        std::vector<std::vector<MX> >& adjSens);

    /** \brief Expand the matrix valued graph into a scalar valued graph */
    SXFunction expand(const std::vector<SX>& inputv);

    /// Get a vector of symbolic variables with the same dimensions as the inputs
    virtual std::vector<MX> symbolicInput() const { return inputv_;}

    /// Get a vector of symbolic variables corresponding to the outputs
    virtual std::vector<MX> symbolicOutput(const std::vector<MX>& arg);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /// Is the class able to propagate seeds through the algorithm?
    virtual bool spCanEvaluate(bool fwd) { return true;}

    /// Reset the sparsity propagation
    virtual void spInit(bool fwd);

    /// Print work vector
    void printWork(std::ostream &stream=casadi::userOut());

    // print an element of an algorithm
    void print(std::ostream &stream, const AlgEl& el) const;
  };

} // namespace casadi
/// \endcond

#endif // CASADI_MX_FUNCTION_INTERNAL_HPP

