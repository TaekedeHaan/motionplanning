function varargout = hash_combine(varargin)
    %>  void hash_combine(std.size_t &seed, T v)
    %
    %>  void hash_combine(std.size_t &seed, [int ] v)
    %------------------------------------------------------------------------
    %[INTERNAL] 
    %Generate a hash value incrementally (function taken from boost)
    %
    %>  void hash_combine(std.size_t &seed, const int *v, int sz)
    %------------------------------------------------------------------------
    %[INTERNAL] 
    %Generate a hash value incrementally, array.
    %
    %
    %Usage: hash_combine (seed, v)
    %
    %seed is of type std::size_t &. v is of type std::vector< int,std::allocator< int > > const &. 

      try

  [varargout{1:nargout}] = casadiMEX(248,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
