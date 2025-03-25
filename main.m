function varargout = main(varargin)
    say_hello();
    varargout{:} = func(varargin{:});
end
