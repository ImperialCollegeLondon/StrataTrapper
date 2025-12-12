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
    Actions=@(~) assert(code_issues()) );

    return;
end

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(WarningThreshold=0);
plan("test") = matlab.buildtool.tasks.TestTask(test_options{:});
plan("test_codegen") = matlab.buildtool.tasks.TestTask(test_codegen_options{:});
end

function issue_free = code_issues()
    issues = codeIssues();
    disp(issues.Issues);
    issue_free = isempty(issues.Issues);
end
