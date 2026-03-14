function plan = buildfile()
startup;

plan = buildplan(localfunctions);
plan.DefaultTasks = ["check", "test", "test_codegen"];

test_options = {"IncludeSubfolders",false};
test_codegen_options = {"test/CodeGenMexTest.m"};

if isMATLABReleaseOlderThan("R2023b")
    plan("test") = matlab.buildtool.Task( ...
        Description="Run tests", ...
        Actions=@(~) assert(runtests(test_options{:}).Failed == 0));

    plan("test_codegen") = matlab.buildtool.Task( ...
        Description="Run tests", ...
        Actions=@(~) assert(runtests(test_codegen_options{:}).Failed == 0));

    plan("check") = matlab.buildtool.Task(...
        Description="Identify code issues", ...
        Actions=@(~) assert(code_issues(0)));

    return;
end

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(WarningThreshold=0);

source_files_option = list_source_files(plan);
plan("test") = matlab.buildtool.tasks.TestTask(test_options{:},source_files_option{:})...
    .addCodeCoverage("test_coverage.html", MetricLevel="statement");

plan("test_codegen") = matlab.buildtool.tasks.TestTask(test_codegen_options{:});
end

function flag = code_issues(warning_threshold)
issues = codeIssues().Issues;
disp(issues);
errors = find(issues.Severity == 'error');
warnings = find(issues.Severity == 'warning');
flag = (numel(errors) == 0) && (numel(warnings) <= warning_threshold);
end

function source_files_option = list_source_files(plan)
src_dir = fullfile(plan.RootFolder, "src");
if isfolder(src_dir)
    d = dir(fullfile(src_dir, "**", "*"));
    % Keep only files (not folders) and exclude '.' and '..'
    files = d(~[d.isdir]);
    source_files = string(fullfile({files.folder}, {files.name}).');
else
    source_files = string.empty(0,1);
end

is_matlab_file = endsWith(source_files,[".m",".mlx"],"IgnoreCase",true);
source_files = source_files(is_matlab_file);

source_files_option = {"SourceFiles",source_files};
end
