function varargout = controldaeIn(varargin)
    %Input arguments of an ODE/DAE function
    %
    %>Input scheme: casadi::ControlledDAEInput (CONTROL_DAE_NUM_IN = 9) [controldaeIn]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| CONTROL_DAE_T          | t                      | Global physical time.  |
    %|                        |                        | (1-by-1) .             |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_X          | x                      | State vector           |
    %|                        |                        | (dimension nx-by-1).   |
    %|                        |                        | Should have the same   |
    %|                        |                        | amount of non-zeros as |
    %|                        |                        | DAEOutput:DAE_RES      |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_Z          | z                      | Algebraic state vector |
    %|                        |                        | (dimension np-by-1). . |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_P          | p                      | Parameter vector       |
    %|                        |                        | (dimension np-by-1). . |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_U          | u                      | Control vector         |
    %|                        |                        | (dimension nu-by-1). . |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_U_INTERP   | u_interp               | Control vector,        |
    %|                        |                        | linearly interpolated  |
    %|                        |                        | (dimension nu-by-1). . |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_X_MAJOR    | x_major                | State vector           |
    %|                        |                        | (dimension nx-by-1) at |
    %|                        |                        | the last major time-   |
    %|                        |                        | step .                 |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_T0         | t0                     | Time at start of       |
    %|                        |                        | control interval       |
    %|                        |                        | (1-by-1) .             |
    %+------------------------+------------------------+------------------------+
    %| CONTROL_DAE_TF         | tf                     | Time at end of control |
    %|                        |                        | interval (1-by-1) .    |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = controldaeIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity(), n5 = "", x5 = casadi::Sparsity(), n6 = "", x6 = casadi::Sparsity(), n7 = "", x7 = casadi::Sparsity(), n8 = "", x8 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n5 is of type std::string const &. x5 is of type Sparsity. n6 is of type std::string const &. x6 is of type Sparsity. n7 is of type std::string const &. x7 is of type Sparsity. n8 is of type std::string const &. x8 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1146,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
