function varargout = collocationPoints(varargin)
    %Obtain collocation points of specific order and scheme.
    %
    %Parameters:
    %-----------
    %
    %scheme:  'radau' or 'legendre'
    %
    %
    %Usage: retval = collocationPoints (order, scheme = "radau")
    %
    %order is of type int. scheme is of type std::string const &. order is of type int. scheme is of type std::string const &. retval is of type std::vector< double,std::allocator< double > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1219,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
