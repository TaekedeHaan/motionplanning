function varargout = nlpSolverOut(varargin)
    %Output arguments of an NLP Solver
    %
    %>Output scheme: casadi::NlpSolverOutput (NLP_SOLVER_NUM_OUT = 6) [nlpSolverOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| NLP_SOLVER_X           | x                      | Decision variables at  |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (nx x 1) .             |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_F           | f                      | Cost function value at |
    %|                        |                        | the optimal solution   |
    %|                        |                        | (1 x 1) .              |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_G           | g                      | Constraints function   |
    %|                        |                        | at the optimal         |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_X       | lam_x                  | Lagrange multipliers   |
    %|                        |                        | for bounds on X at the |
    %|                        |                        | solution (nx x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_G       | lam_g                  | Lagrange multipliers   |
    %|                        |                        | for bounds on G at the |
    %|                        |                        | solution (ng x 1) .    |
    %+------------------------+------------------------+------------------------+
    %| NLP_SOLVER_LAM_P       | lam_p                  | Lagrange multipliers   |
    %|                        |                        | for bounds on P at the |
    %|                        |                        | solution (np x 1) .    |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = nlpSolverOut (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1176,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
