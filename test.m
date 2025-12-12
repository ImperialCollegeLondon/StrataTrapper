if isempty(gcp('nocreate'))
    parpool('Threads',2);
end
demo(parfor_arg=2,show_figures=false,show_progress=false);
