function varargout = daeOut(varargin)
    %Output arguments of an DAE function
    %
    %>Output scheme: casadi::DAEOutput (DAE_NUM_OUT = 3) [daeOut]
    %
    %+-----------+-------+--------------------------------------------+
    %| Full name | Short |                Description                 |
    %+===========+=======+============================================+
    %| DAE_ODE   | ode   | Right hand side of the implicit ODE .      |
    %+-----------+-------+--------------------------------------------+
    %| DAE_ALG   | alg   | Right hand side of algebraic equations .   |
    %+-----------+-------+--------------------------------------------+
    %| DAE_QUAD  | quad  | Right hand side of quadratures equations . |
    %+-----------+-------+--------------------------------------------+
    %
    %
    %Usage: retval = daeOut (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1154,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
