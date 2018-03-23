classdef CasadiMeta < SwigRef
    %Collects global CasADi meta information.
    %
    %Joris Gillis
    %
    %C++ includes: casadi_meta.hpp 
    %Usage: CasadiMeta ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = CasadiMeta(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1217, varargin{:});
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
        casadiMEX(1218, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = getVersion(varargin)
    %Usage: retval = getVersion ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1206, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getGitRevision(varargin)
    %Usage: retval = getGitRevision ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1207, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getGitDescribe(varargin)
    %Usage: retval = getGitDescribe ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1208, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getFeatureList(varargin)
    %Usage: retval = getFeatureList ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1209, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getBuildType(varargin)
    %Usage: retval = getBuildType ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1210, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCompilerId(varargin)
    %Usage: retval = getCompilerId ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1211, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCompiler(varargin)
    %Usage: retval = getCompiler ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1212, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCompilerFlags(varargin)
    %Usage: retval = getCompilerFlags ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1213, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getModules(varargin)
    %Usage: retval = getModules ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1214, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getPlugins(varargin)
    %Usage: retval = getPlugins ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1215, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getInstallPrefix(varargin)
    %Usage: retval = getInstallPrefix ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1216, varargin{:});

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
