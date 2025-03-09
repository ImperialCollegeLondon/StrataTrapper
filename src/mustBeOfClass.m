function mustBeOfClass(input,className)
    % Test for specific class name
    cname = class(input);
    if ~strcmp(cname,className)
        eid = 'Class:notCorrectClass';
        msg = 'Input must be of class %s.';
        error(eid,msg,className);
    end
end
