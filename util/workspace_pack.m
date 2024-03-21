function [packed] = workspace_pack()

names = evalin('caller', 'who');

packed = struct();
for i = 1:length(names)
    varName = names{i};
    packed.(varName) = evalin('caller', varName);
end

end
