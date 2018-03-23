classdef IOInterfaceFunction < SwigRef
    %Usage: IOInterfaceFunction ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = getInput(self,varargin)
    %Usage: retval = getInput (iname)
    %
    %iname is of type std::string const &. iname is of type std::string const &. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.IOInterfaceFunction')
        self = casadi.IOInterfaceFunction(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(823, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOutput(self,varargin)
    %Usage: retval = getOutput (oname)
    %
    %oname is of type std::string const &. oname is of type std::string const &. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.IOInterfaceFunction')
        self = casadi.IOInterfaceFunction(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(824, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setInput(self,varargin)
    %Usage: setInput (val, iname)
    %
    %val is of type DMatrix. iname is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(825, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOutput(self,varargin)
    %Usage: setOutput (val, oname)
    %
    %val is of type DMatrix. oname is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(826, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setInputNZ(self,varargin)
    %Usage: setInputNZ (val, iname)
    %
    %val is of type DMatrix. iname is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(827, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOutputNZ(self,varargin)
    %Usage: setOutputNZ (val, oname)
    %
    %val is of type DMatrix. oname is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(828, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = IOInterfaceFunction(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(829, varargin{:});
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
        casadiMEX(830, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
