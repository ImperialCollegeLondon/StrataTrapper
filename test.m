if isempty(gcp('nocreate'))
    parpool('Threads');
end
demo(parfor_arg=4,show_figures=false,show_progress=false);
