function varargout = socpStruct(varargin)
    %Structure specification of an SOCP
    %
    %>Struct scheme: casadi::SOCPStruct ( = 3) [socpStruct]
    %
    %+------------------------+------------------------+------------------------+
    %|       Full name        |         Short          |      Description       |
    %+========================+========================+========================+
    %| SOCP_STRUCT_G          | g                      | The horizontal stack   |
    %|                        |                        | of all matrices Gi: (  |
    %|                        |                        | n x N) .               |
    %+------------------------+------------------------+------------------------+
    %| SOCP_STRUCT_E          | e                      | The horizontal stack   |
    %|                        |                        | of all vectors ei: ( n |
    %|                        |                        | x m) .                 |
    %+------------------------+------------------------+------------------------+
    %| SOCP_STRUCT_A          | a                      | The matrix A: ( nc x   |
    %|                        |                        | n) .                   |
    %+------------------------+------------------------+------------------------+
    %
    %
    %Usage: retval = socpStruct (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity(), n2 = "", x2 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n2 is of type std::string const &. x2 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1187,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
