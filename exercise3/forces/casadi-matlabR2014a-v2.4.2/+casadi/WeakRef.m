classdef WeakRef < casadi.SharedObject
    %[INTERNAL]  Weak reference type A
    %weak reference to a SharedObject.
    %
    %Joel Andersson
    %
    %C++ includes: weak_ref.hpp 
    %Usage: WeakRef ()
    %
  methods
    function varargout = shared(self,varargin)
    %[INTERNAL]  Get a shared
    %(owning) reference.
    %
    %
    %Usage: retval = shared ()
    %
    %retval is of type SharedObject. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(69, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = alive(self,varargin)
    %[INTERNAL]  Check if alive.
    %
    %
    %Usage: retval = alive ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.WeakRef')
        self = casadi.WeakRef(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(70, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = WeakRef(varargin)
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(71, varargin{:});
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
        casadiMEX(72, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
