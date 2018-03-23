classdef LrDleSolver < casadi.Function
    %Base class for Low-rank Discrete Lyapunov Equation Solvers.
    %
    %
    %
    %::
    %
    %  A in R^(n x n)
    %  V in S^m
    %  C in R^(n x m)
    %  Hi in R^(n x Hsi)
    %  
    %
    %
    %
    %finds $P$ that satisfies:
    %
    %
    %
    %::
    %
    %  P = A P A' + C V C'
    %  
    %
    %
    %
    %and outputs
    %
    %Yi = Hi^T P Hi
    %
    %General information
    %===================
    %
    %
    %
    %>Input scheme: casadi::LR_DLEInput (LR_DLE_NUM_IN = 4) [lrdleIn]
    %
    %+-----------+-------+----------------------------------------+
    %| Full name | Short |              Description               |
    %+===========+=======+========================================+
    %| LR_DLE_A  | a     | A matrix .                             |
    %+-----------+-------+----------------------------------------+
    %| LR_DLE_V  | v     | V matrix .                             |
    %+-----------+-------+----------------------------------------+
    %| LR_DLE_C  | c     | C matrix .                             |
    %+-----------+-------+----------------------------------------+
    %| LR_DLE_H  | h     | H matrix: horizontal stack of all Hi . |
    %+-----------+-------+----------------------------------------+
    %
    %>Output scheme: casadi::LR_DLEOutput (LR_DLE_NUM_OUT = 1) [lrdleOut]
    %
    %+-----------+-------+---------------------------------+
    %| Full name | Short |           Description           |
    %+===========+=======+=================================+
    %| LR_DLE_Y  | y     | Y matrix, block diagonal form . |
    %+-----------+-------+---------------------------------+
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
    %|              |              |              | options      | lityNode     |
    %|              |              |              | according to |              |
    %|              |              |              | a given      |              |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| eps_unstable | OT_REAL      | 0.000        | A margin for | casadi::LrDl |
    %|              |              |              | unstability  | eInternal    |
    %|              |              |              | detection    |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| error_unstab | OT_BOOLEAN   | false        | Throw an     | casadi::LrDl |
    %| le           |              |              | exception    | eInternal    |
    %|              |              |              | when it is   |              |
    %|              |              |              | detected     |              |
    %|              |              |              | that         |              |
    %|              |              |              | Product(A_i, |              |
    %|              |              |              | i=N..1) has  |              |
    %|              |              |              | eigenvalues  |              |
    %|              |              |              | greater than |              |
    %|              |              |              | 1-eps_unstab |              |
    %|              |              |              | le           |              |
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
    %| pos_def      | OT_BOOLEAN   | false        | Assume P     | casadi::LrDl |
    %|              |              |              | positive     | eInternal    |
    %|              |              |              | definite     |              |
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
    %- fixed_smith
    %
    %- dle
    %
    %- lrdple
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %LrDleSolver.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %fixed_smith
    %-----------
    %
    %
    %
    %Solving the Discrete Lyapunov Equations with a regular LinearSolver
    %
    %>List of available options
    %
    %+------+------------+---------+----------------------------+
    %|  Id  |    Type    | Default |        Description         |
    %+======+============+=========+============================+
    %| iter | OT_INTEGER | 100     | Number of Smith iterations |
    %+------+------------+---------+----------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %dle
    %---
    %
    %
    %
    %Solving the Discrete Lyapunov Equations with a Low-rank Discrete Lyapunov
    %Equations solver
    %
    %Solving the Low-Rank Discrete Lyapunov Equations with a regular Discrete
    %Lyapunov Equations solver
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
    %lrdple
    %------
    %
    %
    %
    %Solving the low-rank Periodic Discrete Lyapunov Equations with a low- rank
    %discrete Lyapunov solver
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| dple            | OT_DICT         | GenericType()   | Options to be   |
    %|                 |                 |                 | passed to the   |
    %|                 |                 |                 | DPLE solver.    |
    %+-----------------+-----------------+-----------------+-----------------+
    %| dple_solver     | OT_STRING       | GenericType()   | User-defined    |
    %|                 |                 |                 | DPLE solver     |
    %|                 |                 |                 | class.          |
    %+-----------------+-----------------+-----------------+-----------------+
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
    %C++ includes: lr_dle_solver.hpp 
    %Usage: LrDleSolver ()
    %
  methods
    function varargout = clone(self,varargin)
    %Clone.
    %
    %
    %Usage: retval = clone ()
    %
    %retval is of type LrDleSolver. 

      try

      if ~isa(self,'casadi.LrDleSolver')
        self = casadi.LrDleSolver(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1118, self, varargin{:});

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

      if ~isa(self,'casadi.LrDleSolver')
        self = casadi.LrDleSolver(self);
      end
      [varargout{1:nargout}] = casadiMEX(1119, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = LrDleSolver(varargin)
      self@casadi.Function(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1125, varargin{:});
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
        casadiMEX(1126, self);
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

      [varargout{1:max(1,nargout)}] = casadiMEX(1120, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1121, varargin{:});

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

      [varargout{1:nargout}] = casadiMEX(1122, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(1123, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sparsity(varargin)
    %Usage: retval = sparsity (st, Hs = std::vector< int >())
    %
    %st is of type std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > > const &. Hs is of type std::vector< int,std::allocator< int > > const &. st is of type std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > > const &. Hs is of type std::vector< int,std::allocator< int > > const &. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1124, varargin{:});

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
