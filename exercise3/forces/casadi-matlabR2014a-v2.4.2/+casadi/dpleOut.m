function varargout = dpleOut(varargin)
    %Output arguments of a dple solver
    %
    %>Output scheme: casadi::DPLEOutput (DPLE_NUM_OUT = 1) [dpleOut]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| DPLE_P                 | p                      | Lyapunov matrix        |
    %|                        |                        | (horzcat when          |
    %|                        |                        | const_dim, diagcat     |
    %|                        |                        | otherwise) (Cholesky   |
    %|                        |                        | of P if pos_def) .     |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = dpleOut (n0 = "", x0 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1151,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
