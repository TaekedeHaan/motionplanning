function varargout = collocationInterpolators(varargin)
    %Obtain collocation interpolating matrices.
    %
    %Parameters:
    %-----------
    %
    %tau_root:  location of collocation points, as obtained from
    %collocationPoints
    %
    %C:  interpolating coefficients to obtain derivatives Length: order+1, order
    %+ 1
    %
    %
    %
    %::
    %
    %dX/dt @collPoint(j) ~ Sum_i C[j][i]*X@collPoint(i)
    %
    %
    %
    %Parameters:
    %-----------
    %
    %D:  interpolating coefficients to obtain end state Length: order+1
    %
    %
    %Usage: collocationInterpolators (tau_root)
    %
    %tau_root is of type std::vector< double,std::allocator< double > > const &. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(1220,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
