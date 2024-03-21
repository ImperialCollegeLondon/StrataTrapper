function [] = workspace_unpack(packed)

names = fieldnames(packed);

for i = 1:length(names)
    varName = names{i};
    assignin('caller', varName, packed.(varName));
end

end
