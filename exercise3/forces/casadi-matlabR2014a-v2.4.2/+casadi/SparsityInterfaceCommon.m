classdef SparsityInterfaceCommon < SwigRef
    %Usage: SparsityInterfaceCommon ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = horzcat(varargin)
    %>  MatType horzcat([MatType ] v)
    %------------------------------------------------------------------------
    %
    %Concatenate a list of matrices horizontally Alternative terminology:
    %horizontal stack, hstack, horizontal append, [a b].
    %
    %horzcat(horzsplit(x, ...)) = x
    %
    %>  MatType horzcat(MatType x, MatType y)
    %------------------------------------------------------------------------
    %
    %Concatenate horizontally, two matrices.
    %
    %>  MatType horzcat(MatType x, MatType y, MatType z)
    %------------------------------------------------------------------------
    %
    %Concatenate horizontally, three matrices.
    %
    %>  MatType horzcat(MatType x, MatType y, MatType z, MatType w)
    %------------------------------------------------------------------------
    %
    %Concatenate horizontally, four matrices.
    %
    %
    %Usage: retval = horzcat (v)
    %
    %v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(128, varargin);

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = vertcat(varargin)
    %>  MatType vertcat([MatType ] v)
    %------------------------------------------------------------------------
    %
    %Concatenate a list of matrices vertically Alternative terminology: vertical
    %stack, vstack, vertical append, [a;b].
    %
    %vertcat(vertsplit(x, ...)) = x
    %
    %>  MatType vertcat(MatType x, MatType y)
    %------------------------------------------------------------------------
    %
    %Concatenate vertically, two matrices.
    %
    %>  MatType vertcat(MatType x, MatType y, MatType z)
    %------------------------------------------------------------------------
    %
    %Concatenate vertically, three matrices.
    %
    %>  MatType vertcat(MatType x, MatType y, MatType z, MatType w)
    %------------------------------------------------------------------------
    %
    %Concatenate vertically, four matrices.
    %
    %
    %Usage: retval = vertcat (v)
    %
    %v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(129, varargin);

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = horzsplit(varargin)
    %>  [MatType ] horzsplit(MatType v, [int ] offset)
    %------------------------------------------------------------------------
    %
    %split horizontally, retaining groups of columns
    %
    %Parameters:
    %-----------
    %
    %offset:  List of all start columns for each group the last column group will
    %run to the end.
    %
    %horzcat(horzsplit(x, ...)) = x
    %
    %>  [MatType ] horzsplit(MatType v, int incr=1)
    %------------------------------------------------------------------------
    %
    %split horizontally, retaining fixed-sized groups of columns
    %
    %Parameters:
    %-----------
    %
    %incr:  Size of each group of columns
    %
    %horzcat(horzsplit(x, ...)) = x
    %
    %
    %Usage: retval = horzsplit (v, incr = 1)
    %
    %v is of type SX. incr is of type int. v is of type SX. incr is of type int. retval is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(130, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = offset(varargin)
    %Helper function, get offsets corresponding to a vector of matrices.
    %
    %
    %Usage: retval = offset (v, vert = true)
    %
    %v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. vert is of type bool. v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. vert is of type bool. retval is of type std::vector< int,std::allocator< int > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(131, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = vertsplit(varargin)
    %>  [MatType ] vertsplit(MatType v, [int ] offset)
    %------------------------------------------------------------------------
    %
    %split vertically, retaining groups of rows
    %
    %*
    %
    %Parameters:
    %-----------
    %
    %output_offset:  List of all start rows for each group the last row group
    %will run to the end.
    %
    %vertcat(vertsplit(x, ...)) = x
    %
    %>  [MatType ] vertsplit(MatType v, int incr=1)
    %------------------------------------------------------------------------
    %
    %split vertically, retaining fixed-sized groups of rows
    %
    %Parameters:
    %-----------
    %
    %incr:  Size of each group of rows
    %
    %vertcat(vertsplit(x, ...)) = x
    %
    %
    %
    %::
    %
    %  >>> print vertsplit(SX.sym("a",4))
    %  [SX(a_0), SX(a_1), SX(a_2), SX(a_3)]
    %  
    %
    %
    %
    %
    %
    %::
    %
    %  >>> print vertsplit(SX.sym("a",4),2)
    %  [SX([a_0, a_1]), SX([a_2, a_3])]
    %  
    %
    %
    %
    %If the number of rows is not a multiple of incr, the last entry returned
    %will have a size smaller than incr.
    %
    %
    %
    %::
    %
    %  >>> print vertsplit(DMatrix([0,1,2,3,4]),2)
    %  [DMatrix([0, 1]), DMatrix([2, 3]), DMatrix(4)]
    %  
    %
    %
    %
    %
    %Usage: retval = vertsplit (v, incr = 1)
    %
    %v is of type SX. incr is of type int. v is of type SX. incr is of type int. retval is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(132, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = blockcat(varargin)
    %>  MatType blockcat([[MatType ] ] v)
    %------------------------------------------------------------------------
    %
    %Construct a matrix from a list of list of blocks.
    %
    %>  MatType blockcat(MatType A, MatType B, MatType C, MatType D)
    %------------------------------------------------------------------------
    %
    %Construct a matrix from 4 blocks.
    %
    %
    %Usage: retval = blockcat (A, B, C, D)
    %
    %A is of type SX. B is of type SX. C is of type SX. D is of type SX. A is of type SX. B is of type SX. C is of type SX. D is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(133, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = blocksplit(varargin)
    %>  [[MatType ] ] blocksplit(MatType x, [int ] vert_offset, [int ] horz_offset)
    %------------------------------------------------------------------------
    %
    %chop up into blocks
    %
    %Parameters:
    %-----------
    %
    %vert_offset:  Defines the boundaries of the block rows
    %
    %horz_offset:  Defines the boundaries of the block columns
    %
    %blockcat(blocksplit(x,..., ...)) = x
    %
    %>  [[MatType ] ] blocksplit(MatType x, int vert_incr=1, int horz_incr=1)
    %------------------------------------------------------------------------
    %
    %chop up into blocks
    %
    %Parameters:
    %-----------
    %
    %vert_incr:  Defines the increment for block boundaries in row dimension
    %
    %horz_incr:  Defines the increment for block boundaries in column dimension
    %
    %blockcat(blocksplit(x,..., ...)) = x
    %
    %
    %Usage: retval = blocksplit (x, vert_incr = 1, horz_incr = 1)
    %
    %x is of type SX. vert_incr is of type int. horz_incr is of type int. x is of type SX. vert_incr is of type int. horz_incr is of type int. retval is of type std::vector< std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >,std::allocator< std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(134, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = diagcat(varargin)
    %>  MatType diagcat([MatType ] A)
    %------------------------------------------------------------------------
    %
    %Construct a matrix with given block on the diagonal.
    %
    %>  MatType diagcat(MatType x, MatType y)
    %------------------------------------------------------------------------
    %
    %Concatenate along diagonal, two matrices.
    %
    %>  MatType diagcat(MatType x, MatType y, MatType z)
    %------------------------------------------------------------------------
    %
    %Concatenate along diagonal, three matrices.
    %
    %>  MatType diagcat(MatType x, MatType y, MatType z, MatType w)
    %------------------------------------------------------------------------
    %
    %Concatenate along diagonal, four matrices.
    %
    %
    %Usage: retval = diagcat (A)
    %
    %A is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. A is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(135, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = diagsplit(varargin)
    %>  [MatType ] diagsplit(MatType x, [int ] output_offset1, [int ] output_offset2)
    %------------------------------------------------------------------------
    %
    %split diagonally, retaining square matrices
    %
    %Parameters:
    %-----------
    %
    %output_offset1:  List of all start locations (row) for each group the last
    %matrix will run to the end.
    %
    %output_offset2:  List of all start locations (row) for each group the last
    %matrix will run to the end.
    %
    %diagcat(diagsplit(x, ...)) = x
    %
    %>  [MatType ] diagsplit(MatType x, [int ] output_offset)
    %------------------------------------------------------------------------
    %
    %split diagonally, retaining square matrices
    %
    %Parameters:
    %-----------
    %
    %output_offset:  List of all start locations for each group the last matrix
    %will run to the end.
    %
    %diagcat(diagsplit(x, ...)) = x
    %
    %>  [MatType ] diagsplit(MatType x, int incr=1)
    %------------------------------------------------------------------------
    %
    %split diagonally, retaining groups of square matrices
    %
    %Parameters:
    %-----------
    %
    %incr:  Size of each matrix
    %
    %diagsplit(diagsplit(x, ...)) = x
    %
    %>  [MatType ] diagsplit(MatType x, int incr1, int incr2)
    %------------------------------------------------------------------------
    %
    %split diagonally, retaining fixed-sized matrices
    %
    %Parameters:
    %-----------
    %
    %incr1:  Row dimension of each matrix
    %
    %incr2:  Column dimension of each matrix
    %
    %diagsplit(diagsplit(x, ...)) = x
    %
    %
    %Usage: retval = diagsplit (x, incr1, incr2)
    %
    %x is of type SX. incr1 is of type int. incr2 is of type int. x is of type SX. incr1 is of type int. incr2 is of type int. retval is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(136, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = veccat(varargin)
    %concatenate vertically while vectorizing all arguments with vec
    %
    %
    %Usage: retval = veccat (x)
    %
    %x is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. x is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(137, varargin);

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mtimes(varargin)
    %>  MatType mul(MatType X, MatType Y)
    %------------------------------------------------------------------------
    %
    %Matrix product of two matrices.
    %
    %>  MatType mul([MatType ] args)
    %------------------------------------------------------------------------
    %
    %Matrix product of n matrices.
    %
    %
    %Usage: retval = mtimes (args)
    %
    %args is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. args is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(138, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mac(varargin)
    %Multiply-accumulate operation Matrix product of two matrices (X and Y),
    %adding the result to a third matrix Z. The result has the same sparsity
    %pattern as C meaning that other entries of (X*Y) are ignored. The operation
    %is equivalent to: Z+mul(X,Y).project(Z.sparsity()).
    %
    %
    %Usage: retval = mac (X, Y, Z)
    %
    %X is of type SX. Y is of type SX. Z is of type SX. X is of type SX. Y is of type SX. Z is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(139, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = transpose(varargin)
    %Transpose.
    %
    %
    %Usage: retval = transpose (X)
    %
    %X is of type SX. X is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(140, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = vec(varargin)
    %make a vector Reshapes/vectorizes the matrix such that the shape becomes
    %(expr.numel(), 1). Columns are stacked on top of each other. Same as
    %reshape(expr, expr.numel(), 1)
    %
    %a c b d  turns into
    %
    %a b c d
    %
    %
    %Usage: retval = vec (a)
    %
    %a is of type SX. a is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(141, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = vecNZ(varargin)
    %Returns a flattened version of the matrix, preserving only nonzeros.
    %
    %
    %Usage: retval = vecNZ (a)
    %
    %a is of type SX. a is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(142, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = reshape(varargin)
    %>  MatType reshape(MatType a, int nrow, int ncol)
    %------------------------------------------------------------------------
    %
    %Returns a reshaped version of the matrix.
    %
    %>  MatType reshape(MatType a,(int,int) rc)
    %------------------------------------------------------------------------
    %
    %Returns a reshaped version of the matrix, dimensions as a vector.
    %
    %>  MatType reshape(MatType a, Sparsity sp)
    %------------------------------------------------------------------------
    %
    %Reshape the matrix.
    %
    %
    %Usage: retval = reshape (a, sp)
    %
    %a is of type SX. sp is of type Sparsity. a is of type SX. sp is of type Sparsity. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(143, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sprank(varargin)
    %Obtain the structural rank of a sparsity-pattern.
    %
    %
    %Usage: retval = sprank (A)
    %
    %A is of type SX. A is of type SX. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(144, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_0_mul(varargin)
    %0-norm (nonzero count) of a Matrix-matrix product
    %
    %
    %Usage: retval = norm_0_mul (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(145, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = triu(varargin)
    %Get the upper triangular part of a matrix.
    %
    %
    %Usage: retval = triu (a, includeDiagonal = true)
    %
    %a is of type SX. includeDiagonal is of type bool. a is of type SX. includeDiagonal is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(146, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tril(varargin)
    %Get the lower triangular part of a matrix.
    %
    %
    %Usage: retval = tril (a, includeDiagonal = true)
    %
    %a is of type SX. includeDiagonal is of type bool. a is of type SX. includeDiagonal is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(147, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = kron(varargin)
    %Kronecker tensor product.
    %
    %Creates a block matrix in which each element (i, j) is a_ij*b
    %
    %
    %Usage: retval = kron (a, b)
    %
    %a is of type SX. b is of type SX. a is of type SX. b is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(148, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = repmat(varargin)
    %Repeat matrix A n times vertically and m times horizontally.
    %
    %
    %Usage: retval = repmat (A, rc)
    %
    %A is of type SX. rc is of type std::pair< int,int > const &. A is of type SX. rc is of type std::pair< int,int > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(149, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = length(varargin)
    %Usage: retval = length (v)
    %
    %v is of type SX. v is of type SX. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(150, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = SparsityInterfaceCommon(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(151, varargin{:});
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
        casadiMEX(152, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
