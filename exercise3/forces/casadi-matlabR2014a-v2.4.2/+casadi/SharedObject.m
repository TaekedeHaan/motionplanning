classdef SharedObject < casadi.PrintSharedObject
    %SharedObject implements a reference counting framework similar for efficient
    %and easily-maintained memory management.
    %
    %To use the class, both the SharedObject class (the public class), and the
    %SharedObjectNode class (the internal class) must be inherited from. It can
    %be done in two different files and together with memory management, this
    %approach provides a clear distinction of which methods of the class are to
    %be considered "public", i.e. methods for public use that can be considered
    %to remain over time with small changes, and the internal memory.
    %
    %When interfacing a software, which typically includes including some header
    %file, this is best done only in the file where the internal class is
    %defined, to avoid polluting the global namespace and other side effects.
    %
    %The default constructor always means creating a null pointer to an internal
    %class only. To allocate an internal class (this works only when the internal
    %class isn't abstract), use the constructor with arguments.
    %
    %The copy constructor and the assignment operator perform shallow copies
    %only, to make a deep copy you must use the clone method explicitly. This
    %will give a shared pointer instance.
    %
    %In an inheritance hierarchy, you can cast down automatically, e.g. (
    %SXFunction is a child class of Function): SXFunction derived(...); Function
    %base = derived;
    %
    %To cast up, use the shared_cast template function, which works analogously
    %to dynamic_cast, static_cast, const_cast etc, e.g.: SXFunction derived(...);
    %Function base = derived; SXFunction derived_from_base =
    %shared_cast<SXFunction>(base);
    %
    %A failed shared_cast will result in a null pointer (cf. dynamic_cast)
    %
    %Joel Andersson
    %
    %C++ includes: shared_object.hpp 
    %Usage: SharedObject ()
    %
  methods
    function varargout = disp(self,varargin)
    %Print a representation of the object.
    %
    %
    %Usage: disp (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:nargout}] = casadiMEX(56, self, varargin{:});

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

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:nargout}] = casadiMEX(57, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printPtr(self,varargin)
    %[INTERNAL]  Print the
    %pointer to the internal class
    %
    %
    %Usage: printPtr ()
    %

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:nargout}] = casadiMEX(58, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = init(self,varargin)
    %[DEPRECATED] Initialize or re-initialize the object:
    %
    %more documentation in the node class (SharedObjectNode and derived classes)
    %
    %
    %Usage: init (allow_reinit = true)
    %
    %allow_reinit is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(59, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isInit(self,varargin)
    %Is initialized?
    %
    %
    %Usage: retval = isInit ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(60, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = assertInit(self,varargin)
    %[INTERNAL]  Assert
    %that it is initialized
    %
    %
    %Usage: assertInit ()
    %

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:nargout}] = casadiMEX(61, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isNull(self,varargin)
    %Is a null pointer?
    %
    %
    %Usage: retval = isNull ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(62, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeUnique(self,varargin)
    %Make unique.
    %
    %If there are other references to the object, then make a deep copy of it and
    %point to this new object
    %
    %
    %Usage: makeUnique (clone_members = true)
    %
    %clone_members is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(63, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hash(self,varargin)
    %Returns a number that is unique for a given Node. If the Object does not
    %point to any node, "0" is returned.
    %
    %
    %Usage: retval = hash ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.SharedObject')
        self = casadi.SharedObject(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(64, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = SharedObject(varargin)
      self@casadi.PrintSharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(65, varargin{:});
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
        casadiMEX(66, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
