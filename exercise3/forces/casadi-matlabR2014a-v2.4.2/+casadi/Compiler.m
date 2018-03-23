classdef Compiler < casadi.OptionsFunctionality
    %Compiler.
    %
    %Just-in-time compilation of code
    %
    %General information
    %===================
    %
    %
    %
    %>List of available options
    %
    %+--------------+--------------+--------------+--------------+--------------+
    %|      Id      |     Type     |   Default    | Description  |   Used in    |
    %+==============+==============+==============+==============+==============+
    %| defaults_rec | OT_STRINGVEC | GenericType( | Changes      | casadi::Opti |
    %| ipes         | TOR          | )            | default      | onsFunctiona |
    %|              |              |              | options      | lityNode     |
    %|              |              |              | according to |              |
    %|              |              |              | a given      |              |
    %|              |              |              | recipe (low- |              |
    %|              |              |              | level)       |              |
    %+--------------+--------------+--------------+--------------+--------------+
    %| name         | OT_STRING    | "unnamed_sha | name of the  | casadi::Opti |
    %|              |              | red_object"  | object       | onsFunctiona |
    %|              |              |              |              | lityNode     |
    %+--------------+--------------+--------------+--------------+--------------+
    %
    %List of plugins
    %===============
    %
    %
    %
    %- clang
    %
    %- shell
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Compiler.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %clang
    %-----
    %
    %
    %
    %Interface to the JIT compiler CLANG
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| flags           | OT_STRINGVECTOR | GenericType()   | Compile flags   |
    %|                 |                 |                 | for the JIT     |
    %|                 |                 |                 | compiler.       |
    %|                 |                 |                 | Default: None   |
    %+-----------------+-----------------+-----------------+-----------------+
    %| include_path    | OT_STRING       | ""              | Include paths   |
    %|                 |                 |                 | for the JIT     |
    %|                 |                 |                 | compiler. The   |
    %|                 |                 |                 | include         |
    %|                 |                 |                 | directory       |
    %|                 |                 |                 | shipped with    |
    %|                 |                 |                 | CasADi will be  |
    %|                 |                 |                 | automatically   |
    %|                 |                 |                 | appended.       |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %shell
    %-----
    %
    %
    %
    %Interface to the JIT compiler SHELL
    %
    %>List of available options
    %
    %+-----------------+-----------------+-----------------+-----------------+
    %|       Id        |      Type       |     Default     |   Description   |
    %+=================+=================+=================+=================+
    %| compiler        | OT_STRING       | "gcc"           | Compiler        |
    %|                 |                 |                 | command         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| compiler_setup  | OT_STRING       | "-fPIC -shared" | Compiler setup  |
    %|                 |                 |                 | command         |
    %+-----------------+-----------------+-----------------+-----------------+
    %| flags           | OT_STRINGVECTOR | GenericType()   | Compile flags   |
    %|                 |                 |                 | for the JIT     |
    %|                 |                 |                 | compiler.       |
    %|                 |                 |                 | Default: None   |
    %+-----------------+-----------------+-----------------+-----------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joris Gillis
    %Diagrams
    %--------
    %
    %
    %
    %C++ includes: compiler.hpp 
    %Usage: Compiler ()
    %
  methods
    function varargout = plugin_name(self,varargin)
    %Query plugin name.
    %
    %
    %Usage: retval = plugin_name ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.Compiler')
        self = casadi.Compiler(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(939, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Compiler(varargin)
      self@casadi.OptionsFunctionality(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(940, varargin{:});
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
        casadiMEX(941, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(935, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasPlugin(varargin)
    %Usage: retval = hasPlugin (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(936, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = loadPlugin(varargin)
    %Usage: loadPlugin (name)
    %
    %name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(937, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = doc(varargin)
    %Usage: retval = doc (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(938, varargin{:});

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
