classdef QpSolver < casadi.Function
    %QpSolver.
    %
    %Solves the following strictly convex problem:
    %
    %
    %
    %::
    %
    %  min          1/2 x' H x + g' x
    %   x
    %  
    %  subject to
    %              LBA <= A x <= UBA
    %              LBX <= x   <= UBX
    %  
    %      with :
    %        H sparse (n x n) positive definite
    %        g dense  (n x 1)
    %  
    %      n: number of decision variables (x)
    %      nc: number of constraints (A)
    %
    %
    %
    %If H is not positive-definite, the solver should throw an error.
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::QpSolverInput (QP_SOLVER_NUM_IN = 9) [qpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| QP_SOLVER_H            | h                      | The square matrix H:   |
    %|                        |                        | sparse, (n x n). Only  |
    %|                        |                        | the lower triangular   |
    %|                        |                        | part is actually used. |
    %|                        |                        | The matrix is assumed  |
    %|                        |                        | to be symmetrical.     |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_G            | g                      | The vector g: dense,   |
    %|                        |                        | (n x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_A            | a                      | The matrix A: sparse,  |
    %|                        |                        | (nc x n) - product     |
    %|                        |                        | with x must be dense.  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LBA          | lba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_UBA          | uba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LBX          | lbx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_UBX          | ubx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_X0           | x0                     | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LAM_X0       | lam_x0                 | dense                  |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::QpSolverOutput (QP_SOLVER_NUM_OUT = 4) [qpOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| QP_SOLVER_X            | x                      | The primal solution .  |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_COST         | cost                   | The optimal cost .     |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LAM_A        | lam_a                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | linear bounds .        |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LAM_X        | lam_x                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | simple bounds .        |
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
    %|              |              |              | according to | asadi::QpSol |
    %|              |              |              | a given      | verInternal  |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)  (lp) |              |
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
    %
    %List of plugins
    %===============
    %
    %
    %
    %- cplex
    %
    %- ooqp
    %
    %- qpoases
    %
    %- sqic
    %
    %- nlp
    %
    %- qcqp
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %QpSolver.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %cplex
    %-----
    %
    %
    %
    %Interface to Cplex solver for sparse Quadratic Programs
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| barrier_maxiter | OT_INTEGER      | 2.100e+09       | Maximum number  |
    %|                 |                 |                 | of barrier      |
    %|                 |                 |                 | iterations.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| convex          | OT_BOOLEAN      | true            | Indicates if    |
    %|                 |                 |                 | the QP is       |
    %|                 |                 |                 | convex or not   |
    %|                 |                 |                 | (affects only   |
    %|                 |                 |                 | the barrier     |
    %|                 |                 |                 | method).        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dep_check       | OT_STRING       | "off"           | Detect          |
    %|                 |                 |                 | redundant       |
    %|                 |                 |                 | constraints. (a |
    %|                 |                 |                 | utomatic:-1|off |
    %|                 |                 |                 | :0|begin:1|end: |
    %|                 |                 |                 | 2|both:3)       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dump_filename   | OT_STRING       | "qp.dat"        | The filename to |
    %|                 |                 |                 | dump to.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dump_to_file    | OT_BOOLEAN      | false           | Dumps QP to     |
    %|                 |                 |                 | file in CPLEX   |
    %|                 |                 |                 | format.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| qp_method       | OT_STRING       | "automatic"     | Determines      |
    %|                 |                 |                 | which CPLEX     |
    %|                 |                 |                 | algorithm to    |
    %|                 |                 |                 | use. (automatic |
    %|                 |                 |                 | |primal_simplex |
    %|                 |                 |                 | |dual_simplex|n |
    %|                 |                 |                 | etwork|barrier| |
    %|                 |                 |                 | sifting|concurr |
    %|                 |                 |                 | ent|crossover)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| simplex_maxiter | OT_INTEGER      | 2.100e+09       | Maximum number  |
    %|                 |                 |                 | of simplex      |
    %|                 |                 |                 | iterations.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| tol             | OT_REAL         | 0.000           | Tolerance of    |
    %|                 |                 |                 | solver          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| warm_start      | OT_BOOLEAN      | false           | Use warm start  |
    %|                 |                 |                 | with simplex    |
    %|                 |                 |                 | methods         |
    %|                 |                 |                 | (affects only   |
    %|                 |                 |                 | the simplex     |
    %|                 |                 |                 | methods).       |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %ooqp
    %----
    %
    %
    %
    %Interface to the OOQP Solver for quadratic programming The current
    %implementation assumes that OOQP is configured with the MA27 sparse linear
    %solver.
    %
    %NOTE: when doing multiple calls to evaluate(), check if you need to
    %reInit();
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| artol           | OT_REAL         | 0.000           | tolerance as    |
    %|                 |                 |                 | provided with   |
    %|                 |                 |                 | setArTol to     |
    %|                 |                 |                 | OOQP            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| mutol           | OT_REAL         | 0.000           | tolerance as    |
    %|                 |                 |                 | provided with   |
    %|                 |                 |                 | setMuTol to     |
    %|                 |                 |                 | OOQP            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_level     | OT_INTEGER      | 0               | Print level.    |
    %|                 |                 |                 | OOQP listens to |
    %|                 |                 |                 | print_level 0,  |
    %|                 |                 |                 | 10 and 100      |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %qpoases
    %-------
    %
    %
    %
    %Interface to QPOases Solver for quadratic programming
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| CPUtime         | OT_REAL         | None            | The maximum     |
    %|                 |                 |                 | allowed CPU     |
    %|                 |                 |                 | time in seconds |
    %|                 |                 |                 | for the whole   |
    %|                 |                 |                 | initialisation  |
    %|                 |                 |                 | (and the        |
    %|                 |                 |                 | actually        |
    %|                 |                 |                 | required one on |
    %|                 |                 |                 | output).        |
    %|                 |                 |                 | Disabled if     |
    %|                 |                 |                 | unset.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| boundRelaxation | OT_REAL         | 10000           | Initial         |
    %|                 |                 |                 | relaxation of   |
    %|                 |                 |                 | bounds to start |
    %|                 |                 |                 | homotopy and    |
    %|                 |                 |                 | initial value   |
    %|                 |                 |                 | for far bounds. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| boundTolerance  | OT_REAL         | 0.000           | If upper and    |
    %|                 |                 |                 | lower bounds    |
    %|                 |                 |                 | differ less     |
    %|                 |                 |                 | than this       |
    %|                 |                 |                 | tolerance, they |
    %|                 |                 |                 | are regarded    |
    %|                 |                 |                 | equal, i.e. as  |
    %|                 |                 |                 | equality        |
    %|                 |                 |                 | constraint.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableCholeskyR | OT_INTEGER      | 0               | Specifies the   |
    %| efactorisation  |                 |                 | frequency of a  |
    %|                 |                 |                 | full re-        |
    %|                 |                 |                 | factorisation   |
    %|                 |                 |                 | of projected    |
    %|                 |                 |                 | Hessian matrix: |
    %|                 |                 |                 | 0: turns them   |
    %|                 |                 |                 | off, 1: uses    |
    %|                 |                 |                 | them at each    |
    %|                 |                 |                 | iteration etc.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableDriftCorr | OT_INTEGER      | 1               | Specifies the   |
    %| ection          |                 |                 | frequency of    |
    %|                 |                 |                 | drift           |
    %|                 |                 |                 | corrections: 0: |
    %|                 |                 |                 | turns them off. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableEqualitie | OT_BOOLEAN      | False           | Specifies       |
    %| s               |                 |                 | whether         |
    %|                 |                 |                 | equalities      |
    %|                 |                 |                 | should be       |
    %|                 |                 |                 | treated as      |
    %|                 |                 |                 | always active   |
    %|                 |                 |                 | (True) or not   |
    %|                 |                 |                 | (False)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableFarBounds | OT_BOOLEAN      | True            | Enables the use |
    %|                 |                 |                 | of far bounds.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableFlippingB | OT_BOOLEAN      | True            | Enables the use |
    %| ounds           |                 |                 | of flipping     |
    %|                 |                 |                 | bounds.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableFullLITes | OT_BOOLEAN      | False           | Enables         |
    %| ts              |                 |                 | condition-      |
    %|                 |                 |                 | hardened (but   |
    %|                 |                 |                 | more expensive) |
    %|                 |                 |                 | LI test.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableNZCTests  | OT_BOOLEAN      | True            | Enables nonzero |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | tests.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableRamping   | OT_BOOLEAN      | True            | Enables         |
    %|                 |                 |                 | ramping.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| enableRegularis | OT_BOOLEAN      | False           | Enables         |
    %| ation           |                 |                 | automatic       |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | regularisation. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsDen          | OT_REAL         | 0.000           | Denominator     |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | ratio tests.    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsFlipping     | OT_REAL         | 0.000           | Tolerance of    |
    %|                 |                 |                 | squared         |
    %|                 |                 |                 | Cholesky        |
    %|                 |                 |                 | diagonal factor |
    %|                 |                 |                 | which triggers  |
    %|                 |                 |                 | flipping bound. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsIterRef      | OT_REAL         | 0.000           | Early           |
    %|                 |                 |                 | termination     |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsLITests      | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | linear          |
    %|                 |                 |                 | independence    |
    %|                 |                 |                 | tests.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsNZCTests     | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | nonzero         |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | tests.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsNum          | OT_REAL         | -0.000          | Numerator       |
    %|                 |                 |                 | tolerance for   |
    %|                 |                 |                 | ratio tests.    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| epsRegularisati | OT_REAL         | 0.000           | Scaling factor  |
    %| on              |                 |                 | of identity     |
    %|                 |                 |                 | matrix used for |
    %|                 |                 |                 | Hessian         |
    %|                 |                 |                 | regularisation. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| finalRamping    | OT_REAL         | 1               | Final value for |
    %|                 |                 |                 | ramping         |
    %|                 |                 |                 | strategy.       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| growFarBounds   | OT_REAL         | 1000            | Factor to grow  |
    %|                 |                 |                 | far bounds.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| initialFarBound | OT_REAL         | 1000000         | Initial size    |
    %| s               |                 |                 | for far bounds. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| initialRamping  | OT_REAL         | 0.500           | Start value for |
    %|                 |                 |                 | ramping         |
    %|                 |                 |                 | strategy.       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| initialStatusBo | OT_STRING       | lower           | Initial status  |
    %| unds            |                 |                 | of bounds at    |
    %|                 |                 |                 | first           |
    %|                 |                 |                 | iteration.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| maxDualJump     | OT_REAL         | 100000000       | Maximum allowed |
    %|                 |                 |                 | jump in dual    |
    %|                 |                 |                 | variables in    |
    %|                 |                 |                 | linear          |
    %|                 |                 |                 | independence    |
    %|                 |                 |                 | tests.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| maxPrimalJump   | OT_REAL         | 100000000       | Maximum allowed |
    %|                 |                 |                 | jump in primal  |
    %|                 |                 |                 | variables in    |
    %|                 |                 |                 | nonzero         |
    %|                 |                 |                 | curvature       |
    %|                 |                 |                 | tests.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nWSR            | OT_INTEGER      | None            | The maximum     |
    %|                 |                 |                 | number of       |
    %|                 |                 |                 | working set     |
    %|                 |                 |                 | recalculations  |
    %|                 |                 |                 | to be performed |
    %|                 |                 |                 | during the      |
    %|                 |                 |                 | initial         |
    %|                 |                 |                 | homotopy.       |
    %|                 |                 |                 | Default is 5(nx |
    %|                 |                 |                 | + nc)           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| numRefinementSt | OT_INTEGER      | 1               | Maximum number  |
    %| eps             |                 |                 | of iterative    |
    %|                 |                 |                 | refinement      |
    %|                 |                 |                 | steps.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| numRegularisati | OT_INTEGER      | 0               | Maximum number  |
    %| onSteps         |                 |                 | of successive   |
    %|                 |                 |                 | regularisation  |
    %|                 |                 |                 | steps.          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| printLevel      | OT_STRING       | medium          | Defines the     |
    %|                 |                 |                 | amount of text  |
    %|                 |                 |                 | output during   |
    %|                 |                 |                 | QP solution,    |
    %|                 |                 |                 | see Section 5.7 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| terminationTole | OT_REAL         | 0.000           | Relative        |
    %| rance           |                 |                 | termination     |
    %|                 |                 |                 | tolerance to    |
    %|                 |                 |                 | stop homotopy.  |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %sqic
    %----
    %
    %
    %
    %Interface to the SQIC solver for quadratic programming
    %
    %>List of available options
    %
    %+----+------+---------+-------------+
    %| Id | Type | Default | Description |
    %+====+======+=========+=============+
    %+----+------+---------+-------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %nlp
    %---
    %
    %
    %
    %Solve QPs using an NlpSolver
    %
    %>List of available options
    %
    %+----+------+---------+-------------+
    %| Id | Type | Default | Description |
    %+====+======+=========+=============+
    %+----+------+---------+-------------+
    %
    %>List of available stats
    %
    %+------------------+
    %|        Id        |
    %+==================+
    %| nlp_solver_stats |
    %+------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %qcqp
    %----
    %
    %
    %
    %Solve QP using a QcqpSolver
    %
    %>List of available options
    %
    %+----+------+---------+-------------+
    %| Id | Type | Default | Description |
    %+====+======+=========+=============+
    %+----+------+---------+-------------+
    %
    %>List of available stats
    %
    %+-------------------+
    %|        Id         |
    %+===================+
    %| qcqp_solver_stats |
    %+-------------------+
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
    %C++ includes: qp_solver.hpp 
    %Usage: QpSolver ()
    %
  methods
    function varargout = generateNativeCode(self,varargin)
    %Generate native code in the interfaced language for debugging
    %
    %
    %Usage: generateNativeCode (file)
    %
    %file is of type std::ostream &. 

      try

      if ~isa(self,'casadi.QpSolver')
        self = casadi.QpSolver(self);
      end
      [varargout{1:nargout}] = casadiMEX(1009, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = QpSolver(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1010, varargin{:});
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
        casadiMEX(1011, self);
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

      [varargout{1:max(1,nargout)}] = casadiMEX(1005, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1006, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(1007, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1008, varargin{:});

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
