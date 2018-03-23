function varargout = extractShared(varargin)
    %Extract shared subexpressions from an set of expressions.
    %
    %
    %Usage: extractShared (ex, v_prefix = "v_", v_suffix = "")
    %
    %ex is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. v_prefix is of type std::string const &. v_suffix is of type std::string const &. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(902,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
