function varargout = controlsimulatorIn(varargin)
    %Input arguments of a control simulator
    %
    %>Input scheme: casadi::ControlSimulatorInput (CONTROLSIMULATOR_NUM_IN = 3) [controlsimulatorIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| CONTROLSIMULATOR_X0    | x0                     | Differential or        |
    %|                        |                        | algebraic state at t0  |
    %|                        |                        | (dimension nx-by-1) .  |
    %+------------------------+------------------------+------------------------+
    %| CONTROLSIMULATOR_P     | p                      | Parameters that are    |
    %|                        |                        | fixed over the entire  |
    %|                        |                        | horizon (dimension np- |
    %|                        |                        | by-1) .                |
    %+------------------------+------------------------+------------------------+
    %| CONTROLSIMULATOR_U     | u                      | Parameters that change |
    %|                        |                        | over the integration   |
    %|                        |                        | intervals (dimension   |
    %|                        |                        | nu-by-(ns-1)) .        |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = controlsimulatorIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1147,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
