function plan = buildfile()
import matlab.buildtool.tasks.CodeIssuesTask

plan = buildplan(localfunctions);

plan("check") = CodeIssuesTask;

plan.DefaultTasks = "check";
end
