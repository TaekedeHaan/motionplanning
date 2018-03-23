function varargout = cleIn(varargin)
    %Input arguments of a cle solver
    %
    %>Input scheme: casadi::CLEInput (CLE_NUM_IN = 2) [cleIn]
    %
    %+-----------+-------+-------------+
    %| Full name | Short | Description |
    %+===========+=======+=============+
    %| CLE_A     | a     | A matrix .  |
    %+-----------+-------+-------------+
    %| CLE_V     | v     | V matrix .  |
    %+-----------+-------+-------------+
    %
    %
    %Usage: retval = cleIn (n0 = "", x0 = casadi::Sparsity(), n1 = "", x1 = casadi::Sparsity())
    %
    %n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. n0 is of type std::string const &. x0 is of type Sparsity. n1 is of type std::string const &. x1 is of type Sparsity. retval is of type std::pair< std::map< std::string,casadi::Sparsity,std::less< std::string >,std::allocator< std::pair< std::string const,casadi::Sparsity > > >,std::vector< std::string,std::allocator< std::string > > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1144,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
