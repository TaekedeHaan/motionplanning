classdef OptionsFunctionality < casadi.SharedObject
    %Provides options setting/getting functionality.
    %
    %Gives a derived class the ability to set and retrieve options in a
    %convenient way. It also contains error checking, making sure that the option
    %exists and that the value type is correct.
    %
    %A derived class should add option names, types and default values to the
    %corresponding vectors.
    %
    %Joel Andersson
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
    %Diagrams
    %--------
    %
    %
    %
    %C++ includes: options_functionality.hpp 
    %Usage: OptionsFunctionality ()
    %
  methods
    function delete(self)
      if self.swigPtr
        casadiMEX(107, self);
        self.swigPtr=[];
      end
    end
    function varargout = getOption(self,varargin)
    %get an option value
    %
    %
    %Usage: retval = getOption (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type GenericType. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(108, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasOption(self,varargin)
    %check if there is an option str
    %
    %
    %Usage: retval = hasOption (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type bool. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(109, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasSetOption(self,varargin)
    %check if the user has there is an option str
    %
    %
    %Usage: retval = hasSetOption (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type bool. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(110, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printOptions(self,varargin)
    %Print options to a stream.
    %
    %
    %Usage: printOptions ()
    %

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:nargout}] = casadiMEX(111, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = copyOptions(self,varargin)
    %Copy all options from another object.
    %
    %
    %Usage: copyOptions (obj, skipUnknown = false)
    %
    %obj is of type OptionsFunctionality. skipUnknown is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(112, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = dictionary(self,varargin)
    %Get the dictionary.
    %
    %
    %Usage: retval = dictionary ()
    %
    %retval is of type casadi::Dict const &. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(113, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionNames(self,varargin)
    %Get a list of all option names.
    %
    %
    %Usage: retval = getOptionNames ()
    %
    %retval is of type std::vector< std::string,std::allocator< std::string > >. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(114, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionDescription(self,varargin)
    %Get the description of a certain option.
    %
    %
    %Usage: retval = getOptionDescription (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type std::string. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(115, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionType(self,varargin)
    %Get the type of a certain option.
    %
    %
    %Usage: retval = getOptionType (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type casadi::TypeID. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(116, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionTypeName(self,varargin)
    %Get the type name of a certain option.
    %
    %
    %Usage: retval = getOptionTypeName (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type std::string. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(117, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionAllowed(self,varargin)
    %Get the allowed values of a certain option.
    %
    %
    %Usage: retval = getOptionAllowed (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type std::vector< casadi::GenericType,std::allocator< casadi::GenericType > >. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(118, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionAllowedIndex(self,varargin)
    %[INTERNAL]  Get the index into allowed options of a certain option.
    %
    %
    %Usage: retval = getOptionAllowedIndex (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type int. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(119, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOptionByAllowedIndex(self,varargin)
    %[INTERNAL]  Set a certain option by giving its index into the allowed
    %values.
    %
    %
    %Usage: setOptionByAllowedIndex (name, i)
    %
    %name is of type std::string const &. i is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(120, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionEnumValue(self,varargin)
    %[INTERNAL]  Get the enum value corresponding to th certain option.
    %
    %
    %Usage: retval = getOptionEnumValue (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type int. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(121, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOptionByEnumValue(self,varargin)
    %[INTERNAL]  Set a certain option by giving an enum value.
    %
    %
    %Usage: setOptionByEnumValue (name, v)
    %
    %name is of type std::string const &. v is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(122, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptionDefault(self,varargin)
    %Get the default of a certain option.
    %
    %
    %Usage: retval = getOptionDefault (str)
    %
    %str is of type std::string const &. str is of type std::string const &. retval is of type GenericType. 

      try

      if ~isa(self,'casadi.OptionsFunctionality')
        self = casadi.OptionsFunctionality(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(123, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOption(self,varargin)
    %>  void OptionsFunctionality.setOption(str str, GenericType val)
    %------------------------------------------------------------------------
    %
    %[DEPRECATED: pass option dictionary to function constructor] Set an option.
    %For a list of options, check the class documentation of this class.
    %
    %The setOptions are only considered before the init function. If properties
    %changes, the init function should be called again.
    %
    %>  void OptionsFunctionality.setOption(Dict dict, bool skipUnknown=false)
    %------------------------------------------------------------------------
    %
    %[DEPRECATED: pass option dictionary to function constructor] Set a set of
    %options. For a list of options, check the class documentation of this class.
    %
    %The setOptions are only considered before the init function. If properties
    %changes, the init function should be called again.
    %
    %
    %Usage: setOption (name, val)
    %
    %name is of type std::string const &. val is of type std::vector< std::vector< int,std::allocator< int > >,std::allocator< std::vector< int,std::allocator< int > > > > const &. 

      try

      [varargout{1:nargout}] = casadiMEX(126, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = OptionsFunctionality(varargin)
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(127, varargin{:});
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
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(124, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addOptionRecipe(varargin)
    %Usage: retval = addOptionRecipe (dict, recipe)
    %
    %dict is of type casadi::Dict const &. recipe is of type std::string const &. dict is of type casadi::Dict const &. recipe is of type std::string const &. retval is of type casadi::Dict. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(125, varargin{:});

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
