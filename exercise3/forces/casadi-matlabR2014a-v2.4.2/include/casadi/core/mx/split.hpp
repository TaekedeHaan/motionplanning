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


#ifndef CASADI_SPLIT_HPP
#define CASADI_SPLIT_HPP

#include "multiple_output.hpp"
#include <map>
#include <stack>

/// \cond INTERNAL

namespace casadi {

  /** \brief Split: Split into multiple expressions splitting the nonzeros
      \author Joel Andersson
      \date 2014
  */
  class CASADI_EXPORT Split : public MultipleOutput {
  public:
    /// Constructor
    Split(const MX& x, const std::vector<int>& offset);

    /// Destructor
    virtual ~Split() = 0;

    /** \brief  Number of outputs */
    virtual int nout() const { return output_sparsity_.size(); }

    /** \brief  Get the sparsity of output oind */
    virtual const Sparsity& sparsity(int oind) const { return output_sparsity_.at(oind);}

    /// Evaluate the function (template)
    template<typename T>
    void evalGen(const T** arg, T** res, int* iw, T* w);

    /// Evaluate the function numerically
    virtual void evalD(const double** arg, double** res, int* iw, double* w);

    /// Evaluate the function symbolically (SX)
    virtual void evalSX(const SXElement** arg, SXElement** res, int* iw, SXElement* w);

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /** \brief Generate code for the operation */
    virtual void generate(const std::vector<int>& arg, const std::vector<int>& res,
                          CodeGenerator& g) const;

    // Sparsity pattern of the outputs
    std::vector<int> offset_;
    std::vector<Sparsity> output_sparsity_;
  };

  /** \brief Horizontal split, x -> x0, x1, ...
      \author Joel Andersson
      \date 2013
  */
  class CASADI_EXPORT Horzsplit : public Split {
  public:

    /// Constructor
    Horzsplit(const MX& x, const std::vector<int>& offset);

    /// Destructor
    virtual ~Horzsplit() {}

    /// Clone function
    virtual Horzsplit* clone() const { return new Horzsplit(*this);}

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_HORZSPLIT;}

    /// Create a horizontal concatenation node
    virtual MX getHorzcat(const std::vector<MX>& x) const;
  };

  /** \brief Diag split, x -> x0, x1, ...
      \author Joris Gillis
      \date 2014
  */
  class CASADI_EXPORT Diagsplit : public Split {
  public:

    /// Constructor
    Diagsplit(const MX& x, const std::vector<int>& offset1, const std::vector<int>& offset2);

    /// Destructor
    virtual ~Diagsplit() {}

    /// Clone function
    virtual Diagsplit* clone() const { return new Diagsplit(*this);}

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_DIAGSPLIT;}

    /// Create a diagonal concatenation node
    virtual MX getDiagcat(const std::vector<MX>& x) const;
  };

  /** \brief Vertical split of vectors, x -> x0, x1, ...
      \author Joel Andersson
      \date 2014
  */
  class CASADI_EXPORT Vertsplit : public Split {
  public:

    /// Constructor
    Vertsplit(const MX& x, const std::vector<int>& offset);

    /// Destructor
    virtual ~Vertsplit() {}

    /// Clone function
    virtual Vertsplit* clone() const { return new Vertsplit(*this);}

    /** \brief  Evaluate symbolically (MX) */
    virtual void evalMX(const std::vector<MX>& arg, std::vector<MX>& res);

    /** \brief Calculate forward mode directional derivatives */
    virtual void evalFwd(const std::vector<std::vector<MX> >& fseed,
                         std::vector<std::vector<MX> >& fsens);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void evalAdj(const std::vector<std::vector<MX> >& aseed,
                         std::vector<std::vector<MX> >& asens);

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_VERTSPLIT;}

    /// Create a vertical concatenation node (vectors only)
    virtual MX getVertcat(const std::vector<MX>& x) const;
  };

} // namespace casadi

/// \endcond

#endif // CASADI_SPLIT_HPP
