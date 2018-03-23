classdef Sparsity < casadi.SharedObject & casadi.SpSparsity
    %General sparsity class.
    %
    %The storage format is a compressed column storage (CCS) format.  In this
    %format, the structural non-zero elements are stored in column-major order,
    %starting from the upper left corner of the matrix and ending in the lower
    %right corner.
    %
    %In addition to the dimension ( size1(), size2()), (i.e. the number of rows
    %and the number of columns respectively), there are also two vectors of
    %integers:
    %
    %"colind" [length size2()+1], which contains the index to the first non-
    %zero element on or after the corresponding column. All the non-zero elements
    %of a particular i are thus the elements with index el that fulfills:
    %colind[i] <= el < colind[i+1].
    %
    %"row" [same length as the number of non-zero elements, nnz()] The rows for
    %each of the structural non-zeros.
    %
    %Note that with this format, it is cheap to loop over all the non-zero
    %elements of a particular column, at constant time per element, but expensive
    %to jump to access a location (i, j).
    %
    %If the matrix is dense, i.e. length(row) == size1()*size2(), the format
    %reduces to standard dense column major format, which allows access to an
    %arbitrary element in constant time.
    %
    %Since the object is reference counted (it inherits from SharedObject),
    %several matrices are allowed to share the same sparsity pattern.
    %
    %The implementations of some methods of this class has been taken from the
    %CSparse package and modified to use C++ standard library and CasADi data
    %structures.
    %
    %See:   Matrix
    %
    %Joel Andersson
    %
    %C++ includes: sparsity.hpp 
    %Usage: Sparsity ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = reCache(self,varargin)
    %[INTERNAL]  Check if there
    %is an identical copy of the sparsity pattern in the cache, and if so, make a
    %shallow copy of that one.
    %
    %
    %Usage: reCache ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(166, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

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

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:nargout}] = casadiMEX(168, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getDiag(self,varargin)
    %Get the diagonal of the matrix/create a diagonal matrix (mapping will
    %contain the nonzero mapping) When the input is square, the diagonal elements
    %are returned. If the input is vector-like, a diagonal matrix is constructed
    %with it.
    %
    %
    %Usage: retval = getDiag ()
    %
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(169, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = compress(self,varargin)
    %Compress a sparsity pattern.
    %
    %
    %Usage: retval = compress ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(170, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isEqual(self,varargin)
    %Usage: retval = isEqual (nrow, ncol, colind, row)
    %
    %nrow is of type int. ncol is of type int. colind is of type std::vector< int,std::allocator< int > > const &. row is of type std::vector< int,std::allocator< int > > const &. nrow is of type int. ncol is of type int. colind is of type std::vector< int,std::allocator< int > > const &. row is of type std::vector< int,std::allocator< int > > const &. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(171, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eq(self,varargin)
    %Usage: retval = eq (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(172, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ne(self,varargin)
    %Usage: retval = ne (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(173, self, varargin{:});

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
    %Get the number of rows.
    %
    %
    %Usage: retval = size1 ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(174, self, varargin{:});

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
    %Get the number of columns.
    %
    %
    %Usage: retval = size2 ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(175, self, varargin{:});

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
    %The total number of elements, including structural zeros, i.e.
    %size2()*size1()
    %
    %See:   nnz()
    %
    %
    %Usage: retval = numel ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(176, self, varargin{:});

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
    %Check if the sparsity is empty.
    %
    %A sparsity is considered empty if one of the dimensions is zero (or
    %optionally both dimensions)
    %
    %
    %Usage: retval = isempty (both = false)
    %
    %both is of type bool. both is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(177, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nnz(self,varargin)
    %Get the number of (structural) non-zeros.
    %
    %See:   numel()
    %
    %
    %Usage: retval = nnz ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(178, self, varargin{:});

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
    %Number of non-zeros in the upper triangular half, i.e. the number of
    %elements (i, j) with j>=i.
    %
    %
    %Usage: retval = sizeU ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(179, self, varargin{:});

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
    %Number of non-zeros in the lower triangular half, i.e. the number of
    %elements (i, j) with j<=i.
    %
    %
    %Usage: retval = sizeL ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(180, self, varargin{:});

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
    %Number of non-zeros on the diagonal, i.e. the number of elements (i, j) with
    %j==i.
    %
    %
    %Usage: retval = sizeD ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(181, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = bandwidthU(self,varargin)
    %Upper half-bandwidth.
    %
    %
    %Usage: retval = bandwidthU ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(182, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = bandwidthL(self,varargin)
    %Lower half-bandwidth.
    %
    %
    %Usage: retval = bandwidthL ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(183, self, varargin{:});

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
    %Get the shape.
    %
    %
    %Usage: retval = size ()
    %
    %retval is of type std::pair< int,int >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      out = casadiMEX(184, self, varargin{:});
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
    function varargout = colind(self,varargin)
    %Get a reference to the colindex of column cc (see class description)
    %
    %
    %Usage: retval = colind (cc)
    %
    %cc is of type int. cc is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(185, self, varargin{:});

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
    %Get the row of a non-zero element.
    %
    %
    %Usage: retval = row (el)
    %
    %el is of type int. el is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(186, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCol(self,varargin)
    %Get the column for each non-zero entry Together with the row-vector, this
    %vector gives the sparsity of the matrix in sparse triplet format, i.e. the
    %column and row for each non-zero elements.
    %
    %
    %Usage: retval = getCol ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(187, self, varargin{:});

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
    %Resize.
    %
    %
    %Usage: resize (nrow, ncol)
    %
    %nrow is of type int. ncol is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(188, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addNZ(self,varargin)
    %Get the index of a non-zero element Add the element if it does not exist and
    %copy object if it's not unique.
    %
    %
    %Usage: retval = addNZ (rr, cc)
    %
    %rr is of type int. cc is of type int. rr is of type int. cc is of type int. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(189, self, varargin{:});

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
    %Returns true if the pattern has a non-zero at location rr, cc.
    %
    %
    %Usage: retval = hasNZ (rr, cc)
    %
    %rr is of type int. cc is of type int. rr is of type int. cc is of type int. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(190, self, varargin{:});

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
    %>  int Sparsity.getNZ(int rr, int cc) const 
    %------------------------------------------------------------------------
    %
    %Get the index of an existing non-zero element return -1 if the element does
    %not exist.
    %
    %>  [int] Sparsity.getNZ([int ] rr, [int ] cc) const 
    %------------------------------------------------------------------------
    %
    %Get a set of non-zero element return -1 if the element does not exist.
    %
    %>  void Sparsity.getNZ([int ] INOUT) const 
    %------------------------------------------------------------------------
    %
    %Get the nonzero index for a set of elements The index vector is used both
    %for input and outputs and must be sorted by increasing nonzero index, i.e.
    %column-wise. Elements not found in the sparsity pattern are set to -1.
    %
    %
    %Usage: getNZ (INOUT)
    %
    %INOUT is of type std::vector< int,std::allocator< int > > &. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(191, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getLowerNZ(self,varargin)
    %Get nonzeros in lower triangular part.
    %
    %
    %Usage: retval = getLowerNZ ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(192, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getUpperNZ(self,varargin)
    %Get nonzeros in upper triangular part.
    %
    %
    %Usage: retval = getUpperNZ ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(193, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCCS(self,varargin)
    %Get the sparsity in compressed column storage (CCS) format.
    %
    %
    %Usage: getCCS ()
    %

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(194, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getCRS(self,varargin)
    %Get the sparsity in compressed row storage (CRS) format.
    %
    %
    %Usage: getCRS ()
    %

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(195, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getTriplet(self,varargin)
    %Get the sparsity in sparse triplet format.
    %
    %
    %Usage: getTriplet ()
    %

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(196, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sub(self,varargin)
    %>  Sparsity Sparsity.sub([int ] rr, [int ] cc,[int ] output_mapping, bool ind1=false) const 
    %------------------------------------------------------------------------
    %
    %Get a submatrix.
    %
    %Returns the sparsity of the submatrix, with a mapping such that submatrix[k]
    %= originalmatrix[mapping[k]]
    %
    %>  Sparsity Sparsity.sub([int ] rr, Sparsity sp,[int ] output_mapping, bool ind1=false) const 
    %------------------------------------------------------------------------
    %
    %Get a set of elements.
    %
    %Returns the sparsity of the corresponding elements, with a mapping such that
    %submatrix[k] = originalmatrix[mapping[k]]
    %
    %
    %Usage: retval = sub (rr, sp, ind1 = false)
    %
    %rr is of type std::vector< int,std::allocator< int > > const &. sp is of type Sparsity. ind1 is of type bool. rr is of type std::vector< int,std::allocator< int > > const &. sp is of type Sparsity. ind1 is of type bool. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(197, self, varargin{:});

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
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(198, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = transpose(self,varargin)
    %Transpose the matrix and get the reordering of the non-zero entries.
    %
    %Parameters:
    %-----------
    %
    %mapping:  the non-zeros of the original matrix for each non-zero of the new
    %matrix
    %
    %
    %Usage: retval = transpose (mapping, invert_mapping = false)
    %
    %mapping is of type std::vector< int,std::allocator< int > > &. invert_mapping is of type bool. mapping is of type std::vector< int,std::allocator< int > > &. invert_mapping is of type bool. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(199, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isTranspose(self,varargin)
    %Check if the sparsity is the transpose of another.
    %
    %
    %Usage: retval = isTranspose (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(200, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isReshape(self,varargin)
    %Check if the sparsity is a reshape of another.
    %
    %
    %Usage: retval = isReshape (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(201, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = patternCombine(self,varargin)
    %Combine two sparsity patterns Returns the new sparsity pattern as well as a
    %mapping with the same length as the number of non-zero elements The mapping
    %matrix contains the arguments for each nonzero, the first bit indicates if
    %the first argument is nonzero, the second bit indicates if the second
    %argument is nonzero (note that none of, one of or both of the arguments can
    %be nonzero)
    %
    %
    %Usage: retval = patternCombine (y, f0x_is_zero, fx0_is_zero)
    %
    %y is of type Sparsity. f0x_is_zero is of type bool. fx0_is_zero is of type bool. y is of type Sparsity. f0x_is_zero is of type bool. fx0_is_zero is of type bool. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(202, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = patternUnion(self,varargin)
    %Union of two sparsity patterns.
    %
    %
    %Usage: retval = patternUnion (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(203, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = plus(self,varargin)
    %Usage: retval = plus (b)
    %
    %b is of type Sparsity. b is of type Sparsity. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(204, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = patternIntersection(self,varargin)
    %Intersection of two sparsity patterns Returns the new sparsity pattern as
    %well as a mapping with the same length as the number of non-zero elements
    %The value is 1 if the non-zero comes from the first (i.e. this) object, 2 if
    %it is from the second and 3 (i.e. 1 | 2) if from both.
    %
    %
    %Usage: retval = patternIntersection (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(205, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mtimes(self,varargin)
    %Usage: retval = mtimes (b)
    %
    %b is of type Sparsity. b is of type Sparsity. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(206, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = patternProduct(self,varargin)
    %Sparsity pattern for a matrix-matrix product Returns the sparsity pattern
    %resulting from multiplying the pattern with another pattern y from the
    %right.
    %
    %
    %Usage: retval = patternProduct (y)
    %
    %y is of type Sparsity. y is of type Sparsity. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(207, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = patternInverse(self,varargin)
    %Take the inverse of a sparsity pattern; flip zeros and non-zeros.
    %
    %
    %Usage: retval = patternInverse ()
    %
    %retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(208, self, varargin{:});

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
    %For the matrices A to B A(m, n) length(jj)=m , length(ii)=n B(nrow, ncol)
    %
    %A=enlarge(m, n, ii, jj) makes sure that
    %
    %B[jj, ii] == A
    %
    %
    %Usage: enlarge (nrow, ncol, rr, cc, ind1 = false)
    %
    %nrow is of type int. ncol is of type int. rr is of type std::vector< int,std::allocator< int > > const &. cc is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(209, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = enlargeRows(self,varargin)
    %Enlarge the matrix along the first dimension (i.e. insert rows)
    %
    %
    %Usage: enlargeRows (nrow, rr, ind1 = false)
    %
    %nrow is of type int. rr is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(210, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = enlargeColumns(self,varargin)
    %Enlarge the matrix along the second dimension (i.e. insert columns)
    %
    %
    %Usage: enlargeColumns (ncol, cc, ind1 = false)
    %
    %ncol is of type int. cc is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(211, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeDense(self,varargin)
    %Make a patten dense.
    %
    %
    %Usage: retval = makeDense (mapping)
    %
    %mapping is of type std::vector< int,std::allocator< int > > &. mapping is of type std::vector< int,std::allocator< int > > &. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(212, self, varargin{:});

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
    %>  [int] Sparsity.erase([int ] rr, [int ] cc, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase rows and/or columns of a matrix.
    %
    %>  [int] Sparsity.erase([int ] rr, bool ind1=false)
    %------------------------------------------------------------------------
    %
    %Erase elements of a matrix.
    %
    %
    %Usage: retval = erase (rr, ind1 = false)
    %
    %rr is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. rr is of type std::vector< int,std::allocator< int > > const &. ind1 is of type bool. retval is of type std::vector< int,std::allocator< int > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(213, self, varargin{:});

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
    %Append another sparsity patten vertically (NOTE: only efficient if vector)
    %
    %
    %Usage: append (sp)
    %
    %sp is of type Sparsity. 

      try

      [varargout{1:nargout}] = casadiMEX(214, self, varargin{:});

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
    %Append another sparsity patten horizontally.
    %
    %
    %Usage: appendColumns (sp)
    %
    %sp is of type Sparsity. 

      try

      [varargout{1:nargout}] = casadiMEX(215, self, varargin{:});

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
    %[DEPRECATED]: Reserve space
    %
    %
    %Usage: reserve (nnz, ncol)
    %
    %nnz is of type int. ncol is of type int. 

      try

      [varargout{1:nargout}] = casadiMEX(216, self, varargin{:});

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
    %Is scalar?
    %
    %
    %Usage: retval = isscalar (scalar_and_dense = false)
    %
    %scalar_and_dense is of type bool. scalar_and_dense is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(217, self, varargin{:});

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
    %Is dense?
    %
    %
    %Usage: retval = isdense ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(218, self, varargin{:});

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
    %Check if the pattern is a row vector (i.e. size1()==1)
    %
    %
    %Usage: retval = isrow ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(219, self, varargin{:});

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
    %Check if the pattern is a column vector (i.e. size2()==1)
    %
    %
    %Usage: retval = iscolumn ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(220, self, varargin{:});

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
    %Check if the pattern is a row or column vector.
    %
    %
    %Usage: retval = isvector ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(221, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isdiag(self,varargin)
    %Is diagonal?
    %
    %
    %Usage: retval = isdiag ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(222, self, varargin{:});

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
    %Is square?
    %
    %
    %Usage: retval = issquare ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(223, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = issymmetric(self,varargin)
    %Is symmetric?
    %
    %
    %Usage: retval = issymmetric ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(224, self, varargin{:});

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
    %Is upper triangular?
    %
    %
    %Usage: retval = istriu ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(225, self, varargin{:});

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
    %Is lower triangular?
    %
    %
    %Usage: retval = istril ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(226, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = issingular(self,varargin)
    %Check whether the sparsity-pattern indicates structural singularity.
    %
    %
    %Usage: retval = issingular ()
    %
    %retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(227, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = rowsSequential(self,varargin)
    %Do the rows appear sequentially on each column.
    %
    %Parameters:
    %-----------
    %
    %strictly:  if true, then do not allow multiple entries
    %
    %
    %Usage: retval = rowsSequential (strictly = true)
    %
    %strictly is of type bool. strictly is of type bool. retval is of type bool. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(228, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = removeDuplicates(self,varargin)
    %Remove duplicate entries.
    %
    %The same indices will be removed from the mapping vector, which must have
    %the same length as the number of nonzeros
    %
    %
    %Usage: removeDuplicates (mapping)
    %
    %mapping is of type std::vector< int,std::allocator< int > > &. 

      try

      [varargout{1:nargout}] = casadiMEX(229, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eliminationTree(self,varargin)
    %Calculate the elimination tree See Direct Methods for Sparse Linear Systems
    %by Davis (2006). If the parameter ata is false, the algorithm is equivalent
    %to Matlab's etree(A), except that the indices are zero- based. If ata is
    %true, the algorithm is equivalent to Matlab's etree(A, 'row').
    %
    %
    %Usage: retval = eliminationTree (ata = false)
    %
    %ata is of type bool. ata is of type bool. retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(230, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = depthFirstSearch(self,varargin)
    %Depth-first search on the adjacency graph of the sparsity See Direct Methods
    %for Sparse Linear Systems by Davis (2006).
    %
    %
    %Usage: retval = depthFirstSearch (j, top, xi, pstack, pinv, marked)
    %
    %j is of type int. top is of type int. xi is of type std::vector< int,std::allocator< int > > &. pstack is of type std::vector< int,std::allocator< int > > &. pinv is of type std::vector< int,std::allocator< int > > const &. marked is of type std::vector< bool,std::allocator< bool > > &. j is of type int. top is of type int. xi is of type std::vector< int,std::allocator< int > > &. pstack is of type std::vector< int,std::allocator< int > > &. pinv is of type std::vector< int,std::allocator< int > > const &. marked is of type std::vector< bool,std::allocator< bool > > &. retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(231, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = stronglyConnectedComponents(self,varargin)
    %Find the strongly connected components of the bigraph defined by the
    %sparsity pattern of a square matrix.
    %
    %See Direct Methods for Sparse Linear Systems by Davis (2006). Returns:
    %Number of components
    %
    %Offset for each components (length: 1 + number of components)
    %
    %Indices for each components, component i has indices index[offset[i]], ...,
    %index[offset[i+1]]
    %
    %In the case that the matrix is symmetric, the result has a particular
    %interpretation: Given a symmetric matrix A and n =
    %A.stronglyConnectedComponents(p, r)
    %
    %=> A[p, p] will appear block-diagonal with n blocks and with the indices of
    %the block boundaries to be found in r.
    %
    %
    %Usage: retval = stronglyConnectedComponents ()
    %
    %retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(232, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = dulmageMendelsohn(self,varargin)
    %Compute the Dulmage-Mendelsohn decomposition See Direct Methods for Sparse
    %Linear Systems by Davis (2006).
    %
    %Dulmage-Mendelsohn will try to bring your matrix into lower block-
    %triangular (LBT) form. It will not care about the distance of off- diagonal
    %elements to the diagonal: there is no guarantee you will get a block-
    %diagonal matrix if you supply a randomly permuted block- diagonal matrix.
    %
    %If your matrix is symmetrical, this method is of limited use; permutation
    %can make it non-symmetric.
    %
    %See:   stronglyConnectedComponents
    %
    %
    %Usage: retval = dulmageMendelsohn (seed = 0)
    %
    %seed is of type int. seed is of type int. retval is of type int. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(233, self, varargin{:});

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

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(234, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unidirectionalColoring(self,varargin)
    %Perform a unidirectional coloring: A greedy distance-2 coloring algorithm
    %(Algorithm 3.1 in A. H. GEBREMEDHIN, F. MANNE, A. POTHEN)
    %
    %
    %Usage: retval = unidirectionalColoring (AT = casadi::Sparsity(), cutoff = std::numeric_limits< int >::max())
    %
    %AT is of type Sparsity. cutoff is of type int. AT is of type Sparsity. cutoff is of type int. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(235, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = starColoring(self,varargin)
    %Perform a star coloring of a symmetric matrix: A greedy distance-2 coloring
    %algorithm Algorithm 4.1 in What Color Is Your Jacobian? Graph Coloring for
    %Computing Derivatives A. H. GEBREMEDHIN, F. MANNE, A. POTHEN SIAM Rev.,
    %47(4), 629705 (2006)
    %
    %Ordering options: None (0), largest first (1)
    %
    %
    %Usage: retval = starColoring (ordering = 1, cutoff = std::numeric_limits< int >::max())
    %
    %ordering is of type int. cutoff is of type int. ordering is of type int. cutoff is of type int. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(236, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = starColoring2(self,varargin)
    %Perform a star coloring of a symmetric matrix: A new greedy distance-2
    %coloring algorithm Algorithm 4.1 in NEW ACYCLIC AND STAR COLORING ALGORITHMS
    %WITH APPLICATION TO COMPUTING HESSIANS A. H. GEBREMEDHIN, A. TARAFDAR, F.
    %MANNE, A. POTHEN SIAM J. SCI. COMPUT. Vol. 29, No. 3, pp. 10421072 (2007)
    %
    %Ordering options: None (0), largest first (1)
    %
    %
    %Usage: retval = starColoring2 (ordering = 1, cutoff = std::numeric_limits< int >::max())
    %
    %ordering is of type int. cutoff is of type int. ordering is of type int. cutoff is of type int. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(237, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = largestFirstOrdering(self,varargin)
    %Order the cols by decreasing degree.
    %
    %
    %Usage: retval = largestFirstOrdering ()
    %
    %retval is of type std::vector< int,std::allocator< int > >. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(238, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = pmult(self,varargin)
    %Permute rows and/or columns Multiply the sparsity with a permutation matrix
    %from the left and/or from the right P * A * trans(P), A * trans(P) or A *
    %trans(P) with P defined by an index vector containing the row for each col.
    %As an alternative, P can be transposed (inverted).
    %
    %
    %Usage: retval = pmult (p, permute_rows = true, permute_cols = true, invert_permutation = false)
    %
    %p is of type std::vector< int,std::allocator< int > > const &. permute_rows is of type bool. permute_cols is of type bool. invert_permutation is of type bool. p is of type std::vector< int,std::allocator< int > > const &. permute_rows is of type bool. permute_cols is of type bool. invert_permutation is of type bool. retval is of type Sparsity. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(239, self, varargin{:});

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
    %Get the dimension as a string.
    %
    %
    %Usage: retval = dimString ()
    %
    %retval is of type std::string. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(240, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = spy(self,varargin)
    %Print a textual representation of sparsity.
    %
    %
    %Usage: spy ()
    %

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:nargout}] = casadiMEX(241, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = spyMatlab(self,varargin)
    %Generate a script for Matlab or Octave which visualizes the sparsity using
    %the spy command.
    %
    %
    %Usage: spyMatlab (mfile)
    %
    %mfile is of type std::string const &. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:nargout}] = casadiMEX(242, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = printCompact(self,varargin)
    %Print a compact description of the sparsity pattern.
    %
    %
    %Usage: printCompact ()
    %

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:nargout}] = casadiMEX(243, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hash(self,varargin)
    %Usage: retval = hash ()
    %
    %retval is of type std::size_t. 

      try

      if ~isa(self,'casadi.Sparsity')
        self = casadi.Sparsity(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(244, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = Sparsity(varargin)
      self@casadi.SharedObject(SwigRef.Null);
      self@casadi.SpSparsity(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(246, varargin{:});
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
        casadiMEX(247, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = scalar(varargin)
    %Create a scalar sparsity pattern.
    %
    %
    %Usage: retval = scalar (dense_scalar = true)
    %
    %dense_scalar is of type bool. dense_scalar is of type bool. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(155, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = dense(varargin)
    %Create a dense rectangular sparsity pattern.
    %
    %
    %Usage: retval = dense (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(156, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unit(varargin)
    %Create the sparsity pattern for a unit vector of length n and a nonzero on
    %position el.
    %
    %
    %Usage: retval = unit (n, el)
    %
    %n is of type int. el is of type int. n is of type int. el is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(157, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = upper(varargin)
    %Usage: retval = upper (n)
    %
    %n is of type int. n is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(158, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = lower(varargin)
    %Usage: retval = lower (n)
    %
    %n is of type int. n is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(159, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = diag(varargin)
    %Create diagonal sparsity pattern.
    %
    %
    %Usage: retval = diag (rc)
    %
    %rc is of type std::pair< int,int > const &. rc is of type std::pair< int,int > const &. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(160, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = band(varargin)
    %Usage: retval = band (n, p)
    %
    %n is of type int. p is of type int. n is of type int. p is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(161, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = banded(varargin)
    %Usage: retval = banded (n, p)
    %
    %n is of type int. p is of type int. n is of type int. p is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(162, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = rowcol(varargin)
    %Usage: retval = rowcol (row, col, nrow, ncol)
    %
    %row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. nrow is of type int. ncol is of type int. row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. nrow is of type int. ncol is of type int. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(163, varargin{:});

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
    %Usage: retval = triplet (nrow, ncol, row, col)
    %
    %nrow is of type int. ncol is of type int. row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. nrow is of type int. ncol is of type int. row is of type std::vector< int,std::allocator< int > > const &. col is of type std::vector< int,std::allocator< int > > const &. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(164, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = compressed(varargin)
    %Create from a single vector containing the pattern in compressed column
    %storage format: The format: The first two entries are the number of rows
    %(nrow) and columns (ncol) The next ncol+1 entries are the column offsets
    %(colind). Note that the last element, colind[ncol], gives the number of
    %nonzeros The last colind[ncol] entries are the row indices
    %
    %
    %Usage: retval = compressed (v)
    %
    %v is of type std::vector< int,std::allocator< int > > const &. v is of type std::vector< int,std::allocator< int > > const &. retval is of type Sparsity. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(165, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = clearCache(varargin)
    %Usage: clearCache ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(167, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = testCast(varargin)
    %Usage: retval = testCast (ptr)
    %
    %ptr is of type casadi::SharedObjectNode const *. ptr is of type casadi::SharedObjectNode const *. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(245, varargin{:});

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
