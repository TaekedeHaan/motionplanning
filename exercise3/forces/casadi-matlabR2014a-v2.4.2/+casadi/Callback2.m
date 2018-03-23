classdef Callback2 < SwigRef
    %C++ includes: callback.hpp 
    %Usage: Callback2 ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (arg)
    %
    %arg is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. arg is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > > const &. retval is of type std::vector< casadi::DMatrix,std::allocator< casadi::DMatrix > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1058, self, varargin{:});

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
    %Number of input arguments.
    %
    %Specify the number of input arguments that a specific instance can handle.
    %The number must not be changed over the lifetime of the object
    %
    %Default implementation: 1
    %
    %
    %Usage: retval = nIn ()
    %
    %retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1059, self, varargin{:});

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
    %Number of output arguments.
    %
    %Specify the number of output arguments that a specific instance can handle.
    %The number must not be changed over the lifetime of the object
    %
    %Default implementation: 1
    %
    %
    %Usage: retval = nOut ()
    %
    %retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1060, self, varargin{:});

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
    %Specify input sparsity.
    %
    %Specify the sparsity corresponding to a given input. The sparsity must not
    %be changed over the lifetime of the object
    %
    %Default implementation: dense using inputShape
    %
    %
    %Usage: retval = inputSparsity (i)
    %
    %i is of type int. i is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1061, self, varargin{:});

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
    %Specify output sparsity.
    %
    %Specify the sparsity corresponding to a given output. The sparsity must not
    %be changed over the lifetime of the object
    %
    %Default implementation: dense using outputShape
    %
    %
    %Usage: retval = outputSparsity (i)
    %
    %i is of type int. i is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1062, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inputShape(self,varargin)
    %Specify input shape.
    %
    %Specify the shape corresponding to a given input. The shape must not be
    %changed over the lifetime of the object
    %
    %Default implementation: scalar (1,1)
    %
    %
    %Usage: retval = inputShape (i)
    %
    %i is of type int. i is of type int. retval is of type std::pair< int,int >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1063, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outputShape(self,varargin)
    %Specify output shape.
    %
    %Specify the shape corresponding to a given output. The shape must not be
    %changed over the lifetime of the object
    %
    %Default implementation: scalar (1,1)
    %
    %
    %Usage: retval = outputShape (i)
    %
    %i is of type int. i is of type int. retval is of type std::pair< int,int >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1064, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = name(self,varargin)
    %Specify the name of the object.
    %
    %
    %Usage: retval = name ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1065, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = options(self,varargin)
    %Specify the options of the object.
    %
    %
    %Usage: retval = options ()
    %
    %retval is of type casadi::Dict. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1066, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = create(self,varargin)
    %Usage: retval = create ()
    %
    %retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1067, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1068, self);
        self.swigPtr=[];
      end
    end
    function self = Callback2(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        if strcmp(class(self),'director_basic.Callback2')
          tmp = casadiMEX(1069, 0, varargin{:});
        else
          tmp = casadiMEX(1069, self, varargin{:});
        end
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
  end
end
