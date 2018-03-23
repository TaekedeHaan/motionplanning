function varargout = sdpOut(varargin)
    %Output arguments of an SDP Solver
    %
    %>Output scheme: casadi::SDPOutput (SDP_SOLVER_NUM_OUT = 7) [sdpOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SDP_SOLVER_X           | x                      | The primal solution (n |
    %|                        |                        | x 1) - may be used as  |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_P           | p                      | The solution P (m x m) |
    %|                        |                        | - may be used as       |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_DUAL        | dual                   | The dual solution (m x |
    %|                        |                        | m) - may be used as    |
    %|                        |                        | initial guess .        |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_COST        | cost                   | The primal optimal     |
    %|                        |                        | cost (1 x 1) .         |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_DUAL_COST   | dual_cost              | The dual optimal cost  |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LAM_A       | lam_a                  | The dual solution      |
    %|                        |                        | corresponding to the   |
    %|                        |                        | linear constraints (nc |
    %|                        |                        | x 1) .                 |
    %+------------------------+------------------------+------------------------+
    %| SDP_SOLVER_LAM_X       | lam_x                  | The dual solution      |
    %|                        |                        | corresponding to       |
    %|                        |                        | simple bounds (n x 1)  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = sdpOut (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1182,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
