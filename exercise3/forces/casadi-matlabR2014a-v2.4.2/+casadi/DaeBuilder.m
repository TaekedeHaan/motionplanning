classdef DaeBuilder < casadi.PrintDaeBuilder
    %An initial-value problem in differential-algebraic equations.
    %
    %Independent variables:
    %======================
    %
    %
    %
    %
    %
    %::
    %
    %  t:      time
    %  
    %
    %
    %
    %Time-continuous variables:
    %==========================
    %
    %
    %
    %
    %
    %::
    %
    %  x:      states defined by ODE
    %  s:      implicitly defined states
    %  z:      algebraic variables
    %  u:      control signals
    %  q:      quadrature states
    %  y:      outputs
    %  
    %
    %
    %
    %Time-constant variables:
    %========================
    %
    %
    %
    %
    %
    %::
    %
    %  p:      free parameters
    %  d:      dependent parameters
    %  
    %
    %
    %
    %Dynamic constraints (imposed everywhere):
    %=========================================
    %
    %
    %
    %
    %
    %::
    %
    %  ODE                    \\dot{x} ==  ode(t, x, s, z, u, p, d)
    %  DAE or implicit ODE:         0 ==  dae(t, x, s, z, u, p, d, sdot)
    %  algebraic equations:         0 ==  alg(t, x, s, z, u, p, d)
    %  quadrature equations:  \\dot{q} == quad(t, x, s, z, u, p, d)
    %  deppendent parameters:       d == ddef(t, x, s, z, u, p, d)
    %  output equations:            y == ydef(t, x, s, z, u, p, d)
    %  
    %
    %
    %
    %Point constraints (imposed pointwise):
    %======================================
    %
    %
    %
    %
    %
    %::
    %
    %  Initial equations:           0 == init(t, x, s, z, u, p, d, sdot)
    %  
    %
    %
    %
    %Joel Andersson
    %
    %C++ includes: dae_builder.hpp 
    %Usage: DaeBuilder ()
    %
  methods
    function v = t(self)
      v = casadiMEX(1260, self);
    end
    function v = x(self)
      v = casadiMEX(1261, self);
    end
    function v = ode(self)
      v = casadiMEX(1262, self);
    end
    function v = lam_ode(self)
      v = casadiMEX(1263, self);
    end
    function v = s(self)
      v = casadiMEX(1264, self);
    end
    function v = sdot(self)
      v = casadiMEX(1265, self);
    end
    function v = dae(self)
      v = casadiMEX(1266, self);
    end
    function v = lam_dae(self)
      v = casadiMEX(1267, self);
    end
    function v = z(self)
      v = casadiMEX(1268, self);
    end
    function v = alg(self)
      v = casadiMEX(1269, self);
    end
    function v = lam_alg(self)
      v = casadiMEX(1270, self);
    end
    function v = q(self)
      v = casadiMEX(1271, self);
    end
    function v = quad(self)
      v = casadiMEX(1272, self);
    end
    function v = lam_quad(self)
      v = casadiMEX(1273, self);
    end
    function v = w(self)
      v = casadiMEX(1274, self);
    end
    function v = wdef(self)
      v = casadiMEX(1275, self);
    end
    function v = lam_wdef(self)
      v = casadiMEX(1276, self);
    end
    function v = y(self)
      v = casadiMEX(1277, self);
    end
    function v = ydef(self)
      v = casadiMEX(1278, self);
    end
    function v = lam_ydef(self)
      v = casadiMEX(1279, self);
    end
    function v = u(self)
      v = casadiMEX(1280, self);
    end
    function v = p(self)
      v = casadiMEX(1281, self);
    end
    function v = c(self)
      v = casadiMEX(1282, self);
    end
    function v = cdef(self)
      v = casadiMEX(1283, self);
    end
    function v = d(self)
      v = casadiMEX(1284, self);
    end
    function v = ddef(self)
      v = casadiMEX(1285, self);
    end
    function v = lam_ddef(self)
      v = casadiMEX(1286, self);
    end
    function v = init(self)
      v = casadiMEX(1287, self);
    end
    function varargout = add_p(self,varargin)
    %Add a new parameter
    %
    %
    %Usage: retval = add_p (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1288, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_u(self,varargin)
    %Add a new control.
    %
    %
    %Usage: retval = add_u (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1289, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_x(self,varargin)
    %Add a new differential state.
    %
    %
    %Usage: retval = add_x (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1290, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_s(self,varargin)
    %Add a implicit state.
    %
    %
    %Usage: retval = add_s (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type std::pair< casadi::MX,casadi::MX >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1291, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_z(self,varargin)
    %Add a new algebraic variable.
    %
    %
    %Usage: retval = add_z (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1292, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_q(self,varargin)
    %Add a new quadrature state.
    %
    %
    %Usage: retval = add_q (name = std::string(), n = 1)
    %
    %name is of type std::string const &. n is of type int. name is of type std::string const &. n is of type int. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1293, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_d(self,varargin)
    %Add a new dependent parameter.
    %
    %
    %Usage: retval = add_d (new_ddef, name = std::string())
    %
    %new_ddef is of type MX. name is of type std::string const &. new_ddef is of type MX. name is of type std::string const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1294, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_y(self,varargin)
    %Add a new output.
    %
    %
    %Usage: retval = add_y (new_ydef, name = std::string())
    %
    %new_ydef is of type MX. name is of type std::string const &. new_ydef is of type MX. name is of type std::string const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1295, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_ode(self,varargin)
    %Add an ordinary differential equation.
    %
    %
    %Usage: add_ode (new_ode, name = std::string())
    %
    %new_ode is of type MX. name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1296, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_dae(self,varargin)
    %Add a differential-algebraic equation.
    %
    %
    %Usage: add_dae (new_dae, name = std::string())
    %
    %new_dae is of type MX. name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1297, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_alg(self,varargin)
    %Add an algebraic equation.
    %
    %
    %Usage: add_alg (new_alg, name = std::string())
    %
    %new_alg is of type MX. name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1298, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = add_quad(self,varargin)
    %Add a quadrature equation.
    %
    %
    %Usage: add_quad (new_quad, name = std::string())
    %
    %new_quad is of type MX. name is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1299, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sanityCheck(self,varargin)
    %Check if dimensions match.
    %
    %
    %Usage: sanityCheck ()
    %

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:nargout}] = casadiMEX(1300, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = split_dae(self,varargin)
    %Identify and separate the algebraic variables and equations in the DAE.
    %
    %
    %Usage: split_dae ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1301, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eliminate_alg(self,varargin)
    %Eliminate algebraic variables and equations transforming them into outputs.
    %
    %
    %Usage: eliminate_alg ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1302, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeSemiExplicit(self,varargin)
    %Transform the implicit DAE to a semi-explicit DAE.
    %
    %
    %Usage: makeSemiExplicit ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1303, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = makeExplicit(self,varargin)
    %Transform the implicit DAE or semi-explicit DAE into an explicit ODE.
    %
    %
    %Usage: makeExplicit ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1304, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sort_d(self,varargin)
    %Sort dependent parameters.
    %
    %
    %Usage: sort_d ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1305, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = split_d(self,varargin)
    %Eliminate interdependencies amongst dependent parameters.
    %
    %
    %Usage: split_d ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1306, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eliminate_d(self,varargin)
    %Eliminate dependent parameters.
    %
    %
    %Usage: eliminate_d ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1307, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eliminate_quad(self,varargin)
    %Eliminate quadrature states and turn them into ODE states.
    %
    %
    %Usage: eliminate_quad ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1308, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sort_dae(self,varargin)
    %Sort the DAE and implicitly defined states.
    %
    %
    %Usage: sort_dae ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1309, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sort_alg(self,varargin)
    %Sort the algebraic equations and algebraic states.
    %
    %
    %Usage: sort_alg ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1310, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = scaleVariables(self,varargin)
    %Scale the variables.
    %
    %
    %Usage: scaleVariables ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1311, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = scaleEquations(self,varargin)
    %Scale the implicit equations.
    %
    %
    %Usage: scaleEquations ()
    %

      try

      [varargout{1:nargout}] = casadiMEX(1312, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = parseFMI(self,varargin)
    %Import existing problem from FMI/XML
    %
    %
    %Usage: parseFMI (filename)
    %
    %filename is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1313, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addLinearCombination(self,varargin)
    %Add a named linear combination of output expressions.
    %
    %
    %Usage: retval = addLinearCombination (name, f_out)
    %
    %name is of type std::string const &. f_out is of type std::vector< std::string,std::allocator< std::string > > const &. name is of type std::string const &. f_out is of type std::vector< std::string,std::allocator< std::string > > const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1314, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = create(self,varargin)
    %Construct a function object.
    %
    %
    %Usage: retval = create (fname, s_in, s_out)
    %
    %fname is of type std::string const &. s_in is of type std::vector< std::string,std::allocator< std::string > > const &. s_out is of type std::vector< std::string,std::allocator< std::string > > const &. fname is of type std::string const &. s_in is of type std::vector< std::string,std::allocator< std::string > > const &. s_out is of type std::vector< std::string,std::allocator< std::string > > const &. retval is of type MXFunction. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1315, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = paren(self,varargin)
    %Usage: retval = paren (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type MX. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1316, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = der(self,varargin)
    %>  MX DaeBuilder.der(str name) const 
    %------------------------------------------------------------------------
    %
    %Get a derivative expression by name.
    %
    %>  MX DaeBuilder.der(MX var) const 
    %------------------------------------------------------------------------
    %
    %Get a derivative expression by non-differentiated expression.
    %
    %
    %Usage: retval = der (var)
    %
    %var is of type MX. var is of type MX. retval is of type MX. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1317, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = nominal(self,varargin)
    %>  double DaeBuilder.nominal(str name) const 
    %------------------------------------------------------------------------
    %
    %Get the nominal value by name.
    %
    %>  [double] DaeBuilder.nominal(MX var) const 
    %------------------------------------------------------------------------
    %
    %Get the nominal value(s) by expression.
    %
    %
    %Usage: retval = nominal (var)
    %
    %var is of type MX. var is of type MX. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1318, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setNominal(self,varargin)
    %>  void DaeBuilder.setNominal(str name, double val)
    %------------------------------------------------------------------------
    %
    %Set the nominal value by name.
    %
    %>  void DaeBuilder.setNominal(MX var, [double ] val)
    %------------------------------------------------------------------------
    %
    %Set the nominal value(s) by expression.
    %
    %
    %Usage: setNominal (var, val)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1319, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = min(self,varargin)
    %>  double DaeBuilder.min(str name, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the lower bound by name.
    %
    %>  [double] DaeBuilder.min(MX var, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the lower bound(s) by expression.
    %
    %
    %Usage: retval = min (var, normalized = false)
    %
    %var is of type MX. normalized is of type bool. var is of type MX. normalized is of type bool. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1320, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setMin(self,varargin)
    %>  void DaeBuilder.setMin(str name, double val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the lower bound by name.
    %
    %>  void DaeBuilder.setMin(MX var, [double ] val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the lower bound(s) by expression.
    %
    %
    %Usage: setMin (var, val, normalized = false)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. normalized is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1321, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = max(self,varargin)
    %>  double DaeBuilder.max(str name, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the upper bound by name.
    %
    %>  [double] DaeBuilder.max(MX var, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the upper bound(s) by expression.
    %
    %
    %Usage: retval = max (var, normalized = false)
    %
    %var is of type MX. normalized is of type bool. var is of type MX. normalized is of type bool. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1322, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setMax(self,varargin)
    %>  void DaeBuilder.setMax(str name, double val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the upper bound by name.
    %
    %>  void DaeBuilder.setMax(MX var, [double ] val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the upper bound(s) by expression.
    %
    %
    %Usage: setMax (var, val, normalized = false)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. normalized is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1323, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = initialGuess(self,varargin)
    %>  double DaeBuilder.initialGuess(str name, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the initial guess by name.
    %
    %>  [double] DaeBuilder.initialGuess(MX var, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the initial guess(es) by expression.
    %
    %
    %Usage: retval = initialGuess (var, normalized = false)
    %
    %var is of type MX. normalized is of type bool. var is of type MX. normalized is of type bool. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1324, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setInitialGuess(self,varargin)
    %>  void DaeBuilder.setInitialGuess(str name, double val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the initial guess by name.
    %
    %>  void DaeBuilder.setInitialGuess(MX var, [double ] val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the initial guess(es) by expression.
    %
    %
    %Usage: setInitialGuess (var, val, normalized = false)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. normalized is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1325, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = start(self,varargin)
    %>  double DaeBuilder.start(str name, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the (optionally normalized) value at time 0 by name.
    %
    %>  [double] DaeBuilder.start(MX var, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the (optionally normalized) value(s) at time 0 by expression.
    %
    %
    %Usage: retval = start (var, normalized = false)
    %
    %var is of type MX. normalized is of type bool. var is of type MX. normalized is of type bool. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1326, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setStart(self,varargin)
    %>  void DaeBuilder.setStart(str name, double val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the (optionally normalized) value at time 0 by name.
    %
    %>  void DaeBuilder.setStart(MX var, [double ] val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the (optionally normalized) value(s) at time 0 by expression.
    %
    %
    %Usage: setStart (var, val, normalized = false)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. normalized is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1327, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = derivativeStart(self,varargin)
    %>  double DaeBuilder.derivativeStart(str name, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the (optionally normalized) derivative value at time 0 by name.
    %
    %>  [double] DaeBuilder.derivativeStart(MX var, bool normalized=false) const 
    %------------------------------------------------------------------------
    %
    %Get the (optionally normalized) derivative value(s) at time 0 by expression.
    %
    %
    %Usage: retval = derivativeStart (var, normalized = false)
    %
    %var is of type MX. normalized is of type bool. var is of type MX. normalized is of type bool. retval is of type std::vector< double,std::allocator< double > >. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1328, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setDerivativeStart(self,varargin)
    %>  void DaeBuilder.setDerivativeStart(str name, double val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the (optionally normalized) derivative value at time 0 by name.
    %
    %>  void DaeBuilder.setDerivativeStart(MX var, [double ] val, bool normalized=false)
    %------------------------------------------------------------------------
    %
    %Set the (optionally normalized) derivative value(s) at time 0 by expression.
    %
    %
    %Usage: setDerivativeStart (var, val, normalized = false)
    %
    %var is of type MX. val is of type std::vector< double,std::allocator< double > > const &. normalized is of type bool. 

      try

      [varargout{1:nargout}] = casadiMEX(1329, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = unit(self,varargin)
    %>  str DaeBuilder.unit(str name) const 
    %------------------------------------------------------------------------
    %
    %Get the unit for a component.
    %
    %>  str DaeBuilder.unit(MX var) const 
    %------------------------------------------------------------------------
    %
    %Get the unit given a vector of symbolic variables (all units must be
    %identical)
    %
    %
    %Usage: retval = unit (var)
    %
    %var is of type MX. var is of type MX. retval is of type std::string. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1330, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = setUnit(self,varargin)
    %Set the unit for a component.
    %
    %
    %Usage: setUnit (name, val)
    %
    %name is of type std::string const &. val is of type std::string const &. 

      try

      [varargout{1:nargout}] = casadiMEX(1331, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = disp(self,varargin)
    %Print representation.
    %
    %
    %Usage: disp (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:nargout}] = casadiMEX(1332, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = print(self,varargin)
    %Print description.
    %
    %
    %Usage: print (trailing_newline = true)
    %
    %trailing_newline is of type bool. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:nargout}] = casadiMEX(1333, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = addVariable(self,varargin)
    %>  void DaeBuilder.addVariable(str name, Variable var)
    %------------------------------------------------------------------------
    %
    %Add a variable.
    %
    %>  MX DaeBuilder.addVariable(str name, int n=1)
    %
    %>  MX DaeBuilder.addVariable(str name, Sparsity sp)
    %------------------------------------------------------------------------
    %
    %Add a new variable: returns corresponding symbolic expression.
    %
    %
    %Usage: retval = addVariable (name, sp)
    %
    %name is of type std::string const &. sp is of type Sparsity. name is of type std::string const &. sp is of type Sparsity. retval is of type MX. 

      try

      [varargout{1:nargout}] = casadiMEX(1334, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = variable(self,varargin)
    %Access a variable by name
    %
    %
    %Usage: retval = variable (name)
    %
    %name is of type std::string const &. name is of type std::string const &. retval is of type Variable. 

      try

      if ~isa(self,'casadi.DaeBuilder')
        self = casadi.DaeBuilder(self);
      end
      [varargout{1:max(1,nargout)}] = casadiMEX(1335, self, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = DaeBuilder(varargin)
      self@casadi.PrintDaeBuilder(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(1336, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1337, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
