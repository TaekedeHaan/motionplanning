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


#ifndef CASADI_MULTIPLICATION_HPP
#define CASADI_MULTIPLICATION_HPP

#include "mx_node.hpp"

/// \cond INTERNAL

namespace casadi {
  /** \brief An MX atomic for matrix-matrix product,
             note that the first factor must be provided transposed
      \author Joel Andersson
      \date 2010
  */
  class CASADI_EXPORT Multiplication : public MXNode {
  public:

    /** \brief  Constructor */
    Multiplication(const MX& z, const MX& x, const MX& y);

    /** \brief  Destructor */
    virtual ~Multiplication() {}

    /** \brief  Clone function */
    virtual Multiplication* clone() const { return new Multiplication(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T** arg, T** res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res, int* iw, SXElement* w);

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief Get the operation */
    virtual int getOp() const { return OP_MATMUL;}

    /// Can the operation be performed inplace (i.e. overwrite the result)
    virtual int numInplace() const { return 1;}

    /** \brief Check if two nodes are equivalent up to a given depth */
    virtual bool zz_isEqual(const MXNode* node, int depth) const {
      return sameOpAndDeps(node, depth) && dynamic_cast<const Multiplication*>(node)!=0;
    }

    /** \brief Get required length of w field */
    virtual size_t sz_w() const { return sparsity().size1();}
  };


  /** \brief An MX atomic for matrix-matrix product,
             note that the factor must be provided transposed
      \author Joel Andersson
      \date 2010
  */
  class CASADI_EXPORT DenseMultiplication : public Multiplication{
  public:

    /** \brief  Constructor */
    DenseMultiplication(const MX& z, const MX& x, const MX& y)
        : Multiplication(z, x, y) {}

    /** \brief  Destructor */
    virtual ~DenseMultiplication() {}

    /** \brief  Clone function */
    virtual DenseMultiplication* clone() const { return new DenseMultiplication(*this);}

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;
  };


} // namespace casadi
/// \endcond

#endif // CASADI_MULTIPLICATION_HPP
