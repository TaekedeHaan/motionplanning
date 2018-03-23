classdef Callback < casadi.Functor
    %Callback.
    %
    %In C++, supply a CallbackCPtr function pointer When the callback function
    %returns a non-zero integer, the host is signalled of a problem. E.g. an
    %NlpSolver may halt iterations if the Callback is something else than 0
    %
    %In python, supply a callable, annotated with pycallback decorator
    %
    %C++ includes: functor.hpp 
    %Usage: Callback ()
    %
  methods
    function varargout = paren(self,varargin)
    %Usage: retval = paren (fcn, user_data)
    %
    %fcn is of type Function. user_data is of type void *. fcn is of type Function. user_data is of type void *. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1086, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Callback(varargin)
      self@casadi.Functor(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1087, varargin{:});
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
        casadiMEX(1088, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
