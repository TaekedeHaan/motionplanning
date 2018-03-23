classdef ImplicitFunction < casadi.Function
    %Abstract base class for the implicit function classes.
    %
    %Mathematically, the equation:
    %
    %F(z, x1, x2, ..., xn) == 0
    %
    %where d_F/dz is invertible, implicitly defines the equation:
    %
    %z := G(x1, x2, ..., xn)
    %
    %In CasADi, F is a Function. The first input presents the variables that need
    %to be solved for. The first output is the residual that needs to attain
    %zero. Optional remaining outputs can be supplied; they are output
    %expressions.
    %
    %In pseudo-code, we can write:
    %
    %G* = ImplicitFunction('solver',F)
    %
    %Here, G* is a Function with one extra input over the pure mathematical G:
    %
    %z := G*(z0, x1, x2, ..., xn)
    %
    %The first input to the ImplicitFunction is the intial guess for z.
    %
    %General information
    %===================
    %
    %
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
    %| constraints  | OT_INTEGERVE | GenericType( | Constrain    | casadi::Impl |
    %|              | CTOR         | )            | the          | icitFunction |
    %|              |              |              | unknowns. 0  | Internal     |
    %|              |              |              | (default):   |              |
    %|              |              |              | no           |              |
    %|              |              |              | constraint   |              |
    %|              |              |              | on ui, 1: ui |              |
    %|              |              |              | >= 0.0, -1:  |              |
    %|              |              |              | ui <= 0.0,   |              |
    %|              |              |              | 2: ui > 0.0, |              |
    %|              |              |              | -2: ui <     |              |
    %|              |              |              | 0.0.         |              |
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
    %| implicit_inp | OT_INTEGER   | 0            | Index of the | casadi::Impl |
    %| ut           |              |              | input that   | icitFunction |
    %|              |              |              | corresponds  | Internal     |
    %|              |              |              | to the       |              |
    %|              |              |              | actual root- |              |
    %|              |              |              | finding      |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| implicit_out | OT_INTEGER   | 0            | Index of the | casadi::Impl |
    %| put          |              |              | output that  | icitFunction |
    %|              |              |              | corresponds  | Internal     |
    %|              |              |              | to the       |              |
    %|              |              |              | actual root- |              |
    %|              |              |              | finding      |              |
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
    %| jacobian_fun | OT_FUNCTION  | GenericType( | Function     | casadi::Impl |
    %| ction        |              | )            | object for   | icitFunction |
    %|              |              |              | calculating  | Internal     |
    %|              |              |              | the Jacobian |              |
    %|              |              |              | (autogenerat |              |
    %|              |              |              | ed by        |              |
    %|              |              |              | default)     |              |
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
    %| linear_solve | OT_STRING    | "csparse"    | User-defined | casadi::Impl |
    %| r            |              |              | linear       | icitFunction |
    %|              |              |              | solver       | Internal     |
    %|              |              |              | class.       |              |
    %|              |              |              | Needed for s |              |
    %|              |              |              | ensitivities |              |
    %|              |              |              | .            |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| linear_solve | OT_FUNCTION  | GenericType( | Function     | casadi::Impl |
    %| r_function   |              | )            | object for   | icitFunction |
    %|              |              |              | solving the  | Internal     |
    %|              |              |              | linearized   |              |
    %|              |              |              | problem (aut |              |
    %|              |              |              | ogenerated   |              |
    %|              |              |              | by default)  |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| linear_solve | OT_DICT      | GenericType( | Options to   | casadi::Impl |
    %| r_options    |              | )            | be passed to | icitFunction |
    %|              |              |              | the linear   | Internal     |
    %|              |              |              | solver.      |              |
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
    %- kinsol
    %
    %- nlp
    %
    %- newton
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %ImplicitFunction.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %kinsol
    %------
    %
    %
    %
    %KINSOL interface from the Sundials suite
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| abstol          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion       |
    %|                 |                 |                 | tolerance       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| disable_interna | OT_BOOLEAN      | false           | Disable KINSOL  |
    %| l_warnings      |                 |                 | internal        |
    %|                 |                 |                 | warning         |
    %|                 |                 |                 | messages        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| exact_jacobian  | OT_BOOLEAN      | true            |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| f_scale         | OT_REALVECTOR   |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| iterative_solve | OT_STRING       | "gmres"         | gmres|bcgstab|t |
    %| r               |                 |                 | fqmr            |
    %+-----------------+-----------------+-----------------+-----------------+
    %| linear_solver_t | OT_STRING       | "dense"         | dense|banded|it |
    %| ype             |                 |                 | erative|user_de |
    %|                 |                 |                 | fined           |
    %+-----------------+-----------------+-----------------+-----------------+
    %| lower_bandwidth | OT_INTEGER      |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 0               | Maximum number  |
    %|                 |                 |                 | of Newton       |
    %|                 |                 |                 | iterations.     |
    %|                 |                 |                 | Putting 0 sets  |
    %|                 |                 |                 | the default     |
    %|                 |                 |                 | value of        |
    %|                 |                 |                 | KinSol.         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_krylov      | OT_INTEGER      | 0               |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| pretype         | OT_STRING       | "none"          | (none|left|righ |
    %|                 |                 |                 | t|both)         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| strategy        | OT_STRING       | "none"          | Globalization   |
    %|                 |                 |                 | strategy (none| |
    %|                 |                 |                 | linesearch)     |
    %+-----------------+-----------------+-----------------+-----------------+
    %| u_scale         | OT_REALVECTOR   |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| upper_bandwidth | OT_INTEGER      |                 |                 |
    %+-----------------+-----------------+-----------------+-----------------+
    %| use_preconditio | OT_BOOLEAN      | false           | precondition an |
    %| ner             |                 |                 | iterative       |
    %|                 |                 |                 | solver          |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+-----------+
    %|    Id     |
    %+===========+
    %| eval_djac |
    %+-----------+
    %| eval_f    |
    %+-----------+
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
    %Use an NlpSolver as ImplicitFunction solver
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
    %+--------------+
    %|      Id      |
    %+==============+
    %| solver_stats |
    %+--------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %newton
    %------
    %
    %
    %
    %Implements simple newton iterations to solve an implicit function.
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| abstol          | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion       |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | max(|F|)        |
    %+-----------------+-----------------+-----------------+-----------------+
    %| abstolStep      | OT_REAL         | 0.000           | Stopping        |
    %|                 |                 |                 | criterion       |
    %|                 |                 |                 | tolerance on    |
    %|                 |                 |                 | step size       |
    %+-----------------+-----------------+-----------------+-----------------+
    %| max_iter        | OT_INTEGER      | 1000            | Maximum number  |
    %|                 |                 |                 | of Newton       |
    %|                 |                 |                 | iterations to   |
    %|                 |                 |                 | perform before  |
    %|                 |                 |                 | returning.      |
    %+-----------------+-----------------+-----------------+-----------------+
    %| print_iteration | OT_BOOLEAN      | false           | Print           |
    %|                 |                 |                 | information     |
    %|                 |                 |                 | about each      |
    %|                 |                 |                 | iteration       |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %>List of available monitors
    %
    %+----------+
    %|    Id    |
    %+==========+
    %| F        |
    %+----------+
    %| J        |
    %+----------+
    %| normF    |
    %+----------+
    %| step     |
    %+----------+
    %| stepsize |
    %+----------+
    %
    %>List of available stats
    %
    %+---------------+
    %|      Id       |
    %+===============+
    %| iter          |
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
    %C++ includes: implicit_function.hpp 
    %Usage: ImplicitFunction ()
    %
  methods
    function varargout = getF(self,varargin)
    %Access F.
    %
    %
    %Usage: retval = getF ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(956, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getJac(self,varargin)
    %Access Jacobian.
    %
    %
    %Usage: retval = getJac ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(957, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getLinsol(self,varargin)
    %Access linear solver.
    %
    %
    %Usage: retval = getLinsol ()
    %
    %retval is of type LinearSolver. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(958, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = ImplicitFunction(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(959, varargin{:});
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
        casadiMEX(960, self);
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

      [varargout{1:max(1,nargout)}] = casadiMEX(952, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(953, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(954, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(955, varargin{:});

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
