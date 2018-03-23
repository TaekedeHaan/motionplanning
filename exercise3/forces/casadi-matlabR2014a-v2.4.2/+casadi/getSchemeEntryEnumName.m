function varargout = getSchemeEntryEnumName(varargin)
    %Usage: retval = getSchemeEntryEnumName (scheme, i)
    %
    %scheme is of type casadi::InputOutputScheme. i is of type int. scheme is of type casadi::InputOutputScheme. i is of type int. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(23,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
