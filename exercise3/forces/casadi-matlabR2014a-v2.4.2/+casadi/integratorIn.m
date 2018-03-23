function varargout = integratorIn(varargin)
    %Input arguments of an integrator
    %
    %>Input scheme: casadi::IntegratorInput (INTEGRATOR_NUM_IN = 6) [integratorIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| INTEGRATOR_X0          | x0                     | Differential state at  |
    %|                        |                        | the initial time .     |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_P           | p                      | Parameters .           |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_Z0          | z0                     | Initial guess for the  |
    %|                        |                        | algebraic variable .   |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RX0         | rx0                    | Backward differential  |
    %|                        |                        | state at the final     |
    %|                        |                        | time .                 |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RP          | rp                     | Backward parameter     |
    %|                        |                        | vector .               |
    %+------------------------+------------------------+------------------------+
    %| INTEGRATOR_RZ0         | rz0                    | Initial guess for the  |
    %|                        |                        | backwards algebraic    |
    %|                        |                        | variable .             |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = integratorIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1157,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
