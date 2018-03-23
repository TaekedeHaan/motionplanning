classdef Variable < casadi.PrintVariable
    %Usage: Variable ()
    %
  methods
    function varargout = name(self,varargin)
    %Usage: retval = name ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.Variable')
        self = casadi.Variable(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1238, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function v = v(self)
      v = casadiMEX(1239, self);
    end
    function v = d(self)
      v = casadiMEX(1240, self);
    end
    function v = nominal(self)
      v = casadiMEX(1241, self);
    end
    function v = start(self)
      v = casadiMEX(1242, self);
    end
    function v = min(self)
      v = casadiMEX(1243, self);
    end
    function v = max(self)
      v = casadiMEX(1244, self);
    end
    function v = initialGuess(self)
      v = casadiMEX(1245, self);
    end
    function v = derivativeStart(self)
      v = casadiMEX(1246, self);
    end
    function v = variability(self)
      v = casadiMEX(1247, self);
    end
    function v = causality(self)
      v = casadiMEX(1248, self);
    end
    function v = category(self)
      v = casadiMEX(1249, self);
    end
    function v = alias(self)
      v = casadiMEX(1250, self);
    end
    function v = description(self)
      v = casadiMEX(1251, self);
    end
    function v = valueReference(self)
      v = casadiMEX(1252, self);
    end
    function v = unit(self)
      v = casadiMEX(1253, self);
    end
    function v = displayUnit(self)
      v = casadiMEX(1254, self);
    end
    function v = free(self)
      v = casadiMEX(1255, self);
    end
    function varargout = print(self,varargin)
    %Usage: print (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.Variable')
        self = casadi.Variable(self);
      end
      [varargout{1:nargout}] = casadiMEX(1256, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = disp(self,varargin)
    %Usage: disp (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.Variable')
        self = casadi.Variable(self);
      end
      [varargout{1:nargout}] = casadiMEX(1257, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Variable(varargin)
      self@casadi.PrintVariable(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1258, varargin{:});
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
        casadiMEX(1259, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
