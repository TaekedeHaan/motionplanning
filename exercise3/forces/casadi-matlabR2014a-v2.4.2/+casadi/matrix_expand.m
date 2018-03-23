function varargout = matrix_expand(varargin)
    %Expand MX graph to SXFunction call.
    %
    %Expand the given expression e, optionally supplying expressions contained in
    %it at which expansion should stop.
    %
    %
    %Usage: retval = matrix_expand (e, boundary = std::vector< casadi::MX >(), options = casadi::Dict())
    %
    %e is of type MX. boundary is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. options is of type casadi::Dict const &. e is of type MX. boundary is of type std::vector< casadi::MX,std::allocator< casadi::MX > > const &. options is of type casadi::Dict const &. retval is of type MX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(903,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
