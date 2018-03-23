classdef Function < casadi.OptionsFunctionality & casadi.IOInterfaceFunction
    %General function.
    %
    %A general function $f$ in casadi can be multi-input, multi-output. Number of
    %inputs: nin nIn() Number of outputs: nout nOut()  We can view this function
    %as a being composed of a ( nin, nout) grid of single-input, single-output
    %primitive functions. Each such primitive function $f_ {i, j} \\forall i
    %\\in [0, nin-1], j \\in [0, nout-1]$ can map as $\\mathbf {R}^{n,
    %m}\\to\\mathbf{R}^{p, q}$, in which n, m, p, q can take different values
    %for every (i, j) pair.  When passing input, you specify which partition $i$
    %is active. You pass the numbers vectorized, as a vector of size $(n*m)$.
    %When requesting output, you specify which partition $j$ is active. You get
    %the numbers vectorized, as a vector of size $(p*q)$.  To calculate
    %Jacobians, you need to have $(m=1, q=1)$.
    %
    %Write the Jacobian as $J_ {i, j} = \\nabla f_{i, j} = \\frac
    %{\\partial f_{i, j}(\\vec{x})}{\\partial \\vec{x}}$.
    %
    %We have the following relationships for function mapping from a row vector
    %to a row vector:
    %
    %$ \\vec {s}_f = \\nabla f_{i, j} . \\vec{v}$ $ \\vec {s}_a =
    %(\\nabla f_{i, j})^T . \\vec{w}$
    %
    %Some quantities in these formulas must be transposed: input col: transpose $
    %\\vec {v} $ and $\\vec{s}_a$ output col: transpose $ \\vec {w} $ and
    %$\\vec{s}_f$  NOTE: Functions are allowed to modify their input arguments
    %when evaluating: implicitFunction, IDAS solver Further releases may disallow
    %this.
    %
    %Joel Andersson
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
    %>List of available monitors
    %
    %+---------+--------------------------+
    %|   Id    |         Used in          |
    %+=========+==========================+
    %| inputs  | casadi::FunctionInternal |
    %+---------+--------------------------+
    %| outputs | casadi::FunctionInternal |
    %+---------+--------------------------+
    %
    %Diagrams
    %--------
    %
    %
    %
    %C++ includes: function.hpp 
    %Usage: Function ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(832, self);
        self.swigPtr=[];
      end
    end
    function varargout = inputIndex(self,varargin)
    %Find the index for a string describing a particular entry of an input
    %scheme.
    %
    %example: schemeEntry("x_opt") -> returns NLP_SOLVER_X if FunctionInternal
    %adheres to SCHEME_NLPINput
    %
    %
    %Usage: retval = inputIndex (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(833, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputIndex(self,varargin)
    %Find the index for a string describing a particular entry of an output
    %scheme.
    %
    %example: schemeEntry("x_opt") -> returns NLP_SOLVER_X if FunctionInternal
    %adheres to SCHEME_NLPINput
    %
    %
    %Usage: retval = outputIndex (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(834, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inputName(self,varargin)
    %Get input scheme name by index.
    %
    %
    %Usage: retval = inputName (ind)
    %
    %ind is of type int. ind is of type int. retval is of type std::string. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(835, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputName(self,varargin)
    %Get output scheme name by index.
    %
    %
    %Usage: retval = outputName (ind)
    %
    %ind is of type int. ind is of type int. retval is of type std::string. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(836, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inputDescription(self,varargin)
    %Get input scheme description by index.
    %
    %
    %Usage: retval = inputDescription (ind)
    %
    %ind is of type int. ind is of type int. retval is of type std::string. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(837, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputDescription(self,varargin)
    %Get output scheme description by index.
    %
    %
    %Usage: retval = outputDescription (ind)
    %
    %ind is of type int. ind is of type int. retval is of type std::string. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(838, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = defaultInput(self,varargin)
    %Get default input value.
    %
    %
    %Usage: retval = defaultInput (ind)
    %
    %ind is of type int. ind is of type int. retval is of type double. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(839, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inputSparsity(self,varargin)
    %Get sparsity of a given input.
    %
    %
    %Usage: retval = inputSparsity (iname)
    %
    %iname is of type std::string const &. iname is of type std::string const &. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(840, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputSparsity(self,varargin)
    %Get sparsity of a given output.
    %
    %
    %Usage: retval = outputSparsity (iname)
    %
    %iname is of type std::string const &. iname is of type std::string const &. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(841, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nIn(self,varargin)
    %Get the number of function inputs.
    %
    %
    %Usage: retval = nIn ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(842, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nOut(self,varargin)
    %Get the number of function outputs.
    %
    %
    %Usage: retval = nOut ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(843, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nnzIn(self,varargin)
    %Get total number of nonzeros in all of the matrix-valued inputs.
    %
    %
    %Usage: retval = nnzIn ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(844, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nnzOut(self,varargin)
    %Get total number of nonzeros in all of the matrix-valued outputs.
    %
    %
    %Usage: retval = nnzOut ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(845, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = numelIn(self,varargin)
    %Get total number of elements in all of the matrix-valued inputs.
    %
    %
    %Usage: retval = numelIn ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(846, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = numelOut(self,varargin)
    %Get total number of elements in all of the matrix-valued outputs.
    %
    %
    %Usage: retval = numelOut ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(847, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inputScheme(self,varargin)
    %Get input scheme.
    %
    %
    %Usage: retval = inputScheme ()
    %
    %retval is of type std::vector< std::string,std::allocator< std::string > >. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(848, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputScheme(self,varargin)
    %Get output scheme.
    %
    %
    %Usage: retval = outputScheme ()
    %
    %retval is of type std::vector< std::string,std::allocator< std::string > >. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(849, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = evaluate(self,varargin)
    %Evaluate.
    %
    %
    %Usage: evaluate ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(850, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printDimensions(self,varargin)
    %Print dimensions of inputs and outputs.
    %
    %
    %Usage: printDimensions ()
    %

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:nargout}] = casadiMEX(851, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = jacobian(self,varargin)
    %Generate a Jacobian function of output oind with respect to input iind.
    %
    %Parameters:
    %-----------
    %
    %iind:  The index of the input
    %
    %oind:  The index of the output
    %
    %The default behavior of this class is defined by the derived class. If
    %compact is set to true, only the nonzeros of the input and output
    %expressions are considered. If symmetric is set to true, the Jacobian being
    %calculated is known to be symmetric (usually a Hessian), which can be
    %exploited by the algorithm.
    %
    %The generated Jacobian has one more output than the calling function
    %corresponding to the Jacobian and the same number of inputs.
    %
    %
    %Usage: retval = jacobian (iind, oind, compact = false, symmetric = false)
    %
    %iind is of type std::string const &. oind is of type std::string const &. compact is of type bool. symmetric is of type bool. iind is of type std::string const &. oind is of type std::string const &. compact is of type bool. symmetric is of type bool. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(852, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setJacobian(self,varargin)
    %Set the Jacobian function of output oind with respect to input iind NOTE:
    %Does not take ownership, only weak references to the Jacobians are kept
    %internally
    %
    %
    %Usage: setJacobian (jac, iind = 0, oind = 0, compact = false)
    %
    %jac is of type Function. iind is of type int. oind is of type int. compact is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(853, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = gradient(self,varargin)
    %Generate a gradient function of output oind with respect to input iind.
    %
    %Parameters:
    %-----------
    %
    %iind:  The index of the input
    %
    %oind:  The index of the output
    %
    %The default behavior of this class is defined by the derived class. Note
    %that the output must be scalar. In other cases, use the Jacobian instead.
    %
    %
    %Usage: retval = gradient (iind, oind)
    %
    %iind is of type std::string const &. oind is of type std::string const &. iind is of type std::string const &. oind is of type std::string const &. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(854, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tangent(self,varargin)
    %Generate a tangent function of output oind with respect to input iind.
    %
    %Parameters:
    %-----------
    %
    %iind:  The index of the input
    %
    %oind:  The index of the output
    %
    %The default behavior of this class is defined by the derived class. Note
    %that the input must be scalar. In other cases, use the Jacobian instead.
    %
    %
    %Usage: retval = tangent (iind, oind)
    %
    %iind is of type std::string const &. oind is of type std::string const &. iind is of type std::string const &. oind is of type std::string const &. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(855, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hessian(self,varargin)
    %Generate a Hessian function of output oind with respect to input iind.
    %
    %Parameters:
    %-----------
    %
    %iind:  The index of the input
    %
    %oind:  The index of the output
    %
    %The generated Hessian has two more outputs than the calling function
    %corresponding to the Hessian and the gradients.
    %
    %
    %Usage: retval = hessian (iind, oind)
    %
    %iind is of type std::string const &. oind is of type std::string const &. iind is of type std::string const &. oind is of type std::string const &. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(856, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = fullJacobian(self,varargin)
    %Generate a Jacobian function of all the inputs elements with respect to all
    %the output elements).
    %
    %
    %Usage: retval = fullJacobian ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(857, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setFullJacobian(self,varargin)
    %Set the Jacobian of all the input nonzeros with respect to all output
    %nonzeros NOTE: Does not take ownership, only weak references to the Jacobian
    %are kept internally
    %
    %
    %Usage: setFullJacobian (jac)
    %
    %jac is of type Function. 

      try

      [varargout{1:nargout}] = casadiMEX(858, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = call(self,varargin)
    %Evaluate the function symbolically or numerically.
    %
    %
    %Usage: call (arg, always_inline = false, never_inline = false)
    %
    %arg is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. always_inline is of type bool. never_inline is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(859, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (arg, always_inline = false, never_inline = false)
    %
    %arg is of type casadi::MXDict const &. always_inline is of type bool. never_inline is of type bool. arg is of type casadi::MXDict const &. always_inline is of type bool. never_inline is of type bool. retval is of type casadi::MXDict const. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(860, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = callForward(self,varargin)
    %Create call to (cached) derivative function, forward mode.
    %
    %
    %Usage: callForward (arg, res, fseed, always_inline = false, never_inline = false)
    %
    %arg is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. res is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. fseed is of type std::vector< std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > >,std::allocator< std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > > > const &. always_inline is of type bool. never_inline is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(861, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = callReverse(self,varargin)
    %Create call to (cached) derivative function, reverse mode.
    %
    %
    %Usage: callReverse (arg, res, aseed, always_inline = false, never_inline = false)
    %
    %arg is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. res is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. aseed is of type std::vector< std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > >,std::allocator< std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > > > const &. always_inline is of type bool. never_inline is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(862, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = callDerivative(self,varargin)
    %[INTERNAL]
    %Evaluate the function symbolically or numerically with directional
    %derivatives The first two arguments are the nondifferentiated inputs and
    %results of the evaluation, the next two arguments are a set of forward
    %directional seeds and the resulting forward directional derivatives, the
    %length of the vector being the number of forward directions. The next two
    %arguments are a set of adjoint directional seeds and the resulting adjoint
    %directional derivatives, the length of the vector being the number of
    %adjoint directions.
    %
    %
    %Usage: callDerivative (arg, fseed, aseed, always_inline = false, never_inline = false)
    %
    %arg is of type casadi::MXVector const &. fseed is of type casadi::MXVectorVector const &. aseed is of type casadi::MXVectorVector const &. always_inline is of type bool. never_inline is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(863, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mapsum(self,varargin)
    %Evaluate symbolically in parallel and sum (matrix graph)
    %
    %Parameters:
    %-----------
    %
    %parallelization:  Type of parallelization used: expand|serial|openmp
    %
    %
    %Usage: retval = mapsum (arg, parallelization = "serial")
    %
    %arg is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. parallelization is of type std::string const &. arg is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. parallelization is of type std::string const &. retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(864, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mapaccum(self,varargin)
    %Create a mapaccumulated version of this function.
    %
    %Suppose the function has a signature of:
    %
    %::
    %
    %     f: (x, u) -> (x_next , y )
    %  
    %
    %
    %
    %The the mapaccumulated version has the signature:
    %
    %::
    %
    %     F: (x0, U) -> (X , Y )
    %  
    %      with
    %          U: horzcat([u0, u1, ..., u_(N-1)])
    %          X: horzcat([x1, x2, ..., x_N])
    %          Y: horzcat([y0, y1, ..., y_(N-1)])
    %  
    %      and
    %          x1, y0 <- f(x0, u0)
    %          x2, y1 <- f(x1, u1)
    %          ...
    %          x_N, y_(N-1) <- f(x_(N-1), u_(N-1))
    %  
    %
    %
    %
    %
    %Usage: retval = mapaccum (name, N, options = casadi::Dict())
    %
    %name is of type std::string const &. N is of type int. options is of type casadi::Dict const &. name is of type std::string const &. N is of type int. options is of type casadi::Dict const &. retval is of type Function. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(865, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = map(self,varargin)
    %>  [[MX] ] Function.map([[MX ] ] arg, str parallelization="serial")
    %
    %>  [MX] Function.map([MX ] arg, str parallelization="serial")
    %------------------------------------------------------------------------
    %
    %Evaluate symbolically in parallel (matrix graph)
    %
    %Parameters:
    %-----------
    %
    %parallelization:  Type of parallelization used: expand|serial|openmp
    %
    %>  Function Function.map(str name, int N, Dict options=Dict()) const 
    %------------------------------------------------------------------------
    %
    %Create a mapped version of this function.
    %
    %Suppose the function has a signature of:
    %
    %::
    %
    %     f: (a, p) -> ( s )
    %  
    %
    %
    %
    %The the mapaccumulated version has the signature:
    %
    %::
    %
    %     F: (A, P) -> (S )
    %  
    %      with
    %          a: horzcat([a0, a1, ..., a_(N-1)])
    %          p: horzcat([p0, p1, ..., p_(N-1)])
    %          s: horzcat([s0, s1, ..., s_(N-1)])
    %      and
    %          s0 <- f(a0, p0)
    %          s1 <- f(a1, p1)
    %          ...
    %          s_(N-1) <- f(a_(N-1), p_(N-1))
    %  
    %
    %
    %
    %
    %Usage: retval = map (name, N, options = casadi::Dict())
    %
    %name is of type std::string const &. N is of type int. options is of type casadi::Dict const &. name is of type std::string const &. N is of type int. options is of type casadi::Dict const &. retval is of type Function. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(866, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = derivative(self,varargin)
    %Get a function that calculates nfwd forward derivatives and nadj adjoint
    %derivatives Legacy function: Use derForward and derReverse instead.
    %
    %Returns a function with (1+nfwd)*n_in+nadj*n_out inputs and (1+nfwd)*n_out +
    %nadj*n_in outputs. The first n_in inputs correspond to nondifferentiated
    %inputs. The next nfwd*n_in inputs correspond to forward seeds, one direction
    %at a time and the last nadj*n_out inputs correspond to adjoint seeds, one
    %direction at a time. The first n_out outputs correspond to nondifferentiated
    %outputs. The next nfwd*n_out outputs correspond to forward sensitivities,
    %one direction at a time and the last nadj*n_in outputs corresponds to
    %adjoint sensitivities, one direction at a time.
    %
    %(n_in = nIn(), n_out = nOut())
    %
    %
    %Usage: retval = derivative (nfwd, nadj)
    %
    %nfwd is of type int. nadj is of type int. nfwd is of type int. nadj is of type int. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(867, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = derForward(self,varargin)
    %Get a function that calculates nfwd forward derivatives.
    %
    %Returns a function with n_in + n_out +nfwd*n_in inputs and nfwd*n_out
    %outputs. The first n_in inputs correspond to nondifferentiated inputs. The
    %next n_out inputs correspond to nondifferentiated outputs. and the last
    %nfwd*n_in inputs correspond to forward seeds, one direction at a time The
    %nfwd*n_out outputs correspond to forward sensitivities, one direction at a
    %time. * (n_in = nIn(), n_out = nOut())
    %
    %The functions returned are cached, meaning that if called multiple timed
    %with the same value, then multiple references to the same function will be
    %returned.
    %
    %
    %Usage: retval = derForward (nfwd)
    %
    %nfwd is of type int. nfwd is of type int. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(868, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = derReverse(self,varargin)
    %Get a function that calculates nadj adjoint derivatives.
    %
    %Returns a function with n_in + n_out +nadj*n_out inputs and nadj*n_in
    %outputs. The first n_in inputs correspond to nondifferentiated inputs. The
    %next n_out inputs correspond to nondifferentiated outputs. and the last
    %nadj*n_out inputs correspond to adjoint seeds, one direction at a time The
    %nadj*n_in outputs correspond to adjoint sensitivities, one direction at a
    %time. * (n_in = nIn(), n_out = nOut())
    %
    %(n_in = nIn(), n_out = nOut())
    %
    %The functions returned are cached, meaning that if called multiple timed
    %with the same value, then multiple references to the same function will be
    %returned.
    %
    %
    %Usage: retval = derReverse (nadj)
    %
    %nadj is of type int. nadj is of type int. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(869, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setDerForward(self,varargin)
    %Set a function that calculates nfwd forward derivatives NOTE: Does not take
    %ownership, only weak references to the derivatives are kept internally.
    %
    %
    %Usage: setDerForward (fcn, nfwd)
    %
    %fcn is of type Function. nfwd is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(870, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setDerReverse(self,varargin)
    %Set a function that calculates nadj adjoint derivatives NOTE: Does not take
    %ownership, only weak references to the derivatives are kept internally.
    %
    %
    %Usage: setDerReverse (fcn, nadj)
    %
    %fcn is of type Function. nadj is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(871, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = jacSparsity(self,varargin)
    %Get, if necessary generate, the sparsity of a Jacobian block
    %
    %
    %Usage: retval = jacSparsity (iind, oind, compact = false, symmetric = false)
    %
    %iind is of type std::string const &. oind is of type std::string const &. compact is of type bool. symmetric is of type bool. iind is of type std::string const &. oind is of type std::string const &. compact is of type bool. symmetric is of type bool. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(872, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setJacSparsity(self,varargin)
    %Generate the sparsity of a Jacobian block
    %
    %
    %Usage: setJacSparsity (sp, iind, oind, compact = false)
    %
    %sp is of type Sparsity. iind is of type std::string const &. oind is of type std::string const &. compact is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(873, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = generate(self,varargin)
    %Export / Generate C code for the function.
    %
    %
    %Usage: generate (opts = casadi::Dict())
    %
    %opts is of type casadi::Dict const &. 

      try

      [varargout{1:nargout}] = casadiMEX(874, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getStats(self,varargin)
    %Get all statistics obtained at the end of the last evaluate call.
    %
    %
    %Usage: retval = getStats ()
    %
    %retval is of type casadi::Dict const &. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(876, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getStat(self,varargin)
    %Get a single statistic obtained at the end of the last evaluate call.
    %
    %
    %Usage: retval = getStat (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type GenericType. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(877, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = symbolicInput(self,varargin)
    %Get a vector of symbolic variables with the same dimensions as the inputs.
    %
    %There is no guarantee that consecutive calls return identical objects
    %
    %
    %Usage: retval = symbolicInput (unique = false)
    %
    %unique is of type bool. unique is of type bool. retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(878, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = symbolicInputSX(self,varargin)
    %Get a vector of symbolic variables with the same dimensions as the inputs,
    %SX graph.
    %
    %There is no guarantee that consecutive calls return identical objects
    %
    %
    %Usage: retval = symbolicInputSX ()
    %
    %retval is of type std::vector< casadi::SX,std::allocator< casadi::SX > >. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(879, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = symbolicOutput(self,varargin)
    %Get a vector of symbolic variables with the same dimensions as the outputs.
    %
    %There is no guarantee that consecutive calls return identical objects
    %
    %
    %Usage: retval = symbolicOutput ()
    %
    %retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(880, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = spCanEvaluate(self,varargin)
    %[INTERNAL]  Is the
    %class able to propagate seeds through the algorithm?
    %
    %(for usage, see the example propagating_sparsity.cpp)
    %
    %
    %Usage: retval = spCanEvaluate (fwd)
    %
    %fwd is of type bool. fwd is of type bool. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(881, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = spInit(self,varargin)
    %[INTERNAL]  Reset the
    %sparsity propagation.
    %
    %(for usage, see the example propagating_sparsity.cpp)
    %
    %
    %Usage: spInit (fwd)
    %
    %fwd is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(882, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = spEvaluate(self,varargin)
    %[INTERNAL]  Propagate
    %the sparsity pattern through a set of directional.
    %
    %derivatives forward or backward (for usage, see the example
    %propagating_sparsity.cpp)
    %
    %
    %Usage: spEvaluate (fwd)
    %
    %fwd is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(883, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sz_arg(self,varargin)
    %[INTERNAL]  Get required
    %length of arg field.
    %
    %
    %Usage: retval = sz_arg ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(884, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sz_res(self,varargin)
    %[INTERNAL]  Get required
    %length of res field.
    %
    %
    %Usage: retval = sz_res ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(885, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sz_iw(self,varargin)
    %[INTERNAL]  Get required
    %length of iw field.
    %
    %
    %Usage: retval = sz_iw ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(886, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sz_w(self,varargin)
    %[INTERNAL]  Get required
    %length of w field.
    %
    %
    %Usage: retval = sz_w ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(887, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addMonitor(self,varargin)
    %Add modules to be monitored.
    %
    %
    %Usage: addMonitor (mon)
    %
    %mon is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(888, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = removeMonitor(self,varargin)
    %Remove modules to be monitored.
    %
    %
    %Usage: removeMonitor (mon)
    %
    %mon is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(889, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = checkInputs(self,varargin)
    %[INTERNAL]  Check if
    %the numerical values of the supplied bounds make sense.
    %
    %
    %Usage: checkInputs ()
    %

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:nargout}] = casadiMEX(890, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getSanitizedName(self,varargin)
    %get function name with all non alphanumeric characters converted to '_'
    %
    %
    %Usage: retval = getSanitizedName ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.Function')
        self = casadi.Function(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(891, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Function(varargin)
      self@casadi.OptionsFunctionality(SwigRef.Null);
      self@casadi.IOInterfaceFunction(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(893, varargin{:});
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
  end
  methods(Static)
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(875, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sanitizeName(varargin)
    %Usage: retval = sanitizeName (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(892, varargin{:});

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
