function plan = buildfile()
plan = buildplan(localfunctions);

if isMATLABReleaseOlderThan("R2023b")
    plan("test") = matlab.buildtool.Task( ...
    Description="Run tests", ...
    Actions=@(~) assert(runtests().Failed == 0));
    plan.DefaultTasks = "test";
    return;
end

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(WarningThreshold=0);
plan("test") = matlab.buildtool.tasks.TestTask;
plan.DefaultTasks = ["check","test"];
end
