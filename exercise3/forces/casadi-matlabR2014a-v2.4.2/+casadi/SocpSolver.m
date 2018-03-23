classdef SocpSolver < casadi.Function
    %SocpSolver.
    %
    %Solves an Second Order Cone Programming (SOCP) problem in standard form.
    %
    %Primal:
    %
    %
    %
    %::
    %
    %  min          c' x
    %  x
    %  subject to
    %  || Gi' x + hi ||_2 <= ei' x + fi  i = 1..m
    %  
    %  LBA <= A x <= UBA
    %  LBX <= x   <= UBX
    %  
    %  with x ( n x 1)
    %  c   dense ( n x 1 )
    %  Gi  sparse (n x ni)
    %  hi  dense (ni x 1)
    %  ei  sparse (n x 1)
    %  fi  dense (1 x 1)
    %  N = Sum_i^m ni
    %  A sparse (nc x n)
    %  LBA, UBA dense vector (nc x 1)
    %  LBX, UBX dense vector (n x 1)
    %
    %
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::SOCPInput (SOCP_SOLVER_NUM_IN = 10) [socpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SOCP_SOLVER_G          | g                      | The horizontal stack   |
    %|                        |                        | of all matrices Gi: (  |
    %|                        |                        | n x N) .               |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_H          | h                      | The vertical stack of  |
    %|                        |                        | all vectors hi: ( N x  |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_E          | e                      | The horizontal stack   |
    %|                        |                        | of all vectors ei: ( n |
    %|                        |                        | x m) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_F          | f                      | The vertical stack of  |
    %|                        |                        | all scalars fi: ( m x  |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_C          | c                      | The vector c: ( n x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_A          | a                      | The matrix A: ( nc x   |
    %|                        |                        | n) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LBA        | lba                    | Lower bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_UBA        | uba                    | Upper bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LBX        | lbx                    | Lower bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_UBX        | ubx                    | Upper bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::SOCPOutput (SOCP_SOLVER_NUM_OUT = 6) [socpOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SOCP_SOLVER_X          | x                      | The primal solution (n |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_COST       | cost                   | The primal optimal     |
    %|                        |                        | cost (1 x 1) .         |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_DUAL_COST  | dual_cost              | The dual optimal cost  |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_A      | lam_a                  | The dual solution      |
    %|                        |                        | corresponding to the   |
    %|                        |                        | linear constraints (nc |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_X      | lam_x                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | simple bounds (n x 1)  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_CONE   | lam_cone               | The dual solution      |
    %|                        |                        | correspoding to cone   |
    %|                        |                        | (2-norm) constraints   |
    %|                        |                        | (m x 1) .              |
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
    %| defaults_rec | OT_STRING    | GenericType( | Changes      | casadi::Socp |
    %| ipe          |              | )            | default      | SolverIntern |
    %|              |              |              | options in a | al           |
    %|              |              |              | given way    |              |
    %|              |              |              | (qcqp)       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| defaults_rec | OT_STRINGVEC | GenericType( | Changes      | casadi::Opti |
    %| ipes         | TOR          | )            | default      | onsFunctiona |
    %|              |              |              | options      | lityNode     |
    %|              |              |              | according to |              |
    %|              |              |              | a given      |              |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)       |              |
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
    %| ni           | OT_INTEGERVE | GenericType( | Provide the  | casadi::Socp |
    %|              | CTOR         | )            | size of each | SolverIntern |
    %|              |              |              | SOC          | al           |
    %|              |              |              | constraint.  |              |
    %|              |              |              | Must sum up  |              |
    %|              |              |              | to N.        |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| output_schem | OT_STRINGVEC | GenericType( | Custom       | casadi::Func |
    %| e            | TOR          | )            | output       | tionInternal |
    %|              |              |              | scheme       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| print_proble | OT_BOOLEAN   | false        | Print out    | casadi::Socp |
    %| m            |              |              | problem      | SolverIntern |
    %|              |              |              | statement    | al           |
    %|              |              |              | for          |              |
    %|              |              |              | debugging.   |              |
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
    %- ecos
    %
    %- mosek
    %
    %- sdp
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %SocpSolver.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %ecos
    %----
    %
    %
    %
    %Interface to the SOCP solver ECOS
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| abstol          | OT_REAL         | ABSTOL          | Absolute        |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | duality gap     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| abstol_inacc    | OT_REAL         | ATOL_INACC      | Absolute        |
    %|                 |                 |                 | relaxed         |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | duality gap     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| delta           | OT_REAL         | DELTA           | Regularization  |
    %|                 |                 |                 | parameter       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eps             | OT_REAL         | EPS             | Regularization  |
    %|                 |                 |                 | threshold       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| feastol         | OT_REAL         | FEASTOL         | Primal/dual     |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| feastol_inacc   | OT_REAL         | FTOL_INACC      | Primal/dual     |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | relaxed         |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gamma           | OT_REAL         | GAMMA           | Scaling the     |
    %|                 |                 |                 | final step      |
    %|                 |                 |                 | length          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| maxit           | OT_INTEGER      | MAXIT           | Maximum number  |
    %|                 |                 |                 | of iterations   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| nitref          | OT_INTEGER      | NITREF          | Number of       |
    %|                 |                 |                 | iterative       |
    %|                 |                 |                 | refinement      |
    %|                 |                 |                 | steps           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltol          | OT_REAL         | RELTOL          | Relative        |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | duality gap     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| reltol_inacc    | OT_REAL         | RTOL_INACC      | Relative        |
    %|                 |                 |                 | relaxed         |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | duality gap     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| verbose         | OT_INTEGER      | VERBOSE         | Verbosity bool  |
    %|                 |                 |                 | for PRINTLEVEL  |
    %|                 |                 |                 | < 3             |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available stats
    %
    %+-----------------------+
    %|          Id           |
    %+=======================+
    %| dcost                 |
    %+-----------------------+
    %| dinf                  |
    %+-----------------------+
    %| dinfres               |
    %+-----------------------+
    %| dres                  |
    %+-----------------------+
    %| exit_code             |
    %+-----------------------+
    %| exit_code_explanation |
    %+-----------------------+
    %| gap                   |
    %+-----------------------+
    %| iter                  |
    %+-----------------------+
    %| kapovert              |
    %+-----------------------+
    %| mu                    |
    %+-----------------------+
    %| nitref1               |
    %+-----------------------+
    %| nitref2               |
    %+-----------------------+
    %| nitref3               |
    %+-----------------------+
    %| pcost                 |
    %+-----------------------+
    %| pinf                  |
    %+-----------------------+
    %| pinfres               |
    %+-----------------------+
    %| pres                  |
    %+-----------------------+
    %| relgap                |
    %+-----------------------+
    %| sigma                 |
    %+-----------------------+
    %| step                  |
    %+-----------------------+
    %| step_aff              |
    %+-----------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %mosek
    %-----
    %
    %
    %
    %Interface to the SOCP solver MOSEK
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| MSK_DPAR_ANA_SO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_INFEAS_TOL    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_BASIS_ | OT_REAL         | 0.000           | Consult MOSEK   |
    %| REL_TOL_S       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_BASIS_ | OT_REAL         | 0.000           | Consult MOSEK   |
    %| TOL_S           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_BASIS_ | OT_REAL         | 0.000           | Consult MOSEK   |
    %| TOL_X           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_CHECK_ | OT_REAL         | 0.000           | Consult MOSEK   |
    %| CONVEXITY_REL_T |                 |                 | manual.         |
    %| OL              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 0.000           | Consult MOSEK   |
    %| OL_AIJ          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 1.000e+20       | Consult MOSEK   |
    %| OL_AIJ_HUGE     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 1.000e+10       | Consult MOSEK   |
    %| OL_AIJ_LARGE    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 1.000e+16       | Consult MOSEK   |
    %| OL_BOUND_INF    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 100000000       | Consult MOSEK   |
    %| OL_BOUND_WRN    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 100000000       | Consult MOSEK   |
    %| OL_CJ_LARGE     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 1.000e+16       | Consult MOSEK   |
    %| OL_C_HUGE       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 0.000           | Consult MOSEK   |
    %| OL_QIJ          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_DATA_T | OT_REAL         | 0.000           | Consult MOSEK   |
    %| OL_X            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_FEASRE | OT_REAL         | 0.000           | Consult MOSEK   |
    %| PAIR_TOL        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _CO_TOL_DFEAS   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _CO_TOL_INFEAS  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _CO_TOL_MU_RED  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 1000            | Consult MOSEK   |
    %| _CO_TOL_NEAR_RE |                 |                 | manual.         |
    %| L               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _CO_TOL_PFEAS   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _CO_TOL_REL_GAP |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _NL_MERIT_BAL   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _NL_TOL_DFEAS   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _NL_TOL_MU_RED  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 1000            | Consult MOSEK   |
    %| _NL_TOL_NEAR_RE |                 |                 | manual.         |
    %| L               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _NL_TOL_PFEAS   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _NL_TOL_REL_GAP |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.995           | Consult MOSEK   |
    %| _NL_TOL_REL_STE |                 |                 | manual.         |
    %| P               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_DFEAS      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 1               | Consult MOSEK   |
    %| _TOL_DSAFE      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_INFEAS     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_MU_RED     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_PATH       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_PFEAS      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 1               | Consult MOSEK   |
    %| _TOL_PSAFE      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_REL_GAP    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 1.000           | Consult MOSEK   |
    %| _TOL_REL_STEP   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_INTPNT | OT_REAL         | 0.000           | Consult MOSEK   |
    %| _TOL_STEP_SIZE  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_LOWER_ | OT_REAL         | -1.000e+30      | Consult MOSEK   |
    %| OBJ_CUT         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_LOWER_ | OT_REAL         | -5.000e+29      | Consult MOSEK   |
    %| OBJ_CUT_FINITE_ |                 |                 | manual.         |
    %| TRH             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_DI | OT_REAL         | -1              | Consult MOSEK   |
    %| SABLE_TERM_TIME |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_HE | OT_REAL         | -1              | Consult MOSEK   |
    %| URISTIC_TIME    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_MA | OT_REAL         | -1              | Consult MOSEK   |
    %| X_TIME          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_MA | OT_REAL         | 60              | Consult MOSEK   |
    %| X_TIME_APRX_OPT |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_NE | OT_REAL         | 0               | Consult MOSEK   |
    %| AR_TOL_ABS_GAP  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_NE | OT_REAL         | 0.001           | Consult MOSEK   |
    %| AR_TOL_REL_GAP  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_RE | OT_REAL         | 0.750           | Consult MOSEK   |
    %| L_ADD_CUT_LIMIT |                 |                 | manual.         |
    %| ED              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_RE | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_GAP_CONST     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0               | Consult MOSEK   |
    %| L_ABS_GAP       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_ABS_RELAX_INT |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_FEAS          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0               | Consult MOSEK   |
    %| L_MAX_CUT_FRAC_ |                 |                 | manual.         |
    %| RHS             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0               | Consult MOSEK   |
    %| L_MIN_CUT_FRAC_ |                 |                 | manual.         |
    %| RHS             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0               | Consult MOSEK   |
    %| L_REL_DUAL_BOUN |                 |                 | manual.         |
    %| D_IMPROVEMENT   |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_REL_GAP       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_REL_RELAX_INT |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_MIO_TO | OT_REAL         | 0.000           | Consult MOSEK   |
    %| L_X             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_NONCON | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VEX_TOL_FEAS    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_NONCON | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VEX_TOL_OPT     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_OPTIMI | OT_REAL         | -1              | Consult MOSEK   |
    %| ZER_MAX_TIME    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_PRESOL | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VE_TOL_ABS_LIND |                 |                 | manual.         |
    %| EP              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_PRESOL | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VE_TOL_AIJ      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_PRESOL | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VE_TOL_REL_LIND |                 |                 | manual.         |
    %| EP              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_PRESOL | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VE_TOL_S        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_PRESOL | OT_REAL         | 0.000           | Consult MOSEK   |
    %| VE_TOL_X        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_QCQO_R | OT_REAL         | 0.000           | Consult MOSEK   |
    %| EFORMULATE_REL_ |                 |                 | manual.         |
    %| DROP_TOL        |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_SIMPLE | OT_REAL         | 0.000           | Consult MOSEK   |
    %| X_ABS_TOL_PIV   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_SIM_LU | OT_REAL         | 0.010           | Consult MOSEK   |
    %| _TOL_REL_PIV    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_UPPER_ | OT_REAL         | 1.000e+30       | Consult MOSEK   |
    %| OBJ_CUT         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_DPAR_UPPER_ | OT_REAL         | 5.000e+29       | Consult MOSEK   |
    %| OBJ_CUT_FINITE_ |                 |                 | manual.         |
    %| TRH             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_ALLOC_ | OT_STRING       | 5000            | Consult MOSEK   |
    %| ADD_QNZ         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_ANA_SO | OT_STRING       | 1               | Consult MOSEK   |
    %| L_BASIS         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_ANA_SO | OT_STRING       | 0               | Consult MOSEK   |
    %| L_PRINT_VIOLATE |                 |                 | manual.         |
    %| D               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_AUTO_S | OT_STRING       | 0               | Consult MOSEK   |
    %| ORT_A_BEFORE_OP |                 |                 | manual.         |
    %| T               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_AUTO_U | OT_STRING       | 0               | Consult MOSEK   |
    %| PDATE_SOL_INFO  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_BASIS_ | OT_STRING       | 0               | Consult MOSEK   |
    %| SOLVE_USE_PLUS_ |                 |                 | manual.         |
    %| ONE             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_BI_CLE | OT_STRING       | 0               | Consult MOSEK   |
    %| AN_OPTIMIZER    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_BI_IGN | OT_STRING       | 0               | Consult MOSEK   |
    %| ORE_MAX_ITER    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_BI_IGN | OT_STRING       | 0               | Consult MOSEK   |
    %| ORE_NUM_ERROR   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_BI_MAX | OT_STRING       | 1000000         | Consult MOSEK   |
    %| _ITERATIONS     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CACHE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| LICENSE         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CHECK_ | OT_STRING       | 2               | Consult MOSEK   |
    %| CONVEXITY       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_COMPRE | OT_STRING       | 1               | Consult MOSEK   |
    %| SS_STATFILE     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CONCUR | OT_STRING       | 2               | Consult MOSEK   |
    %| RENT_NUM_OPTIMI |                 |                 | manual.         |
    %| ZERS            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CONCUR | OT_STRING       | 2               | Consult MOSEK   |
    %| RENT_PRIORITY_D |                 |                 | manual.         |
    %| UAL_SIMPLEX     |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CONCUR | OT_STRING       | 3               | Consult MOSEK   |
    %| RENT_PRIORITY_F |                 |                 | manual.         |
    %| REE_SIMPLEX     |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CONCUR | OT_STRING       | 4               | Consult MOSEK   |
    %| RENT_PRIORITY_I |                 |                 | manual.         |
    %| NTPNT           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_CONCUR | OT_STRING       | 1               | Consult MOSEK   |
    %| RENT_PRIORITY_P |                 |                 | manual.         |
    %| RIMAL_SIMPLEX   |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_FEASRE | OT_STRING       | 0               | Consult MOSEK   |
    %| PAIR_OPTIMIZE   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INFEAS | OT_STRING       | 0               | Consult MOSEK   |
    %| _GENERIC_NAMES  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INFEAS | OT_STRING       | 1               | Consult MOSEK   |
    %| _PREFER_PRIMAL  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INFEAS | OT_STRING       | 0               | Consult MOSEK   |
    %| _REPORT_AUTO    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INFEAS | OT_STRING       | 1               | Consult MOSEK   |
    %| _REPORT_LEVEL   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 1               | Consult MOSEK   |
    %| _BASIS          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 1               | Consult MOSEK   |
    %| _DIFF_STEP      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _FACTOR_DEBUG_L |                 |                 | manual.         |
    %| VL              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _FACTOR_METHOD  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _HOTSTART       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 400             | Consult MOSEK   |
    %| _MAX_ITERATIONS |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | -1              | Consult MOSEK   |
    %| _MAX_NUM_COR    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | -1              | Consult MOSEK   |
    %| _MAX_NUM_REFINE |                 |                 | manual.         |
    %| MENT_STEPS      |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 40              | Consult MOSEK   |
    %| _OFF_COL_TRH    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _ORDER_METHOD   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 1               | Consult MOSEK   |
    %| _REGULARIZATION |                 |                 | manual.         |
    %| _USE            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _SCALING        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _SOLVE_FORM     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_INTPNT | OT_STRING       | 0               | Consult MOSEK   |
    %| _STARTING_POINT |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LICENS | OT_STRING       | 0               | Consult MOSEK   |
    %| E_DEBUG         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LICENS | OT_STRING       | 100             | Consult MOSEK   |
    %| E_PAUSE_TIME    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LICENS | OT_STRING       | 0               | Consult MOSEK   |
    %| E_SUPPRESS_EXPI |                 |                 | manual.         |
    %| RE_WRNS         |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LICENS | OT_STRING       | 0               | Consult MOSEK   |
    %| E_WAIT          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LIC_TR | OT_STRING       | 7               | Consult MOSEK   |
    %| H_EXPIRY_WRN    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG    | OT_STRING       | 10              | Consult MOSEK   |
    %|                 |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_BI | OT_STRING       | 4               | Consult MOSEK   |
    %|                 |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_BI | OT_STRING       | 2500            | Consult MOSEK   |
    %| _FREQ           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_CH | OT_STRING       | 0               | Consult MOSEK   |
    %| ECK_CONVEXITY   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_CO | OT_STRING       | 1               | Consult MOSEK   |
    %| NCURRENT        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_CU | OT_STRING       | 1               | Consult MOSEK   |
    %| T_SECOND_OPT    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_EX | OT_STRING       | 0               | Consult MOSEK   |
    %| PAND            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_FA | OT_STRING       | 1               | Consult MOSEK   |
    %| CTOR            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_FE | OT_STRING       | 1               | Consult MOSEK   |
    %| AS_REPAIR       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_FI | OT_STRING       | 1               | Consult MOSEK   |
    %| LE              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_HE | OT_STRING       | 1               | Consult MOSEK   |
    %| AD              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_IN | OT_STRING       | 1               | Consult MOSEK   |
    %| FEAS_ANA        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_IN | OT_STRING       | 4               | Consult MOSEK   |
    %| TPNT            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_MI | OT_STRING       | 4               | Consult MOSEK   |
    %| O               |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_MI | OT_STRING       | 1000            | Consult MOSEK   |
    %| O_FREQ          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_NO | OT_STRING       | 1               | Consult MOSEK   |
    %| NCONVEX         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_OP | OT_STRING       | 1               | Consult MOSEK   |
    %| TIMIZER         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_OR | OT_STRING       | 1               | Consult MOSEK   |
    %| DER             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_PA | OT_STRING       | 0               | Consult MOSEK   |
    %| RAM             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_PR | OT_STRING       | 1               | Consult MOSEK   |
    %| ESOLVE          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_RE | OT_STRING       | 0               | Consult MOSEK   |
    %| SPONSE          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SE | OT_STRING       | 1               | Consult MOSEK   |
    %| NSITIVITY       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SE | OT_STRING       | 0               | Consult MOSEK   |
    %| NSITIVITY_OPT   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SI | OT_STRING       | 4               | Consult MOSEK   |
    %| M               |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SI | OT_STRING       | 1000            | Consult MOSEK   |
    %| M_FREQ          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SI | OT_STRING       | 1               | Consult MOSEK   |
    %| M_MINOR         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_SI | OT_STRING       | 1000            | Consult MOSEK   |
    %| M_NETWORK_FREQ  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_LOG_ST | OT_STRING       | 0               | Consult MOSEK   |
    %| ORAGE           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MAX_NU | OT_STRING       | 6               | Consult MOSEK   |
    %| M_WARNINGS      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_BR | OT_STRING       | 0               | Consult MOSEK   |
    %| ANCH_DIR        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_BR | OT_STRING       | 1               | Consult MOSEK   |
    %| ANCH_PRIORITIES |                 |                 | manual.         |
    %| _USE            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CO | OT_STRING       | 0               | Consult MOSEK   |
    %| NSTRUCT_SOL     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CO | OT_STRING       | 0               | Consult MOSEK   |
    %| NT_SOL          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CU | OT_STRING       | 1               | Consult MOSEK   |
    %| T_CG            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CU | OT_STRING       | 1               | Consult MOSEK   |
    %| T_CMIR          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CU | OT_STRING       | -1              | Consult MOSEK   |
    %| T_LEVEL_ROOT    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_CU | OT_STRING       | -1              | Consult MOSEK   |
    %| T_LEVEL_TREE    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_FE | OT_STRING       | -1              | Consult MOSEK   |
    %| ASPUMP_LEVEL    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_HE | OT_STRING       | -1              | Consult MOSEK   |
    %| URISTIC_LEVEL   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_HO | OT_STRING       | 1               | Consult MOSEK   |
    %| TSTART          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_KE | OT_STRING       | 1               | Consult MOSEK   |
    %| EP_BASIS        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_LO | OT_STRING       | -1              | Consult MOSEK   |
    %| CAL_BRANCH_NUMB |                 |                 | manual.         |
    %| ER              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_MA | OT_STRING       | -1              | Consult MOSEK   |
    %| X_NUM_BRANCHES  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_MA | OT_STRING       | -1              | Consult MOSEK   |
    %| X_NUM_RELAXS    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_MA | OT_STRING       | -1              | Consult MOSEK   |
    %| X_NUM_SOLUTIONS |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_MO | OT_STRING       | 1               | Consult MOSEK   |
    %| DE              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_MT | OT_STRING       | 1               | Consult MOSEK   |
    %| _USER_CB        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_NO | OT_STRING       | 0               | Consult MOSEK   |
    %| DE_OPTIMIZER    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_NO | OT_STRING       | 0               | Consult MOSEK   |
    %| DE_SELECTION    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_OP | OT_STRING       | 0               | Consult MOSEK   |
    %| TIMIZER_MODE    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_PR | OT_STRING       | 1               | Consult MOSEK   |
    %| ESOLVE_AGGREGAT |                 |                 | manual.         |
    %| E               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_PR | OT_STRING       | 1               | Consult MOSEK   |
    %| ESOLVE_PROBING  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_PR | OT_STRING       | 1               | Consult MOSEK   |
    %| ESOLVE_USE      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_PR | OT_STRING       | -1              | Consult MOSEK   |
    %| OBING_LEVEL     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_RI | OT_STRING       | -1              | Consult MOSEK   |
    %| NS_MAX_NODES    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_RO | OT_STRING       | 0               | Consult MOSEK   |
    %| OT_OPTIMIZER    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_ST | OT_STRING       | -1              | Consult MOSEK   |
    %| RONG_BRANCH     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MIO_US | OT_STRING       | 0               | Consult MOSEK   |
    %| E_MULTITHREADED |                 |                 | manual.         |
    %| _OPTIMIZER      |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_MT_SPI | OT_STRING       | 0               | Consult MOSEK   |
    %| NCOUNT          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_NONCON | OT_STRING       | 100000          | Consult MOSEK   |
    %| VEX_MAX_ITERATI |                 |                 | manual.         |
    %| ONS             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_NUM_TH | OT_STRING       | 0               | Consult MOSEK   |
    %| READS           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_MA | OT_STRING       | 5               | Consult MOSEK   |
    %| X_TERMS_PER_LIN |                 |                 | manual.         |
    %| E               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_HEADER      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_HINTS       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 0               | Consult MOSEK   |
    %| ITE_PARAMETERS  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_PROBLEM     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 0               | Consult MOSEK   |
    %| ITE_SOLUTIONS   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_SOL_BAS     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_SOL_ITG     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPF_WR | OT_STRING       | 1               | Consult MOSEK   |
    %| ITE_SOL_ITR     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_OPTIMI | OT_STRING       | 0               | Consult MOSEK   |
    %| ZER             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PARAM_ | OT_STRING       | 1               | Consult MOSEK   |
    %| READ_CASE_NAME  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PARAM_ | OT_STRING       | 0               | Consult MOSEK   |
    %| READ_IGN_ERROR  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | -1              | Consult MOSEK   |
    %| VE_ELIMINATOR_M |                 |                 | manual.         |
    %| AX_NUM_TRIES    |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 1               | Consult MOSEK   |
    %| VE_ELIMINATOR_U |                 |                 | manual.         |
    %| SE              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 1               | Consult MOSEK   |
    %| VE_ELIM_FILL    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | -1              | Consult MOSEK   |
    %| VE_LEVEL        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 100             | Consult MOSEK   |
    %| VE_LINDEP_ABS_W |                 |                 | manual.         |
    %| ORK_TRH         |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 100             | Consult MOSEK   |
    %| VE_LINDEP_REL_W |                 |                 | manual.         |
    %| ORK_TRH         |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 1               | Consult MOSEK   |
    %| VE_LINDEP_USE   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | -1              | Consult MOSEK   |
    %| VE_MAX_NUM_REDU |                 |                 | manual.         |
    %| CTIONS          |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRESOL | OT_STRING       | 2               | Consult MOSEK   |
    %| VE_USE          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_PRIMAL | OT_STRING       | 0               | Consult MOSEK   |
    %| _REPAIR_OPTIMIZ |                 |                 | manual.         |
    %| ER              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_QO_SEP | OT_STRING       | 0               | Consult MOSEK   |
    %| ARABLE_REFORMUL |                 |                 | manual.         |
    %| ATION           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_A | OT_STRING       | 100000          | Consult MOSEK   |
    %| NZ              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_C | OT_STRING       | 10000           | Consult MOSEK   |
    %| ON              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_C | OT_STRING       | 2500            | Consult MOSEK   |
    %| ONE             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_D | OT_STRING       | 1               | Consult MOSEK   |
    %| ATA_COMPRESSED  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_D | OT_STRING       | 0               | Consult MOSEK   |
    %| ATA_FORMAT      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_D | OT_STRING       | 0               | Consult MOSEK   |
    %| EBUG            |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_K | OT_STRING       | 0               | Consult MOSEK   |
    %| EEP_FREE_CON    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_L | OT_STRING       | 0               | Consult MOSEK   |
    %| P_DROP_NEW_VARS |                 |                 | manual.         |
    %| _IN_BOU         |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_L | OT_STRING       | 1               | Consult MOSEK   |
    %| P_QUOTED_NAMES  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_M | OT_STRING       | 1               | Consult MOSEK   |
    %| PS_FORMAT       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_M | OT_STRING       | 1               | Consult MOSEK   |
    %| PS_KEEP_INT     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_M | OT_STRING       | 1               | Consult MOSEK   |
    %| PS_OBJ_SENSE    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_M | OT_STRING       | 1               | Consult MOSEK   |
    %| PS_RELAX        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_M | OT_STRING       | 1024            | Consult MOSEK   |
    %| PS_WIDTH        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_Q | OT_STRING       | 20000           | Consult MOSEK   |
    %| NZ              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_T | OT_STRING       | 0               | Consult MOSEK   |
    %| ASK_IGNORE_PARA |                 |                 | manual.         |
    %| M               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_READ_V | OT_STRING       | 10000           | Consult MOSEK   |
    %| AR              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SENSIT | OT_STRING       | 0               | Consult MOSEK   |
    %| IVITY_ALL       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SENSIT | OT_STRING       | 6               | Consult MOSEK   |
    %| IVITY_OPTIMIZER |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SENSIT | OT_STRING       | 0               | Consult MOSEK   |
    %| IVITY_TYPE      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_BA | OT_STRING       | 1               | Consult MOSEK   |
    %| SIS_FACTOR_USE  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_DE | OT_STRING       | 1               | Consult MOSEK   |
    %| GEN             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_DU | OT_STRING       | 90              | Consult MOSEK   |
    %| AL_CRASH        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_DU | OT_STRING       | 0               | Consult MOSEK   |
    %| AL_PHASEONE_MET |                 |                 | manual.         |
    %| HOD             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_DU | OT_STRING       | 50              | Consult MOSEK   |
    %| AL_RESTRICT_SEL |                 |                 | manual.         |
    %| ECTION          |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_DU | OT_STRING       | 0               | Consult MOSEK   |
    %| AL_SELECTION    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_EX | OT_STRING       | 0               | Consult MOSEK   |
    %| PLOIT_DUPVEC    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_HO | OT_STRING       | 1               | Consult MOSEK   |
    %| TSTART          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_HO | OT_STRING       | 1               | Consult MOSEK   |
    %| TSTART_LU       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_IN | OT_STRING       | 0               | Consult MOSEK   |
    %| TEGER           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_MA | OT_STRING       | 10000000        | Consult MOSEK   |
    %| X_ITERATIONS    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_MA | OT_STRING       | 250             | Consult MOSEK   |
    %| X_NUM_SETBACKS  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_NO | OT_STRING       | 1               | Consult MOSEK   |
    %| N_SINGULAR      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_PR | OT_STRING       | 90              | Consult MOSEK   |
    %| IMAL_CRASH      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_PR | OT_STRING       | 0               | Consult MOSEK   |
    %| IMAL_PHASEONE_M |                 |                 | manual.         |
    %| ETHOD           |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_PR | OT_STRING       | 50              | Consult MOSEK   |
    %| IMAL_RESTRICT_S |                 |                 | manual.         |
    %| ELECTION        |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_PR | OT_STRING       | 0               | Consult MOSEK   |
    %| IMAL_SELECTION  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_RE | OT_STRING       | 0               | Consult MOSEK   |
    %| FACTOR_FREQ     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_RE | OT_STRING       | 0               | Consult MOSEK   |
    %| FORMULATION     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_SA | OT_STRING       | 0               | Consult MOSEK   |
    %| VE_LU           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_SC | OT_STRING       | 0               | Consult MOSEK   |
    %| ALING           |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_SC | OT_STRING       | 0               | Consult MOSEK   |
    %| ALING_METHOD    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_SO | OT_STRING       | 0               | Consult MOSEK   |
    %| LVE_FORM        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_ST | OT_STRING       | 50              | Consult MOSEK   |
    %| ABILITY_PRIORIT |                 |                 | manual.         |
    %| Y               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SIM_SW | OT_STRING       | 0               | Consult MOSEK   |
    %| ITCH_OPTIMIZER  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SOLUTI | OT_STRING       | 0               | Consult MOSEK   |
    %| ON_CALLBACK     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SOL_FI | OT_STRING       | 0               | Consult MOSEK   |
    %| LTER_KEEP_BASIC |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SOL_FI | OT_STRING       | 0               | Consult MOSEK   |
    %| LTER_KEEP_RANGE |                 |                 | manual.         |
    %| D               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SOL_RE | OT_STRING       | -1              | Consult MOSEK   |
    %| AD_NAME_WIDTH   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_SOL_RE | OT_STRING       | 1024            | Consult MOSEK   |
    %| AD_WIDTH        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_TIMING | OT_STRING       | 1               | Consult MOSEK   |
    %| _LEVEL          |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WARNIN | OT_STRING       | 1               | Consult MOSEK   |
    %| G_LEVEL         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| BAS_CONSTRAINTS |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| BAS_HEAD        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| BAS_VARIABLES   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| DATA_COMPRESSED |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| DATA_FORMAT     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| DATA_PARAM      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| FREE_CON        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| GENERIC_NAMES   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| GENERIC_NAMES_I |                 |                 | manual.         |
    %| O               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| IGNORE_INCOMPAT |                 |                 | manual.         |
    %| IBLE_CONIC_ITEM |                 |                 |                 |
    %| S               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| IGNORE_INCOMPAT |                 |                 | manual.         |
    %| IBLE_ITEMS      |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| IGNORE_INCOMPAT |                 |                 | manual.         |
    %| IBLE_NL_ITEMS   |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| IGNORE_INCOMPAT |                 |                 | manual.         |
    %| IBLE_PSD_ITEMS  |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| INT_CONSTRAINTS |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| INT_HEAD        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| INT_VARIABLES   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 80              | Consult MOSEK   |
    %| LP_LINE_WIDTH   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| LP_QUOTED_NAMES |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| LP_STRICT_FORMA |                 |                 | manual.         |
    %| T               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 10              | Consult MOSEK   |
    %| LP_TERMS_PER_LI |                 |                 | manual.         |
    %| NE              |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| MPS_INT         |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 8               | Consult MOSEK   |
    %| PRECISION       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| SOL_BARVARIABLE |                 |                 | manual.         |
    %| S               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| SOL_CONSTRAINTS |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| SOL_HEAD        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| SOL_IGNORE_INVA |                 |                 | manual.         |
    %| LID_NAMES       |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| SOL_VARIABLES   |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 1               | Consult MOSEK   |
    %| TASK_INC_SOL    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_IPAR_WRITE_ | OT_STRING       | 0               | Consult MOSEK   |
    %| XML_MODE        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_BAS_SO | OT_STRING       |                 | Consult MOSEK   |
    %| L_FILE_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_DATA_F | OT_STRING       |                 | Consult MOSEK   |
    %| ILE_NAME        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_DEBUG_ | OT_STRING       |                 | Consult MOSEK   |
    %| FILE_NAME       |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_FEASRE | OT_STRING       | MSK-            | Consult MOSEK   |
    %| PAIR_NAME_PREFI |                 |                 | manual.         |
    %| X               |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_FEASRE | OT_STRING       | -               | Consult MOSEK   |
    %| PAIR_NAME_SEPAR |                 |                 | manual.         |
    %| ATOR            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_FEASRE | OT_STRING       | WSUMVIOL        | Consult MOSEK   |
    %| PAIR_NAME_WSUMV |                 |                 | manual.         |
    %| IOL             |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_INT_SO | OT_STRING       |                 | Consult MOSEK   |
    %| L_FILE_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_ITR_SO | OT_STRING       |                 | Consult MOSEK   |
    %| L_FILE_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_MIO_DE | OT_STRING       |                 | Consult MOSEK   |
    %| BUG_STRING      |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_PARAM_ | OT_STRING       | %%              | Consult MOSEK   |
    %| COMMENT_SIGN    |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_PARAM_ | OT_STRING       |                 | Consult MOSEK   |
    %| READ_FILE_NAME  |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_PARAM_ | OT_STRING       |                 | Consult MOSEK   |
    %| WRITE_FILE_NAME |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_READ_M | OT_STRING       |                 | Consult MOSEK   |
    %| PS_BOU_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_READ_M | OT_STRING       |                 | Consult MOSEK   |
    %| PS_OBJ_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_READ_M | OT_STRING       |                 | Consult MOSEK   |
    %| PS_RAN_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_READ_M | OT_STRING       |                 | Consult MOSEK   |
    %| PS_RHS_NAME     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SENSIT | OT_STRING       |                 | Consult MOSEK   |
    %| IVITY_FILE_NAME |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SENSIT | OT_STRING       |                 | Consult MOSEK   |
    %| IVITY_RES_FILE_ |                 |                 | manual.         |
    %| NAME            |                 |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SOL_FI | OT_STRING       |                 | Consult MOSEK   |
    %| LTER_XC_LOW     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SOL_FI | OT_STRING       |                 | Consult MOSEK   |
    %| LTER_XC_UPR     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SOL_FI | OT_STRING       |                 | Consult MOSEK   |
    %| LTER_XX_LOW     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_SOL_FI | OT_STRING       |                 | Consult MOSEK   |
    %| LTER_XX_UPR     |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_STAT_F | OT_STRING       |                 | Consult MOSEK   |
    %| ILE_NAME        |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_STAT_K | OT_STRING       |                 | Consult MOSEK   |
    %| EY              |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_STAT_N | OT_STRING       |                 | Consult MOSEK   |
    %| AME             |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| MSK_SPAR_WRITE_ | OT_STRING       | XMSKGEN         | Consult MOSEK   |
    %| LP_GEN_VAR_NAME |                 |                 | manual.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| eps_unstable    | OT_REAL         | 0.000           | A margin for    |
    %|                 |                 |                 | unstability     |
    %|                 |                 |                 | detection       |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available stats
    %
    %+--------------------+
    %|         Id         |
    %+====================+
    %| problem_status     |
    %+--------------------+
    %| solution_status    |
    %+--------------------+
    %| termination_reason |
    %+--------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %sdp
    %---
    %
    %
    %
    %Solve SOCPs using an SdpSolver
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
    %| sdp_solver_stats |
    %+------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joris Gillis
    %Diagrams
    %--------
    %
    %
    %
    %C++ includes: socp_solver.hpp 
    %Usage: SocpSolver ()
    %
  methods
    function self = SocpSolver(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1035, varargin{:});
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
        casadiMEX(1036, self);
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

      [varargout{1:max(1,nargout)}] = casadiMEX(1031, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(1032, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1033, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1034, varargin{:});

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
