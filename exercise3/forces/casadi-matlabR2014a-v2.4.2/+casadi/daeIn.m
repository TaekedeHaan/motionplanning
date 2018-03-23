function varargout = daeIn(varargin)
    %Input arguments of an ODE/DAE function
    %
    %>Input scheme: casadi::DAEInput (DAE_NUM_IN = 4) [daeIn]
    %
    %+-----------+-------+----------------------------+
    %| Full name | Short |        Description         |
    %+===========+=======+============================+
    %| DAE_X     | x     | Differential state .       |
    %+-----------+-------+----------------------------+
    %| DAE_Z     | z     | Algebraic state .          |
    %+-----------+-------+----------------------------+
    %| DAE_P     | p     | Parameter .                |
    %+-----------+-------+----------------------------+
    %| DAE_T     | t     | Explicit time dependence . |
    %+-----------+-------+----------------------------+
    %
    %
    %Usage: retval = daeIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1153,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
