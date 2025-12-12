function plan = buildfile()

plan = buildplan(localfunctions);
plan.DefaultTasks = ["check", "test"];

test_options = {"IncludeSubfolders",true};

if isMATLABReleaseOlderThan("R2023b")
    plan("test") = matlab.buildtool.Task( ...
    Description="Run tests", ...
    Actions=@(~) assert(runtests(test_options{:}).Failed == 0));

    plan("check") = matlab.buildtool.Task(...
    Description="Identify code issues", ...
    Actions=@(~) assert(code_issues()) );
    
    return;
end

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(WarningThreshold=0);
plan("test") = matlab.buildtool.tasks.TestTask(test_options{:});

end

function issue_free = code_issues()
    issues = codeIssues();
    disp(issues.Issues);
    issue_free = isempty(issues.Issues);
end
