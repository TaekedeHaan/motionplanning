classdef IterationCallback < SwigRef
    %C++ includes: functor.hpp
    %
    %Usage: IterationCallback ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (fcn)
    %
    %fcn is of type Function. fcn is of type Function. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1083, self, varargin{:});

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
        casadiMEX(1084, self);
        self.swigPtr=[];
      end
    end
    function self = IterationCallback(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        if strcmp(class(self),'director_basic.IterationCallback')
          tmp = casadiMEX(1085, 0, varargin{:});
        else
          tmp = casadiMEX(1085, self, varargin{:});
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
