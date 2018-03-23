classdef ExpSX < casadi.GenericExpressionCommon
    %Expression interface.
    %
    %This is a common base class for SX, MX and Matrix<>, introducing a uniform
    %syntax and implementing common functionality using the curiously recurring
    %template pattern (CRTP) idiom. Joel Andersson
    %
    %C++ includes: generic_expression.hpp 
    %Usage: ExpSX ()
    %
  methods
    function self = ExpSX(varargin)
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(473, varargin{:});
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
        casadiMEX(474, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
