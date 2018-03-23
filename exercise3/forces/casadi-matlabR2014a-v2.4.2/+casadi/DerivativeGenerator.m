classdef DerivativeGenerator < casadi.Functor
    %Derivative Generator Functor.
    %
    %In C++, supply a DerivativeGeneratorCPtr function pointer
    %
    %In python, supply a callable, annotated with derivativegenerator decorator
    %
    %C++ includes: functor.hpp 
    %Usage: DerivativeGenerator ()
    %
  methods
    function varargout = paren(self,varargin)
    %Usage: retval = paren (fcn, ndir, user_data)
    %
    %fcn is of type Function. ndir is of type int. user_data is of type void *. fcn is of type Function. ndir is of type int. user_data is of type void *. retval is of type Function. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1077, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = DerivativeGenerator(varargin)
      self@casadi.Functor(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1078, varargin{:});
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
        casadiMEX(1079, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
