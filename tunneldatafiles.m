function names = tunneldatafiles(name, groups, root, section)
% Returns a cell array of filenames for use with the windtunneldata
% interface
% name: string, name of project (like 'AirfoilPressure')
% section: integer, lab section (optional)
% groups: integer array, what groups to take data from
% root: the folder to look in (specified using linux-style relative pathing
%   or system-specific absolute pathing)
names=cell(length(groups),1);
switch nargin
    case 1
        error('too few arguments')
    case 2
        for i = 1:length(groups)
            names(i) = cellstr(sprintf('%s_G%02d.csv',name,groups(i)));
        end
    case 3
        for i = 1:length(groups)
            names(i) = cellstr(sprintf('%s/%s_G%02d.csv',root,name,groups(i)));
        end
    case 4
        for i = 1:length(groups)
            names(i) = cellstr(sprintf('%s/%s_S%03d_G%02d.csv',root,name,section,groups(i)));
        end
end
end