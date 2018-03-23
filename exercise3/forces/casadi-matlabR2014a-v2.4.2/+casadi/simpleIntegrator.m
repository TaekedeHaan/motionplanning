function varargout = simpleIntegrator(varargin)
    %Simplified wrapper for the Integrator class Constructs an integrator using
    %the same syntax as simpleRK and simpleIRK. The constructed function (which
    %is of type MXFunction), has three inputs, corresponding to initial state
    %(x0), parameter (p) and integration time (h) and one output, corresponding
    %to final state (xf).
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
    %Usage: retval = simpleIntegrator (f, integrator = "cvodes", integrator_options = casadi::Dict())
    %
    %f is of type Function. integrator is of type std::string const &. integrator_options is of type casadi::Dict const &. f is of type Function. integrator is of type std::string const &. integrator_options is of type casadi::Dict const &. retval is of type MXFunction. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1223,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
