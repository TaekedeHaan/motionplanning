classdef GenericExpressionCommon < SwigRef
    %Usage: GenericExpressionCommon ()
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = plus(varargin)
    %Usage: retval = plus (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(421, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = minus(varargin)
    %Usage: retval = minus (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(422, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = times(varargin)
    %Usage: retval = times (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(423, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = rdivide(varargin)
    %Usage: retval = rdivide (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(424, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ldivide(varargin)
    %Usage: retval = ldivide (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(425, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = lt(varargin)
    %Usage: retval = lt (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(426, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = le(varargin)
    %Usage: retval = le (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(427, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = gt(varargin)
    %Usage: retval = gt (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(428, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ge(varargin)
    %Usage: retval = ge (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(429, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = eq(varargin)
    %Usage: retval = eq (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(430, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ne(varargin)
    %Usage: retval = ne (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(431, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = and(varargin)
    %Usage: retval = and (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(432, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = or(varargin)
    %Usage: retval = or (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(433, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = not(varargin)
    %Usage: retval = not (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(434, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = abs(varargin)
    %Absolute value.
    %
    %
    %Usage: retval = abs (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(435, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sqrt(varargin)
    %Square root.
    %
    %
    %Usage: retval = sqrt (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(436, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sin(varargin)
    %Sine.
    %
    %
    %Usage: retval = sin (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(437, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = cos(varargin)
    %Cosine.
    %
    %
    %Usage: retval = cos (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(438, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tan(varargin)
    %Tangent.
    %
    %
    %Usage: retval = tan (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(439, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = atan(varargin)
    %Arc tangent.
    %
    %
    %Usage: retval = atan (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(440, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = asin(varargin)
    %Arc sine.
    %
    %
    %Usage: retval = asin (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(441, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = acos(varargin)
    %Arc cosine.
    %
    %
    %Usage: retval = acos (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(442, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = tanh(varargin)
    %Hyperbolic tangent.
    %
    %
    %Usage: retval = tanh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(443, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sinh(varargin)
    %Hyperbolic sine.
    %
    %
    %Usage: retval = sinh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(444, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = cosh(varargin)
    %Hyperbolic cosine.
    %
    %
    %Usage: retval = cosh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(445, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = atanh(varargin)
    %Inverse hyperbolic tangent.
    %
    %
    %Usage: retval = atanh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(446, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = asinh(varargin)
    %Inverse hyperbolic sine.
    %
    %
    %Usage: retval = asinh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(447, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = acosh(varargin)
    %Inverse hyperbolic cosine.
    %
    %
    %Usage: retval = acosh (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(448, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = exp(varargin)
    %Exponential function.
    %
    %
    %Usage: retval = exp (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(449, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = log(varargin)
    %Natural logarithm.
    %
    %
    %Usage: retval = log (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(450, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = log10(varargin)
    %Base-10 logarithm.
    %
    %
    %Usage: retval = log10 (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(451, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = floor(varargin)
    %Round down to nearest integer.
    %
    %
    %Usage: retval = floor (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(452, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = ceil(varargin)
    %Round up to nearest integer.
    %
    %
    %Usage: retval = ceil (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(453, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = erf(varargin)
    %Error function.
    %
    %
    %Usage: retval = erf (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(454, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = erfinv(varargin)
    %Invers error function.
    %
    %
    %Usage: retval = erfinv (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(455, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = sign(varargin)
    %Sine function sign(x) := -1 for x<0 sign(x) := 1 for x>0, sign(0) := 0
    %sign(NaN) := NaN
    %
    %
    %Usage: retval = sign (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(456, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = power(varargin)
    %Usage: retval = power (x, n)
    %
    %x is of type SX. n is of type SX. x is of type SX. n is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(457, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = mod(varargin)
    %Usage: retval = mod (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(458, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = atan2(varargin)
    %Two argument arc tangent.
    %
    %
    %Usage: retval = atan2 (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(459, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = min(varargin)
    %Usage: retval = min (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(460, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = max(varargin)
    %Usage: retval = max (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(461, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = simplify(varargin)
    %Simplify an expression.
    %
    %
    %Usage: retval = simplify (x)
    %
    %x is of type SX. x is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(462, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = isEqual(varargin)
    %Check if two nodes are equivalent up to a given depth. Depth=0 checks if the
    %expressions are identical, i.e. points to the same node.
    %
    %a = x*x b = x*x
    %
    %a.isEqual(b, 0) will return false, but a.isEqual(b, 1) will return true
    %
    %
    %Usage: retval = isEqual (x, y, depth = 0)
    %
    %x is of type SX. y is of type SX. depth is of type int. x is of type SX. y is of type SX. depth is of type int. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(463, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = iszero(varargin)
    %Addition.
    %
    %
    %Usage: retval = iszero (x)
    %
    %x is of type SX. x is of type SX. retval is of type bool. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(464, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = copysign(varargin)
    %Copy sign.
    %
    %
    %Usage: retval = copysign (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(465, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function varargout = constpow(varargin)
    %Elementwise power with const power.
    %
    %
    %Usage: retval = constpow (x, y)
    %
    %x is of type SX. y is of type SX. x is of type SX. y is of type SX. retval is of type SX. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(466, varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

    end
    function self = GenericExpressionCommon(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if varargin{1}~=SwigRef.Null
          self.swigPtr = varargin{1}.swigPtr;
        end
      else

      try

        tmp = casadiMEX(467, varargin{:});
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
        casadiMEX(468, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
