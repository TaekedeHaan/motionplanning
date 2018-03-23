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


#ifndef CASADI_NORM_HPP
#define CASADI_NORM_HPP

#include "mx_node.hpp"

/// \cond INTERNAL
namespace casadi {

  /** \brief Matrix and vector norms

      \author Joel Andersson
      \date 2010-2013
  */
  class CASADI_EXPORT Norm : public MXNode {
  public:

    /** \brief  Constructor */
    explicit Norm(const MX& x);

    /** \brief  Destructor */
    virtual ~Norm() {}
  };

  /** \brief Represents a Frobenius norm
      \author Joel Andersson
      \date 2010-2013
  */
  class CASADI_EXPORT NormF : public Norm {
  public:

    /** \brief  Constructor */
    explicit NormF(const MX& x) : Norm(x) {}

    /** \brief  Destructor */
    virtual ~NormF() {}

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

    /** \brief Generate code for the operation */
    void generate(const std::vector<int>& arg, const std::vector<int>& res,
                  CodeGenerator& g) const;

    /** \brief  Clone function */
    virtual NormF* clone() const { return new NormF(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_NORMF;}
  };

  /** \brief Represents a 2-norm (spectral norm)
      \author Joel Andersson
      \date 2010-2013
  */
  class CASADI_EXPORT Norm2 : public Norm {
  public:

    /** \brief  Constructor */
    explicit Norm2(const MX& x): Norm(x) {}

    /** \brief  Destructor */
    virtual ~Norm2() {}

    /** \brief  Clone function */
    virtual Norm2* clone() const { return new Norm2(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_NORM2;}
  };

  /** \brief 1-norm
      \author Joel Andersson
      \date 2010-2013
  */
  class CASADI_EXPORT Norm1 : public Norm {
  public:

    /** \brief  Constructor */
    Norm1(const MX& x) : Norm(x) {}

    /** \brief  Destructor */
    virtual ~Norm1() {}

    /** \brief  Clone function */
    virtual Norm1* clone() const { return new Norm1(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_NORM1;}
  };

  /** \brief Represents an infinity-norm operation on a MX
      \author Joel Andersson
      \date 2010
  */
  class CASADI_EXPORT NormInf : public Norm {
  public:

    /** \brief  Constructor */
    NormInf(const MX& x) : Norm(x) {}

    /** \brief  Destructor */
    virtual ~NormInf() {}

    /** \brief  Clone function */
    virtual NormInf* clone() const { return new NormInf(*this);}

    /** \brief  Print expression */
    virtual std::string print(const std::vector<std::string>& arg) const;

    /** \brief Get the operation */
    virtual int getOp() const { return OP_NORMINF;}
  };

} // namespace casadi

/// \endcond

#endif // CASADI_NORM_HPP
