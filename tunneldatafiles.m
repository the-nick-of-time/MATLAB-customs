function names = tunneldatafiles(format, arguments)
% Returns a cell array of filenames for use with the windtunneldata
% interface
% Inputs:
%   format: the format of the output, in a sprintf-able form
%   arguments: an array of cell arrays, each with the necessary set of inputs
%       to the string format
names=cell(size(arguments, 1), 1);
for i = 1:length(names)
    names{i} = sprintf(format, arguments{i, :});
end
end
