function varargout = simpleIRK(varargin)
    %Construct an implicit Runge-Kutta integrator using a collocation scheme The
    %constructed function (which is of type MXFunction), has three inputs,
    %corresponding to initial state (x0), parameter (p) and integration time (h)
    %and one output, corresponding to final state (xf).
    %
    %Parameters:
    %-----------
    %
    %f:  ODE function with two inputs (x and p) and one output (xdot)
    %
    %N:  Number of integrator steps
    %
    %order:  Order of interpolating polynomials
    %
    %scheme:  Collocation scheme, as excepted by collocationPoints function.
    %
    %
    %Usage: retval = simpleIRK (f, N = 10, order = 4, scheme = "radau", solver = "newton", solver_options = casadi::Dict())
    %
    %f is of type Function. N is of type int. order is of type int. scheme is of type std::string const &. solver is of type std::string const &. solver_options is of type casadi::Dict const &. f is of type Function. N is of type int. order is of type int. scheme is of type std::string const &. solver is of type std::string const &. solver_options is of type casadi::Dict const &. retval is of type MXFunction. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1222,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
