cd Repos/ScallopRSA2021

%% Load October rsk files

oct1 = RSKopen('data/CTD/RSK_raw/RSA_20211006_021.rsk');
oct1 = RSKreaddata(oct1, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct2 = RSKopen('data/CTD/RSK_raw/RSA_20211008_064.rsk');
oct2 = RSKreaddata(oct2, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct3 = RSKopen('data/CTD/RSK_raw/RSA_20211010_114.rsk');
oct3 = RSKreaddata(oct3, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

% read downcasts from all profiles
oct1down = RSKreadprofiles(oct1, 'direction', 'down'); % 22 profiles
oct2down = RSKreadprofiles(oct2, 'direction', 'down'); % 47 profiles
oct2up = RSKreadprofiles(oct2, 'direction', 'up'); % upcast of profile 12
oct3down = RSKreadprofiles(oct3, 'direction', 'down'); % 50 profiles

% derive sea pressure
oct1down = RSKderiveseapressure(oct1down); % 10.1325 patm
oct2down = RSKderiveseapressure(oct2down); % 10.1325 patm
oct2up = RSKderiveseapressure(oct2up);
oct3down = RSKderiveseapressure(oct3down); % 10.1325 patm

% derive depth
oct1down = RSKderivedepth(oct1down);
oct2down = RSKderivedepth(oct2down);
oct2up = RSKderivedepth(oct2up);
oct3down = RSKderivedepth(oct3down);

RSKprintchannels(oct1down);

%% Calculate mixed-layer depths

% Levitus 1982:
% depth at which temp change from surface is 0.5°C
% depth at which sigmaT change from surface sigma-t is 0.125
    % sigmaT = rho(S,T) - 1000 kg/m^3
        % density 1.027 g/cm3 = sigmaT 27 kg/m3
        % sigmaT = (rho - 1) * 1000;

% Hofmann 2008:
% depth at which temp change from surface is 0.5°C

oct1down.data.values[?].sigmaT = NaN;
oct1down.data.values[?].

