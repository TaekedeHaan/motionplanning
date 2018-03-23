classdef GenMX < casadi.GenericMatrixCommon & casadi.SpMX
    %Matrix base class.
    %
    %This is a common base class for MX and Matrix<>, introducing a uniform
    %syntax and implementing common functionality using the curiously recurring
    %template pattern (CRTP) idiom.  The class is designed with the idea that
    %"everything is a matrix", that is, also scalars and vectors. This
    %philosophy makes it easy to use and to interface in particularly with Python
    %and Matlab/Octave.  The syntax tries to stay as close as possible to the
    %ublas syntax when it comes to vector/matrix operations.  Index starts with
    %0. Index vec happens as follows: (rr, cc) -> k = rr+cc*size1() Vectors are
    %column vectors.  The storage format is Compressed Column Storage (CCS),
    %similar to that used for sparse matrices in Matlab, but unlike this format,
    %we do allow for elements to be structurally non-zero but numerically zero.
    %The sparsity pattern, which is reference counted and cached, can be accessed
    %with Sparsity& sparsity() Joel Andersson
    %
    %C++ includes: generic_matrix.hpp 
    %Usage: GenMX ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = nnz(self,varargin)
    %Get the number of (structural) non-zero elements.
    %
    %
    %Usage: retval = nnz ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(394, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sizeL(self,varargin)
    %Get the number of non-zeros in the lower triangular half.
    %
    %
    %Usage: retval = sizeL ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(395, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sizeU(self,varargin)
    %Get the number of non-zeros in the upper triangular half.
    %
    %
    %Usage: retval = sizeU ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(396, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sizeD(self,varargin)
    %Get get the number of non-zeros on the diagonal.
    %
    %
    %Usage: retval = sizeD ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(397, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = numel(self,varargin)
    %>  int MatType .numel() const 
    %------------------------------------------------------------------------
    %
    %Get the number of elements.
    %
    %>  int MatType .numel(int i) const 
    %------------------------------------------------------------------------
    %
    %Get the number of elements in slice (cf. MATLAB)
    %
    %
    %Usage: retval = numel (i)
    %
    %i is of type int. i is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(398, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = size1(self,varargin)
    %Get the first dimension (i.e. number of rows)
    %
    %
    %Usage: retval = size1 ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(399, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = size2(self,varargin)
    %Get the second dimension (i.e. number of columns)
    %
    %
    %Usage: retval = size2 ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(400, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = dimString(self,varargin)
    %Get string representation of dimensions. The representation is (nrow x ncol
    %= numel | size)
    %
    %
    %Usage: retval = dimString ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(401, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = size(self,varargin)
    %>  (int,int) MatType .shape() const 
    %------------------------------------------------------------------------
    %
    %Get the shape.
    %
    %>  int MatType .shape(int axis) const 
    %------------------------------------------------------------------------
    %
    %Get the size along a particular dimensions.
    %
    %
    %Usage: retval = size (axis)
    %
    %axis is of type int. axis is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      out = casadiMEX(402, self, varargin{:});
      if nargout>1
        for i=1:length(out)
          varargout{i} = out(i);
        end
      else
        varargout{1}=out;
      end

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isempty(self,varargin)
    %Check if the sparsity is empty, i.e. if one of the dimensions is zero (or
    %optionally both dimensions)
    %
    %
    %Usage: retval = isempty (both = false)
    %
    %both is of type bool. both is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(403, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isdense(self,varargin)
    %Check if the matrix expression is dense.
    %
    %
    %Usage: retval = isdense ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(404, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isscalar(self,varargin)
    %Check if the matrix expression is scalar.
    %
    %
    %Usage: retval = isscalar (scalar_and_dense = false)
    %
    %scalar_and_dense is of type bool. scalar_and_dense is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(405, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = issquare(self,varargin)
    %Check if the matrix expression is square.
    %
    %
    %Usage: retval = issquare ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(406, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isvector(self,varargin)
    %Check if the matrix is a row or column vector.
    %
    %
    %Usage: retval = isvector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(407, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isrow(self,varargin)
    %Check if the matrix is a row vector (i.e. size1()==1)
    %
    %
    %Usage: retval = isrow ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(408, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = iscolumn(self,varargin)
    %Check if the matrix is a column vector (i.e. size2()==1)
    %
    %
    %Usage: retval = iscolumn ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(409, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = istriu(self,varargin)
    %Check if the matrix is upper triangular.
    %
    %
    %Usage: retval = istriu ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(410, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = istril(self,varargin)
    %Check if the matrix is lower triangular.
    %
    %
    %Usage: retval = istril ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(411, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = row(self,varargin)
    %Get the sparsity pattern. See the Sparsity class for details.
    %
    %
    %Usage: retval = row (el)
    %
    %el is of type int. el is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(412, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = colind(self,varargin)
    %Get the sparsity pattern. See the Sparsity class for details.
    %
    %
    %Usage: retval = colind (col)
    %
    %col is of type int. col is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(413, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = find(self,varargin)
    %Get the location of all non-zero elements as they would appear in a Dense
    %matrix A : DenseMatrix 4 x 3 B : SparseMatrix 4 x 3 , 5 structural non-
    %zeros.
    %
    %k = A.find() A[k] will contain the elements of A that are non-zero in B
    %
    %
    %Usage: retval = find (ind1 = true)
    %
    %ind1 is of type bool. ind1 is of type bool. retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(414, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sparsity(self,varargin)
    %Get the sparsity pattern.
    %
    %
    %Usage: retval = sparsity ()
    %
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.GenMX')
        self = casadi.GenMX(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(415, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = GenMX(varargin)
      self@casadi.GenericMatrixCommon(SwigRef.Null);
      self@casadi.SpMX(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(419, varargin{:});
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
        casadiMEX(420, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = sym(varargin)
    %>  static MatType MatType .sym(str name, int nrow=1, int ncol=1)
    %------------------------------------------------------------------------
    %
    %Create an nrow-by-ncol symbolic primitive.
    %
    %>  static MatType MatType .sym(str name, (int,int) rc)
    %------------------------------------------------------------------------
    %
    %Construct a symbolic primitive with given dimensions.
    %
    %>  MatType MatType .sym(str name, Sparsity sp)
    %------------------------------------------------------------------------
    %
    %Create symbolic primitive with a given sparsity pattern.
    %
    %>  [MatType ] MatType .sym(str name, Sparsity sp, int p)
    %------------------------------------------------------------------------
    %
    %Create a vector of length p with with matrices with symbolic primitives of
    %given sparsity.
    %
    %>  static[MatType ] MatType .sym(str name, int nrow, int ncol, int p)
    %------------------------------------------------------------------------
    %
    %Create a vector of length p with nrow-by-ncol symbolic primitives.
    %
    %>  [[MatType ] ] MatType .sym(str name, Sparsity sp, int p, int r)
    %------------------------------------------------------------------------
    %
    %Create a vector of length r of vectors of length p with symbolic primitives
    %with given sparsity.
    %
    %>  static[[MatType] ] MatType .sym(str name, int nrow, int ncol, int p, int r)
    %------------------------------------------------------------------------
    %
    %Create a vector of length r of vectors of length p with nrow-by-ncol
    %symbolic primitives.
    %
    %
    %Usage: retval = sym (name, nrow, ncol, p, r)
    %
    %name is of type std::string const &. nrow is of type int. ncol is of type int. p is of type int. r is of type int. name is of type std::string const &. nrow is of type int. ncol is of type int. p is of type int. r is of type int. retval is of type std::vector< std::vector< casadi::MX,std::allocator< casadi::MX > >,std::allocator< std::vector< casadi::MX,std::allocator< casadi::MX > > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(416, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = zeros(varargin)
    %Create a dense matrix or a matrix with specified sparsity with all entries
    %zero.
    %
    %
    %Usage: retval = zeros (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(417, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ones(varargin)
    %Create a dense matrix or a matrix with specified sparsity with all entries
    %one.
    %
    %
    %Usage: retval = ones (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(418, varargin{:});

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
