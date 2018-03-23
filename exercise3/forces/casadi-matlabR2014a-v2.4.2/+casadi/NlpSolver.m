classdef NlpSolver < casadi.Function
    %NlpSolver.
    %
    %Solves the following parametric nonlinear program (NLP):
    %
    %::
    %
    %  min          F(x, p)
    %   x
    %  
    %  subject to
    %              LBX <=   x    <= UBX
    %              LBG <= G(x, p) <= UBG
    %                         p  == P
    %  
    %      nx: number of decision variables
    %      ng: number of constraints
    %      np: number of parameters
    %  
    %
    %
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::NlpSolverInput (NLP_SOLVER_NUM_IN = 8) [nlpSolverIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X0          | x0                     | Decision variables,    |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_P           | p                      | Value of fixed         |
    %|                        |                        | parameters (np x 1) .  |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBX         | lbx                    | Decision variables     |
    %|                        |                        | lower bound (nx x 1),  |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBX         | ubx                    | Decision variables     |
    %|                        |                        | upper bound (nx x 1),  |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBG         | lbg                    | Constraints lower      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBG         | ubg                    | Constraints upper      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X0      | lam_x0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on X,       |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G0      | lam_g0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on G,       |
    %|                        |                        | initial guess (ng x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::NlpSolverOutput (NLP_SOLVER_NUM_OUT = 6) [nlpSolverOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X           | x                      | Decision variables at  |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (nx x 1) .             |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_F           | f                      | Cost function value at |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_G           | g                      | Constraints function   |
    %|                        |                        | at the optimal         |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X       | lam_x                  | Lagrange multipliers   |
    %|                        |                        | for bounds on X at the |
    %|                        |                        | solution (nx x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G       | lam_g                  | Lagrange multipliers   |
    %|                        |                        | for bounds on G at the |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_P       | lam_p                  | Lagrange multipliers   |
    %|                        |                        | for bounds on P at the |
    %|                        |                        | solution (np x 1) .    |
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
    %|              |              |              | options      | lityNode   c |
    %|              |              |              | according to | asadi::NlpSo |
    %|              |              |              | a given      | lverInternal |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)  (qp) |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| eval_errors_ | OT_BOOLEAN   | false        | When errors  | casadi::NlpS |
    %| fatal        |              |              | occur during | olverInterna |
    %|              |              |              | evaluation   | l            |
    %|              |              |              | of           |              |
    %|              |              |              | f,g,...,stop |              |
    %|              |              |              | the          |              |
    %|              |              |              | iterations   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| expand       | OT_BOOLEAN   | false        | Expand the   | casadi::NlpS |
    %|              |              |              | NLP function | olverInterna |
    %|              |              |              | in terms of  | l            |
    %|              |              |              | scalar       |              |
    %|              |              |              | operations,  |              |
    %|              |              |              | i.e. MX->SX  |              |
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
    %| grad_f       | OT_FUNCTION  | GenericType( | Function for | casadi::NlpS |
    %|              |              | )            | calculating  | olverInterna |
    %|              |              |              | the gradient | l            |
    %|              |              |              | of the       |              |
    %|              |              |              | objective    |              |
    %|              |              |              | (column, aut |              |
    %|              |              |              | ogenerated   |              |
    %|              |              |              | by default)  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| grad_f_optio | OT_DICT      | GenericType( | Options for  | casadi::NlpS |
    %| ns           |              | )            | the autogene | olverInterna |
    %|              |              |              | rated        | l            |
    %|              |              |              | gradient of  |              |
    %|              |              |              | the          |              |
    %|              |              |              | objective.   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| grad_lag     | OT_FUNCTION  | GenericType( | Function for | casadi::NlpS |
    %|              |              | )            | calculating  | olverInterna |
    %|              |              |              | the gradient | l            |
    %|              |              |              | of the       |              |
    %|              |              |              | Lagrangian ( |              |
    %|              |              |              | autogenerate |              |
    %|              |              |              | d by         |              |
    %|              |              |              | default)     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| grad_lag_opt | OT_DICT      | GenericType( | Options for  | casadi::NlpS |
    %| ions         |              | )            | the autogene | olverInterna |
    %|              |              |              | rated        | l            |
    %|              |              |              | gradient of  |              |
    %|              |              |              | the          |              |
    %|              |              |              | Lagrangian.  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| hess_lag     | OT_FUNCTION  | GenericType( | Function for | casadi::NlpS |
    %|              |              | )            | calculating  | olverInterna |
    %|              |              |              | the Hessian  | l            |
    %|              |              |              | of the       |              |
    %|              |              |              | Lagrangian ( |              |
    %|              |              |              | autogenerate |              |
    %|              |              |              | d by         |              |
    %|              |              |              | default)     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| hess_lag_opt | OT_DICT      | GenericType( | Options for  | casadi::NlpS |
    %| ions         |              | )            | the autogene | olverInterna |
    %|              |              |              | rated        | l            |
    %|              |              |              | Hessian of   |              |
    %|              |              |              | the          |              |
    %|              |              |              | Lagrangian.  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| ignore_check | OT_BOOLEAN   | false        | If set to    | casadi::NlpS |
    %| _vec         |              |              | true, the    | olverInterna |
    %|              |              |              | input shape  | l            |
    %|              |              |              | of F will    |              |
    %|              |              |              | not be       |              |
    %|              |              |              | checked.     |              |
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
    %| iteration_ca | OT_CALLBACK  | GenericType( | A function   | casadi::NlpS |
    %| llback       |              | )            | that will be | olverInterna |
    %|              |              |              | called at    | l            |
    %|              |              |              | each         |              |
    %|              |              |              | iteration    |              |
    %|              |              |              | with the     |              |
    %|              |              |              | solver as    |              |
    %|              |              |              | input. Check |              |
    %|              |              |              | documentatio |              |
    %|              |              |              | n of         |              |
    %|              |              |              | Callback .   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| iteration_ca | OT_BOOLEAN   | false        | If set to    | casadi::NlpS |
    %| llback_ignor |              |              | true, errors | olverInterna |
    %| e_errors     |              |              | thrown by it | l            |
    %|              |              |              | eration_call |              |
    %|              |              |              | back will be |              |
    %|              |              |              | ignored.     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| iteration_ca | OT_INTEGER   | 1            | Only call    | casadi::NlpS |
    %| llback_step  |              |              | the callback | olverInterna |
    %|              |              |              | function     | l            |
    %|              |              |              | every few    |              |
    %|              |              |              | iterations.  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jac_f        | OT_FUNCTION  | GenericType( | Function for | casadi::NlpS |
    %|              |              | )            | calculating  | olverInterna |
    %|              |              |              | the Jacobian | l            |
    %|              |              |              | of the       |              |
    %|              |              |              | objective    |              |
    %|              |              |              | (sparse row, |              |
    %|              |              |              | autogenerate |              |
    %|              |              |              | d by         |              |
    %|              |              |              | default)     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jac_f_option | OT_DICT      | GenericType( | Options for  | casadi::NlpS |
    %| s            |              | )            | the autogene | olverInterna |
    %|              |              |              | rated        | l            |
    %|              |              |              | Jacobian of  |              |
    %|              |              |              | the          |              |
    %|              |              |              | objective.   |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jac_g        | OT_FUNCTION  | GenericType( | Function for | casadi::NlpS |
    %|              |              | )            | calculating  | olverInterna |
    %|              |              |              | the Jacobian | l            |
    %|              |              |              | of the       |              |
    %|              |              |              | constraints  |              |
    %|              |              |              | (autogenerat |              |
    %|              |              |              | ed by        |              |
    %|              |              |              | default)     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| jac_g_option | OT_DICT      | GenericType( | Options for  | casadi::NlpS |
    %| s            |              | )            | the autogene | olverInterna |
    %|              |              |              | rated        | l            |
    %|              |              |              | Jacobian of  |              |
    %|              |              |              | the          |              |
    %|              |              |              | constraints. |              |
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
    %| regularity_c | OT_BOOLEAN   | true         | Throw        | casadi::Func |
    %| heck         |              |              | exceptions   | tionInternal |
    %|              |              |              | when NaN or  |              |
    %|              |              |              | Inf appears  |              |
    %|              |              |              | during       |              |
    %|              |              |              | evaluation   |              |
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
    %| warn_initial | OT_BOOLEAN   | false        | Warn if the  | casadi::NlpS |
    %| _bounds      |              |              | initial      | olverInterna |
    %|              |              |              | guess does   | l            |
    %|              |              |              | not satisfy  |              |
    %|              |              |              | LBX and UBX  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %
    %List of plugins
    %===============
    %
    %
    %
    %- ipopt
    %
    %- knitro
    %
    %- snopt
    %
    %- worhp
    %
    %- scpgen
    %
    %- sqpmethod
    %
    %- stabilizedsqp
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %NlpSolver.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %ipopt
    %-----
    %
    %
    %
    %When in warmstart mode, output NLP_SOLVER_LAM_X may be used as input
    %
    %NOTE: Even when max_iter == 0, it is not guaranteed that
    %input(NLP_SOLVER_X0) == output(NLP_SOLVER_X). Indeed if bounds on X or
    %constraints are unmet, they will differ.
    %
    %For a good tutorial on IPOPT,
    %seehttp://drops.dagstuhl.de/volltexte/2009/2089/pdf/09061.WaechterAndreas.Paper.2089.pdf
    %
    %A good resource about the algorithms in IPOPT is: Wachter and L. T. Biegler,
    %On the Implementation of an Interior-Point Filter Line-Search Algorithm for
    %Large-Scale Nonlinear Programming, Mathematical Programming 106(1), pp.
    %25-57, 2006 (As Research Report RC 23149, IBM T. J. Watson Research Center,
    %Yorktown, USA
    %
    %Caveats: with default options, multipliers for the decision variables are
    %wrong for equality constraints. Change the 'fixed_variable_treatment' to
    %'make_constraint' or 'relax_bounds' to obtain correct results.
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| accept_after_ma | OT_INTEGER      | -1              | Accept a trial  |
    %| x_steps         |                 |                 | point after     |
    %|                 |                 |                 | maximal this    |
    %|                 |                 |                 | number of       |
    %|                 |                 |                 | steps. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| accept_every_tr | OT_STRING       | no              | Always accept   |
    %| ial_step        |                 |                 | the first trial |
    %|                 |                 |                 | step. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_comp | OT_REAL         | 0.010           | "Acceptance"    |
    %| l_inf_tol       |                 |                 | threshold for   |
    %|                 |                 |                 | the             |
    %|                 |                 |                 | complementarity |
    %|                 |                 |                 | conditions.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_cons | OT_REAL         | 0.010           | "Acceptance"    |
    %| tr_viol_tol     |                 |                 | threshold for   |
    %|                 |                 |                 | the constraint  |
    %|                 |                 |                 | violation. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_dual | OT_REAL         | 1.000e+10       | "Acceptance"    |
    %| _inf_tol        |                 |                 | threshold for   |
    %|                 |                 |                 | the dual        |
    %|                 |                 |                 | infeasibility.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_iter | OT_INTEGER      | 15              | Number of       |
    %|                 |                 |                 | "acceptable"    |
    %|                 |                 |                 | iterates before |
    %|                 |                 |                 | triggering      |
    %|                 |                 |                 | termination.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_obj_ | OT_REAL         | 1.000e+20       | "Acceptance"    |
    %| change_tol      |                 |                 | stopping        |
    %|                 |                 |                 | criterion based |
    %|                 |                 |                 | on objective    |
    %|                 |                 |                 | function        |
    %|                 |                 |                 | change. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| acceptable_tol  | OT_REAL         | 0.000           | "Acceptable"    |
    %|                 |                 |                 | convergence     |
    %|                 |                 |                 | tolerance       |
    %|                 |                 |                 | (relative).     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_glo | OT_STRING       | obj-constr-     | Globalization   |
    %| balization      |                 | filter          | strategy for    |
    %|                 |                 |                 | the adaptive mu |
    %|                 |                 |                 | selection mode. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_kkt | OT_STRING       | 2-norm-squared  | Norm used for   |
    %| _norm_type      |                 |                 | the KKT error   |
    %|                 |                 |                 | in the adaptive |
    %|                 |                 |                 | mu              |
    %|                 |                 |                 | globalization   |
    %|                 |                 |                 | strategies.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_kkt | OT_REAL         | 1.000           | Sufficient      |
    %| error_red_fact  |                 |                 | decrease factor |
    %|                 |                 |                 | for "kkt-error" |
    %|                 |                 |                 | globalization   |
    %|                 |                 |                 | strategy. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_kkt | OT_INTEGER      | 4               | Maximum number  |
    %| error_red_iters |                 |                 | of iterations   |
    %|                 |                 |                 | requiring       |
    %|                 |                 |                 | sufficient      |
    %|                 |                 |                 | progress. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_mon | OT_REAL         | 0.800           | Determines the  |
    %| otone_init_fact |                 |                 | initial value   |
    %| or              |                 |                 | of the barrier  |
    %|                 |                 |                 | parameter when  |
    %|                 |                 |                 | switching to    |
    %|                 |                 |                 | the monotone    |
    %|                 |                 |                 | mode. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_res | OT_STRING       | no              | Indicates if    |
    %| tore_previous_i |                 |                 | the previous    |
    %| terate          |                 |                 | iterate should  |
    %|                 |                 |                 | be restored if  |
    %|                 |                 |                 | the monotone    |
    %|                 |                 |                 | mode is         |
    %|                 |                 |                 | entered. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| adaptive_mu_saf | OT_REAL         | 0               | (see IPOPT      |
    %| eguard_factor   |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| alpha_for_y     | OT_STRING       | primal          | Method to       |
    %|                 |                 |                 | determine the   |
    %|                 |                 |                 | step size for   |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | multipliers.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| alpha_for_y_tol | OT_REAL         | 10              | Tolerance for   |
    %|                 |                 |                 | switching to    |
    %|                 |                 |                 | full equality   |
    %|                 |                 |                 | multiplier      |
    %|                 |                 |                 | steps. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| alpha_min_frac  | OT_REAL         | 0.050           | Safety factor   |
    %|                 |                 |                 | for the minimal |
    %|                 |                 |                 | step size       |
    %|                 |                 |                 | (before         |
    %|                 |                 |                 | switching to    |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase). (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| alpha_red_facto | OT_REAL         | 0.500           | Fractional      |
    %| r               |                 |                 | reduction of    |
    %|                 |                 |                 | the trial step  |
    %|                 |                 |                 | size in the     |
    %|                 |                 |                 | backtracking    |
    %|                 |                 |                 | line search.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| barrier_tol_fac | OT_REAL         | 10              | Factor for mu   |
    %| tor             |                 |                 | in barrier stop |
    %|                 |                 |                 | test. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_frac      | OT_REAL         | 0.010           | Desired minimum |
    %|                 |                 |                 | relative        |
    %|                 |                 |                 | distance from   |
    %|                 |                 |                 | the initial     |
    %|                 |                 |                 | point to bound. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_mult_init | OT_STRING       | constant        | Initialization  |
    %| _method         |                 |                 | method for      |
    %|                 |                 |                 | bound           |
    %|                 |                 |                 | multipliers     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_mult_init | OT_REAL         | 1               | Initial value   |
    %| _val            |                 |                 | for the bound   |
    %|                 |                 |                 | multipliers.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_mult_rese | OT_REAL         | 1000            | Threshold for   |
    %| t_threshold     |                 |                 | resetting bound |
    %|                 |                 |                 | multipliers     |
    %|                 |                 |                 | after the       |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_push      | OT_REAL         | 0.010           | Desired minimum |
    %|                 |                 |                 | absolute        |
    %|                 |                 |                 | distance from   |
    %|                 |                 |                 | the initial     |
    %|                 |                 |                 | point to bound. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| bound_relax_fac | OT_REAL         | 0.000           | Factor for      |
    %| tor             |                 |                 | initial         |
    %|                 |                 |                 | relaxation of   |
    %|                 |                 |                 | the bounds.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| check_derivativ | OT_STRING       | no              | Indicates       |
    %| es_for_naninf   |                 |                 | whether it is   |
    %|                 |                 |                 | desired to      |
    %|                 |                 |                 | check for       |
    %|                 |                 |                 | Nan/Inf in      |
    %|                 |                 |                 | derivative      |
    %|                 |                 |                 | matrices (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| chi_cup         | OT_REAL         | 1.500           | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| chi_hat         | OT_REAL         | 2               | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| chi_tilde       | OT_REAL         | 5               | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| compl_inf_tol   | OT_REAL         | 0.000           | Desired         |
    %|                 |                 |                 | threshold for   |
    %|                 |                 |                 | the             |
    %|                 |                 |                 | complementarity |
    %|                 |                 |                 | conditions.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| con_integer_md  | OT_DICT         | None            | Integer         |
    %|                 |                 |                 | metadata (a     |
    %|                 |                 |                 | dictionary with |
    %|                 |                 |                 | lists of        |
    %|                 |                 |                 | integers) about |
    %|                 |                 |                 | constraints to  |
    %|                 |                 |                 | be passed to    |
    %|                 |                 |                 | IPOPT           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| con_numeric_md  | OT_DICT         | None            | Numeric         |
    %|                 |                 |                 | metadata (a     |
    %|                 |                 |                 | dictionary with |
    %|                 |                 |                 | lists of reals) |
    %|                 |                 |                 | about           |
    %|                 |                 |                 | constraints to  |
    %|                 |                 |                 | be passed to    |
    %|                 |                 |                 | IPOPT           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| con_string_md   | OT_DICT         | None            | String metadata |
    %|                 |                 |                 | (a dictionary   |
    %|                 |                 |                 | with lists of   |
    %|                 |                 |                 | strings) about  |
    %|                 |                 |                 | constraints to  |
    %|                 |                 |                 | be passed to    |
    %|                 |                 |                 | IPOPT           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| constr_mult_ini | OT_REAL         | 1000            | Maximum allowed |
    %| t_max           |                 |                 | least-square    |
    %|                 |                 |                 | guess of        |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | multipliers.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| constr_mult_res | OT_REAL         | 0               | Threshold for   |
    %| et_threshold    |                 |                 | resetting       |
    %|                 |                 |                 | equality and    |
    %|                 |                 |                 | inequality      |
    %|                 |                 |                 | multipliers     |
    %|                 |                 |                 | after           |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| constr_viol_tol | OT_REAL         | 0.000           | Desired         |
    %|                 |                 |                 | threshold for   |
    %|                 |                 |                 | the constraint  |
    %|                 |                 |                 | violation. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| constraint_viol | OT_STRING       | 1-norm          | Norm to be used |
    %| ation_norm_type |                 |                 | for the         |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation in    |
    %|                 |                 |                 | the line        |
    %|                 |                 |                 | search. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| corrector_compl | OT_REAL         | 1               | Complementarity |
    %| _avrg_red_fact  |                 |                 | tolerance       |
    %|                 |                 |                 | factor for      |
    %|                 |                 |                 | accepting       |
    %|                 |                 |                 | corrector step  |
    %|                 |                 |                 | (unsupported!). |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| corrector_type  | OT_STRING       | none            | The type of     |
    %|                 |                 |                 | corrector steps |
    %|                 |                 |                 | that should be  |
    %|                 |                 |                 | taken           |
    %|                 |                 |                 | (unsupported!). |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| delta           | OT_REAL         | 1               | Multiplier for  |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation in    |
    %|                 |                 |                 | the switching   |
    %|                 |                 |                 | rule. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| delta_y_max     | OT_REAL         | 1.000e+12       | a parameter     |
    %|                 |                 |                 | used to check   |
    %|                 |                 |                 | if the fast     |
    %|                 |                 |                 | direction can   |
    %|                 |                 |                 | be used asthe   |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | direction (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dependency_dete | OT_STRING       | no              | Indicates if    |
    %| ction_with_rhs  |                 |                 | the right hand  |
    %|                 |                 |                 | sides of the    |
    %|                 |                 |                 | constraints     |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | considered      |
    %|                 |                 |                 | during          |
    %|                 |                 |                 | dependency      |
    %|                 |                 |                 | detection (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dependency_dete | OT_STRING       | none            | Indicates which |
    %| ctor            |                 |                 | linear solver   |
    %|                 |                 |                 | should be used  |
    %|                 |                 |                 | to detect       |
    %|                 |                 |                 | linearly        |
    %|                 |                 |                 | dependent       |
    %|                 |                 |                 | equality        |
    %|                 |                 |                 | constraints.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| derivative_test | OT_STRING       | none            | Enable          |
    %|                 |                 |                 | derivative      |
    %|                 |                 |                 | checker (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| derivative_test | OT_INTEGER      | -2              | Index of first  |
    %| _first_index    |                 |                 | quantity to be  |
    %|                 |                 |                 | checked by      |
    %|                 |                 |                 | derivative      |
    %|                 |                 |                 | checker (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| derivative_test | OT_REAL         | 0.000           | Size of the     |
    %| _perturbation   |                 |                 | finite          |
    %|                 |                 |                 | difference      |
    %|                 |                 |                 | perturbation in |
    %|                 |                 |                 | derivative      |
    %|                 |                 |                 | test. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| derivative_test | OT_STRING       | no              | Indicates       |
    %| _print_all      |                 |                 | whether         |
    %|                 |                 |                 | information for |
    %|                 |                 |                 | all estimated   |
    %|                 |                 |                 | derivatives     |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | printed. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| derivative_test | OT_REAL         | 0.000           | Threshold for   |
    %| _tol            |                 |                 | indicating      |
    %|                 |                 |                 | wrong           |
    %|                 |                 |                 | derivative.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| diverging_itera | OT_REAL         | 1.000e+20       | Threshold for   |
    %| tes_tol         |                 |                 | maximal value   |
    %|                 |                 |                 | of primal       |
    %|                 |                 |                 | iterates. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dual_inf_tol    | OT_REAL         | 1               | Desired         |
    %|                 |                 |                 | threshold for   |
    %|                 |                 |                 | the dual        |
    %|                 |                 |                 | infeasibility.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsilon_c       | OT_REAL         | 0.010           | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eta_min         | OT_REAL         | 10              | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eta_penalty     | OT_REAL         | 0.000           | Relaxation      |
    %|                 |                 |                 | factor in the   |
    %|                 |                 |                 | Armijo          |
    %|                 |                 |                 | condition for   |
    %|                 |                 |                 | the penalty     |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eta_phi         | OT_REAL         | 0.000           | Relaxation      |
    %|                 |                 |                 | factor in the   |
    %|                 |                 |                 | Armijo          |
    %|                 |                 |                 | condition. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| evaluate_orig_o | OT_STRING       | yes             | Determines if   |
    %| bj_at_resto_tri |                 |                 | the original    |
    %| al              |                 |                 | objective       |
    %|                 |                 |                 | function should |
    %|                 |                 |                 | be evaluated at |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase trial     |
    %|                 |                 |                 | points. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| expect_infeasib | OT_STRING       | no              | Enable          |
    %| le_problem      |                 |                 | heuristics to   |
    %|                 |                 |                 | quickly detect  |
    %|                 |                 |                 | an infeasible   |
    %|                 |                 |                 | problem. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| expect_infeasib | OT_REAL         | 0.001           | Threshold for   |
    %| le_problem_ctol |                 |                 | disabling "expe |
    %|                 |                 |                 | ct_infeasible_p |
    %|                 |                 |                 | roblem" option. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| expect_infeasib | OT_REAL         | 100000000       | Multiplier      |
    %| le_problem_ytol |                 |                 | threshold for   |
    %|                 |                 |                 | activating "exp |
    %|                 |                 |                 | ect_infeasible_ |
    %|                 |                 |                 | problem"        |
    %|                 |                 |                 | option. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fast_des_fact   | OT_REAL         | 0.100           | a parameter     |
    %|                 |                 |                 | used to check   |
    %|                 |                 |                 | if the fast     |
    %|                 |                 |                 | direction can   |
    %|                 |                 |                 | be used asthe   |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | direction (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fast_step_compu | OT_STRING       | no              | Indicates if    |
    %| tation          |                 |                 | the linear      |
    %|                 |                 |                 | system should   |
    %|                 |                 |                 | be solved       |
    %|                 |                 |                 | quickly. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| file_print_leve | OT_INTEGER      | 5               | Verbosity level |
    %| l               |                 |                 | for output      |
    %|                 |                 |                 | file. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| filter_margin_f | OT_REAL         | 0.000           | Factor          |
    %| act             |                 |                 | determining     |
    %|                 |                 |                 | width of margin |
    %|                 |                 |                 | for obj-constr- |
    %|                 |                 |                 | filter adaptive |
    %|                 |                 |                 | globalization   |
    %|                 |                 |                 | strategy. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| filter_max_marg | OT_REAL         | 1               | Maximum width   |
    %| in              |                 |                 | of margin in    |
    %|                 |                 |                 | obj-constr-     |
    %|                 |                 |                 | filter adaptive |
    %|                 |                 |                 | globalization   |
    %|                 |                 |                 | strategy. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| filter_reset_tr | OT_INTEGER      | 5               | Number of       |
    %| igger           |                 |                 | iterations that |
    %|                 |                 |                 | trigger the     |
    %|                 |                 |                 | filter reset.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| findiff_perturb | OT_REAL         | 0.000           | Size of the     |
    %| ation           |                 |                 | finite          |
    %|                 |                 |                 | difference      |
    %|                 |                 |                 | perturbation    |
    %|                 |                 |                 | for derivative  |
    %|                 |                 |                 | approximation.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| first_hessian_p | OT_REAL         | 0.000           | Size of first   |
    %| erturbation     |                 |                 | x-s             |
    %|                 |                 |                 | perturbation    |
    %|                 |                 |                 | tried. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fixed_mu_oracle | OT_STRING       | average_compl   | Oracle for the  |
    %|                 |                 |                 | barrier         |
    %|                 |                 |                 | parameter when  |
    %|                 |                 |                 | switching to    |
    %|                 |                 |                 | fixed mode.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| fixed_variable_ | OT_STRING       | make_parameter  | Determines how  |
    %| treatment       |                 |                 | fixed variables |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | handled. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma_hat       | OT_REAL         | 0.040           | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma_phi       | OT_REAL         | 0.000           | Relaxation      |
    %|                 |                 |                 | factor in the   |
    %|                 |                 |                 | filter margin   |
    %|                 |                 |                 | for the barrier |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma_theta     | OT_REAL         | 0.000           | Relaxation      |
    %|                 |                 |                 | factor in the   |
    %|                 |                 |                 | filter margin   |
    %|                 |                 |                 | for the         |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma_tilde     | OT_REAL         | 4               | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_approxi | OT_STRING       | exact           | Indicates what  |
    %| mation          |                 |                 | Hessian         |
    %|                 |                 |                 | information is  |
    %|                 |                 |                 | to be used.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_approxi | OT_STRING       | nonlinear-      | Indicates in    |
    %| mation_space    |                 | variables       | which subspace  |
    %|                 |                 |                 | the Hessian     |
    %|                 |                 |                 | information is  |
    %|                 |                 |                 | to be           |
    %|                 |                 |                 | approximated.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_constan | OT_STRING       | no              | Indicates       |
    %| t               |                 |                 | whether the     |
    %|                 |                 |                 | problem is a    |
    %|                 |                 |                 | quadratic       |
    %|                 |                 |                 | problem (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| honor_original_ | OT_STRING       | yes             | Indicates       |
    %| bounds          |                 |                 | whether final   |
    %|                 |                 |                 | points should   |
    %|                 |                 |                 | be projected    |
    %|                 |                 |                 | into original   |
    %|                 |                 |                 | bounds. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| inf_pr_output   | OT_STRING       | original        | Determines what |
    %|                 |                 |                 | value is        |
    %|                 |                 |                 | printed in the  |
    %|                 |                 |                 | "inf_pr" output |
    %|                 |                 |                 | column. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| jac_c_constant  | OT_STRING       | no              | Indicates       |
    %|                 |                 |                 | whether all     |
    %|                 |                 |                 | equality        |
    %|                 |                 |                 | constraints are |
    %|                 |                 |                 | linear (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| jac_d_constant  | OT_STRING       | no              | Indicates       |
    %|                 |                 |                 | whether all     |
    %|                 |                 |                 | inequality      |
    %|                 |                 |                 | constraints are |
    %|                 |                 |                 | linear (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| jacobian_approx | OT_STRING       | exact           | Specifies       |
    %| imation         |                 |                 | technique to    |
    %|                 |                 |                 | compute         |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | Jacobian (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| jacobian_regula | OT_REAL         | 0.250           | Exponent for mu |
    %| rization_expone |                 |                 | in the          |
    %| nt              |                 |                 | regularization  |
    %|                 |                 |                 | for rank-       |
    %|                 |                 |                 | deficient       |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | Jacobians. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| jacobian_regula | OT_REAL         | 0.000           | Size of the     |
    %| rization_value  |                 |                 | regularization  |
    %|                 |                 |                 | for rank-       |
    %|                 |                 |                 | deficient       |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | Jacobians. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| kappa_d         | OT_REAL         | 0.000           | Weight for      |
    %|                 |                 |                 | linear damping  |
    %|                 |                 |                 | term (to handle |
    %|                 |                 |                 | one-sided       |
    %|                 |                 |                 | bounds). (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| kappa_sigma     | OT_REAL         | 1.000e+10       | Factor limiting |
    %|                 |                 |                 | the deviation   |
    %|                 |                 |                 | of dual         |
    %|                 |                 |                 | variables from  |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | estimates. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| kappa_soc       | OT_REAL         | 0.990           | Factor in the   |
    %|                 |                 |                 | sufficient      |
    %|                 |                 |                 | reduction rule  |
    %|                 |                 |                 | for second      |
    %|                 |                 |                 | order           |
    %|                 |                 |                 | correction.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| kappa_x_dis     | OT_REAL         | 100             | a parameter     |
    %|                 |                 |                 | used to check   |
    %|                 |                 |                 | if the fast     |
    %|                 |                 |                 | direction can   |
    %|                 |                 |                 | be used asthe   |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | direction (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| kappa_y_dis     | OT_REAL         | 10000           | a parameter     |
    %|                 |                 |                 | used to check   |
    %|                 |                 |                 | if the fast     |
    %|                 |                 |                 | direction can   |
    %|                 |                 |                 | be used asthe   |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | direction (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| least_square_in | OT_STRING       | no              | Least square    |
    %| it_duals        |                 |                 | initialization  |
    %|                 |                 |                 | of all dual     |
    %|                 |                 |                 | variables (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| least_square_in | OT_STRING       | no              | Least square    |
    %| it_primal       |                 |                 | initialization  |
    %|                 |                 |                 | of the primal   |
    %|                 |                 |                 | variables (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_STRING       | sherman-        | Strategy for    |
    %| aug_solver      |                 | morrison        | solving the     |
    %|                 |                 |                 | augmented       |
    %|                 |                 |                 | system for low- |
    %|                 |                 |                 | rank Hessian.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_REAL         | 1               | Value for B0 in |
    %| init_val        |                 |                 | low-rank        |
    %|                 |                 |                 | update. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_REAL         | 100000000       | Upper bound on  |
    %| init_val_max    |                 |                 | value for B0 in |
    %|                 |                 |                 | low-rank        |
    %|                 |                 |                 | update. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_REAL         | 0.000           | Lower bound on  |
    %| init_val_min    |                 |                 | value for B0 in |
    %|                 |                 |                 | low-rank        |
    %|                 |                 |                 | update. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_STRING       | scalar1         | Initialization  |
    %| initialization  |                 |                 | strategy for    |
    %|                 |                 |                 | the limited     |
    %|                 |                 |                 | memory quasi-   |
    %|                 |                 |                 | Newton          |
    %|                 |                 |                 | approximation.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_INTEGER      | 6               | Maximum size of |
    %| max_history     |                 |                 | the history for |
    %|                 |                 |                 | the limited     |
    %|                 |                 |                 | quasi-Newton    |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | approximation.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_INTEGER      | 2               | Threshold for   |
    %| max_skipping    |                 |                 | successive      |
    %|                 |                 |                 | iterations      |
    %|                 |                 |                 | where update is |
    %|                 |                 |                 | skipped. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_STRING       | no              | Determines if   |
    %| special_for_res |                 |                 | the quasi-      |
    %| to              |                 |                 | Newton updates  |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | special during  |
    %|                 |                 |                 | the restoration |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| limited_memory_ | OT_STRING       | bfgs            | Quasi-Newton    |
    %| update_type     |                 |                 | update formula  |
    %|                 |                 |                 | for the limited |
    %|                 |                 |                 | memory          |
    %|                 |                 |                 | approximation.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| line_search_met | OT_STRING       | filter          | Globalization   |
    %| hod             |                 |                 | method used in  |
    %|                 |                 |                 | backtracking    |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_scaling_ | OT_STRING       | yes             | Flag indicating |
    %| on_demand       |                 |                 | that linear     |
    %|                 |                 |                 | scaling is only |
    %|                 |                 |                 | done if it      |
    %|                 |                 |                 | seems required. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver   | OT_STRING       | mumps           | Linear solver   |
    %|                 |                 |                 | used for step   |
    %|                 |                 |                 | computations.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_system_s | OT_STRING       | none            | Method for      |
    %| caling          |                 |                 | scaling the     |
    %|                 |                 |                 | linear system.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_ignore_sin | OT_STRING       | no              | Enables MA27's  |
    %| gularity        |                 |                 | ability to      |
    %|                 |                 |                 | solve a linear  |
    %|                 |                 |                 | system even if  |
    %|                 |                 |                 | the matrix is   |
    %|                 |                 |                 | singular. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_la_init_fa | OT_REAL         | 5               | Real workspace  |
    %| ctor            |                 |                 | memory for      |
    %|                 |                 |                 | MA27. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_liw_init_f | OT_REAL         | 5               | Integer         |
    %| actor           |                 |                 | workspace       |
    %|                 |                 |                 | memory for      |
    %|                 |                 |                 | MA27. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_meminc_fac | OT_REAL         | 10              | Increment       |
    %| tor             |                 |                 | factor for      |
    %|                 |                 |                 | workspace size  |
    %|                 |                 |                 | for MA27. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_pivtol     | OT_REAL         | 0.000           | Pivot tolerance |
    %|                 |                 |                 | for the linear  |
    %|                 |                 |                 | solver MA27.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_pivtolmax  | OT_REAL         | 0.000           | Maximum pivot   |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | the linear      |
    %|                 |                 |                 | solver MA27.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma27_skip_inert | OT_STRING       | no              | Always pretend  |
    %| ia_check        |                 |                 | inertia is      |
    %|                 |                 |                 | correct. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma28_pivtol     | OT_REAL         | 0.010           | Pivot tolerance |
    %|                 |                 |                 | for linear      |
    %|                 |                 |                 | solver MA28.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_automatic_ | OT_STRING       | yes             | Controls MA57   |
    %| scaling         |                 |                 | automatic       |
    %|                 |                 |                 | scaling (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_block_size | OT_INTEGER      | 16              | Controls block  |
    %|                 |                 |                 | size used by    |
    %|                 |                 |                 | Level 3 BLAS in |
    %|                 |                 |                 | MA57BD (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_node_amalg | OT_INTEGER      | 16              | Node            |
    %| amation         |                 |                 | amalgamation    |
    %|                 |                 |                 | parameter (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_pivot_orde | OT_INTEGER      | 5               | Controls pivot  |
    %| r               |                 |                 | order in MA57   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_pivtol     | OT_REAL         | 0.000           | Pivot tolerance |
    %|                 |                 |                 | for the linear  |
    %|                 |                 |                 | solver MA57.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_pivtolmax  | OT_REAL         | 0.000           | Maximum pivot   |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | the linear      |
    %|                 |                 |                 | solver MA57.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_pre_alloc  | OT_REAL         | 1.050           | Safety factor   |
    %|                 |                 |                 | for work space  |
    %|                 |                 |                 | memory          |
    %|                 |                 |                 | allocation for  |
    %|                 |                 |                 | the linear      |
    %|                 |                 |                 | solver MA57.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma57_small_pivo | OT_INTEGER      | 0               | If set to 1,    |
    %| t_flag          |                 |                 | then when small |
    %|                 |                 |                 | entries defined |
    %|                 |                 |                 | by CNTL(2) are  |
    %|                 |                 |                 | detected they   |
    %|                 |                 |                 | are removed and |
    %|                 |                 |                 | the             |
    %|                 |                 |                 | corresponding   |
    %|                 |                 |                 | pivots placed   |
    %|                 |                 |                 | at the end of   |
    %|                 |                 |                 | the             |
    %|                 |                 |                 | factorization.  |
    %|                 |                 |                 | This can be     |
    %|                 |                 |                 | particularly    |
    %|                 |                 |                 | efficient if    |
    %|                 |                 |                 | the matrix is   |
    %|                 |                 |                 | highly rank     |
    %|                 |                 |                 | deficient. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_nemin      | OT_INTEGER      | 32              | Node            |
    %|                 |                 |                 | Amalgamation    |
    %|                 |                 |                 | parameter (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_print_leve | OT_INTEGER      | 0               | Debug printing  |
    %| l               |                 |                 | level for the   |
    %|                 |                 |                 | linear solver   |
    %|                 |                 |                 | MA86 (see IPOPT |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_small      | OT_REAL         | 0.000           | Zero Pivot      |
    %|                 |                 |                 | Threshold (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_static     | OT_REAL         | 0               | Static Pivoting |
    %|                 |                 |                 | Threshold (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_u          | OT_REAL         | 0.000           | Pivoting        |
    %|                 |                 |                 | Threshold (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ma86_umax       | OT_REAL         | 0.000           | Maximum         |
    %|                 |                 |                 | Pivoting        |
    %|                 |                 |                 | Threshold (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| magic_steps     | OT_STRING       | no              | Enables magic   |
    %|                 |                 |                 | steps. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_cpu_time    | OT_REAL         | 1000000         | Maximum number  |
    %|                 |                 |                 | of CPU seconds. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_filter_rese | OT_INTEGER      | 5               | Maximal allowed |
    %| ts              |                 |                 | number of       |
    %|                 |                 |                 | filter resets   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_hessian_per | OT_REAL         | 1.000e+20       | Maximum value   |
    %| turbation       |                 |                 | of              |
    %|                 |                 |                 | regularization  |
    %|                 |                 |                 | parameter for   |
    %|                 |                 |                 | handling        |
    %|                 |                 |                 | negative        |
    %|                 |                 |                 | curvature. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 3000            | Maximum number  |
    %|                 |                 |                 | of iterations.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_refinement_ | OT_INTEGER      | 10              | Maximum number  |
    %| steps           |                 |                 | of iterative    |
    %|                 |                 |                 | refinement      |
    %|                 |                 |                 | steps per       |
    %|                 |                 |                 | linear system   |
    %|                 |                 |                 | solve. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_resto_iter  | OT_INTEGER      | 3000000         | Maximum number  |
    %|                 |                 |                 | of successive   |
    %|                 |                 |                 | iterations in   |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_soc         | OT_INTEGER      | 4               | Maximum number  |
    %|                 |                 |                 | of second order |
    %|                 |                 |                 | correction      |
    %|                 |                 |                 | trial steps at  |
    %|                 |                 |                 | each iteration. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_soft_resto_ | OT_INTEGER      | 10              | Maximum number  |
    %| iters           |                 |                 | of iterations   |
    %|                 |                 |                 | performed       |
    %|                 |                 |                 | successively in |
    %|                 |                 |                 | soft            |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mehrotra_algori | OT_STRING       | no              | Indicates if we |
    %| thm             |                 |                 | want to do      |
    %|                 |                 |                 | Mehrotra's      |
    %|                 |                 |                 | algorithm. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| min_alpha_prima | OT_REAL         | 0.000           | LIFENG WRITES   |
    %| l               |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| min_hessian_per | OT_REAL         | 0.000           | Smallest        |
    %| turbation       |                 |                 | perturbation of |
    %|                 |                 |                 | the Hessian     |
    %|                 |                 |                 | block. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| min_refinement_ | OT_INTEGER      | 1               | Minimum number  |
    %| steps           |                 |                 | of iterative    |
    %|                 |                 |                 | refinement      |
    %|                 |                 |                 | steps per       |
    %|                 |                 |                 | linear system   |
    %|                 |                 |                 | solve. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_allow_fast_m | OT_STRING       | yes             | Allow skipping  |
    %| onotone_decreas |                 |                 | of barrier      |
    %| e               |                 |                 | problem if      |
    %|                 |                 |                 | barrier test is |
    %|                 |                 |                 | already met.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_init         | OT_REAL         | 0.100           | Initial value   |
    %|                 |                 |                 | for the barrier |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_linear_decre | OT_REAL         | 0.200           | Determines      |
    %| ase_factor      |                 |                 | linear decrease |
    %|                 |                 |                 | rate of barrier |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_max          | OT_REAL         | 100000          | Maximum value   |
    %|                 |                 |                 | for barrier     |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_max_fact     | OT_REAL         | 1000            | Factor for      |
    %|                 |                 |                 | initialization  |
    %|                 |                 |                 | of maximum      |
    %|                 |                 |                 | value for       |
    %|                 |                 |                 | barrier         |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_min          | OT_REAL         | 0.000           | Minimum value   |
    %|                 |                 |                 | for barrier     |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_oracle       | OT_STRING       | quality-        | Oracle for a    |
    %|                 |                 | function        | new barrier     |
    %|                 |                 |                 | parameter in    |
    %|                 |                 |                 | the adaptive    |
    %|                 |                 |                 | strategy. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_strategy     | OT_STRING       | monotone        | Update strategy |
    %|                 |                 |                 | for barrier     |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_superlinear_ | OT_REAL         | 1.500           | Determines      |
    %| decrease_power  |                 |                 | superlinear     |
    %|                 |                 |                 | decrease rate   |
    %|                 |                 |                 | of barrier      |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mu_target       | OT_REAL         | 0               | Desired value   |
    %|                 |                 |                 | of complementar |
    %|                 |                 |                 | ity. (see IPOPT |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mult_diverg_fea | OT_REAL         | 0.000           | tolerance for   |
    %| sibility_tol    |                 |                 | deciding if the |
    %|                 |                 |                 | multipliers are |
    %|                 |                 |                 | diverging (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mult_diverg_y_t | OT_REAL         | 100000000       | tolerance for   |
    %| ol              |                 |                 | deciding if the |
    %|                 |                 |                 | multipliers are |
    %|                 |                 |                 | diverging (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_dep_tol   | OT_REAL         | -1              | Pivot threshold |
    %|                 |                 |                 | for detection   |
    %|                 |                 |                 | of linearly     |
    %|                 |                 |                 | dependent       |
    %|                 |                 |                 | constraints in  |
    %|                 |                 |                 | MUMPS. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_mem_perce | OT_INTEGER      | 1000            | Percentage      |
    %| nt              |                 |                 | increase in the |
    %|                 |                 |                 | estimated       |
    %|                 |                 |                 | working space   |
    %|                 |                 |                 | for MUMPS. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_permuting | OT_INTEGER      | 7               | Controls        |
    %| _scaling        |                 |                 | permuting and   |
    %|                 |                 |                 | scaling in      |
    %|                 |                 |                 | MUMPS (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_pivot_ord | OT_INTEGER      | 7               | Controls pivot  |
    %| er              |                 |                 | order in MUMPS  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_pivtol    | OT_REAL         | 0.000           | Pivot tolerance |
    %|                 |                 |                 | for the linear  |
    %|                 |                 |                 | solver MUMPS.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_pivtolmax | OT_REAL         | 0.100           | Maximum pivot   |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | the linear      |
    %|                 |                 |                 | solver MUMPS.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mumps_scaling   | OT_INTEGER      | 77              | Controls        |
    %|                 |                 |                 | scaling in      |
    %|                 |                 |                 | MUMPS (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| neg_curv_test_t | OT_REAL         | 0               | Tolerance for   |
    %| ol              |                 |                 | heuristic to    |
    %|                 |                 |                 | ignore wrong    |
    %|                 |                 |                 | inertia. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| never_use_fact_ | OT_STRING       | no              | Toggle to       |
    %| cgpen_direction |                 |                 | switch off the  |
    %|                 |                 |                 | fast Chen-      |
    %|                 |                 |                 | Goldfarb        |
    %|                 |                 |                 | direction (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| never_use_piece | OT_STRING       | no              | Toggle to       |
    %| wise_penalty_ls |                 |                 | switch off the  |
    %|                 |                 |                 | piecewise       |
    %|                 |                 |                 | penalty method  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_lower_bound | OT_REAL         | -1.000e+19      | any bound less  |
    %| _inf            |                 |                 | or equal this   |
    %|                 |                 |                 | value will be   |
    %|                 |                 |                 | considered -inf |
    %|                 |                 |                 | (i.e. not lower |
    %|                 |                 |                 | bounded). (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_scaling_con | OT_REAL         | 0               | Target value    |
    %| str_target_grad |                 |                 | for constraint  |
    %| ient            |                 |                 | function        |
    %|                 |                 |                 | gradient size.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_scaling_max | OT_REAL         | 100             | Maximum         |
    %| _gradient       |                 |                 | gradient after  |
    %|                 |                 |                 | NLP scaling.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_scaling_met | OT_STRING       | gradient-based  | Select the      |
    %| hod             |                 |                 | technique used  |
    %|                 |                 |                 | for scaling the |
    %|                 |                 |                 | NLP. (see IPOPT |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_scaling_min | OT_REAL         | 0.000           | Minimum value   |
    %| _value          |                 |                 | of gradient-    |
    %|                 |                 |                 | based scaling   |
    %|                 |                 |                 | values. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_scaling_obj | OT_REAL         | 0               | Target value    |
    %| _target_gradien |                 |                 | for objective   |
    %| t               |                 |                 | function        |
    %|                 |                 |                 | gradient size.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nlp_upper_bound | OT_REAL         | 1.000e+19       | any bound       |
    %| _inf            |                 |                 | greater or this |
    %|                 |                 |                 | value will be   |
    %|                 |                 |                 | considered +inf |
    %|                 |                 |                 | (i.e. not upper |
    %|                 |                 |                 | bounded). (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nu_inc          | OT_REAL         | 0.000           | Increment of    |
    %|                 |                 |                 | the penalty     |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nu_init         | OT_REAL         | 0.000           | Initial value   |
    %|                 |                 |                 | of the penalty  |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| num_linear_vari | OT_INTEGER      | 0               | Number of       |
    %| ables           |                 |                 | linear          |
    %|                 |                 |                 | variables (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| obj_max_inc     | OT_REAL         | 5               | Determines the  |
    %|                 |                 |                 | upper bound on  |
    %|                 |                 |                 | the acceptable  |
    %|                 |                 |                 | increase of     |
    %|                 |                 |                 | barrier         |
    %|                 |                 |                 | objective       |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| obj_scaling_fac | OT_REAL         | 1               | Scaling factor  |
    %| tor             |                 |                 | for the         |
    %|                 |                 |                 | objective       |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| option_file_nam | OT_STRING       |                 | File name of    |
    %| e               |                 |                 | options file    |
    %|                 |                 |                 | (to overwrite   |
    %|                 |                 |                 | default). (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| output_file     | OT_STRING       |                 | File name of    |
    %|                 |                 |                 | desired output  |
    %|                 |                 |                 | file (leave     |
    %|                 |                 |                 | unset for no    |
    %|                 |                 |                 | file output).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_co | OT_INTEGER      | 5000            | Maximum Size of |
    %| arse_size       |                 |                 | Coarse Grid     |
    %|                 |                 |                 | Matrix (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_dr | OT_REAL         | 0.500           | dropping value  |
    %| opping_factor   |                 |                 | for incomplete  |
    %|                 |                 |                 | factor (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_dr | OT_REAL         | 0.100           | dropping value  |
    %| opping_schur    |                 |                 | for sparsify    |
    %|                 |                 |                 | schur           |
    %|                 |                 |                 | complement      |
    %|                 |                 |                 | factor (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_in | OT_REAL         | 5000000         | (see IPOPT      |
    %| verse_norm_fact |                 |                 | documentation)  |
    %| or              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_ma | OT_INTEGER      | 10              | Maximum Size of |
    %| x_levels        |                 |                 | Grid Levels     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_ma | OT_INTEGER      | 10000000        | max fill for    |
    %| x_row_fill      |                 |                 | each row (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iter_re | OT_REAL         | 0.000           | Relative        |
    %| lative_tol      |                 |                 | Residual        |
    %|                 |                 |                 | Convergence     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_iterati | OT_STRING       | no              | Switch on       |
    %| ve              |                 |                 | iterative       |
    %|                 |                 |                 | solver in       |
    %|                 |                 |                 | Pardiso library |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_matchin | OT_STRING       | complete+2x2    | Matching        |
    %| g_strategy      |                 |                 | strategy to be  |
    %|                 |                 |                 | used by Pardiso |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_max_dro | OT_INTEGER      | 4               | Maximal number  |
    %| ptol_correction |                 |                 | of decreases of |
    %| s               |                 |                 | drop tolerance  |
    %|                 |                 |                 | during one      |
    %|                 |                 |                 | solve. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_max_ite | OT_INTEGER      | 500             | Maximum number  |
    %| r               |                 |                 | of Krylov-      |
    %|                 |                 |                 | Subspace        |
    %|                 |                 |                 | Iteration (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_msglvl  | OT_INTEGER      | 0               | Pardiso message |
    %|                 |                 |                 | level (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_out_of_ | OT_INTEGER      | 0               | Enables out-of- |
    %| core_power      |                 |                 | core variant of |
    %|                 |                 |                 | Pardiso (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_redo_sy | OT_STRING       | no              | Toggle for      |
    %| mbolic_fact_onl |                 |                 | handling case   |
    %| y_if_inertia_wr |                 |                 | when elements   |
    %| ong             |                 |                 | were perturbed  |
    %|                 |                 |                 | by Pardiso.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_repeate | OT_STRING       | no              | Interpretation  |
    %| d_perturbation_ |                 |                 | of perturbed    |
    %| means_singular  |                 |                 | elements. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pardiso_skip_in | OT_STRING       | no              | Always pretend  |
    %| ertia_check     |                 |                 | inertia is      |
    %|                 |                 |                 | correct. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pass_nonlinear_ | OT_BOOLEAN      | False           | n/a             |
    %| variables       |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pen_des_fact    | OT_REAL         | 0.200           | a parameter     |
    %|                 |                 |                 | used in penalty |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | computation     |
    %|                 |                 |                 | (for Chen-      |
    %|                 |                 |                 | Goldfarb line   |
    %|                 |                 |                 | search). (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pen_init_fac    | OT_REAL         | 50              | a parameter     |
    %|                 |                 |                 | used to choose  |
    %|                 |                 |                 | initial penalty |
    %|                 |                 |                 | parameterswhen  |
    %|                 |                 |                 | the regularized |
    %|                 |                 |                 | Newton method   |
    %|                 |                 |                 | is used. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pen_theta_max_f | OT_REAL         | 10000           | Determines      |
    %| act             |                 |                 | upper bound for |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation in    |
    %|                 |                 |                 | the filter.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| penalty_init_ma | OT_REAL         | 100000          | Maximal value   |
    %| x               |                 |                 | for the intial  |
    %|                 |                 |                 | penalty         |
    %|                 |                 |                 | parameter (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| penalty_init_mi | OT_REAL         | 1               | Minimal value   |
    %| n               |                 |                 | for the intial  |
    %|                 |                 |                 | penalty         |
    %|                 |                 |                 | parameter for   |
    %|                 |                 |                 | line search(for |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| penalty_max     | OT_REAL         | 1.000e+30       | Maximal value   |
    %|                 |                 |                 | for the penalty |
    %|                 |                 |                 | parameter (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| penalty_update_ | OT_REAL         | 10              | LIFENG WRITES   |
    %| compl_tol       |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| penalty_update_ | OT_REAL         | 0.000           | Threshold for   |
    %| infeasibility_t |                 |                 | infeasibility   |
    %| ol              |                 |                 | in penalty      |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | update test.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| perturb_always_ | OT_STRING       | no              | Active          |
    %| cd              |                 |                 | permanent       |
    %|                 |                 |                 | perturbation of |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | linearization.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| perturb_dec_fac | OT_REAL         | 0.333           | Decrease factor |
    %| t               |                 |                 | for x-s         |
    %|                 |                 |                 | perturbation.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| perturb_inc_fac | OT_REAL         | 8               | Increase factor |
    %| t               |                 |                 | for x-s         |
    %|                 |                 |                 | perturbation.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| perturb_inc_fac | OT_REAL         | 100             | Increase factor |
    %| t_first         |                 |                 | for x-s         |
    %|                 |                 |                 | perturbation    |
    %|                 |                 |                 | for very first  |
    %|                 |                 |                 | perturbation.   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| piecewisepenalt | OT_REAL         | 0.000           | LIFENG WRITES   |
    %| y_gamma_infeasi |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| piecewisepenalt | OT_REAL         | 0.000           | LIFENG WRITES   |
    %| y_gamma_obj     |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| point_perturbat | OT_REAL         | 10              | Maximal         |
    %| ion_radius      |                 |                 | perturbation of |
    %|                 |                 |                 | an evaluation   |
    %|                 |                 |                 | point. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_info_stri | OT_STRING       | no              | Enables         |
    %| ng              |                 |                 | printing of     |
    %|                 |                 |                 | additional info |
    %|                 |                 |                 | string at end   |
    %|                 |                 |                 | of iteration    |
    %|                 |                 |                 | output. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_level     | OT_INTEGER      | 5               | Output          |
    %|                 |                 |                 | verbosity       |
    %|                 |                 |                 | level. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_options_d | OT_STRING       | no              | Switch to print |
    %| ocumentation    |                 |                 | all algorithmic |
    %|                 |                 |                 | options. (see   |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_options_l | OT_STRING       | no              | Undocumented    |
    %| atex_mode       |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_time      | OT_BOOLEAN      | True            | print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about execution |
    %|                 |                 |                 | time            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_timing_st | OT_STRING       | no              | Switch to print |
    %| atistics        |                 |                 | timing          |
    %|                 |                 |                 | statistics.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_user_opti | OT_STRING       | no              | Print all       |
    %| ons             |                 |                 | options set by  |
    %|                 |                 |                 | the user. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_STRING       | none            | The balancing   |
    %| n_balancing_ter |                 |                 | term included   |
    %| m               |                 |                 | in the quality  |
    %|                 |                 |                 | function for    |
    %|                 |                 |                 | centrality.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_STRING       | none            | The penalty     |
    %| n_centrality    |                 |                 | term for        |
    %|                 |                 |                 | centrality that |
    %|                 |                 |                 | is included in  |
    %|                 |                 |                 | quality         |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_INTEGER      | 8               | Maximum number  |
    %| n_max_section_s |                 |                 | of search steps |
    %| teps            |                 |                 | during direct   |
    %|                 |                 |                 | search          |
    %|                 |                 |                 | procedure       |
    %|                 |                 |                 | determining the |
    %|                 |                 |                 | optimal         |
    %|                 |                 |                 | centering       |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_STRING       | 2-norm-squared  | Norm used for   |
    %| n_norm_type     |                 |                 | components of   |
    %|                 |                 |                 | the quality     |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_REAL         | 0               | Tolerance for   |
    %| n_section_qf_to |                 |                 | the golden      |
    %| l               |                 |                 | section search  |
    %|                 |                 |                 | procedure       |
    %|                 |                 |                 | determining the |
    %|                 |                 |                 | optimal         |
    %|                 |                 |                 | centering       |
    %|                 |                 |                 | parameter (in   |
    %|                 |                 |                 | the function    |
    %|                 |                 |                 | value space).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| quality_functio | OT_REAL         | 0.010           | Tolerance for   |
    %| n_section_sigma |                 |                 | the section     |
    %| _tol            |                 |                 | search          |
    %|                 |                 |                 | procedure       |
    %|                 |                 |                 | determining the |
    %|                 |                 |                 | optimal         |
    %|                 |                 |                 | centering       |
    %|                 |                 |                 | parameter (in   |
    %|                 |                 |                 | sigma space).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| recalc_y        | OT_STRING       | no              | Tells the       |
    %|                 |                 |                 | algorithm to    |
    %|                 |                 |                 | recalculate the |
    %|                 |                 |                 | equality and    |
    %|                 |                 |                 | inequality      |
    %|                 |                 |                 | multipliers as  |
    %|                 |                 |                 | least square    |
    %|                 |                 |                 | estimates. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| recalc_y_feas_t | OT_REAL         | 0.000           | Feasibility     |
    %| ol              |                 |                 | threshold for   |
    %|                 |                 |                 | recomputation   |
    %|                 |                 |                 | of multipliers. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| replace_bounds  | OT_STRING       | no              | Indicates if    |
    %|                 |                 |                 | all variable    |
    %|                 |                 |                 | bounds should   |
    %|                 |                 |                 | be replaced by  |
    %|                 |                 |                 | inequality      |
    %|                 |                 |                 | constraints     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| required_infeas | OT_REAL         | 0.900           | Required        |
    %| ibility_reducti |                 |                 | reduction of    |
    %| on              |                 |                 | infeasibility   |
    %|                 |                 |                 | before leaving  |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| residual_improv | OT_REAL         | 1.000           | Minimal         |
    %| ement_factor    |                 |                 | required        |
    %|                 |                 |                 | reduction of    |
    %|                 |                 |                 | residual test   |
    %|                 |                 |                 | ratio in        |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| residual_ratio_ | OT_REAL         | 0.000           | Iterative       |
    %| max             |                 |                 | refinement      |
    %|                 |                 |                 | tolerance (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| residual_ratio_ | OT_REAL         | 0.000           | Threshold for   |
    %| singular        |                 |                 | declaring       |
    %|                 |                 |                 | linear system   |
    %|                 |                 |                 | singular after  |
    %|                 |                 |                 | failed          |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| resto_failure_f | OT_REAL         | 0               | Threshold for   |
    %| easibility_thre |                 |                 | primal          |
    %| shold           |                 |                 | infeasibility   |
    %|                 |                 |                 | to declare      |
    %|                 |                 |                 | failure of      |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| resto_penalty_p | OT_REAL         | 1000            | Penalty         |
    %| arameter        |                 |                 | parameter in    |
    %|                 |                 |                 | the restoration |
    %|                 |                 |                 | phase objective |
    %|                 |                 |                 | function. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| resto_proximity | OT_REAL         | 1               | Weighting       |
    %| _weight         |                 |                 | factor for the  |
    %|                 |                 |                 | proximity term  |
    %|                 |                 |                 | in restoration  |
    %|                 |                 |                 | phase           |
    %|                 |                 |                 | objective. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| rho             | OT_REAL         | 0.100           | Value in        |
    %|                 |                 |                 | penalty         |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | update formula. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| s_max           | OT_REAL         | 100             | Scaling         |
    %|                 |                 |                 | threshold for   |
    %|                 |                 |                 | the NLP error.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| s_phi           | OT_REAL         | 2.300           | Exponent for    |
    %|                 |                 |                 | linear barrier  |
    %|                 |                 |                 | function model  |
    %|                 |                 |                 | in the          |
    %|                 |                 |                 | switching rule. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| s_theta         | OT_REAL         | 1.100           | Exponent for    |
    %|                 |                 |                 | current         |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation in    |
    %|                 |                 |                 | the switching   |
    %|                 |                 |                 | rule. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| sb              | OT_STRING       | no              | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| sigma_max       | OT_REAL         | 100             | Maximum value   |
    %|                 |                 |                 | of the          |
    %|                 |                 |                 | centering       |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| sigma_min       | OT_REAL         | 0.000           | Minimum value   |
    %|                 |                 |                 | of the          |
    %|                 |                 |                 | centering       |
    %|                 |                 |                 | parameter. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| skip_corr_if_ne | OT_STRING       | yes             | Skip the        |
    %| g_curv          |                 |                 | corrector step  |
    %|                 |                 |                 | in negative     |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | iteration       |
    %|                 |                 |                 | (unsupported!). |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| skip_corr_in_mo | OT_STRING       | yes             | Skip the        |
    %| notone_mode     |                 |                 | corrector step  |
    %|                 |                 |                 | during monotone |
    %|                 |                 |                 | barrier         |
    %|                 |                 |                 | parameter mode  |
    %|                 |                 |                 | (unsupported!). |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| skip_finalize_s | OT_STRING       | no              | Indicates if    |
    %| olution_call    |                 |                 | call to NLP::Fi |
    %|                 |                 |                 | nalizeSolution  |
    %|                 |                 |                 | after           |
    %|                 |                 |                 | optimization    |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | suppressed (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| slack_bound_fra | OT_REAL         | 0.010           | Desired minimum |
    %| c               |                 |                 | relative        |
    %|                 |                 |                 | distance from   |
    %|                 |                 |                 | the initial     |
    %|                 |                 |                 | slack to bound. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| slack_bound_pus | OT_REAL         | 0.010           | Desired minimum |
    %| h               |                 |                 | absolute        |
    %|                 |                 |                 | distance from   |
    %|                 |                 |                 | the initial     |
    %|                 |                 |                 | slack to bound. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| slack_move      | OT_REAL         | 0.000           | Correction size |
    %|                 |                 |                 | for very small  |
    %|                 |                 |                 | slacks. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| soft_resto_pder | OT_REAL         | 1.000           | Required        |
    %| ror_reduction_f |                 |                 | reduction in    |
    %| actor           |                 |                 | primal-dual     |
    %|                 |                 |                 | error in the    |
    %|                 |                 |                 | soft            |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| start_with_rest | OT_STRING       | no              | Tells algorithm |
    %| o               |                 |                 | to switch to    |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | phase in first  |
    %|                 |                 |                 | iteration. (see |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| suppress_all_ou | OT_STRING       | no              | Undocumented    |
    %| tput            |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tau_min         | OT_REAL         | 0.990           | Lower bound on  |
    %|                 |                 |                 | fraction-to-    |
    %|                 |                 |                 | the-boundary    |
    %|                 |                 |                 | parameter tau.  |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| theta_max_fact  | OT_REAL         | 10000           | Determines      |
    %|                 |                 |                 | upper bound for |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation in    |
    %|                 |                 |                 | the filter.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| theta_min       | OT_REAL         | 0.000           | LIFENG WRITES   |
    %|                 |                 |                 | THIS. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| theta_min_fact  | OT_REAL         | 0.000           | Determines      |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation       |
    %|                 |                 |                 | threshold in    |
    %|                 |                 |                 | the switching   |
    %|                 |                 |                 | rule. (see      |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tiny_step_tol   | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | detecting       |
    %|                 |                 |                 | numerically     |
    %|                 |                 |                 | insignificant   |
    %|                 |                 |                 | steps. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tiny_step_y_tol | OT_REAL         | 0.010           | Tolerance for   |
    %|                 |                 |                 | quitting        |
    %|                 |                 |                 | because of      |
    %|                 |                 |                 | numerically     |
    %|                 |                 |                 | insignificant   |
    %|                 |                 |                 | steps. (see     |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol             | OT_REAL         | 0.000           | Desired         |
    %|                 |                 |                 | convergence     |
    %|                 |                 |                 | tolerance       |
    %|                 |                 |                 | (relative).     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| var_integer_md  | OT_DICT         | None            | Integer         |
    %|                 |                 |                 | metadata (a     |
    %|                 |                 |                 | dictionary with |
    %|                 |                 |                 | lists of        |
    %|                 |                 |                 | integers) about |
    %|                 |                 |                 | variables to be |
    %|                 |                 |                 | passed to IPOPT |
    %+-----------------+-----------------+-----------------+-----------------+
    %| var_numeric_md  | OT_DICT         | None            | Numeric         |
    %|                 |                 |                 | metadata (a     |
    %|                 |                 |                 | dictionary with |
    %|                 |                 |                 | lists of reals) |
    %|                 |                 |                 | about variables |
    %|                 |                 |                 | to be passed to |
    %|                 |                 |                 | IPOPT           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| var_string_md   | OT_DICT         | None            | String metadata |
    %|                 |                 |                 | (a dictionary   |
    %|                 |                 |                 | with lists of   |
    %|                 |                 |                 | strings) about  |
    %|                 |                 |                 | variables to be |
    %|                 |                 |                 | passed to IPOPT |
    %+-----------------+-----------------+-----------------+-----------------+
    %| vartheta        | OT_REAL         | 0.500           | a parameter     |
    %|                 |                 |                 | used to check   |
    %|                 |                 |                 | if the fast     |
    %|                 |                 |                 | direction can   |
    %|                 |                 |                 | be used asthe   |
    %|                 |                 |                 | line search     |
    %|                 |                 |                 | direction (for  |
    %|                 |                 |                 | Chen-Goldfarb   |
    %|                 |                 |                 | line search).   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_boun | OT_REAL         | 0.001           | same as         |
    %| d_frac          |                 |                 | bound_frac for  |
    %|                 |                 |                 | the regular     |
    %|                 |                 |                 | initializer.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_boun | OT_REAL         | 0.001           | same as         |
    %| d_push          |                 |                 | bound_push for  |
    %|                 |                 |                 | the regular     |
    %|                 |                 |                 | initializer.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_enti | OT_STRING       | no              | Tells algorithm |
    %| re_iterate      |                 |                 | whether to use  |
    %|                 |                 |                 | the GetWarmStar |
    %|                 |                 |                 | tIterate method |
    %|                 |                 |                 | in the NLP.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_init | OT_STRING       | no              | Warm-start for  |
    %| _point          |                 |                 | initial point   |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_mult | OT_REAL         | 0.001           | same as         |
    %| _bound_push     |                 |                 | mult_bound_push |
    %|                 |                 |                 | for the regular |
    %|                 |                 |                 | initializer.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_mult | OT_REAL         | 1000000         | Maximum initial |
    %| _init_max       |                 |                 | value for the   |
    %|                 |                 |                 | equality        |
    %|                 |                 |                 | multipliers.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_same | OT_STRING       | no              | Indicates       |
    %| _structure      |                 |                 | whether a       |
    %|                 |                 |                 | problem with a  |
    %|                 |                 |                 | structure       |
    %|                 |                 |                 | identical to    |
    %|                 |                 |                 | the previous    |
    %|                 |                 |                 | one is to be    |
    %|                 |                 |                 | solved. (see    |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_slac | OT_REAL         | 0.001           | same as slack_b |
    %| k_bound_frac    |                 |                 | ound_frac for   |
    %|                 |                 |                 | the regular     |
    %|                 |                 |                 | initializer.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_slac | OT_REAL         | 0.001           | same as slack_b |
    %| k_bound_push    |                 |                 | ound_push for   |
    %|                 |                 |                 | the regular     |
    %|                 |                 |                 | initializer.    |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start_targ | OT_REAL         | 0               | Unsupported!    |
    %| et_mu           |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| watchdog_shorte | OT_INTEGER      | 10              | Number of       |
    %| ned_iter_trigge |                 |                 | shortened       |
    %| r               |                 |                 | iterations that |
    %|                 |                 |                 | trigger the     |
    %|                 |                 |                 | watchdog. (see  |
    %|                 |                 |                 | IPOPT           |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| watchdog_trial_ | OT_INTEGER      | 3               | Maximum number  |
    %| iter_max        |                 |                 | of watchdog     |
    %|                 |                 |                 | iterations.     |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| wsmp_iterative  | OT_STRING       | no              | Switches to     |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | solver in WSMP. |
    %|                 |                 |                 | (see IPOPT      |
    %|                 |                 |                 | documentation)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %
    %>List of available stats
    %
    %+-------------------------+
    %|           Id            |
    %+=========================+
    %| con_integer_md          |
    %+-------------------------+
    %| con_numeric_md          |
    %+-------------------------+
    %| con_string_md           |
    %+-------------------------+
    %| iter_count              |
    %+-------------------------+
    %| iteration               |
    %+-------------------------+
    %| iterations              |
    %+-------------------------+
    %| n_eval_callback         |
    %+-------------------------+
    %| n_eval_f                |
    %+-------------------------+
    %| n_eval_g                |
    %+-------------------------+
    %| n_eval_grad_f           |
    %+-------------------------+
    %| n_eval_h                |
    %+-------------------------+
    %| n_eval_jac_g            |
    %+-------------------------+
    %| return_status           |
    %+-------------------------+
    %| t_callback_fun.proc     |
    %+-------------------------+
    %| t_callback_fun.wall     |
    %+-------------------------+
    %| t_callback_prepare.proc |
    %+-------------------------+
    %| t_callback_prepare.wall |
    %+-------------------------+
    %| t_eval_f.proc           |
    %+-------------------------+
    %| t_eval_f.wall           |
    %+-------------------------+
    %| t_eval_g.proc           |
    %+-------------------------+
    %| t_eval_g.wall           |
    %+-------------------------+
    %| t_eval_grad_f.proc      |
    %+-------------------------+
    %| t_eval_grad_f.wall      |
    %+-------------------------+
    %| t_eval_h.proc           |
    %+-------------------------+
    %| t_eval_h.wall           |
    %+-------------------------+
    %| t_eval_jac_g.proc       |
    %+-------------------------+
    %| t_eval_jac_g.wall       |
    %+-------------------------+
    %| t_mainloop.proc         |
    %+-------------------------+
    %| t_mainloop.wall         |
    %+-------------------------+
    %| var_integer_md          |
    %+-------------------------+
    %| var_numeric_md          |
    %+-------------------------+
    %| var_string_md           |
    %+-------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %knitro
    %------
    %
    %
    %
    %KNITRO interface
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| BarRule         | OT_INTEGER      | 0               | Barrier Rule    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Debug           | OT_INTEGER      | 0               | Debug level     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Delta           | OT_REAL         | 1               | Initial region  |
    %|                 |                 |                 | scaling factor  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasModeTol     | OT_REAL         | 0.000           | Feasible mode   |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasTol         | OT_REAL         | 0.000           | Feasible        |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasTolAbs      | OT_REAL         | 0               | Absolute        |
    %|                 |                 |                 | feasible        |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Feasible        | OT_BOOLEAN      | 1               | Allow           |
    %|                 |                 |                 | infeasible      |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| GradOpt         | OT_INTEGER      | 1               | Gradient        |
    %|                 |                 |                 | calculation     |
    %|                 |                 |                 | method          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| HessOpt         | OT_INTEGER      | 1               | Hessian         |
    %|                 |                 |                 | calculation     |
    %|                 |                 |                 | method          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| HonorBnds       | OT_BOOLEAN      | 0               | Enforce bounds  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| InitPt          | OT_BOOLEAN      | 0               | Use initial     |
    %|                 |                 |                 | point strategy  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LmSize          | OT_INTEGER      | 10              | Memory pairsize |
    %|                 |                 |                 | limit           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LpSolver        | OT_BOOLEAN      | 0               | Use LpSolver    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxCgIt         | OT_INTEGER      | 0               | Maximum         |
    %|                 |                 |                 | conjugate       |
    %|                 |                 |                 | gradient        |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxIt           | OT_INTEGER      | 10000           | Iteration limit |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Mu              | OT_REAL         | 0.100           | Initial barrier |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Multistart      | OT_BOOLEAN      | 0               | Use multistart  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| NewPoint        | OT_BOOLEAN      | 0               | Select new-     |
    %|                 |                 |                 | point feature   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ObjRange        | OT_REAL         | 1.000e+20       | Maximum         |
    %|                 |                 |                 | objective value |
    %+-----------------+-----------------+-----------------+-----------------+
    %| OptTol          | OT_REAL         | 0.000           | Relative        |
    %|                 |                 |                 | optimality      |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| OptTolAbs       | OT_REAL         | 0               | Absolute        |
    %|                 |                 |                 | optimality      |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| OutLev          | OT_INTEGER      | 2               | Log output      |
    %|                 |                 |                 | level           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Pivot           | OT_REAL         | 0.000           | Initial pivot   |
    %|                 |                 |                 | threshold       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Scale           | OT_BOOLEAN      | 1               | Perform scaling |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ShiftInit       | OT_BOOLEAN      | 1               | Interior-point  |
    %|                 |                 |                 | shifting        |
    %|                 |                 |                 | initial point   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Soc             | OT_INTEGER      | 1               | Second order    |
    %|                 |                 |                 | correction      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| XTol            | OT_REAL         | 0.000           | Relative        |
    %|                 |                 |                 | solution change |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| contype         | OT_INTEGERVECTO |                 |                 |
    %|                 | R               |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %
    %>List of available stats
    %
    %+---------------+
    %|      Id       |
    %+===============+
    %| return_status |
    %+---------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %snopt
    %-----
    %
    %
    %
    %SNOPT interface
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| Backup basis    | OT_INTEGER      | None            | 0 * output      |
    %| file            |                 |                 | extra basis map |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Central         | OT_REAL         | None            | 6.7e-5 * (      |
    %| difference      |                 |                 | Function        |
    %| interval        |                 |                 | precision)^1/3  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Check frequency | OT_INTEGER      | None            | 60 * test row   |
    %|                 |                 |                 | residuals kAx - |
    %|                 |                 |                 | sk              |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Crash option    | OT_INTEGER      | None            | 3 * first basis |
    %|                 |                 |                 | is essentially  |
    %|                 |                 |                 | triangular      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Crash tolerance | OT_REAL         | None            | 0.100           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Debug level     | OT_INTEGER      | None            | 0 * for         |
    %|                 |                 |                 | developers      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Derivative      | OT_INTEGER      | None            | 3               |
    %| level           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Difference      | OT_REAL         | None            | 5.5e-7 * (      |
    %| interval        |                 |                 | Function        |
    %|                 |                 |                 | precision)^1/2  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Dump file       | OT_INTEGER      | None            | 0 * output Load |
    %|                 |                 |                 | data            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Elastic weight  | OT_REAL         | None            | 1.0e+4 * used   |
    %|                 |                 |                 | only during     |
    %|                 |                 |                 | elastic mode    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Expand          | OT_INTEGER      | None            | 10000 * for     |
    %| frequency       |                 |                 | anti-cycling    |
    %|                 |                 |                 | procedure       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Factorization   | OT_INTEGER      | None            | 50 * 100 for    |
    %| frequency       |                 |                 | LPs             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Function        | OT_REAL         | None            | 3.0e-13 * e^0.8 |
    %| precision       |                 |                 | (almost full    |
    %|                 |                 |                 | accuracy)       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Hessian         | OT_STRING       | None            | full memory *   |
    %|                 |                 |                 | default if n1   |
    %|                 |                 |                 | 75  limited     |
    %|                 |                 |                 | memory *        |
    %|                 |                 |                 | default if n1 > |
    %|                 |                 |                 | 75              |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Hessian flush   | OT_INTEGER      | None            | 999999 * no     |
    %|                 |                 |                 | flushing        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Hessian         | OT_INTEGER      | None            | 999999 * for    |
    %| frequency       |                 |                 | full Hessian    |
    %|                 |                 |                 | (never reset)   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Hessian updates | OT_INTEGER      | None            | 10 * for        |
    %|                 |                 |                 | limited memory  |
    %|                 |                 |                 | Hessian         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Insert file     | OT_INTEGER      | None            | 0 * input in    |
    %|                 |                 |                 | industry format |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Iterations      | OT_INTEGER      | None            | 10000 * or 20m  |
    %| limit           |                 |                 | if that is more |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LU              | OT_STRING       | None            | LU partial      |
    %|                 |                 |                 | pivoting *      |
    %|                 |                 |                 | default         |
    %|                 |                 |                 | threshold       |
    %|                 |                 |                 | pivoting        |
    %|                 |                 |                 | strategy  LU    |
    %|                 |                 |                 | rook pivoting * |
    %|                 |                 |                 | threshold rook  |
    %|                 |                 |                 | pivoting  LU    |
    %|                 |                 |                 | complete        |
    %|                 |                 |                 | pivoting *      |
    %|                 |                 |                 | threshold       |
    %|                 |                 |                 | complete        |
    %|                 |                 |                 | pivoting        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LU factor       | OT_REAL         | None            | 3.99 * for NP   |
    %| tolerance       |                 |                 | (100.0 for LP)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LU singularity  | OT_REAL         | None            | 0.000           |
    %| tolerance       |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LU update       | OT_REAL         | None            | 3.99 * for NP ( |
    %| tolerance       |                 |                 | 10.0 for LP)    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Linesearch      | OT_REAL         | None            | 0.9 * smaller   |
    %| tolerance       |                 |                 | for more        |
    %|                 |                 |                 | accurate search |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Load file       | OT_INTEGER      | None            | 0 * input names |
    %|                 |                 |                 | and values      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Major           | OT_REAL         | None            | 1.0e-6 * target |
    %| feasibility     |                 |                 | nonlinear       |
    %| tolerance       |                 |                 | constraint      |
    %|                 |                 |                 | violation       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Major           | OT_INTEGER      | None            | 1000 * or m if  |
    %| iterations      |                 |                 | that is more    |
    %| limit           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Major           | OT_REAL         | None            | 1.0e-6 * target |
    %| optimality      |                 |                 | complementarity |
    %| tolerance       |                 |                 | gap             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Major print     | OT_INTEGER      | None            | 1 * 1-line      |
    %| level           |                 |                 | major iteration |
    %|                 |                 |                 | log             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Major step      | OT_REAL         | None            | 2               |
    %| limit           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Minor           | OT_REAL         | None            | 1.0e-6 * for    |
    %| feasibility     |                 |                 | satisfying the  |
    %| tolerance       |                 |                 | QP bounds       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Minor           | OT_INTEGER      | None            | 500 * or 3m if  |
    %| iterations      |                 |                 | that is more    |
    %| limit           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Minor print     | OT_INTEGER      | None            | 1 * 1-line      |
    %| level           |                 |                 | minor iteration |
    %|                 |                 |                 | log             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| New basis file  | OT_INTEGER      | None            | 0 * output      |
    %|                 |                 |                 | basis map       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| New superbasics | OT_INTEGER      | None            | 99 * controls   |
    %| limit           |                 |                 | early           |
    %|                 |                 |                 | termination of  |
    %|                 |                 |                 | QPs             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Old basis file  | OT_INTEGER      | None            | 0 * input basis |
    %|                 |                 |                 | map             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Partial price   | OT_INTEGER      | None            | 1 * 10 for      |
    %|                 |                 |                 | large LPs       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Penalty         | OT_REAL         | None            | 0.0 * initial   |
    %| parameter       |                 |                 | penalty         |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Pivot tolerance | OT_REAL         | None            | 3.7e-11 * e^2/3 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Print frequency | OT_INTEGER      | None            | 100 * minor     |
    %|                 |                 |                 | iterations log  |
    %|                 |                 |                 | on Print file   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Proximal point  | OT_INTEGER      | None            | 1 * satisfies   |
    %| method          |                 |                 | linear          |
    %|                 |                 |                 | constraints     |
    %|                 |                 |                 | near x0         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Punch file      | OT_INTEGER      | None            | 0 * output      |
    %|                 |                 |                 | Insert data     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| QPSolver        | OT_STRING       | None            | Cholesky *      |
    %|                 |                 |                 | default         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Reduced Hessian | OT_INTEGER      | None            | 2000 * or       |
    %| dimension       |                 |                 | Superbasics     |
    %|                 |                 |                 | limit if that   |
    %|                 |                 |                 | is less         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Save frequency  | OT_INTEGER      | None            | 100 * save      |
    %|                 |                 |                 | basis map       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Scale option    | OT_INTEGER      | None            | 1 * linear      |
    %|                 |                 |                 | constraints and |
    %|                 |                 |                 | variables       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Scale tolerance | OT_REAL         | None            | 0.900           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Solution        | OT_STRING       | None            | Yes * on the    |
    %|                 |                 |                 | Print file      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Solution file   | OT_INTEGER      | None            | 0 * different   |
    %|                 |                 |                 | from printed    |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Sticky          | OT_STRING       | None            | No * Yes makes  |
    %| parameters      |                 |                 | parameter       |
    %|                 |                 |                 | values persist  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Summary         | OT_INTEGER      | None            | 100 * minor     |
    %| frequency       |                 |                 | iterations log  |
    %|                 |                 |                 | on Summary file |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Superbasics     | OT_INTEGER      | None            | n1 + 1 * n1 =   |
    %| limit           |                 |                 | number of       |
    %|                 |                 |                 | nonlinear       |
    %|                 |                 |                 | variables       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| System          | OT_STRING       | None            | No * Yes prints |
    %| information     |                 |                 | more system     |
    %|                 |                 |                 | information     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Timing level    | OT_INTEGER      | None            | 3 * print cpu   |
    %|                 |                 |                 | times           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Unbounded       | OT_REAL         | None            | 1.000e+15       |
    %| objective       |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Unbounded step  | OT_REAL         | None            | 1.000e+18       |
    %| size            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Verify level    | OT_INTEGER      | None            | 0 * cheap check |
    %|                 |                 |                 | on gradients    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Violation limit | OT_REAL         | None            | 10.0 * unscaled |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation limit |
    %+-----------------+-----------------+-----------------+-----------------+
    %| detect_linear   | OT_BOOLEAN      | True            | Make an effort  |
    %|                 |                 |                 | to treat linear |
    %|                 |                 |                 | constraints and |
    %|                 |                 |                 | linear          |
    %|                 |                 |                 | variables       |
    %|                 |                 |                 | specially.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print file      | OT_STRING       | None            | n/a             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_time      | OT_BOOLEAN      | True            | print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about execution |
    %|                 |                 |                 | time            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| specs file      | OT_STRING       | None            | n/a             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| start           | OT_STRING       | Cold            |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| summary         | OT_BOOLEAN      | True            | n/a             |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-----------+
    %|    Id     |
    %+===========+
    %| eval_nlp  |
    %+-----------+
    %| setup_nlp |
    %+-----------+
    %
    %>List of available stats
    %
    %+----------------+
    %|       Id       |
    %+================+
    %| iter_count     |
    %+----------------+
    %| iterations     |
    %+----------------+
    %| n_callback_fun |
    %+----------------+
    %| n_eval_grad_f  |
    %+----------------+
    %| n_eval_jac_g   |
    %+----------------+
    %| return_status  |
    %+----------------+
    %| t_callback_fun |
    %+----------------+
    %| t_eval_grad_f  |
    %+----------------+
    %| t_eval_jac_g   |
    %+----------------+
    %| t_mainloop     |
    %+----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %worhp
    %-----
    %
    %
    %
    %WORHP interface
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| AcceptTolFeas   | OT_REAL         | 0.001           | Tolerance for   |
    %|                 |                 |                 | acceptable      |
    %|                 |                 |                 | feasibility     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| AcceptTolOpti   | OT_REAL         | 0.001           | Tolerance for   |
    %|                 |                 |                 | acceptable      |
    %|                 |                 |                 | optimality      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| AlphaMinConst   | OT_BOOLEAN      | False           | Use a constant  |
    %|                 |                 |                 | lower bound on  |
    %|                 |                 |                 | Armijo stepsize |
    %|                 |                 |                 | in Filter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Ares            | OT_INTEGERVECTO | [42, 41, 42,    | Armijo recovery |
    %|                 | R               | 43, 44, 41, 50] | strategies.     |
    %|                 |                 |                 | Vector of size  |
    %|                 |                 |                 | 7               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ArmijoBeta      | OT_REAL         | 0.712           | Trial stepsize  |
    %|                 |                 |                 | decrease factor |
    %|                 |                 |                 | for Armijo rule |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ArmijoMaxAlpha  | OT_REAL         | 1               | Initial alpha   |
    %|                 |                 |                 | for Armijo rule |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ArmijoMinAlpha  | OT_REAL         | 0.000           | Lower bound on  |
    %|                 |                 |                 | alpha for       |
    %|                 |                 |                 | Armijo rule     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ArmijoMinAlphaR | OT_REAL         | 0.000           | Lower bound on  |
    %| ec              |                 |                 | alpha for       |
    %|                 |                 |                 | Armijo rule     |
    %|                 |                 |                 | during recovery |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ArmijoSigma     | OT_REAL         | 0.005           | Scale factor    |
    %|                 |                 |                 | for linearised  |
    %|                 |                 |                 | descent check   |
    %|                 |                 |                 | in Armijo rule  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| AutoQPRecovery  | OT_BOOLEAN      | True            | Enable          |
    %|                 |                 |                 | automatic QP    |
    %|                 |                 |                 | recovery        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BFGSmaxblockSiz | OT_INTEGER      | 300             | Block size      |
    %| e               |                 |                 | parameter used  |
    %|                 |                 |                 | by certain BFGS |
    %|                 |                 |                 | methods         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BFGSmethod      | OT_INTEGER      | 0               | Choose BFGS     |
    %|                 |                 |                 | method (0:      |
    %|                 |                 |                 | dense, 1-3:     |
    %|                 |                 |                 | block, 100+:    |
    %|                 |                 |                 | sparse)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BFGSminblockSiz | OT_INTEGER      | 300             | Block size      |
    %| e               |                 |                 | parameter used  |
    %|                 |                 |                 | by certain BFGS |
    %|                 |                 |                 | methods         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BFGSrestart     | OT_INTEGER      | 50              | Restart BFGS    |
    %|                 |                 |                 | update after    |
    %|                 |                 |                 | this many       |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BettsFactor     | OT_REAL         | 2.100           | Update factor   |
    %|                 |                 |                 | for Betts'      |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | regularisation  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BettsPoint      | OT_REAL         | 1               | Smallest        |
    %|                 |                 |                 | eigenvalue of   |
    %|                 |                 |                 | the regularised |
    %|                 |                 |                 | Hessian         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| BoundTolFac     | OT_REAL         | 1000            | Factor in       |
    %|                 |                 |                 | determining     |
    %|                 |                 |                 | active          |
    %|                 |                 |                 | constraints by  |
    %|                 |                 |                 | KKT             |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CheckFJ         | OT_REAL         | 1.000e+12       | Upper bound     |
    %|                 |                 |                 | used by Fritz-  |
    %|                 |                 |                 | John heuristic  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CheckStructureD | OT_BOOLEAN      | True            | Enable          |
    %| F               |                 |                 | structural      |
    %|                 |                 |                 | checking of DF  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CheckStructureD | OT_BOOLEAN      | True            | Enable          |
    %| G               |                 |                 | structural      |
    %|                 |                 |                 | checking of DG  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CheckStructureH | OT_BOOLEAN      | True            | Enable          |
    %| M               |                 |                 | structural      |
    %|                 |                 |                 | checking of HM  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepBettsSum | OT_REAL         | 0.500           | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepConStop  | OT_REAL         | 0.000           | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepConvio   | OT_REAL         | 1               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepMaxIter  | OT_INTEGER      | 50              | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepMethod   | OT_INTEGER      | 0               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepMode     | OT_INTEGER      | 1               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepPFactor  | OT_REAL         | 1               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepPMax     | OT_REAL         | 1000000         | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CorStepRecovery | OT_BOOLEAN      | False           | (experimental)  |
    %| DX              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CurvBCond       | OT_REAL         | 0.020           | Block BFGS      |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | condition bound |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CurvBFac        | OT_REAL         | 0.300           | Block BFGS      |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | condition       |
    %|                 |                 |                 | regularisation  |
    %|                 |                 |                 | factor          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CurvCond        | OT_REAL         | 0.020           | BFGS Curvature  |
    %|                 |                 |                 | condition bound |
    %+-----------------+-----------------+-----------------+-----------------+
    %| CurvFac         | OT_REAL         | 0.300           | BFGS curvature  |
    %|                 |                 |                 | condition       |
    %|                 |                 |                 | regularisation  |
    %|                 |                 |                 | factor          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| DebugMarker05   | OT_INTEGER      | 42              | Debug marker.   |
    %|                 |                 |                 | Used to find    |
    %|                 |                 |                 | memory alignmen |
    %|                 |                 |                 | t/padding       |
    %|                 |                 |                 | issues          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| DebugMarker06   | OT_INTEGER      | 42              | Debug marker.   |
    %|                 |                 |                 | Used to find    |
    %|                 |                 |                 | memory alignmen |
    %|                 |                 |                 | t/padding       |
    %|                 |                 |                 | issues          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FGtogether      | OT_BOOLEAN      | False           | F and G cannot  |
    %|                 |                 |                 | be evaluated    |
    %|                 |                 |                 | separately      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FJandND         | OT_BOOLEAN      | False           | Enable Fritz-   |
    %|                 |                 |                 | John and non-   |
    %|                 |                 |                 | differentiable  |
    %|                 |                 |                 | check           |
    %|                 |                 |                 | heuristics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasibleDual    | OT_BOOLEAN      | False           | Activate dual   |
    %|                 |                 |                 | feasibility     |
    %|                 |                 |                 | mode            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasibleInit    | OT_BOOLEAN      | False           | Activate        |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | feasibility     |
    %|                 |                 |                 | mode            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasibleInitTol | OT_REAL         | 0.001           | Feasibility     |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | no-objective    |
    %|                 |                 |                 | feasible mode   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FeasibleOnly    | OT_BOOLEAN      | False           | Activate        |
    %|                 |                 |                 | feasible-only   |
    %|                 |                 |                 | mode            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FidifEps        | OT_REAL         | 0.000           | Finite          |
    %|                 |                 |                 | difference      |
    %|                 |                 |                 | perturbation    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FidifHM         | OT_BOOLEAN      | False           | Approximate     |
    %|                 |                 |                 | Hessian by      |
    %|                 |                 |                 | finite          |
    %|                 |                 |                 | differences     |
    %|                 |                 |                 | (otherwise      |
    %|                 |                 |                 | BFGS)           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FilterBisecAlph | OT_BOOLEAN      | True            | Filter          |
    %| a               |                 |                 | heuristic to    |
    %|                 |                 |                 | save Armijo     |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FilterGammaCV   | OT_REAL         | 0.000           | Constraint      |
    %|                 |                 |                 | violation       |
    %|                 |                 |                 | decrease factor |
    %|                 |                 |                 | in Filter       |
    %|                 |                 |                 | acceptance      |
    %|                 |                 |                 | check           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FilterGammaF    | OT_REAL         | 0.000           | Objective       |
    %|                 |                 |                 | decrease factor |
    %|                 |                 |                 | in Filter       |
    %|                 |                 |                 | acceptance      |
    %|                 |                 |                 | check           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FilterIntersecA | OT_BOOLEAN      | True            | Filter          |
    %| lpha            |                 |                 | heuristic to    |
    %|                 |                 |                 | save Armijo     |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FirstDifCentral | OT_BOOLEAN      | True            | Use central     |
    %|                 |                 |                 | finite          |
    %|                 |                 |                 | difference      |
    %|                 |                 |                 | quotient for    |
    %|                 |                 |                 | first           |
    %|                 |                 |                 | derivatives     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FocusOnFeas     | OT_BOOLEAN      | True            | Enable Focus-   |
    %|                 |                 |                 | on-Feasibility  |
    %|                 |                 |                 | mode            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| FocusOnFeasFact | OT_REAL         | 1.360           | Factor in       |
    %| or              |                 |                 | Focus-on-       |
    %|                 |                 |                 | Feasibility     |
    %|                 |                 |                 | mode            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| GammaAlpha      | OT_REAL         | 0.050           | Safety factor   |
    %|                 |                 |                 | for alphamin    |
    %|                 |                 |                 | calculation by  |
    %|                 |                 |                 | Filter          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| GroupMethod     | OT_INTEGER      | 1               | Select method   |
    %|                 |                 |                 | to determine    |
    %|                 |                 |                 | graph colouring |
    %|                 |                 |                 | groups          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| IgnoreFilterCri | OT_BOOLEAN      | False           | Activate        |
    %| t               |                 |                 | accelerating    |
    %|                 |                 |                 | heuristics for  |
    %|                 |                 |                 | Filter          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| IncBettsTau     | OT_REAL         | 2               | Increase factor |
    %|                 |                 |                 | for Betts'      |
    %|                 |                 |                 | update          |
    %|                 |                 |                 | dampening term  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| IncBettsTauMore | OT_REAL         | 100             | Larger increase |
    %|                 |                 |                 | factor for      |
    %|                 |                 |                 | Betts' update   |
    %|                 |                 |                 | dampening term  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| IncreaseIWS     | OT_REAL         | 1               | Increase factor |
    %|                 |                 |                 | for estimated   |
    %|                 |                 |                 | integer         |
    %|                 |                 |                 | workspace       |
    %|                 |                 |                 | requirement     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| IncreaseRWS     | OT_REAL         | 1               | Increase factor |
    %|                 |                 |                 | for estimated   |
    %|                 |                 |                 | real workspace  |
    %|                 |                 |                 | requirement     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Infty           | OT_REAL         | 1.000e+20       | Upper bound for |
    %|                 |                 |                 | numbers to be   |
    %|                 |                 |                 | regarded as     |
    %|                 |                 |                 | finite          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| InftyUnbounded  | OT_REAL         | 1.000e+20       | Tolerance for   |
    %|                 |                 |                 | unboundedness   |
    %|                 |                 |                 | detection       |
    %|                 |                 |                 | heuristic       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| InitialLMest    | OT_BOOLEAN      | True            | Enable initial  |
    %|                 |                 |                 | Lagrange        |
    %|                 |                 |                 | multiplier      |
    %|                 |                 |                 | estimate        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| KeepAcceptableS | OT_BOOLEAN      | True            | Save acceptable |
    %| ol              |                 |                 | solutions as    |
    %|                 |                 |                 | fallback        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LMestQPipComTol | OT_REAL         | 0.003           | IP              |
    %|                 |                 |                 | complementarity |
    %|                 |                 |                 | tolerance in    |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | multiplier      |
    %|                 |                 |                 | estimate        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LMestQPipResTol | OT_REAL         | 1               | IP residual     |
    %|                 |                 |                 | tolerance in    |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | multiplier      |
    %|                 |                 |                 | estimate        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LinMult         | OT_BOOLEAN      | False           | Control         |
    %|                 |                 |                 | Lagrange        |
    %|                 |                 |                 | multiplier      |
    %|                 |                 |                 | update          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LogLevel        | OT_INTEGER      | 0               | Enable XML      |
    %|                 |                 |                 | logfiles and    |
    %|                 |                 |                 | writing         |
    %|                 |                 |                 | interval        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LogResult       | OT_INTEGER      | 0               | Enable XML      |
    %|                 |                 |                 | result logging  |
    %|                 |                 |                 | and detail      |
    %|                 |                 |                 | level           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LowPassAlphaF   | OT_REAL         | 0.950           | Lowpass-filter  |
    %|                 |                 |                 | update factor   |
    %|                 |                 |                 | for objective   |
    %|                 |                 |                 | values          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LowPassAlphaG   | OT_REAL         | 0.950           | Lowpass-filter  |
    %|                 |                 |                 | update factor   |
    %|                 |                 |                 | for constraint  |
    %|                 |                 |                 | values          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LowPassAlphaMer | OT_REAL         | 0.100           | Lowpass-filter  |
    %| it              |                 |                 | update factor   |
    %|                 |                 |                 | for merit       |
    %|                 |                 |                 | function values |
    %+-----------------+-----------------+-----------------+-----------------+
    %| LowPassFilter   | OT_BOOLEAN      | True            | Enable lowpass- |
    %|                 |                 |                 | filter          |
    %|                 |                 |                 | termination     |
    %|                 |                 |                 | criterion       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97blas3       | OT_BOOLEAN      | False           | Use BLAS level  |
    %|                 |                 |                 | 3 (dgemm) in    |
    %|                 |                 |                 | MA97            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97mf          | OT_BOOLEAN      | False           | Use             |
    %|                 |                 |                 | multifrontal-   |
    %|                 |                 |                 | style forward   |
    %|                 |                 |                 | solve of MA97   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97nemin       | OT_INTEGER      | 8               | Node            |
    %|                 |                 |                 | amalgation,     |
    %|                 |                 |                 | controls        |
    %|                 |                 |                 | merging in      |
    %|                 |                 |                 | elimination     |
    %|                 |                 |                 | tree by MA97    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97ordering    | OT_INTEGER      | 5               | Ordering used   |
    %|                 |                 |                 | by MA97         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97print       | OT_INTEGER      | -1              | Print level     |
    %|                 |                 |                 | used by MA97    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97scaling     | OT_INTEGER      | 0               | Scaling used by |
    %|                 |                 |                 | MA97            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97small       | OT_REAL         | 0.000           | Any pivot whose |
    %|                 |                 |                 | modulus is less |
    %|                 |                 |                 | than this is    |
    %|                 |                 |                 | treated as zero |
    %|                 |                 |                 | by MA97         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MA97u           | OT_REAL         | 0.010           | Relative pivot  |
    %|                 |                 |                 | tolerance of    |
    %|                 |                 |                 | MA97            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MatrixCC        | OT_BOOLEAN      | False           | Not to be       |
    %|                 |                 |                 | included into a |
    %|                 |                 |                 | parameter file! |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxCalls        | OT_INTEGER      | 2.147e+09       | Upper bound to  |
    %|                 |                 |                 | Reverse         |
    %|                 |                 |                 | Communication   |
    %|                 |                 |                 | calls           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxForce        | OT_INTEGER      | 1000            | Maximum number  |
    %|                 |                 |                 | of Force        |
    %|                 |                 |                 | recovery        |
    %|                 |                 |                 | strategy steps  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxGPart        | OT_INTEGER      | 1               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxIter         | OT_INTEGER      | 500             | Upper bound on  |
    %|                 |                 |                 | major           |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxLScounter    | OT_INTEGER      | 3               | Control         |
    %|                 |                 |                 | activation of   |
    %|                 |                 |                 | Filter          |
    %|                 |                 |                 | acceleration    |
    %|                 |                 |                 | heuristics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MaxNorm         | OT_BOOLEAN      | True            | Select max-norm |
    %|                 |                 |                 | instead of      |
    %|                 |                 |                 | 1-norm in       |
    %|                 |                 |                 | Filter          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MeritFunction   | OT_INTEGER      | 4               | Select merit    |
    %|                 |                 |                 | function and    |
    %|                 |                 |                 | penalty update  |
    %|                 |                 |                 | [0, 3..5]       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MeritGradTol    | OT_REAL         | 0.000           | Threshold of    |
    %|                 |                 |                 | meritfunction   |
    %|                 |                 |                 | gradient for    |
    %|                 |                 |                 | increasing      |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | regularisation  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MinBettsTau     | OT_REAL         | 0.000           | Lower bound for |
    %|                 |                 |                 | Betts' update   |
    %|                 |                 |                 | dampening term  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MoreRelax       | OT_BOOLEAN      | False           | Introduce one   |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | variable for    |
    %|                 |                 |                 | every           |
    %|                 |                 |                 | constraint      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| NLPmethod       | OT_INTEGER      | 1               | Select (1)      |
    %|                 |                 |                 | Meritfunction   |
    %|                 |                 |                 | or (3) Filter   |
    %|                 |                 |                 | globalisation   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| NLPprint        | OT_INTEGER      | 2               | NLP print level |
    %|                 |                 |                 | [-1..4]         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PairMethod      | OT_INTEGER      | 1               | Select method   |
    %|                 |                 |                 | to determine    |
    %|                 |                 |                 | graph colouring |
    %|                 |                 |                 | pairgroups      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdEpsBar    | OT_REAL         | 0.900           | Penalty update  |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | factor for      |
    %|                 |                 |                 | MeritFunction = |
    %|                 |                 |                 | 3               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdEpsKFac   | OT_REAL         | 2               | Penalty update  |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | factor for      |
    %|                 |                 |                 | MeritFunction = |
    %|                 |                 |                 | 4               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdEpsKSeque | OT_INTEGER      | 2               | Penalty update  |
    %| nce             |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdMaxDeltaK | OT_REAL         | 11              | Max penalty for |
    %|                 |                 |                 | MeritFunction = |
    %|                 |                 |                 | 4               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdMaxFac    | OT_REAL         | 100000000       | Max factor for  |
    %|                 |                 |                 | increasing      |
    %|                 |                 |                 | penalty for     |
    %|                 |                 |                 | MeritFunction = |
    %|                 |                 |                 | 4               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PenUpdRBar      | OT_REAL         | 2               | Penalty update  |
    %|                 |                 |                 | parameter for   |
    %|                 |                 |                 | MeritFunction = |
    %|                 |                 |                 | 3               |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PrecisionF      | OT_REAL         | 0.000           | (currently      |
    %|                 |                 |                 | unused)         |
    %|                 |                 |                 | Relative        |
    %|                 |                 |                 | precision of    |
    %|                 |                 |                 | objective       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| PrecisionG      | OT_REAL         | 0.000           | (currently      |
    %|                 |                 |                 | unused)         |
    %|                 |                 |                 | Relative        |
    %|                 |                 |                 | precision of    |
    %|                 |                 |                 | constraints     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| QPscaleParam    | OT_REAL         | 0               | (currently      |
    %|                 |                 |                 | unused) Scaling |
    %|                 |                 |                 | factor for QP   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| QuadraticProble | OT_BOOLEAN      | False           | Not to be       |
    %| m               |                 |                 | included into a |
    %|                 |                 |                 | parameter file! |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ReduceBettsTau  | OT_REAL         | 0.300           | Decrease factor |
    %|                 |                 |                 | for Betts'      |
    %|                 |                 |                 | update          |
    %|                 |                 |                 | dampening term  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RefineFeasibili | OT_INTEGER      | 0               | 0 -             |
    %| ty              |                 |                 | Deactivated, 1  |
    %|                 |                 |                 | - After first   |
    %|                 |                 |                 | feasible        |
    %|                 |                 |                 | iterate, 2 -    |
    %|                 |                 |                 | Always on,      |
    %|                 |                 |                 | Activates       |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement due  |
    %|                 |                 |                 | to perturbation |
    %|                 |                 |                 | in constraints  |
    %|                 |                 |                 | using           |
    %|                 |                 |                 | parametric      |
    %|                 |                 |                 | sensitivities   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RefineMaxHMReg  | OT_REAL         | 1000            | Maximum allowed |
    %|                 |                 |                 | regularisation  |
    %|                 |                 |                 | of the hessian  |
    %|                 |                 |                 | CAUTION         |
    %|                 |                 |                 | absolute value  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RefineMaxRelax  | OT_REAL         | 0.750           | Maximum allowed |
    %|                 |                 |                 | relaxation to   |
    %|                 |                 |                 | apply           |
    %|                 |                 |                 | feasibility     |
    %|                 |                 |                 | refinement      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RefineOnlyOnAlp | OT_BOOLEAN      | True            | Activates new   |
    %| ha              |                 |                 | iterative       |
    %|                 |                 |                 | refinement of   |
    %|                 |                 |                 | constraints     |
    %|                 |                 |                 | only when       |
    %|                 |                 |                 | Armijo alpha    |
    %|                 |                 |                 | equals one      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RefineStartTol  | OT_REAL         | 0.000           | Start tolerance |
    %|                 |                 |                 | for successful  |
    %|                 |                 |                 | termination of  |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement due  |
    %|                 |                 |                 | to perturbation |
    %|                 |                 |                 | in constraints  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RegStrategy     | OT_INTEGER      | 1               | Select Hessian  |
    %|                 |                 |                 | regularisation  |
    %|                 |                 |                 | strategy in     |
    %|                 |                 |                 | Filter          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ReinitFilter    | OT_BOOLEAN      | False           | Enables Filter- |
    %|                 |                 |                 | reinitialisatio |
    %|                 |                 |                 | n accelerating  |
    %|                 |                 |                 | heuristic       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RelaxMaxDelta   | OT_REAL         | 0.920           | Upper bound for |
    %|                 |                 |                 | accepting the   |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | variable        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RelaxMaxPen     | OT_REAL         | 50000000        | Upper bound on  |
    %|                 |                 |                 | the constraint  |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | penalty         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RelaxRho        | OT_REAL         | 6               | Update factor   |
    %|                 |                 |                 | for the         |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | penalty         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RelaxStart      | OT_REAL         | 1               | Initial value   |
    %|                 |                 |                 | of the          |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | penalty         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| RestUntilFeas   | OT_BOOLEAN      | False           | Do restoration  |
    %|                 |                 |                 | until a         |
    %|                 |                 |                 | feasible        |
    %|                 |                 |                 | solution is     |
    %|                 |                 |                 | found           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaleConIter    | OT_BOOLEAN      | False           | Scale           |
    %|                 |                 |                 | constraints in  |
    %|                 |                 |                 | every iteration |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaleFacObj     | OT_REAL         | 10              | Value to scale  |
    %|                 |                 |                 | large objective |
    %|                 |                 |                 | functions to    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaleFacQP      | OT_REAL         | 10              | Upper bound on  |
    %|                 |                 |                 | resulting       |
    %|                 |                 |                 | matrix norm for |
    %|                 |                 |                 | QP scaling      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaledFD        | OT_BOOLEAN      | True            | Use a scaled    |
    %|                 |                 |                 | perturbation    |
    %|                 |                 |                 | for finite      |
    %|                 |                 |                 | differences     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaledKKT       | OT_BOOLEAN      | True            | Scale KKT       |
    %|                 |                 |                 | conditions      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaledObj       | OT_BOOLEAN      | True            | Scale the       |
    %|                 |                 |                 | objective       |
    %|                 |                 |                 | function        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ScaledQP        | OT_BOOLEAN      | True            | Scale some      |
    %|                 |                 |                 | matrices handed |
    %|                 |                 |                 | to the QP       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| StartBettsTau   | OT_REAL         | 0.100           | Initial value   |
    %|                 |                 |                 | for Betts'      |
    %|                 |                 |                 | update          |
    %|                 |                 |                 | dampening term  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| SteffensenOnRef | OT_BOOLEAN      | False           | Use Steffensen  |
    %| ine             |                 |                 | Extrapolation   |
    %|                 |                 |                 | during          |
    %|                 |                 |                 | Feasibility     |
    %|                 |                 |                 | Refinement      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| SwitchingDelta  | OT_REAL         | 0.010           | Filter          |
    %|                 |                 |                 | switching       |
    %|                 |                 |                 | condition       |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| SwitchingSCV    | OT_REAL         | 1.100           | Filter          |
    %|                 |                 |                 | switching       |
    %|                 |                 |                 | condition       |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| SwitchingSF     | OT_REAL         | 2.300           | Filter          |
    %|                 |                 |                 | switching       |
    %|                 |                 |                 | condition       |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TakeQPSol       | OT_BOOLEAN      | False           | Evaluate QP     |
    %|                 |                 |                 | search          |
    %|                 |                 |                 | direction       |
    %|                 |                 |                 | regardless of   |
    %|                 |                 |                 | convergence     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| Timeout         | OT_REAL         | 300             | Timeout in      |
    %|                 |                 |                 | seconds         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TolComp         | OT_REAL         | 0.001           | Complementarity |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TolFeas         | OT_REAL         | 0.000           | Feasibility     |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TolOpti         | OT_REAL         | 0.000           | Optimality      |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TolWeakActive   | OT_REAL         | 1               | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TooBig          | OT_BOOLEAN      | True            | Enable too-big  |
    %|                 |                 |                 | termination     |
    %|                 |                 |                 | heuristics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TooBigCV        | OT_REAL         | 1.000e+25       | Upper bound on  |
    %|                 |                 |                 | constraint      |
    %|                 |                 |                 | violation for   |
    %|                 |                 |                 | too-big         |
    %|                 |                 |                 | heuristic       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TooBigKKT       | OT_REAL         | 1.000e+30       | Upper bound on  |
    %|                 |                 |                 | KKT values for  |
    %|                 |                 |                 | too-big         |
    %|                 |                 |                 | heuristic       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UpdateMu        | OT_BOOLEAN      | True            | Activates       |
    %|                 |                 |                 | update of       |
    %|                 |                 |                 | lagrange        |
    %|                 |                 |                 | multipliers     |
    %|                 |                 |                 | during          |
    %|                 |                 |                 | correction step |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UseZen          | OT_BOOLEAN      | False           | Run Zen module  |
    %|                 |                 |                 | after           |
    %|                 |                 |                 | successful      |
    %|                 |                 |                 | termination     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserDF          | OT_BOOLEAN      | True            | Objective       |
    %|                 |                 |                 | gradient values |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserDG          | OT_BOOLEAN      | True            | Jacobian values |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserHM          | OT_BOOLEAN      | True            | Hessian values  |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserHMstructure | OT_INTEGER      | 2               | Enable          |
    %|                 |                 |                 | automatic       |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | structure       |
    %|                 |                 |                 | generation or   |
    %|                 |                 |                 | checking        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserZenDGp      | OT_BOOLEAN      | False           | Hessian values  |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserZenDLp      | OT_BOOLEAN      | False           | Gradient values |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserZenDLpp     | OT_BOOLEAN      | False           | Hessian values  |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| UserZenDLxp     | OT_BOOLEAN      | False           | Hessian values  |
    %|                 |                 |                 | supplied by     |
    %|                 |                 |                 | caller          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| WeakActiveSet   | OT_BOOLEAN      | False           | (experimental)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ZenCheckMaxPert | OT_BOOLEAN      | False           | Check maximum   |
    %|                 |                 |                 | of secure       |
    %|                 |                 |                 | perturbation    |
    %|                 |                 |                 | when updating   |
    %|                 |                 |                 | solution        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ZenFDnewMethod  | OT_BOOLEAN      | True            |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| ZenRenewLU      | OT_BOOLEAN      | False           | false: use LU   |
    %|                 |                 |                 | from last QP    |
    %|                 |                 |                 | step; true:     |
    %|                 |                 |                 | renew LU        |
    %|                 |                 |                 | decomposition.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eps             | OT_REAL         | 0.000           | Machine epsilon |
    %+-----------------+-----------------+-----------------+-----------------+
    %| internalParChan | OT_INTEGER      | 0               | Counter for     |
    %| ged             |                 |                 | changed         |
    %|                 |                 |                 | parameters.     |
    %|                 |                 |                 | Internal use    |
    %|                 |                 |                 | only.           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_time      | OT_BOOLEAN      | True            | Print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about execution |
    %|                 |                 |                 | time            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipBarrier    | OT_REAL         | 7.800           | IP barrier      |
    %|                 |                 |                 | parameter.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipComTol     | OT_REAL         | 0.000           | IP              |
    %|                 |                 |                 | complementarity |
    %|                 |                 |                 | tolerance.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipFracBound  | OT_REAL         | 0.880           | IP fraction-to- |
    %|                 |                 |                 | the-boundary    |
    %|                 |                 |                 | parameter.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipLsMethod   | OT_STRING       | None            | Select the      |
    %|                 |                 |                 | direct linear   |
    %|                 |                 |                 | solver used by  |
    %|                 |                 |                 | the IP method.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipMinAlpha   | OT_REAL         | 0.000           | IP line search  |
    %|                 |                 |                 | minimum step    |
    %|                 |                 |                 | size.           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipRelaxDiv   | OT_REAL         | 2               | The relaxation  |
    %|                 |                 |                 | term is divided |
    %|                 |                 |                 | by this value   |
    %|                 |                 |                 | if successful.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipRelaxMax   | OT_REAL         | 0.000           | Maximum         |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | value.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipRelaxMin   | OT_REAL         | 0.000           | Mimimum         |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | value.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipRelaxMult  | OT_REAL         | 10              | The relaxation  |
    %|                 |                 |                 | term is         |
    %|                 |                 |                 | multiplied by   |
    %|                 |                 |                 | this value if   |
    %|                 |                 |                 | unsuccessful.   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipResTol     | OT_REAL         | 0.000           | IP residuals    |
    %|                 |                 |                 | tolerance.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_ipTryRelax   | OT_BOOLEAN      | True            | Enable          |
    %|                 |                 |                 | relaxation      |
    %|                 |                 |                 | strategy when   |
    %|                 |                 |                 | encountering an |
    %|                 |                 |                 | error.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsItMaxIter  | OT_INTEGER      | 1000            | Maximum number  |
    %|                 |                 |                 | of iterations   |
    %|                 |                 |                 | of the          |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | linear solvers. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsItMethod   | OT_STRING       | None            | Select the      |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | linear solver.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsItPrecondM | OT_STRING       | None            | Select          |
    %| ethod           |                 |                 | preconditioner  |
    %|                 |                 |                 | for the         |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | linear solver.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsRefineMaxI | OT_INTEGER      | 10              | Maximum number  |
    %| ter             |                 |                 | of iterative    |
    %|                 |                 |                 | refinement      |
    %|                 |                 |                 | steps of the    |
    %|                 |                 |                 | direct linear   |
    %|                 |                 |                 | solvers.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsScale      | OT_BOOLEAN      | True            | Enables scaling |
    %|                 |                 |                 | on linear       |
    %|                 |                 |                 | solver level.   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsTol        | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | the linear      |
    %|                 |                 |                 | solver.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_lsTrySimple  | OT_BOOLEAN      | False           | Some matrices   |
    %|                 |                 |                 | can be solved   |
    %|                 |                 |                 | without calling |
    %|                 |                 |                 | a linear        |
    %|                 |                 |                 | equation solver |
    %|                 |                 |                 | .Currently only |
    %|                 |                 |                 | diagonal        |
    %|                 |                 |                 | matrices are    |
    %|                 |                 |                 | supported.Non-  |
    %|                 |                 |                 | diagonal        |
    %|                 |                 |                 | matrices will   |
    %|                 |                 |                 | besolved with   |
    %|                 |                 |                 | the chosen      |
    %|                 |                 |                 | linear equation |
    %|                 |                 |                 | solver.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_maxIter      | OT_INTEGER      | 80              | Imposes an      |
    %|                 |                 |                 | upper limit on  |
    %|                 |                 |                 | the number of   |
    %|                 |                 |                 | minor solver    |
    %|                 |                 |                 | iterations,     |
    %|                 |                 |                 | i.e. for the    |
    %|                 |                 |                 | quadratic       |
    %|                 |                 |                 | subproblem      |
    %|                 |                 |                 | solver.If the   |
    %|                 |                 |                 | limit is        |
    %|                 |                 |                 | reached before  |
    %|                 |                 |                 | convergence,    |
    %|                 |                 |                 | WORHP will      |
    %|                 |                 |                 | activate QP     |
    %|                 |                 |                 | recovery        |
    %|                 |                 |                 | strategies to   |
    %|                 |                 |                 | prevent a       |
    %|                 |                 |                 | solver          |
    %|                 |                 |                 | breakdown.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_method       | OT_STRING       | None            | Select the      |
    %|                 |                 |                 | solution method |
    %|                 |                 |                 | used by the QP  |
    %|                 |                 |                 | solver.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnBeta      | OT_REAL         | 0.900           | NSN stepsize    |
    %|                 |                 |                 | decrease        |
    %|                 |                 |                 | factor.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnGradStep  | OT_BOOLEAN      | True            | Enable gradient |
    %|                 |                 |                 | steps in the    |
    %|                 |                 |                 | NSN method.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnKKT       | OT_REAL         | 0.000           | NSN KKT         |
    %|                 |                 |                 | tolerance.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnLsMethod  | OT_STRING       | None            | Select the      |
    %|                 |                 |                 | direct linear   |
    %|                 |                 |                 | solver used by  |
    %|                 |                 |                 | the NSN method. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnMinAlpha  | OT_REAL         | 0.000           | NSN line search |
    %|                 |                 |                 | minimum step    |
    %|                 |                 |                 | size.           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_nsnSigma     | OT_REAL         | 0.010           | NSN line search |
    %|                 |                 |                 | slope           |
    %|                 |                 |                 | parameter.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_printLevel   | OT_STRING       | None            | Controls the    |
    %|                 |                 |                 | amount of QP    |
    %|                 |                 |                 | solver output.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_scaleIntern  | OT_BOOLEAN      | False           | Enable scaling  |
    %|                 |                 |                 | on QP level.    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_strict       | OT_BOOLEAN      | True            | Use strict      |
    %|                 |                 |                 | termination     |
    %|                 |                 |                 | criteria in IP  |
    %|                 |                 |                 | method.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %
    %>List of available stats
    %
    %+--------------------+
    %|         Id         |
    %+====================+
    %| iter_count         |
    %+--------------------+
    %| iteration          |
    %+--------------------+
    %| iterations         |
    %+--------------------+
    %| n_eval_f           |
    %+--------------------+
    %| n_eval_g           |
    %+--------------------+
    %| n_eval_grad_f      |
    %+--------------------+
    %| n_eval_h           |
    %+--------------------+
    %| n_eval_jac_g       |
    %+--------------------+
    %| return_code        |
    %+--------------------+
    %| return_status      |
    %+--------------------+
    %| t_callback_fun     |
    %+--------------------+
    %| t_callback_prepare |
    %+--------------------+
    %| t_eval_f           |
    %+--------------------+
    %| t_eval_g           |
    %+--------------------+
    %| t_eval_grad_f      |
    %+--------------------+
    %| t_eval_h           |
    %+--------------------+
    %| t_eval_jac_g       |
    %+--------------------+
    %| t_mainloop         |
    %+--------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %scpgen
    %------
    %
    %
    %
    %A structure-exploiting sequential quadratic programming (to be come
    %sequential convex programming) method for nonlinear programming.
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| beta            | OT_REAL         | 0.800           | Line-search     |
    %|                 |                 |                 | parameter,      |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | factor of       |
    %|                 |                 |                 | stepsize        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| c1              | OT_REAL         | 0.000           | Armijo          |
    %|                 |                 |                 | condition,      |
    %|                 |                 |                 | coefficient of  |
    %|                 |                 |                 | decrease in     |
    %|                 |                 |                 | merit           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| codegen         | OT_BOOLEAN      | false           | C-code          |
    %|                 |                 |                 | generation      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| compiler        | OT_STRING       | "gcc -fPIC -O2" | Compiler        |
    %|                 |                 |                 | command to be   |
    %|                 |                 |                 | used for        |
    %|                 |                 |                 | compiling       |
    %|                 |                 |                 | generated code  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_approxi | OT_STRING       | "exact"         | gauss-          |
    %| mation          |                 |                 | newton|exact    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lbfgs_memory    | OT_INTEGER      | 10              | Size of L-BFGS  |
    %|                 |                 |                 | memory.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 50              | Maximum number  |
    %|                 |                 |                 | of SQP          |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter_ls     | OT_INTEGER      | 1               | Maximum number  |
    %|                 |                 |                 | of linesearch   |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| merit_memsize   | OT_INTEGER      | 4               | Size of memory  |
    %|                 |                 |                 | to store        |
    %|                 |                 |                 | history of      |
    %|                 |                 |                 | merit function  |
    %|                 |                 |                 | values          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| merit_start     | OT_REAL         | 0.000           | Lower bound for |
    %|                 |                 |                 | the merit       |
    %|                 |                 |                 | function        |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| name_x          | OT_STRINGVECTOR | GenericType()   | Names of the    |
    %|                 |                 |                 | variables.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_header    | OT_BOOLEAN      | true            | Print the       |
    %|                 |                 |                 | header with     |
    %|                 |                 |                 | problem         |
    %|                 |                 |                 | statistics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_time      | OT_BOOLEAN      | true            | Print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about execution |
    %|                 |                 |                 | time            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_x         | OT_INTEGERVECTO | GenericType()   | Which variables |
    %|                 | R               |                 | to print.       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_solver       | OT_STRING       | GenericType()   | The QP solver   |
    %|                 |                 |                 | to be used by   |
    %|                 |                 |                 | the SQP method  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_solver_optio | OT_DICT         | GenericType()   | Options to be   |
    %| ns              |                 |                 | passed to the   |
    %|                 |                 |                 | QP solver       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reg_threshold   | OT_REAL         | 0.000           | Threshold for   |
    %|                 |                 |                 | the             |
    %|                 |                 |                 | regularization. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| regularize      | OT_BOOLEAN      | false           | Automatic       |
    %|                 |                 |                 | regularization  |
    %|                 |                 |                 | of Lagrange     |
    %|                 |                 |                 | Hessian.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_du          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | dual            |
    %|                 |                 |                 | infeasability   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_pr          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | infeasibility   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_pr_step     | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | the step size   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_reg         | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | regularization  |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| dx          |
    %+-------------+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %| qp          |
    %+-------------+
    %
    %>List of available stats
    %
    %+------------+
    %|     Id     |
    %+============+
    %| iter_count |
    %+------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %sqpmethod
    %---------
    %
    %
    %
    %A textbook SQPMethod
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| beta            | OT_REAL         | 0.800           | Line-search     |
    %|                 |                 |                 | parameter,      |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | factor of       |
    %|                 |                 |                 | stepsize        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| c1              | OT_REAL         | 0.000           | Armijo          |
    %|                 |                 |                 | condition,      |
    %|                 |                 |                 | coefficient of  |
    %|                 |                 |                 | decrease in     |
    %|                 |                 |                 | merit           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_approxi | OT_STRING       | "exact"         | limited-        |
    %| mation          |                 |                 | memory|exact    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lbfgs_memory    | OT_INTEGER      | 10              | Size of L-BFGS  |
    %|                 |                 |                 | memory.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 50              | Maximum number  |
    %|                 |                 |                 | of SQP          |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter_ls     | OT_INTEGER      | 3               | Maximum number  |
    %|                 |                 |                 | of linesearch   |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| merit_memory    | OT_INTEGER      | 4               | Size of memory  |
    %|                 |                 |                 | to store        |
    %|                 |                 |                 | history of      |
    %|                 |                 |                 | merit function  |
    %|                 |                 |                 | values          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| min_step_size   | OT_REAL         | 0.000           | The size (inf-  |
    %|                 |                 |                 | norm) of the    |
    %|                 |                 |                 | step size       |
    %|                 |                 |                 | should not      |
    %|                 |                 |                 | become smaller  |
    %|                 |                 |                 | than this.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_header    | OT_BOOLEAN      | true            | Print the       |
    %|                 |                 |                 | header with     |
    %|                 |                 |                 | problem         |
    %|                 |                 |                 | statistics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_time      | OT_BOOLEAN      | true            | Print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about execution |
    %|                 |                 |                 | time            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_solver       | OT_STRING       | GenericType()   | The QP solver   |
    %|                 |                 |                 | to be used by   |
    %|                 |                 |                 | the SQP method  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_solver_optio | OT_DICT         | GenericType()   | Options to be   |
    %| ns              |                 |                 | passed to the   |
    %|                 |                 |                 | QP solver       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| regularize      | OT_BOOLEAN      | false           | Automatic       |
    %|                 |                 |                 | regularization  |
    %|                 |                 |                 | of Lagrange     |
    %|                 |                 |                 | Hessian.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_du          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | dual            |
    %|                 |                 |                 | infeasability   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_pr          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | infeasibility   |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| bfgs        |
    %+-------------+
    %| dx          |
    %+-------------+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %| qp          |
    %+-------------+
    %
    %>List of available stats
    %
    %+--------------------+
    %|         Id         |
    %+====================+
    %| iter_count         |
    %+--------------------+
    %| iteration          |
    %+--------------------+
    %| iterations         |
    %+--------------------+
    %| n_eval_f           |
    %+--------------------+
    %| n_eval_g           |
    %+--------------------+
    %| n_eval_grad_f      |
    %+--------------------+
    %| n_eval_h           |
    %+--------------------+
    %| n_eval_jac_g       |
    %+--------------------+
    %| return_status      |
    %+--------------------+
    %| t_callback_fun     |
    %+--------------------+
    %| t_callback_prepare |
    %+--------------------+
    %| t_eval_f           |
    %+--------------------+
    %| t_eval_g           |
    %+--------------------+
    %| t_eval_grad_f      |
    %+--------------------+
    %| t_eval_h           |
    %+--------------------+
    %| t_eval_jac_g       |
    %+--------------------+
    %| t_mainloop         |
    %+--------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %stabilizedsqp
    %-------------
    %
    %
    %
    %Stabilized Sequential Quadratic Programming method.
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| TReta1          | OT_REAL         | 0.800           | Required        |
    %|                 |                 |                 | predicted /     |
    %|                 |                 |                 | actual decrease |
    %|                 |                 |                 | for TR increase |
    %+-----------------+-----------------+-----------------+-----------------+
    %| TReta2          | OT_REAL         | 0.200           | Required        |
    %|                 |                 |                 | predicted /     |
    %|                 |                 |                 | actual decrease |
    %|                 |                 |                 | for TR decrease |
    %+-----------------+-----------------+-----------------+-----------------+
    %| alphaMin        | OT_REAL         | 0.001           | Used to check   |
    %|                 |                 |                 | whether to      |
    %|                 |                 |                 | increase rho.   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| beta            | OT_REAL         | 0.500           | Line-search     |
    %|                 |                 |                 | parameter,      |
    %|                 |                 |                 | restoration     |
    %|                 |                 |                 | factor of       |
    %|                 |                 |                 | stepsize        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| c1              | OT_REAL         | 0.001           | Armijo          |
    %|                 |                 |                 | condition,      |
    %|                 |                 |                 | coefficient of  |
    %|                 |                 |                 | decrease in     |
    %|                 |                 |                 | merit           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dvMax0          | OT_REAL         | 100             | Parameter used  |
    %|                 |                 |                 | to defined the  |
    %|                 |                 |                 | max step        |
    %|                 |                 |                 | length.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eps_active      | OT_REAL         | 0.000           | Threshold for   |
    %|                 |                 |                 | the epsilon-    |
    %|                 |                 |                 | active set.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma1          | OT_REAL         | 2               | Trust region    |
    %|                 |                 |                 | increase        |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma2          | OT_REAL         | 1               | Trust region    |
    %|                 |                 |                 | update          |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma3          | OT_REAL         | 1               | Trust region    |
    %|                 |                 |                 | decrease        |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| hessian_approxi | OT_STRING       | "exact"         | limited-        |
    %| mation          |                 |                 | memory|exact    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lbfgs_memory    | OT_INTEGER      | 10              | Size of L-BFGS  |
    %|                 |                 |                 | memory.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 100             | Maximum number  |
    %|                 |                 |                 | of SQP          |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter_ls     | OT_INTEGER      | 20              | Maximum number  |
    %|                 |                 |                 | of linesearch   |
    %|                 |                 |                 | iterations      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_time        | OT_REAL         | 1.000e+12       | Timeout         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| merit_memory    | OT_INTEGER      | 4               | Size of memory  |
    %|                 |                 |                 | to store        |
    %|                 |                 |                 | history of      |
    %|                 |                 |                 | merit function  |
    %|                 |                 |                 | values          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| min_step_size   | OT_REAL         | 0.000           | The size (inf-  |
    %|                 |                 |                 | norm) of the    |
    %|                 |                 |                 | step size       |
    %|                 |                 |                 | should not      |
    %|                 |                 |                 | become smaller  |
    %|                 |                 |                 | than this.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| muR0            | OT_REAL         | 0.000           | Initial choice  |
    %|                 |                 |                 | of              |
    %|                 |                 |                 | regularization  |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nu              | OT_REAL         | 1               | Parameter for   |
    %|                 |                 |                 | primal-dual     |
    %|                 |                 |                 | augmented       |
    %|                 |                 |                 | Lagrangian.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| phiWeight       | OT_REAL         | 0.000           | Weight used in  |
    %|                 |                 |                 | pseudo-filter.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_header    | OT_BOOLEAN      | true            | Print the       |
    %|                 |                 |                 | header with     |
    %|                 |                 |                 | problem         |
    %|                 |                 |                 | statistics      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| regularize      | OT_BOOLEAN      | false           | Automatic       |
    %|                 |                 |                 | regularization  |
    %|                 |                 |                 | of Lagrange     |
    %|                 |                 |                 | Hessian.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| stabilized_qp_s | OT_STRING       | GenericType()   | The Stabilized  |
    %| olver           |                 |                 | QP solver to be |
    %|                 |                 |                 | used by the SQP |
    %|                 |                 |                 | method          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| stabilized_qp_s | OT_DICT         | GenericType()   | Options to be   |
    %| olver_options   |                 |                 | passed to the   |
    %|                 |                 |                 | Stabilized QP   |
    %|                 |                 |                 | solver          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tau0            | OT_REAL         | 0.010           | Initial         |
    %|                 |                 |                 | parameter for   |
    %|                 |                 |                 | the merit       |
    %|                 |                 |                 | function        |
    %|                 |                 |                 | optimality      |
    %|                 |                 |                 | threshold.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_du          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | dual            |
    %|                 |                 |                 | infeasability   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol_pr          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion for   |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | infeasibility   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| yEinitial       | OT_STRING       | "simple"        | Initial         |
    %|                 |                 |                 | multiplier.     |
    %|                 |                 |                 | Simple (all     |
    %|                 |                 |                 | zero) or least  |
    %|                 |                 |                 | (LSQ).          |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-------------+
    %|     Id      |
    %+=============+
    %| dx          |
    %+-------------+
    %| eval_f      |
    %+-------------+
    %| eval_g      |
    %+-------------+
    %| eval_grad_f |
    %+-------------+
    %| eval_h      |
    %+-------------+
    %| eval_jac_g  |
    %+-------------+
    %| qp          |
    %+-------------+
    %
    %>List of available stats
    %
    %+---------------+
    %|      Id       |
    %+===============+
    %| iter_count    |
    %+---------------+
    %| return_status |
    %+---------------+
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
    %C++ includes: nlp_solver.hpp 
    %Usage: NlpSolver ()
    %
  methods
    function varargout = reportConstraints(self,varargin)
    %Prints out a human readable report about possible constraint violations,
    %after solving.
    %
    %
    %Usage: reportConstraints ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(989, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getReportConstraints(self,varargin)
    %Usage: retval = getReportConstraints ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(990, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nlp(self,varargin)
    %Access the NLP.
    %
    %>Input scheme: casadi::NlpSolverInput (NLP_SOLVER_NUM_IN = 8) [nlpSolverIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X0          | x0                     | Decision variables,    |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_P           | p                      | Value of fixed         |
    %|                        |                        | parameters (np x 1) .  |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBX         | lbx                    | Decision variables     |
    %|                        |                        | lower bound (nx x 1),  |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBX         | ubx                    | Decision variables     |
    %|                        |                        | upper bound (nx x 1),  |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBG         | lbg                    | Constraints lower      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBG         | ubg                    | Constraints upper      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X0      | lam_x0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on X,       |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G0      | lam_g0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on G,       |
    %|                        |                        | initial guess (ng x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::NlpSolverOutput (NLP_SOLVER_NUM_OUT = 6) [nlpSolverOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X           | x                      | Decision variables at  |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (nx x 1) .             |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_F           | f                      | Cost function value at |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_G           | g                      | Constraints function   |
    %|                        |                        | at the optimal         |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X       | lam_x                  | Lagrange multipliers   |
    %|                        |                        | for bounds on X at the |
    %|                        |                        | solution (nx x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G       | lam_g                  | Lagrange multipliers   |
    %|                        |                        | for bounds on G at the |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_P       | lam_p                  | Lagrange multipliers   |
    %|                        |                        | for bounds on P at the |
    %|                        |                        | solution (np x 1) .    |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = nlp ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(991, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = gradF(self,varargin)
    %Access the objective gradient function>Input scheme: casadi::GradFInput
    %(GRADF_NUM_IN = 2) [gradFIn]
    %
    %+-----------+-------+---------------------+
    %| Full name | Short |     Description     |
    %+===========+=======+=====================+
    %| GRADF_X   | x     | Decision variable . |
    %+-----------+-------+---------------------+
    %| GRADF_P   | p     | Fixed parameter .   |
    %+-----------+-------+---------------------+
    %
    %
    %Usage: retval = gradF ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(992, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = jacG(self,varargin)
    %Access the Hessian of the Lagrangian function.
    %
    %>Input scheme: casadi::JacGInput (JACG_NUM_IN = 2) [jacGIn]
    %
    %+-----------+-------+---------------------+
    %| Full name | Short |     Description     |
    %+===========+=======+=====================+
    %| JACG_X    | x     | Decision variable . |
    %+-----------+-------+---------------------+
    %| JACG_P    | p     | Fixed parameter .   |
    %+-----------+-------+---------------------+
    %
    %>Output scheme: casadi::JacGOutput (JACG_NUM_OUT = 3) [jacGOut]
    %
    %+-----------+-------+-------------------------------+
    %| Full name | Short |          Description          |
    %+===========+=======+===============================+
    %| JACG_JAC  | jac   | Jacobian of the constraints . |
    %+-----------+-------+-------------------------------+
    %| JACG_F    | f     | Objective function .          |
    %+-----------+-------+-------------------------------+
    %| JACG_G    | g     | Constraint function .         |
    %+-----------+-------+-------------------------------+
    %
    %
    %Usage: retval = jacG ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(993, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hessLag(self,varargin)
    %Access the Jacobian of the constraint function.
    %
    %>Input scheme: casadi::HessLagInput (HESSLAG_NUM_IN = 4) [hessLagIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| HESSLAG_X              | x                      | Decision variable .    |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_P              | p                      | Fixed parameter .      |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_LAM_F          | lam_f                  | Multiplier for f. Just |
    %|                        |                        | a scalar factor for    |
    %|                        |                        | the objective that the |
    %|                        |                        | NLP solver might use   |
    %|                        |                        | to scale the           |
    %|                        |                        | objective.             |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_LAM_G          | lam_g                  | Multiplier for g .     |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::HessLagOutput (HESSLAG_NUM_OUT = 5) [hessLagOut]
    %
    %+----------------+--------+------------------------------------------------+
    %|   Full name    | Short  |                  Description                   |
    %+================+========+================================================+
    %| HESSLAG_HESS   | hess   | Hessian of the Lagrangian .                    |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_F      | f      | Objective function .                           |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_G      | g      | Constraint function .                          |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_GRAD_X | grad_x | Gradient of the Lagrangian with respect to x . |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_GRAD_P | grad_p | Gradient of the Lagrangian with respect to p . |
    %+----------------+--------+------------------------------------------------+
    %
    %
    %Usage: retval = hessLag ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(994, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getReducedHessian(self,varargin)
    %Get the reduced Hessian. Requires a patched sIPOPT installation, see CasADi
    %documentation.
    %
    %
    %Usage: retval = getReducedHessian ()
    %
    %retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(995, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOptionsFromFile(self,varargin)
    %Read options from parameter xml.
    %
    %
    %Usage: setOptionsFromFile (file)
    %
    %file is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(996, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = NlpSolver(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(997, varargin{:});
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
        casadiMEX(998, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(985, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasPlugin(varargin)
    %Usage: retval = hasPlugin (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(986, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(987, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(988, varargin{:});

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
