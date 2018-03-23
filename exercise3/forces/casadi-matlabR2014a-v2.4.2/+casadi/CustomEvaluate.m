classdef CustomEvaluate < casadi.Functor
    %CustomEvaluate.
    %
    %In C++, supply a CustomEvaluateCPtr function pointer
    %
    %In python, supply a callable, annotated with pyevaluate decorator
    %
    %C++ includes: functor.hpp 
    %Usage: CustomEvaluate ()
    %
  methods
    function varargout = paren(self,varargin)
    %Usage: paren (fcn, user_data)
    %
    %fcn is of type CustomFunction. user_data is of type void *. 

      try

      [varargout{1:nargout}] = casadiMEX(1080, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = CustomEvaluate(varargin)
      self@casadi.Functor(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1081, varargin{:});
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
        casadiMEX(1082, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
