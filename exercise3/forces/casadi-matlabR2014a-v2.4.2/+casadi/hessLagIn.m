function varargout = hessLagIn(varargin)
    %Input arguments of an NLP Hessian function
    %
    %>Input scheme: casadi::HessLagInput (HESSLAG_NUM_IN = 4) [hessLagIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| HESSLAG_X              | x                      | Decision variable .    |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_P              | p                      | Fixed parameter .      |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_LAM_F          | lam_f                  | Multiplier for f. Just |
    %|                        |                        | a scalar factor for    |
    %|                        |                        | the objective that the |
    %|                        |                        | NLP solver might use   |
    %|                        |                        | to scale the           |
    %|                        |                        | objective.             |
    %+------------------------+------------------------+------------------------+
    %| HESSLAG_LAM_G          | lam_g                  | Multiplier for g .     |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = hessLagIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1173,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
