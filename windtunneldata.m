% This class provides an interface for reading data from the files created
% by the LabView data aquisition program for the ITLL wind tunnel.
classdef windtunneldata
    properties(Access='protected')
        Atmosphere        % Ambient [p T rho] [Pa K kg/m^3]
        Airspeed          % Airspeed [m/s]
        Dynamic           % Dynamic pressures [Pitot Aux] [Pa]
        PressurePorts     % Scanivalve pressure measurements [elem=16] [Pa]
        AngleAttack       % Angle of Attack [deg]
        Sting             % Sting data [Normal Axial Moment] [N N N*m]
        ELD               % ELD Probe location [x y] [mm]
        VALID
    end
    methods
        function self = windtunneldata(files)
            % Inputs: A cell array of file names, likely produced by the
            %   tunneldatafiles function
            % Outputs: A windtunneldata object
            % Note that you can't tell which data is from which file later.
            %   If necessary, you can have a seperate object for every
            %   input file.
            self.VALID = false;
            for i=1:length(files)
                % This is taken from DataRead.m by Lucas Droste for ASEN
                % 2002.
                %data=csvread(char(files(i)),1);
                try
                    data = load(char(files(i)));
                catch
                    warning('Unable to find file %s', char(files(i)))
                    continue
                end
                % divide data into vectors by variable
                Patm = data(:,1);           % Atmospheric Pressure [Pa]
                Tatm = data(:,2);           % Atmospheric Temperature [K]
                RHOatm = data(:,3);         % Atmospheric Density [kg/m^3]
                airspeed = data(:,4);       % Airspeed [m/s]
                PitotDynP = data(:,5);      % Pitot Dynamic Pressure [Pa]
                AuxDynP = data(:,6);        % Aux Dynamic Pressure [Pa]
                P01 = data(:,7);            % Scanivalve Pressure 1 [Pa]
                P02 = data(:,8);            % Scanivalve Pressure 2 [Pa]
                P03 = data(:,9);            % Scanivalve Pressure 3 [Pa]
                P04 = data(:,10);           % Scanivalve Pressure 4 [Pa]
                P05 = data(:,11);           % Scanivalve Pressure 5 [Pa]
                P06 = data(:,12);           % Scanivalve Pressure 6 [Pa]
                P07 = data(:,13);           % Scanivalve Pressure 7 [Pa]
                P08 = data(:,14);           % Scanivalve Pressure 8 [Pa]
                P09 = data(:,15);           % Scanivalve Pressure 9 [Pa]
                P10 = data(:,16);           % Scanivalve Pressure 10 [Pa]
                P11 = data(:,17);           % Scanivalve Pressure 11 [Pa]
                P12 = data(:,18);           % Scanivalve Pressure 12 [Pa]
                P13 = data(:,19);           % Scanivalve Pressure 13 [Pa]
                P14 = data(:,20);           % Scanivalve Pressure 14 [Pa]
                P15 = data(:,21);           % Scanivalve Pressure 15 [Pa]
                P16 = data(:,22);           % Scanivalve Pressure 16 [Pa]
                angleAttack = data(:,23);   % Angle of Attack [deg]
                StrNormalF = data(:,24);    % Sting Normal Force [N]
                StrAxialF = data(:,25);     % Sting Axial Force [N]
                StrPitchM = data(:,26);     % Sting Pitching Moment [Nm]
                ELDx = data(:,27);          % ELD Probe X axis [mm]
                ELDy = data(:,28);          % ELD Probe Y axis [mm]
                % /end Lucas

                self.Atmosphere = [self.Atmosphere; Patm Tatm RHOatm];
                self.Airspeed = [self.Airspeed; airspeed];
                self.Dynamic = [self.Dynamic; PitotDynP AuxDynP];
                self.PressurePorts = [self.PressurePorts; P01 P02 P03 P04...
                    P05 P06 P07 P08 P09 P10 P11 P12 P13 P14 P15 P16];
                self.AngleAttack = [self.AngleAttack;angleAttack];
                self.Sting = [self.Sting; StrNormalF StrAxialF StrPitchM];
                self.ELD = [self.ELD; ELDx ELDy];

                self.VALID = true;
            end
        end

        function rv = getAny(self, which)
            if nargin == 1
                error('Define a variable to get.')
            elseif isnumeric(which)
                rv = self.getPorts(which);
            elseif strcmp(which, '')
                error('Define a variable to get.')
            elseif any(strcmpi(which, {'pressure', 'temperature', 'density'}))
                rv=self.getAtmosphere(which);
            elseif strcmpi(which, 'airspeed')
                rv=self.getAirspeed();
            elseif any(strcmpi(which, {'pitot', 'auxiliary'}))
                rv=self.getDynamic(which);
            elseif any(strcmpi(which, {'horizontal', 'vertical'}))
                rv=self.getELD(which);
            elseif strcmpi(which, 'angle')
                rv = self.getAngle();
            elseif any(strcmpi(which, {'normal', 'axial', 'moment'}))
                rv = self.getSting(which);
            else
                error('Identifier not found.');
            end
        end
        function rv = getAtmosphere(self, which)
            % Inputs: [optional]
            %   which: a string naming which section of the data you want
            %       Values: p pressure t temperature rho density
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.Atmosphere;
            elseif strcmp(which, '')
                rv = self.Atmosphere;
            elseif strcmpi(which, 'p') || strcmpi(which, 'pressure')
                rv=self.Atmosphere(:,1);
            elseif strcmpi(which, 't') || strcmpi(which, 'temperature')
                rv=self.Atmosphere(:,2);
            elseif strcmpi(which, 'rho') || strcmpi(which, 'density')
                rv=self.Atmosphere(:,3);
            else
                error('Must request pressure, temperature, or density.');
            end
        end
        function rv = getAirspeed(self)
            % Inputs: none
            % Outputs: column vector of airspeed
            rv=self.Airspeed;
        end
        function rv = getDynamic(self, which)
            % Inputs: [optional]
            %   which: a string naming which section of the data you want
            %       Values: p pitot aux auxiliary
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.Dynamic;
            elseif strcmp(which, '')
                rv = self.Dynamic;
            elseif strcmpi(which, 'pitot') || strcmpi(which, 'p')
                rv=self.Dynamic(:,1);
            elseif strcmpi(which, 'aux') || strcmpi(which, 'auxiliary')
                rv=self.Dynamic(:,2);
            elseif strcmpi(which, 'calc') || strcmpi(which, 'calculated')
                rv = .5 .* self.getAtmosphere('density') .* self.getAirspeed() .^ 2;
            else
                error('Must request pitot or auxiliary or calculated.');
            end
        end
        function rv = getPorts(self, which)
            % Inputs: [optional]
            %   which: a numeric vector identifying which ports you want
            %       data from
            %       Values: 1:16
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.PressurePorts;
                return
            elseif all(which <= 16)
                rv = self.PressurePorts(:, which);
            else
                error('You must request ports in the range 1:16.');
            end
        end
        function rv = getAngle(self)
            % Inputs: none
            % Outputs: the angle of attack, in degrees
            rv=self.AngleAttack;
        end
        function rv = getSting(self, which)
            % Inputs: [optional]
            %   which: a string naming which section of the data you want
            %       Values: n normal a axial m moment
            % Outputs: one or two column vectors of force data
            if nargin == 1
                rv = self.Sting;
            elseif strcmp(which, '')
                rv = self.Sting;
            elseif strcmpi(which, 'n') || strcmpi(which, 'normal')
                rv=self.Sting(:,1);
            elseif strcmpi(which, 'a') || strcmpi(which, 'axial')
                rv=self.Sting(:,2);
            elseif strcmpi(which, 'm') || strcmpi(which, 'moment')
                rv=self.Sting(:,3);
            else
                error('Must request normal, axial, or moment.');
            end
        end
        function rv = getELD(self, which)
            % Inputs: [optional]
            %   which: a string naming which section of the data you want
            %       Values: x y
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.ELD;
            elseif strcmp(which, '')
                rv = self.ELD;
            elseif strcmpi(which, 'x') || strcmpi(which, 'horizontal')
                rv=self.ELD(:,1);
            elseif strcmpi(which, 'y') || strcmpi(which, 'vertical')
                rv=self.ELD(:,2);
            else
                error('Must request horizontal or vertical distance.');
            end
        end

        function rv = getLift(self)
            % Inputs: none
            % Outputs: the lift force, in N
            % Uses the sting balance. Does not work from aerodynamic principles.
            N = self.getSting('n');
            A = self.getSting('a');
            alpha = self.getAngle();
            rv = N .* cosd(alpha) - A .* sind(alpha);
        end
        function rv = getCl(self, S, dynSource)
            % Inputs:
            %   S: The planform area of the wing.
            %   [optional] dynSource: What to use for the dynamic pressure. Uses any of the values for getDynamic.
            % Outputs: the total lift coefficient.
            % Uses the sting balance. Does not work from aerodynamic principles.
            L = self.getLift();
            if nargin > 2
                q = self.getDynamic(dynSource);
            else
                q = self.getDynamic('pitot');
            end
            rv = L ./ (q * S);
        end
        function rv = getDrag(self)
            % Inputs: none
            % Outputs: the drag force, in N
            % Uses the sting balance. Does not work from aerodynamic principles.
            N = self.getSting('n');
            A = self.getSting('a');
            alpha = self.getAngle();
            rv = A .* cosd(alpha) + N .* sind(alpha);
        end
        function rv = getCd(self, S, dynSource)
            % Inputs:
            %   S: The planform area of the wing.
            %   [optional] dynSource: What to use for the dynamic pressure. Uses any of the values for getDynamic.
            % Outputs: the total lift coefficient.
            % Uses the sting balance. Does not work from aerodynamic principles.
            D = self.getDrag();
            if nargin > 2
                q = self.getDynamic(dynSource);
            else
                q = self.getDynamic('pitot');
            end
            rv = D ./ (q * S);
        end

        function rv = findByAngle(self, target, tolerance)
            % Inputs:
            %   target: the value that you want to locate in the array
            %   tolerance: the allowable error in the measurement
            % Outputs: a vector of indices at which the value is within
            %   tolerance of the target
            % Example: obj.findByAngle(1, .1) returns the indices at which
            %   the angle of attack is on the interval [.9, 1.1].
            rv = find(abs(self.AngleAttack - target) <= tolerance);
        end
        function rv = findByAirspeed(self, target, tolerance)
            % Inputs:
            %   target: the value that you want to locate in the array
            %   tolerance: the allowable error in the measurement
            % Outputs: a vector of indices at which the value is within
            %   tolerance of the target
            % Example: obj.findByAirspeed(20, 1) returns the indices at
            %   which the airspeed is on the interval [19, 21].
            rv = find(abs(self.Airspeed - target) <= tolerance);
        end
        function rv = findByLocation(self, target, tolerance, which)
            % Inputs:
            %   target: the value that you want to locate in the array
            %   tolerance: the allowable error in the measurement
            %   which: the location that you want, x or y
            % Outputs: a vector of indices at which the value is within
            %   tolerance of the target
            % Example: obj.findBylocation(20, 1, 'x') returns the indices at
            %   which the horizontal location of the ELD probe is on the
            %   interval [19, 21].
            rv = find(abs(self.getELD(which) - target) <= tolerance);
        end

        function rv = averageSets(self, variable, window)
            % Inputs:
            %   variable: The name of the variable to get
            %   window: the size of the blocks to average over
            % Outputs: A matrix with the same number of columns as the
            %   original, but with the number of rows divided by `window`. Each
            %   row is the average of `window` data points.
            if isnumeric(variable)
                data = variable;
            else
                data = self.getAny(variable);
            end
            sz = size(data);
            rv = zeros(ceil(sz(1)/window), sz(2:end));
            for ind = 0:size(rv, 1)-1
                if (ind+1)*window > sz(1)
                    temp = mean(data(ind*window+1 : end, :), 1);
                else
                    temp = mean(data(ind*window+1 : (ind+1)*window, :), 1);
                end
                rv(ind+1, :) = temp;
            end
        end

        function rv = plus(self, other)
            % Overloads the + operator to merge the data from two objects.
            rv.Atmosphere = [self.Atmosphere; other.Atmosphere];
            rv.Airspeed = [self.Airspeed; other.Airspeed];
            rv.Dynamic = [self.Dynamic; other.Dynamic];
            rv.PressurePorts = [self.PressurePorts; other.PressurePorts];
            rv.AngleAttack = [self.AngleAttack; other.AngleAttack];
            rv.Sting = [self.Sting; other.Sting];
            rv.ELD = [self.ELD; other.ELD];
        end
        function rv = eq(self, other)
            % Overloads the == operator to check if two objects hold the
            % same data.
            if numel(self.Atmosphere) ~= numel(other.Atmosphere)
                rv = false;
                return
            end
            rv = all(self.Atmosphere == other.Atmosphere) && ...
                all(self.Airspeed == other.Airspeed) && ...
                all(self.Dynamic == other.Dynamic) && ...
                all(self.PressurePorts == other.PressurePorts) && ...
                all(self.AngleAttack == other.AngleAttack) && ...
                all(self.Sting == other.Sting) && ...
                all(self.ELD == other.ELD);
        end
        function rv = not(self)
            % Overloads the ~ operator to check if the object is fully defined or not
            rv = ~self.VALID;
        end

        function fig = makeplot(self, xvar, yvar, figureargs, plotargs, filter)
            % Inputs:
            %   xvar: name of the variable to go on the x axis
            %   yvar: name of the variable to go on the y axis
            %       Values: temperature pressure density airspeed dynamic
            %           auxiliary angle normal axial moment x y lift drag L/D
            %   [optional] figureargs: a cell array of arguments for the
            %       creation of the plot figure; note that if it contains only
            %       a number or figure handle, the referenced figure is used
            %       instead of a new one being created
            %   [optional] plotargs: a cell array of arguments to customize the
            %       resulting plot
            % Outputs: The figure in which the plot was drawn
            if nargin < 6
                inds = 1:length(self.Airspeed);
            else
                if strcmpi(filter{1}, 'angle')
                    inds = self.findByAngle(filter{2:3});
                elseif strcmpi(filter{1}, 'speed')
                    inds = self.findByAirspeed(filter{2:3});
                end
            end
            if nargin < 5
                plotargs = {};
                if nargin < 4
                    figureargs = {};
                end
            end
            [opts, vars, titles, units] = self.make_registry();

            xplace = find(strcmpi(xvar, opts));
            yplace = find(strcmpi(yvar, opts));

            if ~xplace || ~yplace
                error('Invalid identifier used.');
            end

            X = vars{xplace};
            Y = vars{yplace};
            TITLE = sprintf('%s against %s', titles{yplace}, titles{xplace});
            XLABEL = sprintf('%s (%s)', titles{xplace}, units{xplace});
            YLABEL = sprintf('%s (%s)', titles{yplace}, units{yplace});

            fig = figure(figureargs{:});

            plot(X(inds), Y(inds), plotargs{:});
            title(TITLE)
            xlabel(XLABEL)
            ylabel(YLABEL)
        end
    end
    methods (Access='protected')
        function [opts, vars, titles, units] = make_registry(self)
            opts = {'temperature';
                    'pressure';
                    'density';
                    'airspeed';
                    'dynamic';
                    'auxiliary';
                    'angle';
                    'normal';
                    'axial';
                    'moment';
                    'x';
                    'y';
                    'lift';
                    'drag';
                    'L/D'
                   };
            vars = {self.getAtmosphere('t');
                    self.getAtmosphere('p');
                    self.getAtmosphere('rho');
                    self.getAirspeed();
                    self.getDynamic('pitot');
                    self.getDynamic('aux');
                    self.getAngle();
                    self.getSting('n');
                    self.getSting('a');
                    self.getSting('m');
                    self.getELD('x');
                    self.getELD('y');
                    self.getLift();
                    self.getDrag();
                    self.getLift()/self.getDrag()
                   };
            titles = { 'Atmospheric Temperature';
                       'Atmospheric Pressure';
                       'Atmospheric Density';
                       'Air Speed';
                       'Pitot Dynamic Pressure';
                       'Angle of Attack';
                       'Sting Normal Force';
                       'Sting Axial Force';
                       'Sting Moment';
                       'ELD Probe X';
                       'ELD Probe Y';
                       'Lift Force';
                       'Drag Force';
                       'Lift to Drag Ratio'
                     };
            units = { 'K';
                      'Pa';
                      'kg/m^3';
                      'm/s';
                      'Pa';
                      'degrees';
                      'N';
                      'N';
                      'N*m';
                      'mm';
                      'mm';
                      'N';
                      'N';
                      'unitless'
                    };
        end
    end
end
