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


#ifndef CASADI_BINARY_MX_HPP
#define CASADI_BINARY_MX_HPP

#include "mx_node.hpp"

/// \cond INTERNAL

namespace casadi {
  /** \brief Represents any binary operation that involves two matrices
      \author Joel Andersson
      \date 2010
  */
  template<bool ScX, bool ScY>
  class CASADI_EXPORT BinaryMX : public MXNode {
  public:
    /** \brief  Constructor */
    BinaryMX(Operation op, const MX& x, const MX& y);

    /** \brief  Destructor */
    virtual ~BinaryMX();

    /** \brief  Clone function */
    virtual BinaryMX* clone() const { return new BinaryMX(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return op_;}

    /** \brief Check if binary operation */
    virtual bool isBinaryOp() const { return true;}

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T* const* arg, T* const* res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res, int* iw, SXElement* w);

    /// Can the operation be performed inplace (i.e. overwrite the result)
    virtual int numInplace() const { return 2;}

    /** \brief Generate code for the operation */
    void generate(const std::vector<int>& arg, const std::vector<int>& res,
                  CodeGenerator& g) const;

    /// Get a unary operation
    virtual MX getUnary(int op) const;

    /// Get a binary operation operation
    virtual MX getBinary(int op, const MX& y, bool scX, bool scY) const;

    /** \brief Check if two nodes are equivalent up to a given depth */
    virtual bool zz_isEqual(const MXNode* node, int depth) const {
      if (op_==node->getOp()) {
        if (isEqual(dep(0), node->dep(0), depth-1) && isEqual(dep(1), node->dep(1), depth-1)) {
          // If arguments are equal
          return true;
        } else {
          // If arguments are flipped
          return operation_checker<CommChecker>(op_) && isEqual(dep(1), node->dep(0), depth-1) &&
            isEqual(dep(0), node->dep(1), depth-1);
        }
      } else {
        return false;
      }
    }

    //! \brief Operation
    Operation op_;

  };

} // namespace casadi
/// \endcond

#endif // CASADI_BINARY_MX_HPP
