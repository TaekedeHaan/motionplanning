classdef MatlabSwigIterator < SwigRef
    %Usage: MatlabSwigIterator ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(5, self);
        self.swigPtr=[];
      end
    end
    function varargout = value(self,varargin)
    %Usage: retval = value ()
    %
    %retval is of type mxArray *. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(6, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = incr(self,varargin)
    %Usage: retval = incr (n = 1)
    %
    %n is of type size_t. n is of type size_t. retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(7, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = decr(self,varargin)
    %Usage: retval = decr (n = 1)
    %
    %n is of type size_t. n is of type size_t. retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(8, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = distance(self,varargin)
    %Usage: retval = distance (x)
    %
    %x is of type MatlabSwigIterator. x is of type MatlabSwigIterator. retval is of type ptrdiff_t. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(9, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = equal(self,varargin)
    %Usage: retval = equal (x)
    %
    %x is of type MatlabSwigIterator. x is of type MatlabSwigIterator. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(10, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = copy(self,varargin)
    %Usage: retval = copy ()
    %
    %retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(11, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = next(self,varargin)
    %Usage: retval = next ()
    %
    %retval is of type mxArray *. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(12, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = previous(self,varargin)
    %Usage: retval = previous ()
    %
    %retval is of type mxArray *. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(13, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = advance(self,varargin)
    %Usage: retval = advance (n)
    %
    %n is of type ptrdiff_t. n is of type ptrdiff_t. retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(14, self, varargin{:});

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
    %Usage: retval = eq (x)
    %
    %x is of type MatlabSwigIterator. x is of type MatlabSwigIterator. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(15, self, varargin{:});

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
    %Usage: retval = ne (x)
    %
    %x is of type MatlabSwigIterator. x is of type MatlabSwigIterator. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(16, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = TODOincr(self,varargin)
    %Usage: retval = TODOincr ()
    %
    %retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(17, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = TODOdecr(self,varargin)
    %Usage: retval = TODOdecr ()
    %
    %retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(18, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = plus(self,varargin)
    %Usage: retval = plus (n)
    %
    %n is of type ptrdiff_t. n is of type ptrdiff_t. retval is of type MatlabSwigIterator. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(19, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = minus(self,varargin)
    %Usage: retval = minus (x)
    %
    %x is of type MatlabSwigIterator. x is of type MatlabSwigIterator. retval is of type ptrdiff_t. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(20, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = MatlabSwigIterator(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        error('No matching constructor');
      end
    end
  end
  methods(Static)
  end
end
