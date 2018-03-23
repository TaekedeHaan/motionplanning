function varargout = substituteInPlace(varargin)
    %Inplace substitution with piggyback expressions Substitute variables v out
    %of the expressions vdef sequentially, as well as out of a number of other
    %expressions piggyback.
    %
    %
    %Usage: substituteInPlace (v, inout_vdef, inout_ex, reverse = false)
    %
    %v is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > const &. inout_vdef is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > &. inout_ex is of type std::vector< casadi::Matrix< casadi::SXElement >,std::allocator< casadi::Matrix< casadi::SXElement > > > &. reverse is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(901,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
