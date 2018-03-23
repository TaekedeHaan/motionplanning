function varargout = graph_substitute(varargin)
    %>  MX graph_substitute(MX ex, [MX ] v, [MX ] vdef)
    %------------------------------------------------------------------------
    %
    %Substitute single expression in graph Substitute variable v with expression
    %vdef in an expression ex, preserving nodes.
    %
    %>  [MX] graph_substitute([MX ] ex, [MX ] v, [MX ] vdef)
    %------------------------------------------------------------------------
    %
    %Substitute multiple expressions in graph Substitute variable var with
    %expression expr in multiple expressions, preserving nodes.
    %
    %
    %Usage: retval = graph_substitute (ex, v, vdef)
    %
    %ex is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. v is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. vdef is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. ex is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. v is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. vdef is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. retval is of type std::vector< casadi::MX,std::allocator< casadi::MX > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(904,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
