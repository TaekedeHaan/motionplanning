classdef DerivativeGenerator2 < SwigRef
    %C++ includes:
    %callback.hpp 
    %Usage: DerivativeGenerator2 ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (fcn, ndir)
    %
    %fcn is of type Function. ndir is of type int. fcn is of type Function. ndir is of type int. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1070, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = original(self,varargin)
    %Computes the derivative as if this derivative generator does not exist.
    %
    %
    %Usage: retval = original (fcn, ndir, fwd)
    %
    %fcn is of type Function. ndir is of type int. fwd is of type bool. fcn is of type Function. ndir is of type int. fwd is of type bool. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1071, self, varargin{:});

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
    %retval is of type DerivativeGenerator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1072, self, varargin{:});

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
        casadiMEX(1073, self);
        self.swigPtr=[];
      end
    end
    function self = DerivativeGenerator2(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        if strcmp(class(self),'director_basic.DerivativeGenerator2')
          tmp = casadiMEX(1074, 0, varargin{:});
        else
          tmp = casadiMEX(1074, self, varargin{:});
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
