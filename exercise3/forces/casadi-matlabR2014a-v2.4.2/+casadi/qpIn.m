function varargout = qpIn(varargin)
    %Input arguments of a QP problem
    %
    %>Input scheme: casadi::QpSolverInput (QP_SOLVER_NUM_IN = 9) [qpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| QP_SOLVER_H            | h                      | The square matrix H:   |
    %|                        |                        | sparse, (n x n). Only  |
    %|                        |                        | the lower triangular   |
    %|                        |                        | part is actually used. |
    %|                        |                        | The matrix is assumed  |
    %|                        |                        | to be symmetrical.     |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_G            | g                      | The vector g: dense,   |
    %|                        |                        | (n x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_A            | a                      | The matrix A: sparse,  |
    %|                        |                        | (nc x n) - product     |
    %|                        |                        | with x must be dense.  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LBA          | lba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_UBA          | uba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LBX          | lbx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_UBX          | ubx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_X0           | x0                     | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QP_SOLVER_LAM_X0       | lam_x0                 | dense                  |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = qpIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity(), n7 = "", x7 = casadi::Sparsity(), n8 = "", x8 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1179,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
