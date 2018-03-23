function varargout = nlpSolverIn(varargin)
    %Input arguments of an NLP Solver
    %
    %>Input scheme: casadi::NlpSolverInput (NLP_SOLVER_NUM_IN = 8) [nlpSolverIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X0          | x0                     | Decision variables,    |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_P           | p                      | Value of fixed         |
    %|                        |                        | parameters (np x 1) .  |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBX         | lbx                    | Decision variables     |
    %|                        |                        | lower bound (nx x 1),  |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBX         | ubx                    | Decision variables     |
    %|                        |                        | upper bound (nx x 1),  |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LBG         | lbg                    | Constraints lower      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default -inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_UBG         | ubg                    | Constraints upper      |
    %|                        |                        | bound (ng x 1),        |
    %|                        |                        | default +inf .         |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X0      | lam_x0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on X,       |
    %|                        |                        | initial guess (nx x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G0      | lam_g0                 | Lagrange multipliers   |
    %|                        |                        | for bounds on G,       |
    %|                        |                        | initial guess (ng x 1) |
    %|                        |                        | .                      |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = nlpSolverIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity(), n7 = "", x7 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1175,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
