function varargout = getSchemeEntryEnum(varargin)
    %Usage: retval = getSchemeEntryEnum (scheme, name)
    %
    %scheme is of type casadi::InputOutputScheme. name is of type std::string const &. scheme is of type casadi::InputOutputScheme. name is of type std::string const &. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(24,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
