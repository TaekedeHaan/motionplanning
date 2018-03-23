classdef MatrixCommon < SwigRef
    %Usage: MatrixCommon ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = all(varargin)
    %Returns true only if every element in the matrix is true.
    %
    %
    %Usage: retval = all (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(481, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = any(varargin)
    %Returns true only if any element in the matrix is true.
    %
    %
    %Usage: retval = any (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(482, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = adj(varargin)
    %Matrix adjoint.
    %
    %
    %Usage: retval = adj (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(483, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = getMinor(varargin)
    %Get the (i,j) minor matrix.
    %
    %
    %Usage: retval = getMinor (x, i, j)
    %
    %x is of type SX. i is of type int. j is of type int. x is of type SX. i is of type int. j is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(484, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = cofactor(varargin)
    %Get the (i,j) cofactor matrix.
    %
    %
    %Usage: retval = cofactor (x, i, j)
    %
    %x is of type SX. i is of type int. j is of type int. x is of type SX. i is of type int. j is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(485, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = qr(varargin)
    %QR factorization using the modified Gram-Schmidt algorithm More stable than
    %the classical Gram-Schmidt, but may break down if the rows of A are nearly
    %linearly dependent See J. Demmel: Applied Numerical Linear Algebra
    %(algorithm 3.1.). Note that in SWIG, Q and R are returned by value.
    %
    %
    %Usage: qr (A, output_Q, output_R)
    %
    %A is of type SX. output_Q is of type SX. output_R is of type SX. 

      try

      [varargout{1:nargout}] = casadiMEX(486, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = chol(varargin)
    %Obtain a Cholesky factorisation of a matrix Returns an upper triangular R
    %such that R'R = A. Matrix A must be positive definite.
    %
    %At the moment, the algorithm is dense (Cholesky-Banachiewicz). There is an
    %open ticket #1212 to make it sparse.
    %
    %
    %Usage: retval = chol (A)
    %
    %A is of type SX. A is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(487, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = norm_inf_mul(varargin)
    %Inf-norm of a Matrix-Matrix product.
    %
    %
    %Usage: retval = norm_inf_mul (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(488, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sparsify(varargin)
    %Make a matrix sparse by removing numerical zeros.
    %
    %
    %Usage: retval = sparsify (A, tol = 0)
    %
    %A is of type SX. tol is of type double. A is of type SX. tol is of type double. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(489, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = expand(varargin)
    %Expand the expression as a weighted sum (with constant weights)
    %
    %
    %Usage: expand (ex, output_weights, output_terms)
    %
    %ex is of type SX. output_weights is of type SX. output_terms is of type SX. 

      try

      [varargout{1:nargout}] = casadiMEX(490, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = pw_const(varargin)
    %Create a piecewise constant function Create a piecewise constant function
    %with n=val.size() intervals.
    %
    %Inputs:
    %
    %Parameters:
    %-----------
    %
    %t:  a scalar variable (e.g. time)
    %
    %tval:  vector with the discrete values of t at the interval transitions
    %(length n-1)
    %
    %val:  vector with the value of the function for each interval (length n)
    %
    %
    %Usage: retval = pw_const (t, tval, val)
    %
    %t is of type SX. tval is of type SX. val is of type SX. t is of type SX. tval is of type SX. val is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(491, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = pw_lin(varargin)
    %t a scalar variable (e.g. time)
    %
    %Create a piecewise linear function Create a piecewise linear function:
    %
    %Inputs: tval vector with the the discrete values of t (monotonically
    %increasing) val vector with the corresponding function values (same length
    %as tval)
    %
    %
    %Usage: retval = pw_lin (t, tval, val)
    %
    %t is of type SX. tval is of type SX. val is of type SX. t is of type SX. tval is of type SX. val is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(492, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = heaviside(varargin)
    %Heaviside function.
    %
    %\\[ \\begin {cases} H(x) = 0 & x<0 \\\\ H(x) = 1/2 & x=0 \\\\
    %H(x) = 1 & x>0 \\\\ \\end {cases} \\]
    %
    %
    %Usage: retval = heaviside (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(493, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = rectangle(varargin)
    %rectangle function
    %
    %\\[ \\begin {cases} \\Pi(x) = 1 & |x| < 1/2 \\\\ \\Pi(x) = 1/2 &
    %|x| = 1/2 \\\\ \\Pi(x) = 0 & |x| > 1/2 \\\\ \\end {cases} \\]
    %
    %Also called: gate function, block function, band function, pulse function,
    %window function
    %
    %
    %Usage: retval = rectangle (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(494, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = triangle(varargin)
    %triangle function
    %
    %\\[ \\begin {cases} \\Lambda(x) = 0 & |x| >= 1 \\\\ \\Lambda(x)
    %= 1-|x| & |x| < 1 \\end {cases} \\]
    %
    %
    %Usage: retval = triangle (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(495, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ramp(varargin)
    %ramp function
    %
    %\\[ \\begin {cases} R(x) = 0 & x <= 1 \\\\ R(x) = x & x > 1 \\\\
    %\\end {cases} \\]
    %
    %Also called: slope function
    %
    %
    %Usage: retval = ramp (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(496, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = gauss_quadrature(varargin)
    %>  array(DataType)  gauss_quadrature(array(DataType) f, array(DataType) x, array(DataType) a, array(DataType) b, int order=5)
    %------------------------------------------------------------------------
    %
    %Integrate f from a to b using Gaussian quadrature with n points.
    %
    %>  array(DataType)  gauss_quadrature(array(DataType) f, array(DataType) x, array(DataType) a, array(DataType) b, int order, array(DataType) w)
    %------------------------------------------------------------------------
    %
    %Matrix adjoint.
    %
    %
    %Usage: retval = gauss_quadrature (f, x, a, b, order, w)
    %
    %f is of type SX. x is of type SX. a is of type SX. b is of type SX. order is of type int. w is of type SX. f is of type SX. x is of type SX. a is of type SX. b is of type SX. order is of type int. w is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(497, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = jacobianTimesVector(varargin)
    %Calculate the Jacobian and multiply by a vector from the right This is
    %equivalent to mul(jacobian(ex, arg), v) or mul(jacobian(ex, arg).T, v) for
    %transpose_jacobian set to false and true respectively. If contrast to these
    %expressions, it will use directional derivatives which is typically (but not
    %necessarily) more efficient if the complete Jacobian is not needed and v has
    %few rows.
    %
    %
    %Usage: retval = jacobianTimesVector (ex, arg, v, transpose_jacobian = false)
    %
    %ex is of type SX. arg is of type SX. v is of type SX. transpose_jacobian is of type bool. ex is of type SX. arg is of type SX. v is of type SX. transpose_jacobian is of type bool. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(498, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = taylor(varargin)
    %univariate Taylor series expansion
    %
    %Calculate the Taylor expansion of expression 'ex' up to order 'order' with
    %respect to variable 'x' around the point 'a'
    %
    %$(x)=f(a)+f'(a)(x-a)+f''(a)\\frac
    %{(x-a)^2}{2!}+f'''(a)\\frac{(x-a)^3}{3!}+\\ldots$
    %
    %Example usage:
    %
    %::
    %
    %>>   x
    %
    %
    %
    %
    %Usage: retval = taylor (ex, x, a = 0, order = 1)
    %
    %ex is of type SX. x is of type SX. a is of type SX. order is of type int. ex is of type SX. x is of type SX. a is of type SX. order is of type int. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(499, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mtaylor(varargin)
    %>  array(DataType)  mtaylor(array(DataType) ex, array(DataType) x, array(DataType) a, int order=1)
    %------------------------------------------------------------------------
    %
    %multivariate Taylor series expansion
    %
    %Do Taylor expansions until the aggregated order of a term is equal to
    %'order'. The aggregated order of $x^n y^m$ equals $n+m$.
    %
    %>  array(DataType)  mtaylor(array(DataType) ex, array(DataType) x, array(DataType) a, int order, [int ] order_contributions)
    %------------------------------------------------------------------------
    %
    %multivariate Taylor series expansion
    %
    %Do Taylor expansions until the aggregated order of a term is equal to
    %'order'. The aggregated order of $x^n y^m$ equals $n+m$.
    %
    %The argument order_contributions can denote how match each variable
    %contributes to the aggregated order. If x=[x, y] and order_contributions=[1,
    %2], then the aggregated order of $x^n y^m$ equals $1n+2m$.
    %
    %Example usage
    %
    %$ \\sin(b+a)+\\cos(b+a)(x-a)+\\cos(b+a)(y-b) $ $ y+x-(x^3+3y x^2+3 y^2
    %x+y^3)/6 $ $ (-3 x^2 y-x^3)/6+y+x $
    %
    %
    %Usage: retval = mtaylor (ex, x, a, order, order_contributions)
    %
    %ex is of type SX. x is of type SX. a is of type SX. order is of type int. order_contributions is of type std::vector< int,std::allocator< int > > const &. ex is of type SX. x is of type SX. a is of type SX. order is of type int. order_contributions is of type std::vector< int,std::allocator< int > > const &. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(500, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = poly_coeff(varargin)
    %extracts polynomial coefficients from an expression
    %
    %Parameters:
    %-----------
    %
    %ex:  Scalar expression that represents a polynomial
    %
    %x:  Scalar symbol that the polynomial is build up with
    %
    %
    %Usage: retval = poly_coeff (ex, x)
    %
    %ex is of type SX. x is of type SX. ex is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(501, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = poly_roots(varargin)
    %Attempts to find the roots of a polynomial.
    %
    %This will only work for polynomials up to order 3 It is assumed that the
    %roots are real.
    %
    %
    %Usage: retval = poly_roots (p)
    %
    %p is of type SX. p is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(502, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eig_symbolic(varargin)
    %Attempts to find the eigenvalues of a symbolic matrix This will only work
    %for up to 3x3 matrices.
    %
    %
    %Usage: retval = eig_symbolic (m)
    %
    %m is of type SX. m is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(503, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = MatrixCommon(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(504, varargin{:});
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
        casadiMEX(505, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
