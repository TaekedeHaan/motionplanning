function varargout = hash_sparsity(varargin)
    %>  std.size_t hash_sparsity(int nrow, int ncol, [int ] colind, [int ] row)
    %------------------------------------------------------------------------
    %[INTERNAL] 
    %Hash a sparsity pattern.
    %
    %>  std.size_t hash_sparsity(int nrow, int ncol, const int *colind, const int *row)
    %------------------------------------------------------------------------
    %[INTERNAL] 
    %
    %Usage: retval = hash_sparsity (nrow, ncol, colind, row)
    %
    %nrow is of type int. ncol is of type int. colind is of type int const *. row is of type int const *. nrow is of type int. ncol is of type int. colind is of type int const *. row is of type int const *. retval is of type std::size_t. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(249,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
