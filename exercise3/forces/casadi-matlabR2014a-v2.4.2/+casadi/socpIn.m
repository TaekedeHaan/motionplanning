function varargout = socpIn(varargin)
    %Input arguments of a SOCP problem
    %
    %>Input scheme: casadi::SOCPInput (SOCP_SOLVER_NUM_IN = 10) [socpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SOCP_SOLVER_G          | g                      | The horizontal stack   |
    %|                        |                        | of all matrices Gi: (  |
    %|                        |                        | n x N) .               |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_H          | h                      | The vertical stack of  |
    %|                        |                        | all vectors hi: ( N x  |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_E          | e                      | The horizontal stack   |
    %|                        |                        | of all vectors ei: ( n |
    %|                        |                        | x m) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_F          | f                      | The vertical stack of  |
    %|                        |                        | all scalars fi: ( m x  |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_C          | c                      | The vector c: ( n x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_A          | a                      | The matrix A: ( nc x   |
    %|                        |                        | n) .                   |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LBA        | lba                    | Lower bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_UBA        | uba                    | Upper bounds on Ax (   |
    %|                        |                        | nc x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_LBX        | lbx                    | Lower bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %| SOCP_SOLVER_UBX        | ubx                    | Upper bounds on x ( n  |
    %|                        |                        | x 1 ) .                |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = socpIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity(), n7 = "", x7 = casadi::Sparsity(), n8 = "", x8 = casadi::Sparsity(), n9 = "", x9 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n9 is of type std::string const &. x9 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n9 is of type std::string const &. x9 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1185,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
