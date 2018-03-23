classdef NlpBuilder < casadi.PrintNlpBuilder
    %A symbolic NLP representation.
    %
    %Joel Andersson
    %
    %C++ includes: nlp_builder.hpp 
    %Usage: NlpBuilder ()
    %
  methods
    function v = x(self)
      v = casadiMEX(1224, self);
    end
    function v = f(self)
      v = casadiMEX(1225, self);
    end
    function v = g(self)
      v = casadiMEX(1226, self);
    end
    function v = x_lb(self)
      v = casadiMEX(1227, self);
    end
    function v = x_ub(self)
      v = casadiMEX(1228, self);
    end
    function v = g_lb(self)
      v = casadiMEX(1229, self);
    end
    function v = g_ub(self)
      v = casadiMEX(1230, self);
    end
    function v = x_init(self)
      v = casadiMEX(1231, self);
    end
    function v = lambda_init(self)
      v = casadiMEX(1232, self);
    end
    function varargout = parseNL(self,varargin)
    %Parse an AMPL och PyOmo NL-file.
    %
    %
    %Usage: parseNL (filename, options = casadi::Dict())
    %
    %filename is of type std::string const &. options is of type casadi::Dict const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1233, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = print(self,varargin)
    %Print a description of the object.
    %
    %
    %Usage: print (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.NlpBuilder')
        self = casadi.NlpBuilder(self);
      end
      [varargout{1:nargout}] = casadiMEX(1234, self, varargin{:});

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
    %Print a representation of the object.
    %
    %
    %Usage: disp (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.NlpBuilder')
        self = casadi.NlpBuilder(self);
      end
      [varargout{1:nargout}] = casadiMEX(1235, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = NlpBuilder(varargin)
      self@casadi.PrintNlpBuilder(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1236, varargin{:});
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
        casadiMEX(1237, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
