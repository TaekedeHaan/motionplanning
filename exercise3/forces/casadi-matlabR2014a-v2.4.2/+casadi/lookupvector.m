function varargout = lookupvector(varargin)
    %Returns a vector for quickly looking up entries of supplied list.
    %
    %lookupvector[i]!=-1 <=> v contains i v[lookupvector[i]] == i <=> v contains
    %i
    %
    %Duplicates are treated by looking up last occurrence
    %
    %
    %Usage: retval = lookupvector (v, $ignore)
    %
    %v is of type std::vector< int,std::allocator< int > > const &. $ignore is of type int. v is of type std::vector< int,std::allocator< int > > const &. $ignore is of type int. retval is of type std::vector< int,std::allocator< int > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(68,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
