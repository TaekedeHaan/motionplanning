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


#ifndef CASADI_INTEGRATOR_INTERNAL_HPP
#define CASADI_INTEGRATOR_INTERNAL_HPP

#include "integrator.hpp"
#include "function_internal.hpp"
#include "plugin_interface.hpp"

/// \cond INTERNAL

namespace casadi {

  /** \brief Internal storage for integrator related data

      @copydoc DAE_doc
      \author Joel Andersson
      \date 2010
  */
  class CASADI_EXPORT
  IntegratorInternal : public FunctionInternal,
                       public PluginInterface<IntegratorInternal> {
  public:
    /** \brief  Constructor */
    IntegratorInternal(const Function& f, const Function& g);

    /** \brief  Destructor */
    virtual ~IntegratorInternal()=0;

    /** \brief  Clone */
    virtual IntegratorInternal* clone() const=0;

    /** \brief  Deep copy data members */
    virtual void deepCopyMembers(std::map<SharedObjectNode*, SharedObject>& already_copied);

    /** \brief  Create a new integrator */
    virtual IntegratorInternal* create(const Function& f, const Function& g) const = 0;

    /** \brief  Print solver statistics */
    virtual void printStats(std::ostream &stream) const {}

    /** \brief  Reset the forward problem and bring the time back to t0 */
    virtual void reset();

    /** \brief  Reset the backward problem and take time to tf */
    virtual void resetB();

    /** \brief  Integrate forward until a specified time point */
    virtual void integrate(double t_out) = 0;

    /** \brief  Integrate backward until a specified time point */
    virtual void integrateB(double t_out) = 0;

    /** \brief  evaluate */
    virtual void evaluate();

    /** \brief  Initialize */
    virtual void init();

    /** \brief  Propagate sparsity forward */
    virtual void spFwd(const bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /** \brief  Propagate sparsity backwards */
    virtual void spAdj(bvec_t** arg, bvec_t** res, int* iw, bvec_t* w);

    /// Is the class able to propagate seeds through the algorithm?
    virtual bool spCanEvaluate(bool fwd) { return true;}

    ///@{
    /** \brief Generate a function that calculates \a nfwd forward derivatives */
    virtual Function getDerForward(const std::string& name, int nfwd, Dict& opts);
    virtual int numDerForward() const { return 64;}
    ///@}

    ///@{
    /** \brief Generate a function that calculates \a nadj adjoint derivatives */
    virtual Function getDerReverse(const std::string& name, int nadj, Dict& opts);
    virtual int numDerReverse() const { return 64;}
    ///@}

    /** \brief  Set stop time for the integration */
    virtual void setStopTime(double tf);

    // Helper structure
    struct AugOffset {
      std::vector<int> x, z, q, p, rx, rz, rq, rp;
    };

    /** \brief Set solver specific options to generated augmented integrators */
    virtual void setDerivativeOptions(Integrator& integrator, const AugOffset& offset);

    /** \brief Generate a augmented DAE system with \a nfwd forward sensitivities
    * and \a nadj adjoint sensitivities */
    virtual std::pair<Function, Function> getAugmented(int nfwd, int nadj, AugOffset& offset);

    /// Get offsets in augmented problem
    AugOffset getAugOffset(int nfwd, int nadj);

    /// Create sparsity pattern of the extended Jacobian (forward problem)
    Sparsity spJacF();

    /// Create sparsity pattern of the extended Jacobian (backward problem)
    Sparsity spJacG();

    ///@{
    // Shorthands
    DMatrix&  x0() { return input(INTEGRATOR_X0);}
    DMatrix&   p() { return input(INTEGRATOR_P );}
    DMatrix&  z0() { return input(INTEGRATOR_Z0);}
    DMatrix& rx0() { return input(INTEGRATOR_RX0);}
    DMatrix&  rp() { return input(INTEGRATOR_RP);}
    DMatrix& rz0() { return input(INTEGRATOR_RZ0);}
    DMatrix&  xf() { return output(INTEGRATOR_XF);}
    DMatrix&  qf() { return output(INTEGRATOR_QF);}
    DMatrix&  zf() { return output(INTEGRATOR_ZF);}
    DMatrix& rxf() { return output(INTEGRATOR_RXF);}
    DMatrix& rqf() { return output(INTEGRATOR_RQF);}
    DMatrix& rzf() { return output(INTEGRATOR_RZF);}
    ///@}

    /// Number of states for the forward integration
    int nx_, nz_, nq_;

    /// Number of states for the backward integration
    int nrx_, nrz_, nrq_;

    /// Number of forward and backward parameters
    int np_, nrp_;

    /// Integration horizon
    double t0_, tf_;

    // Current time
    double t_;

    /// ODE/DAE forward integration function
    Function f_;

    /// ODE/DAE backward integration function, if any
    Function g_;

    /// Integrator for sparsity pattern propagation
    LinearSolver linsol_f_, linsol_g_;

    /// Options
    bool print_stats_;

    // Creator function for internal class
    typedef IntegratorInternal* (*Creator)(const Function& f, const Function& g);

    // No static functions exposed
    struct Exposed{ };

    /// Collection of solvers
    static std::map<std::string, Plugin> solvers_;

    /// Infix
    static const std::string infix_;
  };

} // namespace casadi
/// \endcond

#endif // CASADI_INTEGRATOR_INTERNAL_HPP
