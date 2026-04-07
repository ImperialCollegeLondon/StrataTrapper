function data = import_eclipse(args)
% IMPORT_ECLIPSE import reservoir simulation data from .INIT, .EGRID, .SMSPEC, and .UNSMRY files
arguments
    args.result_file_name char
    args.model_dir char = ''
    args.import_states (1,1) logical = false
end

oldpath = addpath(args.model_dir);

data.init = readEclipseOutputFileUnFmt([args.result_file_name,'.INIT']);
data.egrid = readEclipseOutputFileUnFmt([args.result_file_name,'.EGRID']);

[data.G, data.rock] = eclOut2mrst(data.init, data.egrid);
% data.G = computeGeometry(data.G); % TODO check if needed

if args.import_states
    [data.states, data.rstrt] = convertRestartToStates(...
        [args.model_dir,'/',args.result_file_name], ...
        data.G, ...
        'includeWellSols', false);
end

if ~isequal(oldpath,path())
    path(oldpath,'');
end
end
