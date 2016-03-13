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
    end
    methods
        function self = windtunneldata(files)
            % Inputs: A cell array of file names, likely produced by the
            %   tunneldatafiles function
            % Outputs: A windtunneldata object
            % Note that you can't tell which data is from which file later.
            %   If necessary, you can have a seperate object for every
            %   input file.
            for i=1:length(files)
                % This is taken from DataRead.m by Lucas Droste for ASEN
                % 2002.
                data=csvread(char(files(i)),1);
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
            end
        end
        
        function rv = getAtmosphere(self, which)
            % Inputs: [optional] 
            %   which: a string naming which section of the data you want
            %       Values: p pressure t temperature rho density
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.Atmosphere;
            elseif strcmp(which,'')
                rv = self.Atmosphere;
            elseif strcmpi(which,'p') || strcmpi(which,'pressure')
                rv=self.Atmosphere(:,1);
            elseif strcmpi(which,'t') || strcmpi(which,'temperature')
                rv=self.Atmosphere(:,2);
            elseif strcmpi(which,'rho') || strcmpi(which,'density')
                rv=self.Atmosphere(:,3);
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
            elseif strcmp(which,'')
                rv = self.Dynamic;
            elseif strcmpi(which,'pitot') || strcmpi(which,'p')
                rv=self.Dynamic(:,1);
            elseif strcmpi(which,'aux') || strcmpi(which,'auxiliary')
                rv=self.Dynamic(:,2);
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
            else
                rv = self.PressurePorts(:, which);
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
            elseif strcmp(which,'')
                rv = self.Sting;
            elseif strcmpi(which,'n') || strcmpi(which,'normal')
                rv=self.Sting(:,1);
            elseif strcmpi(which,'a') || strcmpi(which,'axial')
                rv=self.Sting(:,2);
            elseif strcmpi(which,'m') || strcmpi(which,'moment')
                rv=self.Sting(:,3);
            end
        end
        function rv = getELD(self, which)
            % Inputs: [optional] 
            %   which: a string naming which section of the data you want
            %       Values: x y
            % Outputs: one or two column vectors of position data
            if nargin == 1
                rv = self.ELD;
            elseif strcmp(which,'')
                rv = self.ELD;
            elseif strcmpi(which,'x') || strcmpi(which,'horizontal')
                rv=self.ELD(:,1);
            elseif strcmpi(which,'y') || strcmpi(which,'vertical')
                rv=self.ELD(:,2);
            end
        end
        
        function rv = findByAngle(self, target, tolerance)
            % Inputs: 
            %   target: the value that you want to locate in the array
            %   tolerance: the allowable error in the measurement
            % Outputs: a vector of indices at which the value is within
            %   tolerance of the target
            % Example: obj.findByAngle(1, .1) returns the indices at which
            %   the angle of attack is on the interval [.9, 1.1].
            rv = find(abs(self.AngleAttack - target) < tolerance);
        end
        function rv = findByAirspeed(self, target, tolerance)
            % Inputs: 
            %   target: the value that you want to locate in the array
            %   tolerance: the allowable error in the measurement
            % Outputs: a vector of indices at which the value is within
            %   tolerance of the target
            % Example: obj.findByAirspeed(20, 1) returns the indices at 
            %   which the airspeed is on the interval [19, 21].
            rv = find(abs(self.Airspeed - target) < tolerance);
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
    end
end