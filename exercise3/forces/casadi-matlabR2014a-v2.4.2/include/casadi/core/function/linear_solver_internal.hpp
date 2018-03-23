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


#ifndef CASADI_LINEAR_SOLVER_INTERNAL_HPP
#define CASADI_LINEAR_SOLVER_INTERNAL_HPP

#include "linear_solver.hpp"
#include "function_internal.hpp"
#include "plugin_interface.hpp"

/// \cond INTERNAL

namespace casadi {

  /** Internal class
      @copydoc LinearSolver_doc
  */
  class CASADI_EXPORT
  LinearSolverInternal : public FunctionInternal,
                         public PluginInterface<LinearSolverInternal> {
  public:
    /// Constructor
    LinearSolverInternal(const Sparsity& sparsity, int nrhs);

    /// Destructor
    virtual ~LinearSolverInternal();

    /// Clone
    virtual LinearSolverInternal* clone() const { return new LinearSolverInternal(*this);}

    /// Initialize
    virtual void init();

    /// Solve the system of equations
    virtual void evaluate();

    /// Prepare the factorization
    virtual void prepare() {}

    /// Solve the system of equations, using internal vector
    virtual void solve(bool transpose);

    /// Solve the system of equations
    virtual void solve(double* x, int nrhs, bool transpose);

    /// Create a solve node
    MX solve(const MX& A, const MX& B, bool transpose);

    /// Evaluate SX, possibly transposed
    virtual void evalSXLinsol(const SXElement** arg, SXElement** res,
                              int* iw, SXElement* w, bool tr, int nrhs);

    /** \brief Quickfix to avoid segfault, #1552 */
    virtual bool canEvalSX() const {return true;}

    /// Evaluate SX
    virtual void evalSX(const SXElement** arg, SXElement** res,
                        int* iw, SXElement* w) {
      evalSXLinsol(arg, res, iw, w, false, output(LINSOL_X).size2());
    }

    /** \brief Calculate forward mode directional derivatives */
    virtual void callForwardLinsol(const std::vector<MX>& arg, const std::vector<MX>& res,
                               const std::vector<std::vector<MX> >& fseed,
                               std::vector<std::vector<MX> >& fsens, bool tr);

    /** \brief Calculate reverse mode directional derivatives */
    virtual void callReverseLinsol(const std::vector<MX>& arg, const std::vector<MX>& res,
                               const std::vector<std::vector<MX> >& aseed,
                               std::vector<std::vector<MX> >& asens, bool tr);

    /** \brief  Propagate sparsity forward */
    virtual void spFwdLinsol(const bvec_t** arg, bvec_t** res,
                             int* iw, bvec_t* w, bool tr, int nrhs);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdjLinsol(bvec_t** arg, bvec_t** res,
                             int* iw, bvec_t* w, bool tr, int nrhs);

    ///@{
    /// Propagate sparsity through a linear solve
    void spSolve(bvec_t* X, const bvec_t* B, bool transpose) const;
    void spSolve(DMatrix& X, const DMatrix& B, bool transpose) const;
    ///@}


    /// Solve the system of equations <tt>Lx = b</tt>
    virtual void solveL(double* x, int nrhs, bool transpose);

    /// Obtain a symbolic Cholesky factorization
    virtual Sparsity getFactorizationSparsity(bool transpose) const;

    /// Obtain a numeric Cholesky factorization
    virtual DMatrix getFactorization(bool transpose) const;

    /// Dulmage-Mendelsohn decomposition
    std::vector<int> rowperm_, colperm_, rowblock_, colblock_;

    /// Is prepared
    bool prepared_;

    /// Get sparsity pattern
    int nrow() const { return input(LINSOL_A).size1();}
    int ncol() const { return input(LINSOL_A).size2();}
    int nnz() const { return input(LINSOL_A).nnz();}
    const int* row() const { return input(LINSOL_A).row();}
    const int* colind() const { return input(LINSOL_A).colind();}

    // Creator function for internal class
    typedef LinearSolverInternal* (*Creator)(const Sparsity& sp, int nrhs);

    // No static functions exposed
    struct Exposed{ };

    /// Collection of solvers
    static std::map<std::string, Plugin> solvers_;

    /// Infix
    static const std::string infix_;
  };


} // namespace casadi
/// \endcond

#endif // CASADI_LINEAR_SOLVER_INTERNAL_HPP

