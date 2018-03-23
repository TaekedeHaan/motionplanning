function varargout = complement(varargin)
    %Returns the list of all i in [0, size[ not found in supplied list.
    %
    %The supplied vector may contain duplicates and may be non-monotonous The
    %supplied vector will be checked for bounds The result vector is guaranteed
    %to be monotonously increasing
    %
    %
    %Usage: retval = complement (v, $ignore)
    %
    %v is of type std::vector< int,std::allocator< int > > const &. $ignore is of type int. v is of type std::vector< int,std::allocator< int > > const &. $ignore is of type int. retval is of type std::vector< int,std::allocator< int > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(67,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
