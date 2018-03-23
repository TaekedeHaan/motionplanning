function varargout = substitute(varargin)
    %>  MatType substitute(MatType ex, MatType v, MatType vdef)
    %------------------------------------------------------------------------
    %
    %Substitute variable v with expression vdef in an expression ex.
    %
    %>  [MatType] substitute([MatType ] ex, [MatType ] v, [MatType ] vdef)
    %------------------------------------------------------------------------
    %
    %Substitute variable var with expression expr in multiple expressions.
    %
    %
    %Usage: retval = substitute (ex, v, vdef)
    %
    %ex is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. vdef is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. ex is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. vdef is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. retval is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(900,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
