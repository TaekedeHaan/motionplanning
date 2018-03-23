classdef DMatrix < casadi.MatrixCommon & casadi.ExpDMatrix & casadi.GenDMatrix & casadi.PrintDMatrix
    %Sparse matrix class. SX and DMatrix are specializations.
    %
    %General sparse matrix class that is designed with the idea that "everything
    %is a matrix", that is, also scalars and vectors. This philosophy makes it
    %easy to use and to interface in particularly with Python and Matlab/Octave.
    %Index starts with 0. Index vec happens as follows: (rr, cc) -> k =
    %rr+cc*size1() Vectors are column vectors.  The storage format is Compressed
    %Column Storage (CCS), similar to that used for sparse matrices in Matlab,
    %but unlike this format, we do allow for elements to be structurally non-zero
    %but numerically zero.  Matrix<DataType> is polymorphic with a
    %std::vector<DataType> that contain all non-identical-zero elements. The
    %sparsity can be accessed with Sparsity& sparsity() Joel Andersson
    %
    %C++ includes: casadi_types.hpp 
    %Usage: DMatrix ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = sanityCheck(self,varargin)
    %Check if the dimensions and colind, row vectors are compatible.
    %
    %Parameters:
    %-----------
    %
    %complete:  set to true to also check elementwise throws an error as possible
    %result
    %
    %
    %Usage: sanityCheck (complete = false)
    %
    %complete is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(587, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasNZ(self,varargin)
    %Returns true if the matrix has a non-zero at location rr, cc.
    %
    %
    %Usage: retval = hasNZ (rr, cc)
    %
    %rr is of type int. cc is of type int. rr is of type int. cc is of type int. retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(588, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nonzero(self,varargin)
    %Returns the truth value of a Matrix.
    %
    %
    %Usage: retval = nonzero ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(589, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isSlice(self,varargin)
    %>  bool array(DataType) .isSlice(bool ind1=false) const 
    %------------------------------------------------------------------------
    %
    %Is the Matrix a Slice (only for IMatrix)
    %
    %
    %Usage: retval = isSlice (ind1 = false)
    %
    %ind1 is of type bool. ind1 is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(590, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = toSlice(self,varargin)
    %>  Slice array(DataType) .toSlice(bool ind1=false) const 
    %------------------------------------------------------------------------
    %
    %Convert to Slice (only for IMatrix)
    %
    %
    %Usage: retval = toSlice (ind1 = false)
    %
    %ind1 is of type bool. ind1 is of type bool. retval is of type Slice. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(591, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = get(self,varargin)
    %>  void array(DataType) .get([double ] output_m) const 
    %------------------------------------------------------------------------
    %
    %Get the elements numerically.
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, Slice rr) const
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, IMatrix rr) const
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, Sparsity sp) const 
    %------------------------------------------------------------------------
    %
    %Get a submatrix, single argument
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, Slice rr, Slice cc) const
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, Slice rr, IMatrix cc) const
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, IMatrix rr, Slice cc) const
    %
    %>  void array(DataType) .get(array(DataType) output_m, bool ind1, IMatrix rr, IMatrix cc) const 
    %------------------------------------------------------------------------
    %
    %Get a submatrix, two arguments
    %
    %
    %Usage: get (ind1, rr, cc)
    %
    %ind1 is of type bool. rr is of type IMatrix. cc is of type IMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(592, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = set(self,varargin)
    %>  void array(DataType) .set(double val)
    %
    %>  void array(DataType) .set(const double *val, bool tr=false)
    %
    %>  void array(DataType) .set([double ] val, bool tr=false)
    %------------------------------------------------------------------------
    %
    %Get the elements numerically.
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, Slice rr)
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, IMatrix rr)
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, Sparsity sp)
    %------------------------------------------------------------------------
    %
    %Set a submatrix, single argument
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, Slice rr, Slice cc)
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, Slice rr, IMatrix cc)
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, IMatrix rr, Slice cc)
    %
    %>  void array(DataType) .set(array(DataType) m, bool ind1, IMatrix rr, IMatrix cc)
    %------------------------------------------------------------------------
    %
    %Set a submatrix, two arguments
    %
    %>  void array(DataType) .set(array(DataType) val)
    %------------------------------------------------------------------------
    %
    %Set all the entries without changing sparsity pattern.
    %
    %
    %Usage: set (m, ind1, rr, cc)
    %
    %m is of type DMatrix. ind1 is of type bool. rr is of type IMatrix. cc is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(593, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setSym(self,varargin)
    %Set upper triangular elements.
    %
    %
    %Usage: setSym (val)
    %
    %val is of type std::vector< double,std::allocator< double > > const &. 

      try

      [varargout{1:nargout}] = casadiMEX(594, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getSym(self,varargin)
    %Get upper triangular elements.
    %
    %
    %Usage: getSym ()
    %

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(595, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getNZ(self,varargin)
    %>  void array(DataType) .getNZ([double ] output_m) const 
    %------------------------------------------------------------------------
    %
    %Get the elements numerically.
    %
    %>  void array(DataType) .getNZ(array(DataType) output_m, bool ind1, Slice k) const
    %
    %>  void array(DataType) .getNZ(array(DataType) output_m, bool ind1, IMatrix k) const 
    %------------------------------------------------------------------------
    %
    %Get a set of nonzeros
    %
    %
    %Usage: getNZ (ind1, k)
    %
    %ind1 is of type bool. k is of type IMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(596, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setNZ(self,varargin)
    %>  void array(DataType) .setNZ(double val)
    %
    %>  void array(DataType) .setNZ(const double *val)
    %
    %>  void array(DataType) .setNZ([double ] val)
    %------------------------------------------------------------------------
    %
    %Set the elements numerically.
    %
    %>  void array(DataType) .setNZ(array(DataType) m, bool ind1, Slice k)
    %
    %>  void array(DataType) .setNZ(array(DataType) m, bool ind1, IMatrix k)
    %------------------------------------------------------------------------
    %
    %Set a set of nonzeros
    %
    %
    %Usage: setNZ (m, ind1, k)
    %
    %m is of type DMatrix. ind1 is of type bool. k is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(597, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = append(self,varargin)
    %[DEPRECATED] Append a matrix vertically (NOTE: only efficient if vector)
    %
    %
    %Usage: append (y)
    %
    %y is of type DMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(598, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = appendColumns(self,varargin)
    %[DEPRECATED] Append a matrix horizontally
    %
    %
    %Usage: appendColumns (y)
    %
    %y is of type DMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(599, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setZero(self,varargin)
    %[DEPRECATED] Set all elements to zero
    %
    %
    %Usage: setZero ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(600, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeSparse(self,varargin)
    %[DEPRECATED: use sparsify instead] Make a matrix sparse by removing
    %numerical zeros smaller in absolute value than a specified tolerance
    %
    %
    %Usage: makeSparse (tol = 0)
    %
    %tol is of type double. 

      try

      [varargout{1:nargout}] = casadiMEX(601, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = uplus(self,varargin)
    %Usage: retval = uplus ()
    %
    %retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(602, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = uminus(self,varargin)
    %Usage: retval = uminus ()
    %
    %retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(603, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printme(self,varargin)
    %Usage: retval = printme (y)
    %
    %y is of type DMatrix. y is of type DMatrix. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(609, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = T(self,varargin)
    %Transpose the matrix.
    %
    %
    %Usage: retval = T ()
    %
    %retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(610, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = print(self,varargin)
    %Print a description of the object.
    %
    %
    %Usage: print (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(614, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printSplit(self,varargin)
    %Get strings corresponding to the nonzeros and the interdependencies.
    %
    %
    %Usage: printSplit ()
    %

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(615, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = disp(self,varargin)
    %Print a representation of the object.
    %
    %
    %Usage: disp (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(616, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printScalar(self,varargin)
    %Print scalar.
    %
    %
    %Usage: printScalar (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(617, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printVector(self,varargin)
    %Print vector-style.
    %
    %
    %Usage: printVector (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(618, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printDense(self,varargin)
    %Print dense matrix-stype.
    %
    %
    %Usage: printDense (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(619, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printSparse(self,varargin)
    %Print sparse matrix style.
    %
    %
    %Usage: printSparse (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:nargout}] = casadiMEX(620, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = clear(self,varargin)
    %Usage: clear ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(621, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = resize(self,varargin)
    %Usage: resize (nrow, ncol)
    %
    %nrow is of type int. ncol is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(622, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = reserve(self,varargin)
    %Usage: reserve (nnz, ncol)
    %
    %nnz is of type int. ncol is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(623, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = erase(self,varargin)
    %>  void array(DataType) .erase([int ] rr, [int ] cc, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase rows and/or
    %columns of a matrix.
    %
    %>  void array(DataType) .erase([int ] rr, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase elements of
    %a matrix.
    %
    %
    %Usage: erase (rr, ind1 = false)
    %
    %rr is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(624, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = remove(self,varargin)
    %Remove columns and rows Remove/delete rows and/or columns of a matrix.
    %
    %
    %Usage: remove (rr, cc)
    %
    %rr is of type std::vector< int,std::allocator< int > > const &. cc is of type std::vector< int,std::allocator< int > > const &. 

      try

      [varargout{1:nargout}] = casadiMEX(625, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = enlarge(self,varargin)
    %Enlarge matrix Make the matrix larger by inserting empty rows and columns,
    %keeping the existing non-zeros.
    %
    %
    %Usage: enlarge (nrow, ncol, rr, cc, ind1 = false)
    %
    %nrow is of type int. ncol is of type int. rr is of type std::vector< int,std::allocator< int > > const &. cc is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(626, self, varargin{:});

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
    %Get an owning reference to the sparsity pattern.
    %
    %
    %Usage: retval = sparsity ()
    %
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(627, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getElementHash(self,varargin)
    %Returns a number that is unique for a given symbolic scalar.
    %
    %Only defined if symbolic scalar.
    %
    %
    %Usage: retval = getElementHash ()
    %
    %retval is of type size_t. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(632, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isRegular(self,varargin)
    %Checks if expression does not contain NaN or Inf.
    %
    %
    %Usage: retval = isRegular ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(633, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isSmooth(self,varargin)
    %Check if smooth.
    %
    %
    %Usage: retval = isSmooth ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(634, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isLeaf(self,varargin)
    %Check if SX is a leaf of the SX graph.
    %
    %Only defined if symbolic scalar.
    %
    %
    %Usage: retval = isLeaf ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(635, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isCommutative(self,varargin)
    %Check whether a binary SX is commutative.
    %
    %Only defined if symbolic scalar.
    %
    %
    %Usage: retval = isCommutative ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(636, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isSymbolic(self,varargin)
    %Check if symbolic (Dense) Sparse matrices invariable return false.
    %
    %
    %Usage: retval = isSymbolic ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(637, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isValidInput(self,varargin)
    %Check if matrix can be used to define function inputs. Sparse matrices can
    %return true if all non-zero elements are symbolic.
    %
    %
    %Usage: retval = isValidInput ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(638, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasDuplicates(self,varargin)
    %[INTERNAL]  Detect
    %duplicate symbolic expressions If there are symbolic primitives appearing
    %more than once, the function will return true and the names of the duplicate
    %expressions will be printed to userOut<true, PL_WARN>(). Note: Will mark the
    %node using SXElement::setTemp. Make sure to call resetInput() after usage.
    %
    %
    %Usage: retval = hasDuplicates ()
    %
    %retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(639, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = resetInput(self,varargin)
    %[INTERNAL]  Reset the
    %marker for an input expression.
    %
    %
    %Usage: resetInput ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(640, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isConstant(self,varargin)
    %Check if the matrix is constant (note that false negative answers are
    %possible)
    %
    %
    %Usage: retval = isConstant ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(641, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isInteger(self,varargin)
    %Check if the matrix is integer-valued (note that false negative answers are
    %possible)
    %
    %
    %Usage: retval = isInteger ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(642, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isZero(self,varargin)
    %check if the matrix is 0 (note that false negative answers are possible)
    %
    %
    %Usage: retval = isZero ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(643, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isOne(self,varargin)
    %check if the matrix is 1 (note that false negative answers are possible)
    %
    %
    %Usage: retval = isOne ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(644, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isMinusOne(self,varargin)
    %check if the matrix is -1 (note that false negative answers are possible)
    %
    %
    %Usage: retval = isMinusOne ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(645, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isIdentity(self,varargin)
    %check if the matrix is an identity matrix (note that false negative answers
    %are possible)
    %
    %
    %Usage: retval = isIdentity ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(646, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hasNonStructuralZeros(self,varargin)
    %Check if the matrix has any zero entries which are not structural zeros.
    %
    %
    %Usage: retval = hasNonStructuralZeros ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(647, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getValue(self,varargin)
    %>  double array(DataType) .getValue() const 
    %------------------------------------------------------------------------
    %
    %Get double value (only if constant)
    %
    %>  double array(DataType) .getValue(int k) const 
    %------------------------------------------------------------------------
    %
    %Get double value (particular nonzero)
    %
    %
    %Usage: retval = getValue (k)
    %
    %k is of type int. k is of type int. retval is of type double. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(648, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setValue(self,varargin)
    %>  void array(DataType) .setValue(double m)
    %------------------------------------------------------------------------
    %
    %Set double value (only if constant)
    %
    %>  void array(DataType) .setValue(double m, int k)
    %------------------------------------------------------------------------
    %
    %Set double value (particular nonzero)
    %
    %
    %Usage: setValue (m, k)
    %
    %m is of type double. k is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(649, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getIntValue(self,varargin)
    %Get double value (only if integer constant)
    %
    %
    %Usage: retval = getIntValue ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(650, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nonzeros(self,varargin)
    %Get all nonzeros.
    %
    %
    %Usage: retval = nonzeros ()
    %
    %retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(651, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nonzeros_int(self,varargin)
    %Get all nonzeros.
    %
    %
    %Usage: retval = nonzeros_int ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(652, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getName(self,varargin)
    %Get name (only if symbolic scalar)
    %
    %
    %Usage: retval = getName ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(653, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getDep(self,varargin)
    %Get expressions of the children of the expression Only defined if symbolic
    %scalar. Wraps SXElement SXElement::getDep(int ch=0) const.
    %
    %
    %Usage: retval = getDep (ch = 0)
    %
    %ch is of type int. ch is of type int. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(654, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getNdeps(self,varargin)
    %Get the number of dependencies of a binary SXElement Only defined if
    %symbolic scalar.
    %
    %
    %Usage: retval = getNdeps ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(655, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = DMatrix(varargin)
      self@casadi.MatrixCommon(SwigRef.Null);
      self@casadi.ExpDMatrix(SwigRef.Null);
      self@casadi.GenDMatrix(SwigRef.Null);
      self@casadi.PrintDMatrix(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(659, varargin{:});
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
    function varargout = assign(self,varargin)
    %Usage: assign (rhs)
    %
    %rhs is of type DMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(660, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (rr, cc)
    %
    %rr is of type IMatrix. cc is of type IMatrix. rr is of type IMatrix. cc is of type IMatrix. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(661, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = paren_asgn(self,varargin)
    %Usage: paren_asgn (m, rr, cc)
    %
    %m is of type DMatrix. rr is of type IMatrix. cc is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(662, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = brace(self,varargin)
    %Usage: retval = brace (rr)
    %
    %rr is of type IMatrix. rr is of type IMatrix. retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(663, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setbrace(self,varargin)
    %Usage: setbrace (m, rr)
    %
    %m is of type DMatrix. rr is of type IMatrix. 

      try

      [varargout{1:nargout}] = casadiMEX(664, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = end(self,varargin)
    %Usage: retval = end (i, n)
    %
    %i is of type int. n is of type int. i is of type int. n is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(665, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ctranspose(self,varargin)
    %Usage: retval = ctranspose ()
    %
    %retval is of type DMatrix. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(666, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = full(self,varargin)
    %Usage: retval = full ()
    %
    %retval is of type mxArray *. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(667, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sparse(self,varargin)
    %[DEPRECATED] Create a sparse matrix with all zeros Use MatType(nrow, ncol)
    %instead
    %
    %
    %Usage: retval = sparse ()
    %
    %retval is of type mxArray *. 

      try

      if ~isa(self,'casadi.DMatrix')
        self = casadi.DMatrix(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(668, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function delete(self)
      if self.swigPtr
        casadiMEX(669, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = binary(varargin)
    %[INTERNAL]  Create nodes by
    %their ID.
    %
    %
    %Usage: retval = binary (op, x, y)
    %
    %op is of type int. x is of type DMatrix. y is of type DMatrix. op is of type int. x is of type DMatrix. y is of type DMatrix. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(604, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unary(varargin)
    %[INTERNAL]  Create nodes by
    %their ID.
    %
    %
    %Usage: retval = unary (op, x)
    %
    %op is of type int. x is of type DMatrix. op is of type int. x is of type DMatrix. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(605, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = scalar_matrix(varargin)
    %[INTERNAL]  Create
    %nodes by their ID.
    %
    %
    %Usage: retval = scalar_matrix (op, x, y)
    %
    %op is of type int. x is of type DMatrix. y is of type DMatrix. op is of type int. x is of type DMatrix. y is of type DMatrix. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(606, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = matrix_scalar(varargin)
    %[INTERNAL]  Create
    %nodes by their ID.
    %
    %
    %Usage: retval = matrix_scalar (op, x, y)
    %
    %op is of type int. x is of type DMatrix. y is of type DMatrix. op is of type int. x is of type DMatrix. y is of type DMatrix. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(607, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = matrix_matrix(varargin)
    %[INTERNAL]  Create
    %nodes by their ID.
    %
    %
    %Usage: retval = matrix_matrix (op, x, y)
    %
    %op is of type int. x is of type DMatrix. y is of type DMatrix. op is of type int. x is of type DMatrix. y is of type DMatrix. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(608, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setEqualityCheckingDepth(varargin)
    %Usage: setEqualityCheckingDepth (eq_depth = 1)
    %
    %eq_depth is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(611, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getEqualityCheckingDepth(varargin)
    %Usage: retval = getEqualityCheckingDepth ()
    %
    %retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(612, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = className(varargin)
    %Usage: retval = className ()
    %
    %retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(613, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = triplet(varargin)
    %Usage: retval = triplet (row, col, d, rc)
    %
    %row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. d is of type DMatrix. rc is of type std::pair< int,int > const &. row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. d is of type DMatrix. rc is of type std::pair< int,int > const &. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(628, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inf(varargin)
    %create a matrix with all inf
    %
    %
    %Usage: retval = inf (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(629, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nan(varargin)
    %create a matrix with all nan
    %
    %
    %Usage: retval = nan (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(630, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eye(varargin)
    %Usage: retval = eye (ncol)
    %
    %ncol is of type int. ncol is of type int. retval is of type DMatrix. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(631, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setPrecision(varargin)
    %Set the 'precision, width & scientific' used in printing and serializing to
    %streams.
    %
    %
    %Usage: setPrecision (precision)
    %
    %precision is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(656, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setWidth(varargin)
    %Set the 'precision, width & scientific' used in printing and serializing to
    %streams.
    %
    %
    %Usage: setWidth (width)
    %
    %width is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(657, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setScientific(varargin)
    %Set the 'precision, width & scientific' used in printing and serializing to
    %streams.
    %
    %
    %Usage: setScientific (scientific)
    %
    %scientific is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(658, varargin{:});

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
