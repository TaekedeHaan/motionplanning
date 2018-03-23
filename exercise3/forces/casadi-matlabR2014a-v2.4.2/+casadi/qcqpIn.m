function varargout = qcqpIn(varargin)
    %Input arguments of a QP problem
    %
    %>Input scheme: casadi::QcqpSolverInput (QCQP_SOLVER_NUM_IN = 12) [qcqpIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| QCQP_SOLVER_H          | h                      | The square matrix H:   |
    %|                        |                        | sparse, (n x n). Only  |
    %|                        |                        | the lower triangular   |
    %|                        |                        | part is actually used. |
    %|                        |                        | The matrix is assumed  |
    %|                        |                        | to be symmetrical.     |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_G          | g                      | The vector g: dense,   |
    %|                        |                        | (n x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_P          | p                      | The horizontal stack   |
    %|                        |                        | of all Pi. Each Pi is  |
    %|                        |                        | sparse (n x n). Only   |
    %|                        |                        | the lower triangular   |
    %|                        |                        | part is actually used. |
    %|                        |                        | The matrix is assumed  |
    %|                        |                        | to be symmetrical.     |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_Q          | q                      | The vertical stack of  |
    %|                        |                        | all qi: dense, (nq n x |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_R          | r                      | The vertical stack of  |
    %|                        |                        | all scalars ri (nq x   |
    %|                        |                        | 1) .                   |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_A          | a                      | The matrix A: sparse,  |
    %|                        |                        | (nc x n) - product     |
    %|                        |                        | with x must be dense.  |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_LBA        | lba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_UBA        | uba                    | dense, (nc x 1)        |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_LBX        | lbx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_UBX        | ubx                    | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_X0         | x0                     | dense, (n x 1)         |
    %+------------------------+------------------------+------------------------+
    %| QCQP_SOLVER_LAM_X0     | lam_x0                 | dense                  |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = qcqpIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity(), n7 = "", x7 = casadi::Sparsity(), n8 = "", x8 = casadi::Sparsity(), n9 = "", x9 = casadi::Sparsity(), n10 = "", x10 = casadi::Sparsity(), n11 = "", x11 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n9 is of type std::string const &. x9 is of type Sparsity. n10 is of type std::string const &. x10 is of type Sparsity. n11 is of type std::string const &. x11 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n9 is of type std::string const &. x9 is of type Sparsity. n10 is of type std::string const &. x10 is of type Sparsity. n11 is of type std::string const &. x11 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1177,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
