classdef GenericType < casadi.SharedObject
    %Generic data type, can hold different types such as bool, int, string etc.
    %
    %Joel Andersson
    %
    %C++ includes: generic_type.hpp 
    %Usage: GenericType ()
    %
  methods
    function varargout = get_description(self,varargin)
    %Get a description of the object's type.
    %
    %
    %Usage: retval = get_description ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(74, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getType(self,varargin)
    %Usage: retval = getType ()
    %
    %retval is of type casadi::TypeID. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(76, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = can_cast_to(self,varargin)
    %Usage: retval = can_cast_to (other)
    %
    %other is of type GenericType. other is of type GenericType. retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(77, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isBool(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isBool ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(78, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isInt(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isInt ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(79, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isDouble(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isDouble ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(80, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isString(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isString ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(81, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isemptyVector(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isemptyVector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(82, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isIntVector(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isIntVector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(83, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isIntVectorVector(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isIntVectorVector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(84, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isDoubleVector(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isDoubleVector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(85, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isStringVector(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isStringVector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(86, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isDict(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isDict ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(87, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isFunction(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isFunction ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(88, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isVoidPointer(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isVoidPointer ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(89, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isCallback(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isCallback ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(90, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isDerivativeGenerator(self,varargin)
    %Check if a particular type.
    %
    %
    %Usage: retval = isDerivativeGenerator ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(91, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toBool(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toBool ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(92, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toInt(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toInt ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(93, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toDouble(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toDouble ()
    %
    %retval is of type double. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(94, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toString(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toString ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(95, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toIntVector(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toIntVector ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(96, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toIntVectorVector(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toIntVectorVector ()
    %
    %retval is of type std::vector< std::vector< int,std::allocator< int > >,std::allocator< std::vector< int,std::allocator< int > > > >. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(97, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toDoubleVector(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toDoubleVector ()
    %
    %retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(98, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toStringVector(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toStringVector ()
    %
    %retval is of type std::vector< std::string,std::allocator< std::string > >. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(99, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toDict(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toDict ()
    %
    %retval is of type casadi::GenericType::Dict. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(100, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toFunction(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toFunction ()
    %
    %retval is of type Function. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(101, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toVoidPointer(self,varargin)
    %Convert to a type.
    %
    %
    %Usage: retval = toVoidPointer ()
    %
    %retval is of type void *. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(102, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eq(self,varargin)
    %Usage: retval = eq (op2)
    %
    %op2 is of type GenericType. op2 is of type GenericType. retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(103, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ne(self,varargin)
    %Usage: retval = ne (op2)
    %
    %op2 is of type GenericType. op2 is of type GenericType. retval is of type bool. 

      try

      if ~isa(self,'casadi.GenericType')
        self = casadi.GenericType(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(104, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = GenericType(varargin)
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(105, varargin{:});
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
        casadiMEX(106, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = get_type_description(varargin)
    %Usage: retval = get_type_description (type)
    %
    %type is of type casadi::TypeID. type is of type casadi::TypeID. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(73, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = from_type(varargin)
    %Usage: retval = from_type (type)
    %
    %type is of type casadi::TypeID. type is of type casadi::TypeID. retval is of type GenericType. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(75, varargin{:});

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
