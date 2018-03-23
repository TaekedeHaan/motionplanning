classdef Integrator < casadi.Function
    %Base class for integrators.
    %
    %Integrator abstract base class
    %
    %Solves an initial value problem (IVP) coupled to a terminal value problem
    %with differential equation given as an implicit ODE coupled to an algebraic
    %equation and a set of quadratures:
    %
    %::
    %
    %   Initial conditions at t=t0
    %   x(t0)  = x0
    %   q(t0)  = 0
    %  
    %   Forward integration from t=t0 to t=tf
    %   der(x) = function(x, z, p, t)                  Forward ODE
    %   0 = fz(x, z, p, t)                  Forward algebraic equations
    %   der(q) = fq(x, z, p, t)                  Forward quadratures
    %  
    %   Terminal conditions at t=tf
    %   rx(tf)  = rx0
    %   rq(tf)  = 0
    %  
    %   Backward integration from t=tf to t=t0
    %   der(rx) = gx(rx, rz, rp, x, z, p, t)        Backward ODE
    %   0 = gz(rx, rz, rp, x, z, p, t)        Backward algebraic equations
    %   der(rq) = gq(rx, rz, rp, x, z, p, t)        Backward quadratures
    %  
    %   where we assume that both the forward and backwards integrations are index-1
    %   (i.e. dfz/dz, dgz/drz are invertible) and furthermore that
    %   gx, gz and gq have a linear dependency on rx, rz and rp.
    %
    %
    %
    %The Integrator class provides some additional functionality, such as getting
    %the value of the state and/or sensitivities at certain time points.
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::IntegratorInput (INTEGRATOR_NUM_IN = 6) [integratorIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| INTEGRATOR_X0          | x0                     | Differential state at  |
    %|                        |                        | the initial time .     |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_P           | p                      | Parameters .           |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_Z0          | z0                     | Initial guess for the  |
    %|                        |                        | algebraic variable .   |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RX0         | rx0                    | Backward differential  |
    %|                        |                        | state at the final     |
    %|                        |                        | time .                 |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RP          | rp                     | Backward parameter     |
    %|                        |                        | vector .               |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RZ0         | rz0                    | Initial guess for the  |
    %|                        |                        | backwards algebraic    |
    %|                        |                        | variable .             |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::IntegratorOutput (INTEGRATOR_NUM_OUT = 6) [integratorOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| INTEGRATOR_XF          | xf                     | Differential state at  |
    %|                        |                        | the final time .       |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_QF          | qf                     | Quadrature state at    |
    %|                        |                        | the final time .       |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_ZF          | zf                     | Algebraic variable at  |
    %|                        |                        | the final time .       |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RXF         | rxf                    | Backward differential  |
    %|                        |                        | state at the initial   |
    %|                        |                        | time .                 |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RQF         | rqf                    | Backward quadrature    |
    %|                        |                        | state at the initial   |
    %|                        |                        | time .                 |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RZF         | rzf                    | Backward algebraic     |
    %|                        |                        | variable at the        |
    %|                        |                        | initial time .         |
    %+------------------------+------------------------+------------------------+
    %
    %>List of available options
    %
    %+--------------+--------------+--------------+--------------+--------------+
    %|      Id      |     Type     |   Default    | Description  |   Used in    |
    %+==============+==============+==============+==============+==============+
    %| ad_weight    | OT_REAL      | GenericType( | Weighting    | casadi::Func |
    %|              |              | )            | factor for   | tionInternal |
    %|              |              |              | derivative c |              |
    %|              |              |              | alculation.W |              |
    %|              |              |              | hen there is |              |
    %|              |              |              | an option of |              |
    %|              |              |              | either using |              |
    %|              |              |              | forward or   |              |
    %|              |              |              | reverse mode |              |
    %|              |              |              | directional  |              |
    %|              |              |              | derivatives, |              |
    %|              |              |              | the          |              |
    %|              |              |              | condition ad |              |
    %|              |              |              | _weight*nf<= |              |
    %|              |              |              | (1-ad_weight |              |
    %|              |              |              | )*na is used |              |
    %|              |              |              | where nf and |              |
    %|              |              |              | na are       |              |
    %|              |              |              | estimates of |              |
    %|              |              |              | the number   |              |
    %|              |              |              | of forward/r |              |
    %|              |              |              | everse mode  |              |
    %|              |              |              | directional  |              |
    %|              |              |              | derivatives  |              |
    %|              |              |              | needed. By   |              |
    %|              |              |              | default,     |              |
    %|              |              |              | ad_weight is |              |
    %|              |              |              | calculated a |              |
    %|              |              |              | utomatically |              |
    %|              |              |              | , but this   |              |
    %|              |              |              | can be       |              |
    %|              |              |              | overridden   |              |
    %|              |              |              | by setting   |              |
    %|              |              |              | this option. |              |
    %|              |              |              | In           |              |
    %|              |              |              | particular,  |              |
    %|              |              |              | 0 means      |              |
    %|              |              |              | forcing      |              |
    %|              |              |              | forward mode |              |
    %|              |              |              | and 1        |              |
    %|              |              |              | forcing      |              |
    %|              |              |              | reverse      |              |
    %|              |              |              | mode. Leave  |              |
    %|              |              |              | unset for    |              |
    %|              |              |              | (class       |              |
    %|              |              |              | specific)    |              |
    %|              |              |              | heuristics.  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| ad_weight_sp | OT_REAL      | GenericType( | Weighting    | casadi::Func |
    %|              |              | )            | factor for   | tionInternal |
    %|              |              |              | sparsity     |              |
    %|              |              |              | pattern      |              |
    %|              |              |              | calculation  |              |
    %|              |              |              | calculation. |              |
    %|              |              |              | Overrides    |              |
    %|              |              |              | default      |              |
    %|              |              |              | behavior.    |              |
    %|              |              |              | Set to 0 and |              |
    %|              |              |              | 1 to force   |              |
    %|              |              |              | forward and  |              |
    %|              |              |              | reverse mode |              |
    %|              |              |              | respectively |              |
    %|              |              |              | . Cf. option |              |
    %|              |              |              | "ad_weight". |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| augmented_op | OT_DICT      | GenericType( | Options to   | casadi::Inte |
    %| tions        |              | )            | be passed    | gratorIntern |
    %|              |              |              | down to the  | al           |
    %|              |              |              | augmented    |              |
    %|              |              |              | integrator,  |              |
    %|              |              |              | if one is    |              |
    %|              |              |              | constructed. |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| compiler     | OT_STRING    | "clang"      | Just-in-time | casadi::Func |
    %|              |              |              | compiler     | tionInternal |
    %|              |              |              | plugin to be |              |
    %|              |              |              | used.        |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| custom_forwa | OT_DERIVATIV | GenericType( | Function     | casadi::Func |
    %| rd           | EGENERATOR   | )            | that returns | tionInternal |
    %|              |              |              | a derivative |              |
    %|              |              |              | function     |              |
    %|              |              |              | given a      |              |
    %|              |              |              | number of    |              |
    %|              |              |              | forward mode |              |
    %|              |              |              | directional  |              |
    %|              |              |              | derivatives. |              |
    %|              |              |              | Overrides    |              |
    %|              |              |              | default      |              |
    %|              |              |              | routines.    |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| custom_rever | OT_DERIVATIV | GenericType( | Function     | casadi::Func |
    %| se           | EGENERATOR   | )            | that returns | tionInternal |
    %|              |              |              | a derivative |              |
    %|              |              |              | function     |              |
    %|              |              |              | given a      |              |
    %|              |              |              | number of    |              |
    %|              |              |              | reverse mode |              |
    %|              |              |              | directional  |              |
    %|              |              |              | derivatives. |              |
    %|              |              |              | Overrides    |              |
    %|              |              |              | default      |              |
    %|              |              |              | routines.    |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| defaults_rec | OT_STRINGVEC | GenericType( | Changes      | casadi::Opti |
    %| ipes         | TOR          | )            | default      | onsFunctiona |
    %|              |              |              | options      | lityNode     |
    %|              |              |              | according to |              |
    %|              |              |              | a given      |              |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| expand_augme | OT_BOOLEAN   | true         | If DAE       | casadi::Inte |
    %| nted         |              |              | callback     | gratorIntern |
    %|              |              |              | functions    | al           |
    %|              |              |              | are          |              |
    %|              |              |              | SXFunction , |              |
    %|              |              |              | have         |              |
    %|              |              |              | augmented    |              |
    %|              |              |              | DAE callback |              |
    %|              |              |              | function     |              |
    %|              |              |              | also be      |              |
    %|              |              |              | SXFunction . |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| full_jacobia | OT_FUNCTION  | GenericType( | The Jacobian | casadi::Func |
    %| n            |              | )            | of all       | tionInternal |
    %|              |              |              | outputs with |              |
    %|              |              |              | respect to   |              |
    %|              |              |              | all inputs.  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| gather_stats | OT_BOOLEAN   | false        | Flag to      | casadi::Func |
    %|              |              |              | indicate     | tionInternal |
    %|              |              |              | whether      |              |
    %|              |              |              | statistics   |              |
    %|              |              |              | must be      |              |
    %|              |              |              | gathered     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| input_scheme | OT_STRINGVEC | GenericType( | Custom input | casadi::Func |
    %|              | TOR          | )            | scheme       | tionInternal |
    %+--------------+--------------+--------------+--------------+--------------+
    %| inputs_check | OT_BOOLEAN   | true         | Throw        | casadi::Func |
    %|              |              |              | exceptions   | tionInternal |
    %|              |              |              | when the     |              |
    %|              |              |              | numerical    |              |
    %|              |              |              | values of    |              |
    %|              |              |              | the inputs   |              |
    %|              |              |              | don't make   |              |
    %|              |              |              | sense        |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jac_penalty  | OT_REAL      | 2            | When         | casadi::Func |
    %|              |              |              | requested    | tionInternal |
    %|              |              |              | for a number |              |
    %|              |              |              | of forward/r |              |
    %|              |              |              | everse       |              |
    %|              |              |              | directions,  |              |
    %|              |              |              | it may be    |              |
    %|              |              |              | cheaper to   |              |
    %|              |              |              | compute      |              |
    %|              |              |              | first the    |              |
    %|              |              |              | full         |              |
    %|              |              |              | jacobian and |              |
    %|              |              |              | then         |              |
    %|              |              |              | multiply     |              |
    %|              |              |              | with seeds,  |              |
    %|              |              |              | rather than  |              |
    %|              |              |              | obtain the   |              |
    %|              |              |              | requested    |              |
    %|              |              |              | directions   |              |
    %|              |              |              | in a straigh |              |
    %|              |              |              | tforward     |              |
    %|              |              |              | manner.      |              |
    %|              |              |              | Casadi uses  |              |
    %|              |              |              | a heuristic  |              |
    %|              |              |              | to decide    |              |
    %|              |              |              | which is     |              |
    %|              |              |              | cheaper. A   |              |
    %|              |              |              | high value   |              |
    %|              |              |              | of 'jac_pena |              |
    %|              |              |              | lty' makes   |              |
    %|              |              |              | it less      |              |
    %|              |              |              | likely for   |              |
    %|              |              |              | the heurstic |              |
    %|              |              |              | to chose the |              |
    %|              |              |              | full         |              |
    %|              |              |              | Jacobian     |              |
    %|              |              |              | strategy.    |              |
    %|              |              |              | The special  |              |
    %|              |              |              | value -1     |              |
    %|              |              |              | indicates    |              |
    %|              |              |              | never to use |              |
    %|              |              |              | the full     |              |
    %|              |              |              | Jacobian     |              |
    %|              |              |              | strategy     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jit          | OT_BOOLEAN   | false        | Use just-in- | casadi::Func |
    %|              |              |              | time         | tionInternal |
    %|              |              |              | compiler to  |              |
    %|              |              |              | speed up the |              |
    %|              |              |              | evaluation   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jit_options  | OT_DICT      | GenericType( | Options to   | casadi::Func |
    %|              |              | )            | be passed to | tionInternal |
    %|              |              |              | the jit      |              |
    %|              |              |              | compiler.    |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| monitor      | OT_STRINGVEC | GenericType( | Monitors to  | casadi::Func |
    %|              | TOR          | )            | be activated | tionInternal |
    %|              |              |              | (inputs|outp |              |
    %|              |              |              | uts)         |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| name         | OT_STRING    | "unnamed_sha | name of the  | casadi::Opti |
    %|              |              | red_object"  | object       | onsFunctiona |
    %|              |              |              |              | lityNode     |
    %+--------------+--------------+--------------+--------------+--------------+
    %| output_schem | OT_STRINGVEC | GenericType( | Custom       | casadi::Func |
    %| e            | TOR          | )            | output       | tionInternal |
    %|              |              |              | scheme       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| print_stats  | OT_BOOLEAN   | false        | Print out    | casadi::Inte |
    %|              |              |              | statistics   | gratorIntern |
    %|              |              |              | after        | al           |
    %|              |              |              | integration  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| regularity_c | OT_BOOLEAN   | true         | Throw        | casadi::Func |
    %| heck         |              |              | exceptions   | tionInternal |
    %|              |              |              | when NaN or  |              |
    %|              |              |              | Inf appears  |              |
    %|              |              |              | during       |              |
    %|              |              |              | evaluation   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| t0           | OT_REAL      | 0            | Beginning of | casadi::Inte |
    %|              |              |              | the time     | gratorIntern |
    %|              |              |              | horizon      | al           |
    %+--------------+--------------+--------------+--------------+--------------+
    %| tf           | OT_REAL      | 1            | End of the   | casadi::Inte |
    %|              |              |              | time horizon | gratorIntern |
    %|              |              |              |              | al           |
    %+--------------+--------------+--------------+--------------+--------------+
    %| user_data    | OT_VOIDPTR   | GenericType( | A user-      | casadi::Func |
    %|              |              | )            | defined      | tionInternal |
    %|              |              |              | field that   |              |
    %|              |              |              | can be used  |              |
    %|              |              |              | to identify  |              |
    %|              |              |              | the function |              |
    %|              |              |              | or pass      |              |
    %|              |              |              | additional   |              |
    %|              |              |              | information  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| verbose      | OT_BOOLEAN   | false        | Verbose      | casadi::Func |
    %|              |              |              | evaluation   | tionInternal |
    %|              |              |              | for          |              |
    %|              |              |              | debugging    |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %
    %List of plugins
    %===============
    %
    %
    %
    %- cvodes
    %
    %- idas
    %
    %- collocation
    %
    %- oldcollocation
    %
    %- rk
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Integrator.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %cvodes
    %------
    %
    %
    %
    %Interface to CVodes from the Sundials suite.
    %
    %A call to evaluate will integrate to the end.
    %
    %You can retrieve the entire state trajectory as follows, after the evaluate
    %call: Call reset. Then call integrate(t_i) and getOuput for a series of
    %times t_i.
    %
    %Note: depending on the dimension and structure of your problem, you may
    %experience a dramatic speed-up by using a sparse linear solver:
    %
    %
    %
    %::
    %
    %     intg.setOption("linear_solver","csparse")
    %     intg.setOption("linear_solver_type","user_defined")
    %
    %
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| abstol          | OT_REAL         | 0.000           | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the IVP         |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| abstolB         | OT_REAL         | GenericType()   | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the adjoint     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to abstol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| disable_interna | OT_BOOLEAN      | false           | Disable CVodes  |
    %| l_warnings      |                 |                 | internal        |
    %|                 |                 |                 | warning         |
    %|                 |                 |                 | messages        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| exact_jacobian  | OT_BOOLEAN      | true            | Use exact       |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | information for |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | integration     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| exact_jacobianB | OT_BOOLEAN      | GenericType()   | Use exact       |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | information for |
    %|                 |                 |                 | the backward    |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to              |
    %|                 |                 |                 | exact_jacobian] |
    %+-----------------+-----------------+-----------------+-----------------+
    %| finite_differen | OT_BOOLEAN      | false           | Use finite      |
    %| ce_fsens        |                 |                 | differences to  |
    %|                 |                 |                 | approximate the |
    %|                 |                 |                 | forward         |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | equations (if   |
    %|                 |                 |                 | AD is not       |
    %|                 |                 |                 | available)      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_abstol    | OT_REAL         | GenericType()   | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to abstol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_all_at_on | OT_BOOLEAN      | true            | Calculate all   |
    %| ce              |                 |                 | right hand      |
    %|                 |                 |                 | sides of the    |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | equations at    |
    %|                 |                 |                 | once            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_err_con   | OT_BOOLEAN      | true            | include the     |
    %|                 |                 |                 | forward         |
    %|                 |                 |                 | sensitivities   |
    %|                 |                 |                 | in all error    |
    %|                 |                 |                 | controls        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_reltol    | OT_REAL         | GenericType()   | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to reltol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_scaling_f | OT_REALVECTOR   | GenericType()   | Scaling factor  |
    %| actors          |                 |                 | for the         |
    %|                 |                 |                 | components if   |
    %|                 |                 |                 | finite          |
    %|                 |                 |                 | differences is  |
    %|                 |                 |                 | used            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_sensitivi | OT_INTEGERVECTO | GenericType()   | Specifies which |
    %| y_parameters    | R               |                 | components will |
    %|                 |                 |                 | be used when    |
    %|                 |                 |                 | estimating the  |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | equations       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| interpolation_t | OT_STRING       | "hermite"       | Type of         |
    %| ype             |                 |                 | interpolation   |
    %|                 |                 |                 | for the adjoint |
    %|                 |                 |                 | sensitivities ( |
    %|                 |                 |                 | hermite|polynom |
    %|                 |                 |                 | ial)            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| iterative_solve | OT_STRING       | "gmres"         | (gmres|bcgstab| |
    %| r               |                 |                 | tfqmr)          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| iterative_solve | OT_STRING       | GenericType()   | (gmres|bcgstab| |
    %| rB              |                 |                 | tfqmr)          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_multiste | OT_STRING       | "bdf"           | Integrator      |
    %| p_method        |                 |                 | scheme          |
    %|                 |                 |                 | (bdf|adams)     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver   | OT_STRING       | GenericType()   | A custom linear |
    %|                 |                 |                 | solver creator  |
    %|                 |                 |                 | function        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solverB  | OT_STRING       | GenericType()   | A custom linear |
    %|                 |                 |                 | solver creator  |
    %|                 |                 |                 | function for    |
    %|                 |                 |                 | backwards       |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to              |
    %|                 |                 |                 | linear_solver]  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_o | OT_DICT         | GenericType()   | Options to be   |
    %| ptions          |                 |                 | passed to the   |
    %|                 |                 |                 | linear solver   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_o | OT_DICT         | GenericType()   | Options to be   |
    %| ptionsB         |                 |                 | passed to the   |
    %|                 |                 |                 | linear solver   |
    %|                 |                 |                 | for backwards   |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to linear_solve |
    %|                 |                 |                 | r_options]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_t | OT_STRING       | "dense"         | (user_defined|d |
    %| ype             |                 |                 | ense|banded|ite |
    %|                 |                 |                 | rative)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_t | OT_STRING       | GenericType()   | (user_defined|d |
    %| ypeB            |                 |                 | ense|banded|ite |
    %|                 |                 |                 | rative)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lower_bandwidth | OT_INTEGER      | GenericType()   | Lower band-     |
    %|                 |                 |                 | width of banded |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | (estimations)   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lower_bandwidth | OT_INTEGER      | GenericType()   | lower band-     |
    %| B               |                 |                 | width of banded |
    %|                 |                 |                 | jacobians for   |
    %|                 |                 |                 | backward        |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to lower_bandwi |
    %|                 |                 |                 | dth]            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_krylov      | OT_INTEGER      | 10              | Maximum Krylov  |
    %|                 |                 |                 | subspace size   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_krylovB     | OT_INTEGER      | GenericType()   | Maximum krylov  |
    %|                 |                 |                 | subspace size   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_multistep_o | OT_INTEGER      | 5               |                 |
    %| rder            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_num_steps   | OT_INTEGER      | 10000           | Maximum number  |
    %|                 |                 |                 | of integrator   |
    %|                 |                 |                 | steps           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nonlinear_solve | OT_STRING       | "newton"        | (newton|functio |
    %| r_iteration     |                 |                 | nal)            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pretype         | OT_STRING       | "none"          | (none|left|righ |
    %|                 |                 |                 | t|both)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pretypeB        | OT_STRING       | GenericType()   | (none|left|righ |
    %|                 |                 |                 | t|both)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quad_err_con    | OT_BOOLEAN      | false           | Should the      |
    %|                 |                 |                 | quadratures     |
    %|                 |                 |                 | affect the step |
    %|                 |                 |                 | size control    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltol          | OT_REAL         | 0.000           | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the IVP         |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltolB         | OT_REAL         | GenericType()   | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the adjoint     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to reltol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| sensitivity_met | OT_STRING       | "simultaneous"  | (simultaneous|s |
    %| hod             |                 |                 | taggered)       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| steps_per_check | OT_INTEGER      | 20              | Number of steps |
    %| point           |                 |                 | between two     |
    %|                 |                 |                 | consecutive     |
    %|                 |                 |                 | checkpoints     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| stop_at_end     | OT_BOOLEAN      | true            | Stop the        |
    %|                 |                 |                 | integrator at   |
    %|                 |                 |                 | the end of the  |
    %|                 |                 |                 | interval        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| upper_bandwidth | OT_INTEGER      | GenericType()   | Upper band-     |
    %|                 |                 |                 | width of banded |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | (estimations)   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| upper_bandwidth | OT_INTEGER      | GenericType()   | Upper band-     |
    %| B               |                 |                 | width of banded |
    %|                 |                 |                 | jacobians for   |
    %|                 |                 |                 | backward        |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to upper_bandwi |
    %|                 |                 |                 | dth]            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| use_preconditio | OT_BOOLEAN      | false           | Precondition an |
    %| ner             |                 |                 | iterative       |
    %|                 |                 |                 | solver          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| use_preconditio | OT_BOOLEAN      | GenericType()   | Precondition an |
    %| nerB            |                 |                 | iterative       |
    %|                 |                 |                 | solver for the  |
    %|                 |                 |                 | backwards       |
    %|                 |                 |                 | problem         |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to use_precondi |
    %|                 |                 |                 | tioner]         |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+---------+
    %|   Id    |
    %+=========+
    %| djacB   |
    %+---------+
    %| psetupB |
    %+---------+
    %| res     |
    %+---------+
    %| resB    |
    %+---------+
    %| resQB   |
    %+---------+
    %| reset   |
    %+---------+
    %
    %>List of available stats
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| nlinsetups  |
    %+-------------+
    %| nlinsetupsB |
    %+-------------+
    %| nsteps      |
    %+-------------+
    %| nstepsB     |
    %+-------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %idas
    %----
    %
    %
    %
    %Interface to IDAS from the Sundials suite.
    %
    %Note: depending on the dimension and structure of your problem, you may
    %experience a dramatic speed-up by using a sparse linear solver:
    %
    %
    %
    %::
    %
    %     intg.setOption("linear_solver","csparse")
    %     intg.setOption("linear_solver_type","user_defined")
    %
    %
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| abstol          | OT_REAL         | 0.000           | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the IVP         |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| abstolB         | OT_REAL         | GenericType()   | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the adjoint     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to abstol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| abstolv         | OT_REALVECTOR   |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| calc_ic         | OT_BOOLEAN      | true            | Use IDACalcIC   |
    %|                 |                 |                 | to get          |
    %|                 |                 |                 | consistent      |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | conditions.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| calc_icB        | OT_BOOLEAN      | GenericType()   | Use IDACalcIC   |
    %|                 |                 |                 | to get          |
    %|                 |                 |                 | consistent      |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | conditions for  |
    %|                 |                 |                 | backwards       |
    %|                 |                 |                 | system          |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to calc_ic].    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| cj_scaling      | OT_BOOLEAN      | false           | IDAS scaling on |
    %|                 |                 |                 | cj for the      |
    %|                 |                 |                 | user-defined    |
    %|                 |                 |                 | linear solver   |
    %|                 |                 |                 | module          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| disable_interna | OT_BOOLEAN      | false           | Disable IDAS    |
    %| l_warnings      |                 |                 | internal        |
    %|                 |                 |                 | warning         |
    %|                 |                 |                 | messages        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| exact_jacobian  | OT_BOOLEAN      | true            | Use exact       |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | information for |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | integration     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| exact_jacobianB | OT_BOOLEAN      | GenericType()   | Use exact       |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | information for |
    %|                 |                 |                 | the backward    |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to              |
    %|                 |                 |                 | exact_jacobian] |
    %+-----------------+-----------------+-----------------+-----------------+
    %| extra_fsens_cal | OT_BOOLEAN      | false           | Call calc ic an |
    %| c_ic            |                 |                 | extra time,     |
    %|                 |                 |                 | with fsens=0    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| finite_differen | OT_BOOLEAN      | false           | Use finite      |
    %| ce_fsens        |                 |                 | differences to  |
    %|                 |                 |                 | approximate the |
    %|                 |                 |                 | forward         |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | equations (if   |
    %|                 |                 |                 | AD is not       |
    %|                 |                 |                 | available)      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| first_time      | OT_REAL         | GenericType()   | First requested |
    %|                 |                 |                 | time as a       |
    %|                 |                 |                 | fraction of the |
    %|                 |                 |                 | time interval   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_abstol    | OT_REAL         | GenericType()   | Absolute        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to abstol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_abstolv   | OT_REALVECTOR   |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_err_con   | OT_BOOLEAN      | true            | include the     |
    %|                 |                 |                 | forward         |
    %|                 |                 |                 | sensitivities   |
    %|                 |                 |                 | in all error    |
    %|                 |                 |                 | controls        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_reltol    | OT_REAL         | GenericType()   | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the forward     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to reltol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_scaling_f | OT_REALVECTOR   | GenericType()   | Scaling factor  |
    %| actors          |                 |                 | for the         |
    %|                 |                 |                 | components if   |
    %|                 |                 |                 | finite          |
    %|                 |                 |                 | differences is  |
    %|                 |                 |                 | used            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fsens_sensitivi | OT_INTEGERVECTO | GenericType()   | Specifies which |
    %| y_parameters    | R               |                 | components will |
    %|                 |                 |                 | be used when    |
    %|                 |                 |                 | estimating the  |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | equations       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| init_xdot       | OT_REALVECTOR   | GenericType()   | Initial values  |
    %|                 |                 |                 | for the state   |
    %|                 |                 |                 | derivatives     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| interpolation_t | OT_STRING       | "hermite"       | Type of         |
    %| ype             |                 |                 | interpolation   |
    %|                 |                 |                 | for the adjoint |
    %|                 |                 |                 | sensitivities ( |
    %|                 |                 |                 | hermite|polynom |
    %|                 |                 |                 | ial)            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| iterative_solve | OT_STRING       | "gmres"         | (gmres|bcgstab| |
    %| r               |                 |                 | tfqmr)          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| iterative_solve | OT_STRING       | GenericType()   | (gmres|bcgstab| |
    %| rB              |                 |                 | tfqmr)          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver   | OT_STRING       | GenericType()   | A custom linear |
    %|                 |                 |                 | solver creator  |
    %|                 |                 |                 | function        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solverB  | OT_STRING       | GenericType()   | A custom linear |
    %|                 |                 |                 | solver creator  |
    %|                 |                 |                 | function for    |
    %|                 |                 |                 | backwards       |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to              |
    %|                 |                 |                 | linear_solver]  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_o | OT_DICT         | GenericType()   | Options to be   |
    %| ptions          |                 |                 | passed to the   |
    %|                 |                 |                 | linear solver   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_o | OT_DICT         | GenericType()   | Options to be   |
    %| ptionsB         |                 |                 | passed to the   |
    %|                 |                 |                 | linear solver   |
    %|                 |                 |                 | for backwards   |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to linear_solve |
    %|                 |                 |                 | r_options]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_t | OT_STRING       | "dense"         | (user_defined|d |
    %| ype             |                 |                 | ense|banded|ite |
    %|                 |                 |                 | rative)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_t | OT_STRING       | GenericType()   | (user_defined|d |
    %| ypeB            |                 |                 | ense|banded|ite |
    %|                 |                 |                 | rative)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lower_bandwidth | OT_INTEGER      | GenericType()   | Lower band-     |
    %|                 |                 |                 | width of banded |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | (estimations)   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lower_bandwidth | OT_INTEGER      | GenericType()   | lower band-     |
    %| B               |                 |                 | width of banded |
    %|                 |                 |                 | jacobians for   |
    %|                 |                 |                 | backward        |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to lower_bandwi |
    %|                 |                 |                 | dth]            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_krylov      | OT_INTEGER      | 10              | Maximum Krylov  |
    %|                 |                 |                 | subspace size   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_krylovB     | OT_INTEGER      | GenericType()   | Maximum krylov  |
    %|                 |                 |                 | subspace size   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_multistep_o | OT_INTEGER      | 5               |                 |
    %| rder            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_num_steps   | OT_INTEGER      | 10000           | Maximum number  |
    %|                 |                 |                 | of integrator   |
    %|                 |                 |                 | steps           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_step_size   | OT_REAL         | 0               | Maximim step    |
    %|                 |                 |                 | size            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pretype         | OT_STRING       | "none"          | (none|left|righ |
    %|                 |                 |                 | t|both)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pretypeB        | OT_STRING       | GenericType()   | (none|left|righ |
    %|                 |                 |                 | t|both)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quad_err_con    | OT_BOOLEAN      | false           | Should the      |
    %|                 |                 |                 | quadratures     |
    %|                 |                 |                 | affect the step |
    %|                 |                 |                 | size control    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltol          | OT_REAL         | 0.000           | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the IVP         |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltolB         | OT_REAL         | GenericType()   | Relative        |
    %|                 |                 |                 | tolerence for   |
    %|                 |                 |                 | the adjoint     |
    %|                 |                 |                 | sensitivity     |
    %|                 |                 |                 | solution        |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to reltol]      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| sensitivity_met | OT_STRING       | "simultaneous"  | (simultaneous|s |
    %| hod             |                 |                 | taggered)       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| steps_per_check | OT_INTEGER      | 20              | Number of steps |
    %| point           |                 |                 | between two     |
    %|                 |                 |                 | consecutive     |
    %|                 |                 |                 | checkpoints     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| stop_at_end     | OT_BOOLEAN      | true            | Stop the        |
    %|                 |                 |                 | integrator at   |
    %|                 |                 |                 | the end of the  |
    %|                 |                 |                 | interval        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| suppress_algebr | OT_BOOLEAN      | false           | Suppress        |
    %| aic             |                 |                 | algebraic       |
    %|                 |                 |                 | variables in    |
    %|                 |                 |                 | the error       |
    %|                 |                 |                 | testing         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| upper_bandwidth | OT_INTEGER      | GenericType()   | Upper band-     |
    %|                 |                 |                 | width of banded |
    %|                 |                 |                 | Jacobian        |
    %|                 |                 |                 | (estimations)   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| upper_bandwidth | OT_INTEGER      | GenericType()   | Upper band-     |
    %| B               |                 |                 | width of banded |
    %|                 |                 |                 | jacobians for   |
    %|                 |                 |                 | backward        |
    %|                 |                 |                 | integration     |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to upper_bandwi |
    %|                 |                 |                 | dth]            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| use_preconditio | OT_BOOLEAN      | false           | Precondition an |
    %| ner             |                 |                 | iterative       |
    %|                 |                 |                 | solver          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| use_preconditio | OT_BOOLEAN      | GenericType()   | Precondition an |
    %| nerB            |                 |                 | iterative       |
    %|                 |                 |                 | solver for the  |
    %|                 |                 |                 | backwards       |
    %|                 |                 |                 | problem         |
    %|                 |                 |                 | [default: equal |
    %|                 |                 |                 | to use_precondi |
    %|                 |                 |                 | tioner]         |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+--------------------------+
    %|            Id            |
    %+==========================+
    %| bjacB                    |
    %+--------------------------+
    %| correctInitialConditions |
    %+--------------------------+
    %| jtimesB                  |
    %+--------------------------+
    %| psetup                   |
    %+--------------------------+
    %| psetupB                  |
    %+--------------------------+
    %| psolveB                  |
    %+--------------------------+
    %| res                      |
    %+--------------------------+
    %| resB                     |
    %+--------------------------+
    %| resS                     |
    %+--------------------------+
    %| rhsQB                    |
    %+--------------------------+
    %
    %>List of available stats
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| nlinsetups  |
    %+-------------+
    %| nlinsetupsB |
    %+-------------+
    %| nsteps      |
    %+-------------+
    %| nstepsB     |
    %+-------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %collocation
    %-----------
    %
    %
    %
    %Fixed-step implicit Runge-Kutta integrator ODE/DAE integrator based on
    %collocation schemes
    %
    %The method is still under development
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| collocation_sch | OT_STRING       | "radau"         | Collocation     |
    %| eme             |                 |                 | scheme (radau|l |
    %|                 |                 |                 | egendre)        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| implicit_solver | OT_STRING       | GenericType()   | An implicit     |
    %|                 |                 |                 | function solver |
    %+-----------------+-----------------+-----------------+-----------------+
    %| implicit_solver | OT_DICT         | GenericType()   | Options to be   |
    %| _options        |                 |                 | passed to the   |
    %|                 |                 |                 | NLP Solver      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| interpolation_o | OT_INTEGER      | 3               | Order of the    |
    %| rder            |                 |                 | interpolating   |
    %|                 |                 |                 | polynomials     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| number_of_finit | OT_INTEGER      | 20              | Number of       |
    %| e_elements      |                 |                 | finite elements |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %oldcollocation
    %--------------
    %
    %
    %
    %Collocation integrator ODE/DAE integrator based on collocation
    %
    %The method is still under development
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| collocation_sch | OT_STRING       | "radau"         | Collocation     |
    %| eme             |                 |                 | scheme (radau|l |
    %|                 |                 |                 | egendre)        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| expand_f        | OT_BOOLEAN      | false           | Expand the      |
    %|                 |                 |                 | ODE/DAE         |
    %|                 |                 |                 | residual        |
    %|                 |                 |                 | function in an  |
    %|                 |                 |                 | SX graph        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| expand_q        | OT_BOOLEAN      | false           | Expand the      |
    %|                 |                 |                 | quadrature      |
    %|                 |                 |                 | function in an  |
    %|                 |                 |                 | SX graph        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hotstart        | OT_BOOLEAN      | true            | Initialize the  |
    %|                 |                 |                 | trajectory at   |
    %|                 |                 |                 | the previous    |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| implicit_solver | OT_STRING       | GenericType()   | An implicit     |
    %|                 |                 |                 | function solver |
    %+-----------------+-----------------+-----------------+-----------------+
    %| implicit_solver | OT_DICT         | GenericType()   | Options to be   |
    %| _options        |                 |                 | passed to the   |
    %|                 |                 |                 | implicit solver |
    %+-----------------+-----------------+-----------------+-----------------+
    %| interpolation_o | OT_INTEGER      | 3               | Order of the    |
    %| rder            |                 |                 | interpolating   |
    %|                 |                 |                 | polynomials     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| number_of_finit | OT_INTEGER      | 20              | Number of       |
    %| e_elements      |                 |                 | finite elements |
    %+-----------------+-----------------+-----------------+-----------------+
    %| startup_integra | OT_STRING       | GenericType()   | An ODE/DAE      |
    %| tor             |                 |                 | integrator that |
    %|                 |                 |                 | can be used to  |
    %|                 |                 |                 | generate a      |
    %|                 |                 |                 | startup         |
    %|                 |                 |                 | trajectory      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| startup_integra | OT_DICT         | GenericType()   | Options to be   |
    %| tor_options     |                 |                 | passed to the   |
    %|                 |                 |                 | startup         |
    %|                 |                 |                 | integrator      |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %rk --
    %
    %
    %
    %Fixed-step explicit Runge-Kutta integrator for ODEs Currently implements
    %RK4.
    %
    %The method is still under development
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| number_of_finit | OT_INTEGER      | 20              | Number of       |
    %| e_elements      |                 |                 | finite elements |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joel Andersson
    %Diagrams
    %--------
    %
    %
    %
    %C++ includes: integrator.hpp 
    %Usage: Integrator ()
    %
  methods
    function varargout = clone(self,varargin)
    %Clone.
    %
    %
    %Usage: retval = clone ()
    %
    %retval is of type Integrator. 

      try

      if ~isa(self,'casadi.Integrator')
        self = casadi.Integrator(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(961, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printStats(self,varargin)
    %Print solver statistics.
    %
    %
    %Usage: printStats ()
    %

      try

      if ~isa(self,'casadi.Integrator')
        self = casadi.Integrator(self);
      end
      [varargout{1:nargout}] = casadiMEX(962, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = reset(self,varargin)
    %Reset the forward problem Time will be set to t0 and state to
    %input(INTEGRATOR_X0)
    %
    %
    %Usage: reset ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(963, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = integrate(self,varargin)
    %Integrate forward until a specified time point.
    %
    %
    %Usage: integrate (t_out)
    %
    %t_out is of type double. 

      try

      [varargout{1:nargout}] = casadiMEX(964, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = resetB(self,varargin)
    %Reset the backward problem.
    %
    %Time will be set to tf and backward state to input(INTEGRATOR_RX0)
    %
    %
    %Usage: resetB ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(965, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = integrateB(self,varargin)
    %Integrate backward until a specified time point.
    %
    %
    %Usage: integrateB (t_out)
    %
    %t_out is of type double. 

      try

      [varargout{1:nargout}] = casadiMEX(966, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getAugmented(self,varargin)
    %Generate a augmented DAE system with nfwd forward sensitivities and nadj
    %adjoint sensitivities.
    %
    %
    %Usage: retval = getAugmented (nfwd, nadj)
    %
    %nfwd is of type int. nadj is of type int. nfwd is of type int. nadj is of type int. retval is of type std::pair< casadi::Function,casadi::Function >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(970, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getDAE(self,varargin)
    %Get the DAE.
    %
    %
    %Usage: retval = getDAE ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(971, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setStopTime(self,varargin)
    %Set a stop time for the forward integration.
    %
    %
    %Usage: setStopTime (tf)
    %
    %tf is of type double. 

      try

      [varargout{1:nargout}] = casadiMEX(972, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Integrator(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(974, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(975, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = hasPlugin(varargin)
    %Usage: retval = hasPlugin (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(967, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = loadPlugin(varargin)
    %Usage: loadPlugin (name)
    %
    %name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(968, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = doc(varargin)
    %Usage: retval = doc (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(969, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(973, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
  end
end
