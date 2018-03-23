classdef GenericMatrixCommon < SwigRef
    %Usage: GenericMatrixCommon ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = mpower(varargin)
    %Matrix power x^n.
    %
    %
    %Usage: retval = mpower (x, n)
    %
    %x is of type SX. n is of type SX. x is of type SX. n is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(272, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mrdivide(varargin)
    %Matrix divide (cf. slash '/' in MATLAB)
    %
    %
    %Usage: retval = mrdivide (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(273, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mldivide(varargin)
    %Matrix divide (cf. backslash '\\' in MATLAB)
    %
    %
    %Usage: retval = mldivide (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(274, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = symvar(varargin)
    %Get all symbols contained in the supplied expression Get all symbols on
    %which the supplied expression depends.
    %
    %See:   SXFunction::getFree(), MXFunction::getFree()
    %
    %
    %Usage: retval = symvar (x)
    %
    %x is of type SX. x is of type SX. retval is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(275, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = quad_form(varargin)
    %>  MatType quad_form(MatType X, MatType A)
    %------------------------------------------------------------------------
    %
    %Calculate quadratic form X^T A X.
    %
    %>  MatType quad_form(MatType X)
    %------------------------------------------------------------------------
    %
    %Calculate quadratic form X^T X.
    %
    %
    %Usage: retval = quad_form (X)
    %
    %X is of type SX. X is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(276, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sum_square(varargin)
    %Calculate some of squares: sum_ij X_ij^2.
    %
    %
    %Usage: retval = sum_square (X)
    %
    %X is of type SX. X is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(277, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = linspace(varargin)
    %Matlab's linspace command.
    %
    %
    %Usage: retval = linspace (a, b, nsteps)
    %
    %a is of type SX. b is of type SX. nsteps is of type int. a is of type SX. b is of type SX. nsteps is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(278, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = cross(varargin)
    %Matlab's cross command.
    %
    %
    %Usage: retval = cross (a, b, dim = -1)
    %
    %a is of type SX. b is of type SX. dim is of type int. a is of type SX. b is of type SX. dim is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(279, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = det(varargin)
    %Matrix determinant (experimental)
    %
    %
    %Usage: retval = det (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(280, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inv(varargin)
    %Matrix inverse (experimental)
    %
    %
    %Usage: retval = inv (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(281, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = trace(varargin)
    %Matrix trace.
    %
    %
    %Usage: retval = trace (a)
    %
    %a is of type SX. a is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(282, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tril2symm(varargin)
    %Convert a lower triangular matrix to a symmetric one.
    %
    %
    %Usage: retval = tril2symm (a)
    %
    %a is of type SX. a is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(283, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = triu2symm(varargin)
    %Convert a upper triangular matrix to a symmetric one.
    %
    %
    %Usage: retval = triu2symm (a)
    %
    %a is of type SX. a is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(284, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_F(varargin)
    %Frobenius norm.
    %
    %
    %Usage: retval = norm_F (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(285, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_2(varargin)
    %2-norm
    %
    %
    %Usage: retval = norm_2 (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(286, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_1(varargin)
    %1-norm
    %
    %
    %Usage: retval = norm_1 (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(287, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_inf(varargin)
    %Infinity-norm.
    %
    %
    %Usage: retval = norm_inf (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(288, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sumCols(varargin)
    %Return a col-wise summation of elements.
    %
    %
    %Usage: retval = sumCols (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(289, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sumRows(varargin)
    %Return a row-wise summation of elements.
    %
    %
    %Usage: retval = sumRows (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(290, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = inner_prod(varargin)
    %Inner product of two matrices with x and y matrices of the same dimension.
    %
    %
    %Usage: retval = inner_prod (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(291, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = outer_prod(varargin)
    %Take the outer product of two vectors Equals.
    %
    %with x and y vectors
    %
    %
    %Usage: retval = outer_prod (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(292, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nullspace(varargin)
    %Computes the nullspace of a matrix A.
    %
    %Finds Z m-by-(m-n) such that AZ = 0 with A n-by-m with m > n
    %
    %Assumes A is full rank
    %
    %Inspired by Numerical Methods in Scientific Computing by Ake Bjorck
    %
    %
    %Usage: retval = nullspace (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(293, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = polyval(varargin)
    %Evaluate a polynomial with coefficients p in x.
    %
    %
    %Usage: retval = polyval (p, x)
    %
    %p is of type SX. x is of type SX. p is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(294, varargin{:});

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
    %Get the diagonal of a matrix or construct a diagonal When the input is
    %square, the diagonal elements are returned. If the input is vector- like, a
    %diagonal matrix is constructed with it.
    %
    %
    %Usage: retval = diag (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(295, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unite(varargin)
    %Unite two matrices no overlapping sparsity.
    %
    %
    %Usage: retval = unite (A, B)
    %
    %A is of type SX. B is of type SX. A is of type SX. B is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(296, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = densify(varargin)
    %Make the matrix dense if not already.
    %
    %
    %Usage: retval = densify (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(297, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = project(varargin)
    %Create a new matrix with a given sparsity pattern but with the nonzeros
    %taken from an existing matrix.
    %
    %
    %Usage: retval = project (A, sp, intersect = false)
    %
    %A is of type SX. sp is of type Sparsity. intersect is of type bool. A is of type SX. sp is of type Sparsity. intersect is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(298, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = if_else(varargin)
    %Branching on MX nodes Ternary operator, "cond ? if_true : if_false".
    %
    %
    %Usage: retval = if_else (cond, if_true, if_false, short_circuit = true)
    %
    %cond is of type SX. if_true is of type SX. if_false is of type SX. short_circuit is of type bool. cond is of type SX. if_true is of type SX. if_false is of type SX. short_circuit is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(299, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = conditional(varargin)
    %Create a switch.
    %
    %If the condition
    %
    %Parameters:
    %-----------
    %
    %ind:  evaluates to the integer k, where 0<=k<f.size(), then x[k] will be
    %returned, otherwise
    %
    %x_default:  will be returned.
    %
    %
    %Usage: retval = conditional (ind, x, x_default, short_circuit = true)
    %
    %ind is of type SX. x is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. x_default is of type SX. short_circuit is of type bool. ind is of type SX. x is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. x_default is of type SX. short_circuit is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(300, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = dependsOn(varargin)
    %Check if expression depends on the argument The argument must be symbolic.
    %
    %
    %Usage: retval = dependsOn (f, arg)
    %
    %f is of type SX. arg is of type SX. f is of type SX. arg is of type SX. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(301, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = solve(varargin)
    %>  MatType solve(MatType A, MatType b)
    %------------------------------------------------------------------------
    %
    %Solve a system of equations: A*x = b The solve routine works similar to
    %Matlab's backslash when A is square and nonsingular. The algorithm used is
    %the following:
    %
    %A simple forward or backward substitution if A is upper or lower triangular
    %
    %If the linear system is at most 3-by-3, form the inverse via minor expansion
    %and multiply
    %
    %Permute the variables and equations as to get a (structurally) nonzero
    %diagonal, then perform a QR factorization without pivoting and solve the
    %factorized system.
    %
    %Note 1: If there are entries of the linear system known to be zero, these
    %will be removed. Elements that are very small, or will evaluate to be zero,
    %can still cause numerical errors, due to the lack of pivoting (which is not
    %possible since cannot compare the size of entries)
    %
    %Note 2: When permuting the linear system, a BLT (block lower triangular)
    %transformation is formed. Only the permutation part of this is however used.
    %An improvement would be to solve block-by-block if there are multiple BLT
    %blocks.
    %
    %>  MatType solve(MatType A, MatType b, str lsolver, Dict dict=Dict())
    %------------------------------------------------------------------------
    %
    %Solve a system of equations: A*x = b.
    %
    %
    %Usage: retval = solve (A, b, lsolver, opts = casadi::Dict())
    %
    %A is of type SX. b is of type SX. lsolver is of type std::string const &. opts is of type casadi::Dict const &. A is of type SX. b is of type SX. lsolver is of type std::string const &. opts is of type casadi::Dict const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(302, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = pinv(varargin)
    %>  MatType pinv(MatType A)
    %------------------------------------------------------------------------
    %
    %Computes the Moore-Penrose pseudo-inverse.
    %
    %If the matrix A is fat (size1<size2), mul(A, pinv(A)) is unity.
    %
    %pinv(A)' = (AA')^(-1) A
    %
    %If the matrix A is slender (size1>size2), mul(pinv(A), A) is unity.
    %
    %pinv(A) = (A'A)^(-1) A'
    %
    %>  MatType pinv(MatType A, str lsolver, Dict dict=Dict())
    %------------------------------------------------------------------------
    %
    %Computes the Moore-Penrose pseudo-inverse.
    %
    %If the matrix A is fat (size1>size2), mul(A, pinv(A)) is unity. If the
    %matrix A is slender (size2<size1), mul(pinv(A), A) is unity.
    %
    %
    %Usage: retval = pinv (A, lsolver, opts = casadi::Dict())
    %
    %A is of type SX. lsolver is of type std::string const &. opts is of type casadi::Dict const &. A is of type SX. lsolver is of type std::string const &. opts is of type casadi::Dict const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(303, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = jacobian(varargin)
    %Calculate jacobian via source code transformation.
    %
    %
    %Usage: retval = jacobian (ex, arg)
    %
    %ex is of type SX. arg is of type SX. ex is of type SX. arg is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(304, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = gradient(varargin)
    %Matrix power x^n.
    %
    %
    %Usage: retval = gradient (ex, arg)
    %
    %ex is of type SX. arg is of type SX. ex is of type SX. arg is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(305, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tangent(varargin)
    %Matrix power x^n.
    %
    %
    %Usage: retval = tangent (ex, arg)
    %
    %ex is of type SX. arg is of type SX. ex is of type SX. arg is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(306, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = hessian(varargin)
    %Usage: retval = hessian (ex, arg, output_g)
    %
    %ex is of type SX. arg is of type SX. output_g is of type SX. ex is of type SX. arg is of type SX. output_g is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(307, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = countNodes(varargin)
    %Count number of nodes
    %
    %
    %Usage: retval = countNodes (A)
    %
    %A is of type SX. A is of type SX. retval is of type int. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(308, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getOperatorRepresentation(varargin)
    %Get a string representation for a binary MatType, using custom arguments.
    %
    %
    %Usage: retval = getOperatorRepresentation (xb, args)
    %
    %xb is of type SX. args is of type std::vector< std::string,std::allocator< std::string > > const &. xb is of type SX. args is of type std::vector< std::string,std::allocator< std::string > > const &. retval is of type std::string. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(309, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = repsum(varargin)
    %Given a repeated matrix, computes the sum of repeated parts.
    %
    %
    %Usage: retval = repsum (A, n, m = 1)
    %
    %A is of type SX. n is of type int. m is of type int. A is of type SX. n is of type int. m is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(310, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = GenericMatrixCommon(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(311, varargin{:});
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
        casadiMEX(312, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
