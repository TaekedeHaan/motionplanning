function varargout = socpOut(varargin)
    %Output arguments of an SOCP Solver
    %
    %>Output scheme: casadi::SOCPOutput (SOCP_SOLVER_NUM_OUT = 6) [socpOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SOCP_SOLVER_X          | x                      | The primal solution (n |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_COST       | cost                   | The primal optimal     |
    %|                        |                        | cost (1 x 1) .         |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_DUAL_COST  | dual_cost              | The dual optimal cost  |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_A      | lam_a                  | The dual solution      |
    %|                        |                        | corresponding to the   |
    %|                        |                        | linear constraints (nc |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_X      | lam_x                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | simple bounds (n x 1)  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LAM_CONE   | lam_cone               | The dual solution      |
    %|                        |                        | correspoding to cone   |
    %|                        |                        | (2-norm) constraints   |
    %|                        |                        | (m x 1) .              |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = socpOut (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1186,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
