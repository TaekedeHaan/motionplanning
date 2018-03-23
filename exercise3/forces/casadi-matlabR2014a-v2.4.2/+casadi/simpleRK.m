function varargout = simpleRK(varargin)
    %Construct an explicit Runge-Kutta integrator The constructed function (which
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
    %
    %Usage: retval = simpleRK (f, N = 10, order = 4)
    %
    %f is of type Function. N is of type int. order is of type int. f is of type Function. N is of type int. order is of type int. retval is of type MXFunction. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1221,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
