classdef SpSparsity < casadi.SparsityInterfaceCommon
    %Sparsity interface class.
    %
    %This is a common base class for GenericMatrix (i.e. MX and Matrix<>) and
    %Sparsity, introducing a uniform syntax and implementing common functionality
    %using the curiously recurring template pattern (CRTP) idiom. Joel Andersson
    %
    %C++ includes: sparsity_interface.hpp 
    %Usage: SpSparsity ()
    %
  methods
    function self = SpSparsity(varargin)
      self@casadi.SparsityInterfaceCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(153, varargin{:});
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
        casadiMEX(154, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
