classdef SdpSolver < casadi.Function
    %SdpSolver.
    %
    %Solves an SDP problem in standard form.
    %Seehttp://sdpa.indsys.chuo-u.ac.jp/sdpa/files/sdpa-c.6.2.0.manual.pdf
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
    %  P = Sum_i^m F_i x_i - G
    %  P negative semidefinite
    %  
    %  LBA <= A x <= UBA
    %  LBX <= x   <= UBX
    %  
    %  with x ( n x 1)
    %  c ( n x 1 )
    %  G, F_i  sparse symmetric (m x m)
    %  X dense symmetric ( m x m )
    %  A sparse matrix ( nc x n)
    %  LBA, UBA dense vector (nc x 1)
    %  LBX, UBX dense vector (n x 1)
    %
    %
    %
    %This formulation is chosen as primal, because it does not call for a large
    %decision variable space.
    %
    %Dual:
    %
    %
    %
    %::
    %
    %  max          trace(G Y)
    %  Y
    %  
    %  subject to
    %  trace(F_i Y) = c_i
    %  Y positive semidefinite
    %  
    %  with Y dense symmetric ( m x m)
    %
    %
    %
    %On generality: you might have formulation with block partitioning:
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
    %  Pj = Sum_i^m F_ij x_i - gj   for all j
    %  Pj negative semidefinite   for all j
    %  
    %  with x ( n x 1)
    %  c ( n x 1 )
    %  G, F_i  sparse symmetric (m x m)
    %  X dense symmetric ( m x m )
    %
    %
    %
    %Dual:
    %
    %::
    %
    %  max          Sum_j trace(Gj Yj)
    %  Yj
    %  
    %  subject to
    %  Sum_j trace(F_ij Yj) = c_i   for all j
    %  Yj positive semidefinite     for all j
    %  
    %  with Y dense symmetric ( m x m)
    %
    %
    %
    %You can cast this into the standard form with: G = diagcat(Gj for all j) Fi
    %= diagcat(F_ij for all j)
    %
    %Implementations of SdpSolver are encouraged to exploit this block structure.
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::SDPInput (SDP_SOLVER_NUM_IN = 8) [sdpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SDP_SOLVER_F           | f                      | The horizontal stack   |
    %|                        |                        | of all matrices F_i: ( |
    %|                        |                        | m x nm) .              |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_C           | c                      | The vector c: ( n x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_G           | g                      | The matrix G: ( m x m) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_A           | a                      | The matrix A: ( nc x   |
    %|                        |                        | n) .                   |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LBA         | lba                    | Lower bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_UBA         | uba                    | Upper bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LBX         | lbx                    | Lower bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_UBX         | ubx                    | Upper bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %
    %>Output scheme: casadi::SDPOutput (SDP_SOLVER_NUM_OUT = 7) [sdpOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SDP_SOLVER_X           | x                      | The primal solution (n |
    %|                        |                        | x 1) - may be used as  |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_P           | p                      | The solution P (m x m) |
    %|                        |                        | - may be used as       |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_DUAL        | dual                   | The dual solution (m x |
    %|                        |                        | m) - may be used as    |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_COST        | cost                   | The primal optimal     |
    %|                        |                        | cost (1 x 1) .         |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_DUAL_COST   | dual_cost              | The dual optimal cost  |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LAM_A       | lam_a                  | The dual solution      |
    %|                        |                        | corresponding to the   |
    %|                        |                        | linear constraints (nc |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LAM_X       | lam_x                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | simple bounds (n x 1)  |
    %|                        |                        | .                      |
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
    %| calc_dual    | OT_BOOLEAN   | true         | Indicate if  | casadi::SdpS |
    %|              |              |              | dual should  | olverInterna |
    %|              |              |              | be allocated | l            |
    %|              |              |              | and          |              |
    %|              |              |              | calculated.  |              |
    %|              |              |              | You may want |              |
    %|              |              |              | to avoid     |              |
    %|              |              |              | calculating  |              |
    %|              |              |              | this         |              |
    %|              |              |              | variable for |              |
    %|              |              |              | problems     |              |
    %|              |              |              | with n       |              |
    %|              |              |              | large, as is |              |
    %|              |              |              | always dense |              |
    %|              |              |              | (m x m).     |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| calc_p       | OT_BOOLEAN   | true         | Indicate if  | casadi::SdpS |
    %|              |              |              | the P-part   | olverInterna |
    %|              |              |              | of primal    | l            |
    %|              |              |              | solution     |              |
    %|              |              |              | should be    |              |
    %|              |              |              | allocated    |              |
    %|              |              |              | and          |              |
    %|              |              |              | calculated.  |              |
    %|              |              |              | You may want |              |
    %|              |              |              | to avoid     |              |
    %|              |              |              | calculating  |              |
    %|              |              |              | this         |              |
    %|              |              |              | variable for |              |
    %|              |              |              | problems     |              |
    %|              |              |              | with n       |              |
    %|              |              |              | large, as is |              |
    %|              |              |              | always dense |              |
    %|              |              |              | (m x m).     |              |
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
    %|              |              |              | according to | asadi::SdpSo |
    %|              |              |              | a given      | lverInternal |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)       |              |
    %|              |              |              | (socp)       |              |
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
    %| print_proble | OT_BOOLEAN   | false        | Print out    | casadi::SdpS |
    %| m            |              |              | problem      | olverInterna |
    %|              |              |              | statement    | l            |
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
    %- dsdp
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %SdpSolver.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %dsdp
    %----
    %
    %
    %
    %Interface to the SDP solver DSDP Warning: The solver DSDP is not good at
    %handling linear equalities. There are several options if you notice
    %difficulties: play around with the parameter "_penalty" leave a gap
    %manually switch to another SDP Solver
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| _loglevel       | OT_INTEGER      | 0               | An integer that |
    %|                 |                 |                 | specifies how   |
    %|                 |                 |                 | much logging is |
    %|                 |                 |                 | done on stdout. |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _penalty        | OT_REAL         | 100000          | Penality        |
    %|                 |                 |                 | parameter       |
    %|                 |                 |                 | lambda. Must    |
    %|                 |                 |                 | exceed the      |
    %|                 |                 |                 | trace of Y.     |
    %|                 |                 |                 | This parameter  |
    %|                 |                 |                 | heavily         |
    %|                 |                 |                 | influences the  |
    %|                 |                 |                 | ability of DSDP |
    %|                 |                 |                 | to treat linear |
    %|                 |                 |                 | equalities. The |
    %|                 |                 |                 | DSDP standard   |
    %|                 |                 |                 | default (1e8)   |
    %|                 |                 |                 | will make a     |
    %|                 |                 |                 | problem with    |
    %|                 |                 |                 | linear equality |
    %|                 |                 |                 | return unusable |
    %|                 |                 |                 | solutions.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _printlevel     | OT_INTEGER      | 1               | A printlevel of |
    %|                 |                 |                 | zero will       |
    %|                 |                 |                 | disable all     |
    %|                 |                 |                 | output. Another |
    %|                 |                 |                 | number          |
    %|                 |                 |                 | indicates how   |
    %|                 |                 |                 | often a line is |
    %|                 |                 |                 | printed.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _reuse          | OT_INTEGER      | 4               | Maximum on the  |
    %|                 |                 |                 | number of times |
    %|                 |                 |                 | the Schur       |
    %|                 |                 |                 | complement      |
    %|                 |                 |                 | matrix is       |
    %|                 |                 |                 | reused          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _rho            | OT_REAL         | 4               | Potential       |
    %|                 |                 |                 | parameter. Must |
    %|                 |                 |                 | be >=1          |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _use_penalty    | OT_BOOLEAN      | true            | Modifies the    |
    %|                 |                 |                 | algorithm to    |
    %|                 |                 |                 | use a penality  |
    %|                 |                 |                 | gamma on r.     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| _zbar           | OT_REAL         | 1.000e+10       | Initial upper   |
    %|                 |                 |                 | bound on the    |
    %|                 |                 |                 | objective of    |
    %|                 |                 |                 | the dual        |
    %|                 |                 |                 | problem.        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dualTol         | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | dual            |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | (translates to  |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | in dsdp terms)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| gapTol          | OT_REAL         | 0.000           | Convergence     |
    %|                 |                 |                 | criterion based |
    %|                 |                 |                 | on distance     |
    %|                 |                 |                 | between primal  |
    %|                 |                 |                 | and dual        |
    %|                 |                 |                 | objective       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| inf             | OT_REAL         | 1.000e+30       | Treat numbers   |
    %|                 |                 |                 | higher than     |
    %|                 |                 |                 | this as         |
    %|                 |                 |                 | infinity        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| maxIter         | OT_INTEGER      | 500             | Maximum number  |
    %|                 |                 |                 | of iterations   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| primalTol       | OT_REAL         | 0.000           | Tolerance for   |
    %|                 |                 |                 | primal          |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | (translates to  |
    %|                 |                 |                 | dual            |
    %|                 |                 |                 | infeasibility   |
    %|                 |                 |                 | in dsdp terms)  |
    %+-----------------+-----------------+-----------------+-----------------+
    %| stepTol         | OT_REAL         | 0.050           | Terminate the   |
    %|                 |                 |                 | solver if the   |
    %|                 |                 |                 | step length in  |
    %|                 |                 |                 | the primal is   |
    %|                 |                 |                 | below this      |
    %|                 |                 |                 | tolerance.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available stats
    %
    %+--------------------+
    %|         Id         |
    %+====================+
    %| solution_type      |
    %+--------------------+
    %| termination_reason |
    %+--------------------+
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
    %C++ includes: sdp_solver.hpp 
    %Usage: SdpSolver ()
    %
  methods
    function self = SdpSolver(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1029, varargin{:});
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
        casadiMEX(1030, self);
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

      [varargout{1:max(1,nargout)}] = casadiMEX(1025, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(1026, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1027, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1028, varargin{:});

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
