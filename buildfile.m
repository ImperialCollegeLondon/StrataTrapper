function plan = buildfile()
import matlab.buildtool.tasks.CodeIssuesTask
plan = buildplan(localfunctions);

task = "check";
plan(task) = CodeIssuesTask(WarningThreshold=0);
plan.DefaultTasks = task;

end
