function varargout = IOScheme(varargin)
    %Usage: retval = IOScheme (arg_s0, arg_s1 = "", arg_s2 = "", arg_s3 = "", arg_s4 = "", arg_s5 = "", arg_s6 = "", arg_s7 = "", arg_s8 = "", arg_s9 = "", arg_s10 = "", arg_s11 = "", arg_s12 = "", arg_s13 = "", arg_s14 = "", arg_s15 = "", arg_s16 = "", arg_s17 = "", arg_s18 = "", arg_s19 = "")
    %
    %arg_s0 is of type std::string const &. arg_s1 is of type std::string const &. arg_s2 is of type std::string const &. arg_s3 is of type std::string const &. arg_s4 is of type std::string const &. arg_s5 is of type std::string const &. arg_s6 is of type std::string const &. arg_s7 is of type std::string const &. arg_s8 is of type std::string const &. arg_s9 is of type std::string const &. arg_s10 is of type std::string const &. arg_s11 is of type std::string const &. arg_s12 is of type std::string const &. arg_s13 is of type std::string const &. arg_s14 is of type std::string const &. arg_s15 is of type std::string const &. arg_s16 is of type std::string const &. arg_s17 is of type std::string const &. arg_s18 is of type std::string const &. arg_s19 is of type std::string const &. arg_s0 is of type std::string const &. arg_s1 is of type std::string const &. arg_s2 is of type std::string const &. arg_s3 is of type std::string const &. arg_s4 is of type std::string const &. arg_s5 is of type std::string const &. arg_s6 is of type std::string const &. arg_s7 is of type std::string const &. arg_s8 is of type std::string const &. arg_s9 is of type std::string const &. arg_s10 is of type std::string const &. arg_s11 is of type std::string const &. arg_s12 is of type std::string const &. arg_s13 is of type std::string const &. arg_s14 is of type std::string const &. arg_s15 is of type std::string const &. arg_s16 is of type std::string const &. arg_s17 is of type std::string const &. arg_s18 is of type std::string const &. arg_s19 is of type std::string const &. retval is of type std::vector< std::string,std::allocator< std::string > >. 

      try

      [varargout{1:max(1,nargout)}] = casadiMEX(831,varargin{:});

      catch err
        if (strcmp(err.identifier,'SWIG:OverloadError'))
          msg = [swig_typename_convertor_cpp2matlab(err.message) 'You have: ' strjoin(cellfun(@swig_typename_convertor_matlab2cpp,varargin,'UniformOutput',false),', ')];
          throwAsCaller(MException(err.identifier,msg));
        else
          rethrow(err);
        end
      end

end
