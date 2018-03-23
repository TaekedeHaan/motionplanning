function varargout = hessLagOut(varargin)
    %Output arguments of an NLP Hessian function
    %
    %>Output scheme: casadi::HessLagOutput (HESSLAG_NUM_OUT = 5) [hessLagOut]
    %
    %+----------------+--------+------------------------------------------------+
    %|   Full name    | Short  |                  Description                   |
    %+================+========+================================================+
    %| HESSLAG_HESS   | hess   | Hessian of the Lagrangian .                    |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_F      | f      | Objective function .                           |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_G      | g      | Constraint function .                          |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_GRAD_X | grad_x | Gradient of the Lagrangian with respect to x . |
    %+----------------+--------+------------------------------------------------+
    %| HESSLAG_GRAD_P | grad_p | Gradient of the Lagrangian with respect to p . |
    %+----------------+--------+------------------------------------------------+
    %
    %
    %Usage: retval = hessLagOut (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity(), n3 = "", x3 = casadi::Sparsity(), n4 = "", x4 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n3 is of type std::string const &. x3 is of type Sparsity. n4 is of type std::string const &. x4 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1174,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
