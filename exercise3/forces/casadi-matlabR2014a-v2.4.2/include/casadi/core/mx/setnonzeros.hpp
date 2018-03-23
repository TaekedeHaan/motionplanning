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


#ifndef CASADI_SETNONZEROS_HPP
#define CASADI_SETNONZEROS_HPP

#include "mx_node.hpp"
#include <map>
#include <stack>

/// \cond INTERNAL

namespace casadi {

  /** \brief Assign or add entries to a matrix
      \author Joel Andersson
      \date 2013
  */
  template<bool Add>
  class CASADI_EXPORT SetNonzeros : public MXNode {
  public:

    /// Constructor
    SetNonzeros(const MX& y, const MX& x);

    /// Destructor
    virtual ~SetNonzeros() = 0;

    /// Get all the nonzeros
    virtual std::vector<int> getAll() const = 0;

    /// Clone function
    virtual SetNonzeros* clone() const = 0;

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief Get the operation */
    virtual int getOp() const { return Add ? OP_ADDNONZEROS : OP_SETNONZEROS;}

    /// Get an IMatrix representation of a GetNonzeros or SetNonzeros node
    virtual Matrix<int> mapping() const;

    /// Can the operation be performed inplace (i.e. overwrite the result)
    virtual int numInplace() const { return 1;}
  };


    /** \brief Add the nonzeros of a matrix to another matrix
      \author Joel Andersson
      \date 2013
  */
  template<bool Add>
  class CASADI_EXPORT SetNonzerosVector : public SetNonzeros<Add>{
  public:

    /// Constructor
    SetNonzerosVector(const MX& y, const MX& x, const std::vector<int>& nz);

    /// Clone function
    virtual SetNonzerosVector* clone() const { return new SetNonzerosVector(*this);}

    /// Destructor
    virtual ~SetNonzerosVector() {}

    /// Get all the nonzeros
    virtual std::vector<int> getAll() const { return nz_;}

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T** arg, T** res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res, int* iw, SXElement* w);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;

    /** \brief Check if two nodes are equivalent up to a given depth */
    virtual bool zz_isEqual(const MXNode* node, int depth) const;

    /// Operation sequence
    std::vector<int> nz_;
  };

  // Specialization of the above when nz_ is a Slice
  template<bool Add>
  class CASADI_EXPORT SetNonzerosSlice : public SetNonzeros<Add>{
  public:

    /// Constructor
    SetNonzerosSlice(const MX& y, const MX& x, const Slice& s) : SetNonzeros<Add>(y, x), s_(s) {}

    /// Clone function
    virtual SetNonzerosSlice* clone() const { return new SetNonzerosSlice(*this);}

    /// Destructor
    virtual ~SetNonzerosSlice() {}

    /// Get all the nonzeros
    virtual std::vector<int> getAll() const { return s_.getAll(s_.stop_);}

    /// Check if the instance is in fact a simple assignment
    bool isAssignment() const;

    /// Simplify
    virtual void simplifyMe(MX& ex);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T** arg, T** res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res,
                        int* iw, SXElement* w);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;

    /** \brief Check if two nodes are equivalent up to a given depth */
    virtual bool zz_isEqual(const MXNode* node, int depth) const;

    // Data member
    Slice s_;
  };

  // Specialization of the above when nz_ is a nested Slice
  template<bool Add>
  class CASADI_EXPORT SetNonzerosSlice2 : public SetNonzeros<Add>{
  public:

    /// Constructor
    SetNonzerosSlice2(const MX& y, const MX& x, const Slice& inner, const Slice& outer) :
        SetNonzeros<Add>(y, x), inner_(inner), outer_(outer) {}

    /// Clone function
    virtual SetNonzerosSlice2* clone() const { return new SetNonzerosSlice2(*this);}

    /// Destructor
    virtual ~SetNonzerosSlice2() {}

    /// Get all the nonzeros
    virtual std::vector<int> getAll() const { return inner_.getAll(outer_, outer_.stop_);}

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg,
                       bvec_t** res, int* iw, bvec_t* w);

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T** arg, T** res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res, int* iw, SXElement* w);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;

    /** \brief Check if two nodes are equivalent up to a given depth */
    virtual bool zz_isEqual(const MXNode* node, int depth) const;

    // Data members
    Slice inner_, outer_;
  };

} // namespace casadi
/// \endcond

#endif // CASADI_SETNONZEROS_HPP
