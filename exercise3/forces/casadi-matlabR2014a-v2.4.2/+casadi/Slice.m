classdef Slice < casadi.PrintSlice
    %Class representing a Slice.
    %
    %Note that Python or Octave do not need to use this class. They can just use
    %slicing utility from the host language ( M[0:6] in Python, M(1:7) )
    %
    %C++ includes: slice.hpp 
    %Usage: Slice ()
    %
  methods
    function varargout = getAll(self,varargin)
    %>  [int] Slice.getAll(int len, bool ind1=false) const 
    %------------------------------------------------------------------------
    %
    %Get a vector of indices.
    %
    %>  [int] Slice.getAll(Slice outer, int len) const 
    %------------------------------------------------------------------------
    %
    %Get a vector of indices (nested slice)
    %
    %
    %Usage: retval = getAll (outer, len)
    %
    %outer is of type Slice. len is of type int. outer is of type Slice. len is of type int. retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(252, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isscalar(self,varargin)
    %Is the slice a scalar.
    %
    %
    %Usage: retval = isscalar (len)
    %
    %len is of type int. len is of type int. retval is of type bool. 

      try

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(253, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toScalar(self,varargin)
    %Get scalar (if isscalar)
    %
    %
    %Usage: retval = toScalar (len)
    %
    %len is of type int. len is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(254, self, varargin{:});

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
    %Usage: retval = eq (other)
    %
    %other is of type Slice. other is of type Slice. retval is of type bool. 

      try

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(255, self, varargin{:});

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
    %Usage: retval = ne (other)
    %
    %other is of type Slice. other is of type Slice. retval is of type bool. 

      try

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(256, self, varargin{:});

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

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:nargout}] = casadiMEX(257, self, varargin{:});

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

      if ~isa(self,'casadi.Slice')
        self = casadi.Slice(self);
      end
      [varargout{1:nargout}] = casadiMEX(258, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function v = start_(self)
      v = casadiMEX(259, self);
    end
    function v = stop_(self)
      v = casadiMEX(260, self);
    end
    function v = step_(self)
      v = casadiMEX(261, self);
    end
    function self = Slice(varargin)
      self@casadi.PrintSlice(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(262, varargin{:});
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
        casadiMEX(263, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = isSlice(varargin)
    %Usage: retval = isSlice (v, ind1 = false)
    %
    %v is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. v is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(250, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isSlice2(varargin)
    %Usage: retval = isSlice2 (v)
    %
    %v is of type std::vector< int,std::allocator< int > > const &. v is of type std::vector< int,std::allocator< int > > const &. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(251, varargin{:});

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
