classdef CasadiOptions < SwigRef
    %Collects global CasADi options.
    %
    %Note to developers: use sparingly. Global options are - in general - a
    %rather bad idea
    %
    %this class must never be instantiated. Access its static members directly
    %Joris Gillis
    %
    %C++ includes: casadi_options.hpp 
    %Usage: CasadiOptions ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = CasadiOptions(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1204, varargin{:});
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
        casadiMEX(1205, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = setCatchErrorsSwig(varargin)
    %Usage: setCatchErrorsSwig (flag)
    %
    %flag is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1189, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCatchErrorsSwig(varargin)
    %Usage: retval = getCatchErrorsSwig ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1190, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setSimplificationOnTheFly(varargin)
    %Usage: setSimplificationOnTheFly (flag)
    %
    %flag is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1191, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getSimplificationOnTheFly(varargin)
    %Usage: retval = getSimplificationOnTheFly ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1192, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = startProfiling(varargin)
    %Usage: startProfiling (filename)
    %
    %filename is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1193, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = stopProfiling(varargin)
    %Usage: stopProfiling ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1194, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setProfilingBinary(varargin)
    %Usage: setProfilingBinary (flag)
    %
    %flag is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1195, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getProfilingBinary(varargin)
    %Usage: retval = getProfilingBinary ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1196, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setPurgeSeeds(varargin)
    %Usage: retval = setPurgeSeeds ()
    %
    %retval is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1197, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setAllowedInternalAPI(varargin)
    %Usage: setAllowedInternalAPI (flag)
    %
    %flag is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1198, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getAllowedInternalAPI(varargin)
    %Usage: retval = getAllowedInternalAPI ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1199, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setCasadiPath(varargin)
    %Usage: setCasadiPath (path)
    %
    %path is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1200, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCasadiPath(varargin)
    %Usage: retval = getCasadiPath ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1201, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setOptimizedNumDir(varargin)
    %Usage: setOptimizedNumDir (n)
    %
    %n is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(1202, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOptimizedNumDir(varargin)
    %Usage: retval = getOptimizedNumDir ()
    %
    %retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1203, varargin{:});

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
