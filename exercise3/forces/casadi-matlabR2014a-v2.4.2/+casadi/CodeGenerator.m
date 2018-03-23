classdef CodeGenerator < SwigRef
    %C++ includes:
    %code_generator.hpp 
    %Usage: CodeGenerator ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = CodeGenerator(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(894, varargin{:});
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
    function varargout = add(self,varargin)
    %>  void CodeGenerator.add(Function f)
    %------------------------------------------------------------------------
    %
    %Add a function (name generated)
    %
    %>  void CodeGenerator.add(Function f, str fname)
    %------------------------------------------------------------------------
    %
    %Add a function.
    %
    %
    %Usage: add (f, fname)
    %
    %f is of type Function. fname is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(895, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = generate(self,varargin)
    %>  void CodeGenerator.generate(str name) const 
    %------------------------------------------------------------------------
    %
    %Generate a file.
    %
    %>  str CodeGenerator.generate() const 
    %------------------------------------------------------------------------
    %
    %Generate a file, return code as string.
    %
    %
    %Usage: retval = generate ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.CodeGenerator')
        self = casadi.CodeGenerator(self);
      end
      [varargout{1:nargout}] = casadiMEX(896, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = compile(self,varargin)
    %Compile and load function.
    %
    %
    %Usage: retval = compile (name, compiler = "gcc -fPIC -O2")
    %
    %name is of type std::string const &. compiler is of type std::string const &. name is of type std::string const &. compiler is of type std::string const &. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(897, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addInclude(self,varargin)
    %Add an include file optionally using a relative path "..." instead of an
    %absolute path <...>
    %
    %
    %Usage: addInclude (new_include, relative_path = false, use_ifdef = std::string())
    %
    %new_include is of type std::string const &. relative_path is of type bool. use_ifdef is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(898, self, varargin{:});

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
        casadiMEX(899, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
