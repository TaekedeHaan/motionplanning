classdef MX < casadi.ExpMX & casadi.GenMX & casadi.SharedObject
    %MX - Matrix expression.
    %
    %The MX class is used to build up trees made up from MXNodes. It is a more
    %general graph representation than the scalar expression, SX, and much less
    %efficient for small objects. On the other hand, the class allows much more
    %general operations than does SX, in particular matrix valued operations and
    %calls to arbitrary differentiable functions.
    %
    %The MX class is designed to have identical syntax with the Matrix<> template
    %class, and uses Matrix<double> as its internal representation of the values
    %at a node. By keeping the syntaxes identical, it is possible to switch from
    %one class to the other, as well as inlining MX functions to SXElement
    %functions.
    %
    %Note that an operation is always "lazy", making a matrix multiplication
    %will create a matrix multiplication node, not perform the actual
    %multiplication.
    %
    %Joel Andersson
    %
    %C++ includes: mx.hpp 
    %Usage: MX ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = MX(varargin)
      self@casadi.ExpMX(SwigRef.Null);
      self@casadi.GenMX(SwigRef.Null);
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(752, varargin{:});
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
        casadiMEX(753, self);
        self.swigPtr=[];
      end
    end
    function varargout = nonzero(self,varargin)
    %Returns the truth value of an MX expression.
    %
    %
    %Usage: retval = nonzero ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(754, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sparsity(self,varargin)
    %Get an owning reference to the sparsity pattern.
    %
    %
    %Usage: retval = sparsity ()
    %
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(755, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = erase(self,varargin)
    %>  void MX.erase([int ] rr, [int ] cc, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase rows and/or
    %columns of a matrix.
    %
    %>  void MX.erase([int ] rr, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase elements of
    %a matrix.
    %
    %
    %Usage: erase (rr, ind1 = false)
    %
    %rr is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(756, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = enlarge(self,varargin)
    %Enlarge matrix Make the matrix larger by inserting empty rows and columns,
    %keeping the existing non-zeros.
    %
    %
    %Usage: enlarge (nrow, ncol, rr, cc, ind1 = false)
    %
    %nrow is of type int. ncol is of type int. rr is of type std::vector< int,std::allocator< int > > const &. cc is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(757, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = uminus(self,varargin)
    %Usage: retval = uminus ()
    %
    %retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(758, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getDep(self,varargin)
    %Get the nth dependency as MX.
    %
    %
    %Usage: retval = getDep (ch = 0)
    %
    %ch is of type int. ch is of type int. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(759, self, varargin{:});

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
    %Number of outputs.
    %
    %
    %Usage: retval = nOut ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(760, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOutput(self,varargin)
    %Get an output.
    %
    %
    %Usage: retval = getOutput (oind = 0)
    %
    %oind is of type int. oind is of type int. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(761, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getNdeps(self,varargin)
    %Get the number of dependencies of a binary SXElement.
    %
    %
    %Usage: retval = getNdeps ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(762, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getName(self,varargin)
    %Get the name.
    %
    %
    %Usage: retval = getName ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(763, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getValue(self,varargin)
    %Get the value (only for scalar constant nodes)
    %
    %
    %Usage: retval = getValue ()
    %
    %retval is of type double. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(764, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getMatrixValue(self,varargin)
    %Get the value (only for constant nodes)
    %
    %
    %Usage: retval = getMatrixValue ()
    %
    %retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(765, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isSymbolic(self,varargin)
    %Check if symbolic.
    %
    %
    %Usage: retval = isSymbolic ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(766, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isConstant(self,varargin)
    %Check if constant.
    %
    %
    %Usage: retval = isConstant ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(767, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isEvaluation(self,varargin)
    %Check if evaluation.
    %
    %
    %Usage: retval = isEvaluation ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(768, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isEvaluationOutput(self,varargin)
    %Check if evaluation output.
    %
    %
    %Usage: retval = isEvaluationOutput ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(769, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getEvaluationOutput(self,varargin)
    %Get the index of evaluation output - only valid when isEvaluationoutput() is
    %true.
    %
    %
    %Usage: retval = getEvaluationOutput ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(770, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isOperation(self,varargin)
    %Is it a certain operation.
    %
    %
    %Usage: retval = isOperation (op)
    %
    %op is of type int. op is of type int. retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(771, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isMultiplication(self,varargin)
    %Check if multiplication.
    %
    %
    %Usage: retval = isMultiplication ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(772, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isCommutative(self,varargin)
    %Check if commutative operation.
    %
    %
    %Usage: retval = isCommutative ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(773, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isNorm(self,varargin)
    %Check if norm.
    %
    %
    %Usage: retval = isNorm ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(774, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isValidInput(self,varargin)
    %Check if matrix can be used to define function inputs. Valid inputs for
    %MXFunctions are combinations of Reshape, concatenations and SymbolicMX.
    %
    %
    %Usage: retval = isValidInput ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(775, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = numPrimitives(self,varargin)
    %Get the number of symbolic primitive Assumes isValidInput() returns true.
    %
    %
    %Usage: retval = numPrimitives ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(776, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getPrimitives(self,varargin)
    %Get symbolic primitives.
    %
    %
    %Usage: retval = getPrimitives ()
    %
    %retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(777, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = splitPrimitives(self,varargin)
    %Split up an expression along symbolic primitives.
    %
    %
    %Usage: retval = splitPrimitives (x)
    %
    %x is of type MX. x is of type MX. retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(778, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = joinPrimitives(self,varargin)
    %Join an expression along symbolic primitives.
    %
    %
    %Usage: retval = joinPrimitives (v)
    %
    %v is of type std::vector< casadi::MX,std::allocator< casadi::MX > > &. v is of type std::vector< casadi::MX,std::allocator< casadi::MX > > &. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(779, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasDuplicates(self,varargin)
    %[INTERNAL]  Detect
    %duplicate symbolic expressions If there are symbolic primitives appearing
    %more than once, the function will return true and the names of the duplicate
    %expressions will be printed to userOut<true, PL_WARN>(). Note: Will mark the
    %node using MX::setTemp. Make sure to call resetInput() after usage.
    %
    %
    %Usage: retval = hasDuplicates ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(780, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = resetInput(self,varargin)
    %[INTERNAL]  Reset the marker
    %for an input expression.
    %
    %
    %Usage: resetInput ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(781, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isIdentity(self,varargin)
    %check if identity
    %
    %
    %Usage: retval = isIdentity ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(782, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isZero(self,varargin)
    %check if zero (note that false negative answers are possible)
    %
    %
    %Usage: retval = isZero ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(783, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isOne(self,varargin)
    %check if zero (note that false negative answers are possible)
    %
    %
    %Usage: retval = isOne ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(784, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isMinusOne(self,varargin)
    %check if zero (note that false negative answers are possible)
    %
    %
    %Usage: retval = isMinusOne ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(785, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isTranspose(self,varargin)
    %Is the expression a transpose?
    %
    %
    %Usage: retval = isTranspose ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(786, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isRegular(self,varargin)
    %Checks if expression does not contain NaN or Inf.
    %
    %
    %Usage: retval = isRegular ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(787, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = numFunctions(self,varargin)
    %Number of functions.
    %
    %
    %Usage: retval = numFunctions ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(788, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getFunction(self,varargin)
    %Get function.
    %
    %
    %Usage: retval = getFunction (i = 0)
    %
    %i is of type int. i is of type int. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(789, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isBinary(self,varargin)
    %Is binary operation.
    %
    %
    %Usage: retval = isBinary ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(790, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isUnary(self,varargin)
    %Is unary operation.
    %
    %
    %Usage: retval = isUnary ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(791, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOp(self,varargin)
    %Get operation type.
    %
    %
    %Usage: retval = getOp ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(792, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getTemp(self,varargin)
    %[INTERNAL]  Get the temporary
    %variable
    %
    %
    %Usage: retval = getTemp ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(793, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setTemp(self,varargin)
    %[INTERNAL]  Set the temporary
    %variable.
    %
    %
    %Usage: setTemp (t)
    %
    %t is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(794, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = get(self,varargin)
    %>  void MX.get(MX &output_m, bool ind1, Slice rr) const
    %
    %>  void MX.get(MX &output_m, bool ind1, IMatrix rr) const
    %
    %>  void MX.get(MX &output_m, bool ind1, Sparsity sp) const 
    %------------------------------------------------------------------------
    %
    %Get a submatrix, single argument
    %
    %>  void MX.get(MX &output_m, bool ind1, Slice rr, Slice cc) const
    %
    %>  void MX.get(MX &output_m, bool ind1, Slice rr, IMatrix cc) const
    %
    %>  void MX.get(MX &output_m, bool ind1, IMatrix rr, Slice cc) const
    %
    %>  void MX.get(MX &output_m, bool ind1, IMatrix rr, IMatrix cc) const 
    %------------------------------------------------------------------------
    %
    %Get a submatrix, two arguments
    %
    %
    %Usage: get (ind1, rr, cc)
    %
    %ind1 is of type bool. rr is of type IMatrix. cc is of type IMatrix. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(800, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = set(self,varargin)
    %>  void MX.set(MX m, bool ind1, Slice rr)
    %
    %>  void MX.set(MX m, bool ind1, IMatrix rr)
    %
    %>  void MX.set(MX m, bool ind1, Sparsity sp)
    %------------------------------------------------------------------------
    %
    %Set a submatrix, single argument
    %
    %
    %Usage: set (m, ind1, rr, cc)
    %
    %m is of type MX. ind1 is of type bool. rr is of type IMatrix. cc is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(801, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getNZ(self,varargin)
    %Get a set of nonzeros
    %
    %
    %Usage: getNZ (ind1, kk)
    %
    %ind1 is of type bool. kk is of type IMatrix. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(802, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setNZ(self,varargin)
    %Set a set of nonzeros
    %
    %
    %Usage: setNZ (m, ind1, kk)
    %
    %m is of type MX. ind1 is of type bool. kk is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(803, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = append(self,varargin)
    %[DEPRECATED] Append a matrix vertically (NOTE: only efficient if vector)
    %
    %
    %Usage: append (y)
    %
    %y is of type MX. 

      try

      [varargout{1:nargout}] = casadiMEX(804, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = appendColumns(self,varargin)
    %[DEPRECATED] Append a matrix horizontally
    %
    %
    %Usage: appendColumns (y)
    %
    %y is of type MX. 

      try

      [varargout{1:nargout}] = casadiMEX(805, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printme(self,varargin)
    %Usage: retval = printme (y)
    %
    %y is of type MX. y is of type MX. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(806, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = attachAssert(self,varargin)
    %returns itself, but with an assertion attached
    %
    %If y does not evaluate to 1, a runtime error is raised
    %
    %
    %Usage: retval = attachAssert (y, fail_message = "")
    %
    %y is of type MX. fail_message is of type std::string const &. y is of type MX. fail_message is of type std::string const &. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(807, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = monitor(self,varargin)
    %Monitor an expression Returns itself, but with the side effect of printing
    %the nonzeros along with a comment.
    %
    %
    %Usage: retval = monitor (comment)
    %
    %comment is of type std::string const &. comment is of type std::string const &. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(808, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeDense(self,varargin)
    %[DEPRECATED: Use densify instead] Make the matrix dense
    %
    %
    %Usage: makeDense (val = 0)
    %
    %val is of type MX. 

      try

      [varargout{1:nargout}] = casadiMEX(809, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = lift(self,varargin)
    %[DEPRECATED] Lift an expression
    %
    %
    %Usage: lift (x_guess)
    %
    %x_guess is of type MX. 

      try

      [varargout{1:nargout}] = casadiMEX(810, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = T(self,varargin)
    %Transpose the matrix.
    %
    %
    %Usage: retval = T ()
    %
    %retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(811, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mapping(self,varargin)
    %Get an IMatrix representation of a GetNonzeros or SetNonzeros node.
    %
    %
    %Usage: retval = mapping ()
    %
    %retval is of type IMatrix. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(812, self, varargin{:});

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
    %Usage: retval = paren (rr, cc)
    %
    %rr is of type IMatrix. cc is of type IMatrix. rr is of type IMatrix. cc is of type IMatrix. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(816, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = paren_asgn(self,varargin)
    %Usage: paren_asgn (m, rr, cc)
    %
    %m is of type MX. rr is of type IMatrix. cc is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(817, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = brace(self,varargin)
    %Usage: retval = brace (rr)
    %
    %rr is of type IMatrix. rr is of type IMatrix. retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(818, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setbrace(self,varargin)
    %Usage: setbrace (m, rr)
    %
    %m is of type MX. rr is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(819, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = end(self,varargin)
    %Usage: retval = end (i, n)
    %
    %i is of type int. n is of type int. i is of type int. n is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(820, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ctranspose(self,varargin)
    %Usage: retval = ctranspose ()
    %
    %retval is of type MX. 

      try

      if ~isa(self,'casadi.MX')
        self = casadi.MX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(821, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = find(varargin)
    %Find first nonzero If failed, returns the number of rows.
    %
    %
    %Usage: retval = find (x)
    %
    %x is of type MX. x is of type MX. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(822, varargin{:});

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
  methods(Static)
    function varargout = binary(varargin)
    %Create nodes by their ID.
    %
    %
    %Usage: retval = binary (op, x, y)
    %
    %op is of type int. x is of type MX. y is of type MX. op is of type int. x is of type MX. y is of type MX. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(795, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unary(varargin)
    %Create nodes by their ID.
    %
    %
    %Usage: retval = unary (op, x)
    %
    %op is of type int. x is of type MX. op is of type int. x is of type MX. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(796, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inf(varargin)
    %create a matrix with all inf
    %
    %
    %Usage: retval = inf (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(797, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nan(varargin)
    %create a matrix with all nan
    %
    %
    %Usage: retval = nan (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(798, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eye(varargin)
    %Usage: retval = eye (ncol)
    %
    %ncol is of type int. ncol is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(799, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setEqualityCheckingDepth(varargin)
    %Usage: setEqualityCheckingDepth (eq_depth = 1)
    %
    %eq_depth is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(813, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getEqualityCheckingDepth(varargin)
    %Usage: retval = getEqualityCheckingDepth ()
    %
    %retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(814, varargin{:});

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

      [varargout{1:max(1,nargout)}] = casadiMEX(815, varargin{:});

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
