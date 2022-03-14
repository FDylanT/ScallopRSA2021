% cd Repos/ScallopRSA2021

%% Load May rsk files

may1 = RSKopen('data/CTD/RSK_raw/RSA_20210504_060.rsk');
may1 = RSKreaddata(may1, 't1', datenum(2021, 05, 02), 't2', datenum(2021, 05, 06));

may2 = RSKopen('data/CTD/RSK_raw/RSA_20210506_113.rsk');
may2 = RSKreaddata(may2, 't1', datenum(2021, 05, 02), 't2', datenum(2021, 05, 06));

% print list of all channels
RSKprintchannels(may1)

% read downcasts from all profiles
may1down = RSKreadprofiles(may1, 'direction', 'down'); % 95 profiles
may2down = RSKreadprofiles(may2, 'direction', 'down'); % 71 profiles

% plot all profiles
%RSKplotprofiles(may1down, 'profile', [1:95], 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(may2down, 'profile', [1:71], 'channel', {'temperature', 'conductivity'});

% depth already appears to have been derived?

%% Clean profiles by trimming

% trim downcasts in may1 file
may1down_uncut = may1down;

    % (no trimming needed: 2, 6:7, 9, 11, 13, 15:16, 21:22, 33, 35:36, 38, 44, 57, 83)
    %RSKplotprofiles(may1down_uncut, 'profile', [2, 6:7, 9, 11, 13, 15:16, 21:22, 33, 35:36, 38, 44, 57, 83], 'channel', {'temperature', 'conductivity'});

for i = [1, 3:4, 10, 12, 14, 20, 24:27, 30, 32, 39, 42:43, 46:47, 50, 52, 54:56, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 84:85, 87:88, 90, 92, 94]
    if i==25
        a = max(may1down.data(i).values(:, 7));
    elseif i==20 || i==75
        a = max(may1down.data(i).values(:, 7))-0.05;
    elseif i==30 || i==32 || i==42 || i==43 || i==46 || i==50 || i==54 || i==60 || i==66 || i==73 || i==79 || i==81 || i==84
        a = max(may1down.data(i).values(:, 7))-0.1;
    elseif i==52 || i==64 || i==68 || i==78 || i==85 || i==90 || i==92
        a = max(may1down.data(i).values(:, 7))-0.15;
    elseif i==10 || i==39 || i==47 || i==56 || i==62 || i==71 || i==74 || i==80 || i==87 || i==94
        a = max(may1down.data(i).values(:, 7))-0.2;
    elseif i==1 || i==3 || i==4 || i==12 || i==26 || i==27 || i==55
        a = max(may1down.data(i).values(:, 7))-0.25;
    elseif i==24 || i==88
        a = max(may1down.data(i).values(:, 7))-0.3;
    elseif i==14 || i==70
        a = max(may1down.data(i).values(:, 7))-0.35;
    elseif i==77
        a = max(may1down.data(i).values(:, 7))-0.45;
    end
    b = max(may1down.data(i).values(:, 7));
    may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', i, 'action', 'remove'); 
end

% check that data were removed
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

% trim downcasts in may2 file
may2down_uncut = may2down;

    % (no trimming needed: 1, 4, 19, 23, 53, 62, 64, 67)
    %RSKplotprofiles(may2down_uncut, 'profile', [1, 4, 19, 23, 53, 62, 64, 67], 'channel', {'temperature', 'conductivity'});

for i = [2, 6:7, 9, 11:12, 14:18, 20:22, 24:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 54:56, 58, 60:61, 65:66, 68:70]
    if i==2 || i==55
        a = max(may2down.data(i).values(:, 7));
    elseif i==16 || i==17 || i==22 || i==29 || i==35 || i==36 || i==46 || i==58 || i==70
        a = max(may2down.data(i).values(:, 7))-0.05;
    elseif i==7 || i==9 || i==27 || i==40 || i==56 || i==65 || i==68
        a = max(may2down.data(i).values(:, 7))-0.1;
    elseif i==6 || i==15 || i==32 || i==34 || i==43 || i==66
        a = max(may2down.data(i).values(:, 7))-0.15;
    elseif i==12 || i==18 || i==20 || i==48 || i==54 || i==69
        a = max(may2down.data(i).values(:, 7))-0.2;
    elseif i==14 || i==26 || i==31 || i==44 || i==60
        a = max(may2down.data(i).values(:, 7))-0.25;
    elseif i==11
        a = max(may2down.data(i).values(:, 7))-0.35;
    elseif i==37
        a = max(may2down.data(i).values(:, 7))-0.4;
    elseif i==25
        a = max(may2down.data(i).values(:, 7))-0.5;
    elseif i==24 || i==51 || i==61
        a = max(may2down.data(i).values(:, 7))-0.55;
    elseif i==21
        a = max(may2down.data(i).values(:, 7))-0.6;
    end
    b = max(may2down.data(i).values(:, 7));
    may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', i, 'action', 'remove');
end

% check that data were removed
%RSKplotprofiles(may2down, 'profile', [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70], 'channel', {'temperature', 'conductivity'});

%% Process data

% correct for analog-to-digital zero-order hold
may1down.channels(12:13) = [];
may1down = RSKcorrecthold(may1down, 'action', 'interp');

may2down.channels(12:13) = [];
may2down = RSKcorrecthold(may2down, 'action', 'interp');

% low-pass filter
may1down = RSKsmooth(may1down, 'channel', {'temperature','conductivity'}, 'windowLength', 5);

may2down = RSKsmooth(may2down, 'channel', {'temperature','conductivity'}, 'windowLength', 5);

% align conductivity & temp
lag = RSKcalculateCTlag(may1down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
may1down = RSKalignchannel(may1down, 'channel', 'temperature', 'lag', lag);

lag = RSKcalculateCTlag(may2down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
may2down = RSKalignchannel(may2down, 'channel', 'temperature', 'lag', lag);

% derive velocity
may1down = RSKderivevelocity(may1down);

may2down = RSKderivevelocity(may2down);

% look at velocity profiles
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'velocity'});

% remove loops
%may1loops0 = RSKremoveloops(may1down, 'threshold', 0.25, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
%may1loops1 = RSKremoveloops(may1down, 'threshold', 0.2, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
%may1loops2 = RSKremoveloops(may1down, 'threshold', 0.15, 'visualize', [10, 14, 26, 71, 78, 80, 84]);

may1down = RSKremoveloops(may1down, 'threshold', 0.2);
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

may2down = RSKremoveloops(may2down, 'threshold', 0.2);
%RSKplotprofiles(may2down, 'profile', [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70], 'channel', {'temperature', 'conductivity'});

% derive salinity
may1down = RSKderivesalinity(may1down);
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity', 'salinity'});

may2down = RSKderivesalinity(may2down);
%RSKplotprofiles(may2down, 'profile', [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70], 'channel', {'temperature', 'conductivity', 'salinity'});

%% Bin-average profiles; then compare raw vs. processed data

% bin-average by sea pressure (may1)
may1down = RSKbinaverage(may1down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (may1)
may1 = RSKreadprofiles(may1);

a = [1:4, 6:7]; %#ok<*NASGU> 
b = 9:16;
c = [20:22, 24:27];
d = [30, 32:33, 35:36, 38:39];
e = [42:44, 46:47, 50, 52];
f = [54:57, 60, 62, 64];
g = [66, 68, 70:71, 73:75];
h = [77:81, 83:85];
i = [87:88, 90, 92, 94];

figure
channel = {'temperature', 'salinity', 'dissolved O21'};
profile = [a, b, c, d, e, f, g, h, i];
[h1, ax] = RSKplotprofiles(may1, 'profile', profile, 'channel', channel, 'direction', 'up'); %#ok<*ASGLU> 
h2 = RSKplotprofiles(may1down, 'profile', profile, 'channel', channel);
set(h2, 'linewidth', 3)

% bin-average by sea pressure (may2)
may2down = RSKbinaverage(may2down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (may2)
may2 = RSKreadprofiles(may2);

a = [1:2, 4, 6:7, 9, 11:12];
b = 14:20;
c = 21:27;
d = [29, 31:32, 34:37];
e = [40, 43:44, 46, 48, 51];
f = [53:56, 58, 60:62];
g = 64:70;

figure
channel = {'temperature', 'salinity', 'dissolved O21'};
profile = [a, b, c, d, e, f, g];
[h1, ax] = RSKplotprofiles(may2, 'profile', profile, 'channel', channel, 'direction', 'up');
h2 = RSKplotprofiles(may2down, 'profile', profile, 'channel', channel);
set(h2, 'linewidth', 3)

%% Assign station numbers to profiles

% may1 file
% no data from sites 006, 012, 016, 022, 030
% chronological sites 001-060; includes 001-057 + 060-062 + 066-068

%list1 = [1:3, 5, 4, 7:11, 13, 13:15, 17:21, 23:29, 31:32, 35, 34, 33, 36:48, 50:51, 56, 55, 52, 49, 49, 53, 53:54, 57, 57, 61, 67:68, 66, 62, 60];

% profiles 14, 78, 80, 84 share station ID with previous profile
profiles1 = [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94];
%profiles1(55) %#ok<NOPTS> 
%list1(55) %#ok<NOPTS> 
% duplicate sites: 13, 49, 53, 57
%compare1 = [list1; profiles1];
stations1 = {'1', '2', '3', '5', '4', '7', '8', '9', '10', '11', '13', '13', '14', '15', '17', '18', '19', '20', '21', '23', '24', '25', '26', '27', '28', '29', '31', '32', '35', '34', '33', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '50', '51', '56', '55', '52', '49', '49', '53', '53', '54', '57', '57', '61', '67', '68', '66', '62', '60'};

may1down = RSKaddstationdata(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'station', stations1);

% may2 file
% no data from sites 081, 111, 114
% chronological sites 065-113; includes 058-059 + 063-065 + 069-113

%list2 = [65, 63, 58, 59, 64, 69:72, 76:78, 73:74, 79, 75, 80, 82, 82:84, 86:87, 93, 88, 85, 89:91, 97, 96, 92, 95, 94, 104, 103, 103, 102, 98, 100, 99, 101, 105:106, 109:110, 108, 107, 112:113];

% profiles 24, 54 share station ID with previous profile
profiles2 = [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70];
%profiles2(36) %#ok<NOPTS> 
%list2(36) %#ok<NOPTS> 
% duplicate sites: 82, 103
%compare2 = [list2; profiles2];
stations2 = {'65', '63', '58', '59', '64', '69', '70', '71', '72', '76', '77', '78', '73', '74', '79', '75', '80', '82', '82', '83', '84', '86', '87', '93', '88', '85', '89', '90', '91', '97', '96', '92', '95', '94', '104', '103', '103', '102', '98', '100', '99', '101', '105', '106', '109', '110', '108', '107', '112', '113'};

may2down = RSKaddstationdata(may2down, 'profile', [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70], 'station', stations2);

%% Extract salinity data
stations = cell(112, 1);
CTD_depth = NaN(112, 1);
bottom_depth = NaN(112, 1);
bottom_temp = NaN(112, 1);
bottom_sal = NaN(112, 1);
surface_depth = NaN(112, 1);
surface_temp = NaN(112, 1);
surface_sal = NaN(112, 1);

% may1 file
for i = 1:62
    p = profiles1(i);
    stations(i) = may1down.data(p).station;
    CTD_depth(i) = max(may1down_uncut.data(p).values(:, 7));
    [depth, index] = max(may1down.data(p).values(:, 7));
    sal = may1down.data(p).values(index, 8);
    while isnan(sal)
        index = index - 1;
        depth = may1down.data(p).values(index, 7);
        temp = may1down.data(p).values(index, 2);
        sal = may1down.data(p).values(index, 8);
    end
    bottom_depth(i) = depth;
    bottom_temp(i) = temp;
    bottom_sal(i) = sal;
    if p == 14 || p == 78 || p == 80 || p == 84 %don't include surface data
        surface_depth(i) = NaN;
        surface_temp(i) = NaN;
        surface_sal(i) = NaN;
    else
        [m, index] = min(abs(may1down.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(i) = may1down.data(p).values(index, 7);
        surface_temp(i) = may1down.data(p).values(index, 2);
        surface_sal(i) = may1down.data(p).values(index, 8);
    end
end

% may2 file
for i = 1:50
    p = profiles2(i);
    k = i + 62; % account for profiles in may1 file
    stations(k) = may2down.data(p).station;
    CTD_depth(k) = max(may2down_uncut.data(p).values(:, 7));
    [depth, index] = max(may2down.data(p).values(:, 7));
    sal = may2down.data(p).values(index, 8);
    while isnan(sal)
        index = index - 1;
        depth = may2down.data(p).values(index, 7);
        temp = may2down.data(p).values(index, 2);
        sal = may2down.data(p).values(index, 8);
    end
    bottom_depth(k) = depth;
    bottom_temp(k) = temp;
    bottom_sal(k) = sal;
    if p == 24 || p == 54 %don't include surface data
        surface_depth(k) = NaN;
        surface_temp(k) = NaN;
        surface_sal(k) = NaN;
    else
        [m, index] = min(abs(may2down.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(k) = may2down.data(p).values(index, 7);
        surface_temp(k) = may2down.data(p).values(index, 2);
        surface_sal(k) = may2down.data(p).values(index, 8);
    end
end

stations = str2double(stations);

may_salinity = [stations CTD_depth bottom_depth bottom_temp bottom_sal surface_depth surface_temp surface_sal];

% determine whether doubled-up profiles are necessary
%may_salinity(stations==13, :) % first goes deeper after binning; remove second
%may_salinity(stations==82, :) % first goes deeper after binning; remove second
%may_salinity(stations==103, :) % first goes deeper after binning; remove second

%may_salinity(stations==49, :) % no difference in depth after binning; remove second

%may_salinity(stations==53, :) % almost no difference in salinity; remove second

%RSKplotprofiles(may1down_uncut, 'profile', 83:84, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(may1down, 'profile', 83:84, 'channel', {'temperature', 'salinity'});
%may_salinity(stations==57, :) % salinity on first seems more accurate; remove second

% remove duplicate station lines
may_salinity = array2table(may_salinity);
may_salinity(isnan(surface_depth), :) = [];

may_salinity.Properties.VariableNames = {'Station', 'CTDDepth', 'BottomDepth', 'BottomTemp', 'BottomSalinity', 'SurfaceDepth', 'SurfaceTemp', 'SurfaceSalinity'};

writetable(may_salinity, "data/CTD/may_CTD.csv");






%% Load October rsk files

oct1 = RSKopen('data/CTD/RSK_raw/RSA_20211006_021.rsk');
oct1 = RSKreaddata(oct1, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct2 = RSKopen('data/CTD/RSK_raw/RSA_20211008_064.rsk');
oct2 = RSKreaddata(oct2, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct3 = RSKopen('data/CTD/RSK_raw/RSA_20211010_114.rsk');
oct3 = RSKreaddata(oct3, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

% print list of all channels
%RSKprintchannels(oct1)

% read downcasts from all profiles
oct1down = RSKreadprofiles(oct1, 'direction', 'down'); % 22 profiles
oct2down = RSKreadprofiles(oct2, 'direction', 'down'); % 47 profiles
oct2up = RSKreadprofiles(oct2, 'direction', 'up'); % upcast of profile 12
oct3down = RSKreadprofiles(oct3, 'direction', 'down'); % 50 profiles

% plot all profiles
%RSKplotprofiles(oct1down, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(oct2down, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(oct2up, 'profile', 12, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(oct3down, 'channel', {'temperature', 'conductivity'});

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

% print list of all channels
%RSKprintchannels(oct1down)

%% Clean profiles by trimming

% trim downcasts in oct1 file
oct1down_uncut = oct1down;

    % (no trimming needed: 1, 8, 11:12) % 10, 16, 18 are funky
    %RSKplotprofiles(oct1down_uncut, 'profile', [1, 8, 10, 11:12, 18], 'channel', {'temperature', 'conductivity'});

for i = [2:7, 9, 13:17, 19:22]
    if i == 16
        a = max(oct1down.data(i).values(:, 7))-0.1;
    elseif i == 19
        a = max(oct1down.data(i).values(:, 7))-0.15;
    elseif i == 2 || i == 13
        a = max(oct1down.data(i).values(:, 7))-0.2;
    elseif i == 3 || i == 7 || i == 15 || i == 21 || i == 22
        a = max(oct1down.data(i).values(:, 7))-0.25;
    elseif i == 6 || i == 17
        a = max(oct1down.data(i).values(:, 7))-0.3;
    elseif i == 5
        a = max(oct1down.data(i).values(:, 7))-0.5;
    elseif i == 20
        a = max(oct1down.data(i).values(:, 7))-0.8;
    elseif i == 4 || i == 14
        a = max(oct1down.data(i).values(:, 7))-1.0;
    elseif i == 9
        a = max(oct1down.data(i).values(:, 7))-1.3;
    end
    b = max(oct1down.data(i).values(:, 7));
    oct1down = RSKtrim(oct1down, 'reference', 'depth', 'range', [a, b], 'profile', i, 'action', 'remove'); 
end

%%% check profs 10, 16, 17, 18

% check that data were removed
%RSKplotprofiles(oct1down, 'profile', 1:22, 'channel', {'temperature', 'conductivity'});

% trim downcasts in oct2 file
oct2down_uncut = oct2down;

    % (no trimming needed: 8, 10:12, 14:24, 26:33, 36:47)
    %RSKplotprofiles(oct2down_uncut, 'profile', [8, 10:12, 14:24, 26:33, 36:47], 'channel', {'temperature', 'conductivity'});

for i = [1:7, 9, 13, 34:35]
    if i == 5 || i == 7 || i == 9
        a = max(oct2down.data(i).values(:, 7))-0.05;
    elseif i == 6 || i == 35
        a = max(oct2down.data(i).values(:, 7))-0.1;
    elseif i == 13
        a = max(oct2down.data(i).values(:, 7))-0.2;
    elseif i == 34
        a = max(oct2down.data(i).values(:, 7))-0.25;
    elseif i == 1 || i == 4
        a = max(oct2down.data(i).values(:, 7))-0.5;
    elseif i == 3
        a = max(oct2down.data(i).values(:, 7))-0.7;
    elseif i == 2
        a = max(oct2down.data(i).values(:, 7))-0.8;
    end
    b = max(oct2down.data(i).values(:, 7));
    oct2down = RSKtrim(oct2down, 'reference', 'depth', 'range', [a, b], 'profile', i, 'action', 'remove'); 
end

% check that data were removed
%RSKplotprofiles(oct2down, 'profile', [1:24, 26:47], 'channel', {'temperature', 'conductivity'});

% trim profile 12 upcast: no trimming needed!
oct2up_uncut = oct2up;

% trim downcasts in oct3 file: no trimming needed!
oct3down_uncut = oct3down;

% check oct3 profiles
%RSKplotprofiles(oct3down, 'profile', [1:15, 17:30, 32:39, 41:42, 44:50], 'channel', {'temperature', 'conductivity'});

%% Process data

% correct for analog-to-digital zero-order hold
oct1down = RSKcorrecthold(oct1down, 'action', 'interp');
oct2down = RSKcorrecthold(oct2down, 'action', 'interp');
oct2up = RSKcorrecthold(oct2up, 'action', 'interp');
oct3down = RSKcorrecthold(oct3down, 'action', 'interp');

% low-pass filter
oct1down = RSKsmooth(oct1down, 'channel', {'temperature','conductivity'}, 'windowLength', 5);
oct2down = RSKsmooth(oct2down, 'channel', {'temperature','conductivity'}, 'windowLength', 5);
oct2up = RSKsmooth(oct2up, 'channel', {'temperature','conductivity'}, 'windowLength', 5);
oct3down = RSKsmooth(oct3down, 'channel', {'temperature','conductivity'}, 'windowLength', 5);

% align conductivity & temp
lag = RSKcalculateCTlag(oct1down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
oct1down = RSKalignchannel(oct1down, 'channel', 'temperature', 'lag', lag);

lag = RSKcalculateCTlag(oct2down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
oct2down = RSKalignchannel(oct2down, 'channel', 'temperature', 'lag', lag);

lag = RSKcalculateCTlag(oct2up);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
oct2up = RSKalignchannel(oct2up, 'channel', 'temperature', 'lag', lag);

lag = RSKcalculateCTlag(oct3down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
oct3down = RSKalignchannel(oct3down, 'channel', 'temperature', 'lag', lag);

% derive velocity
oct1down = RSKderivevelocity(oct1down);
oct2down = RSKderivevelocity(oct2down);
oct2up = RSKderivevelocity(oct2up);
oct3down = RSKderivevelocity(oct3down);

% look at velocity profiles
%RSKplotprofiles(oct1down, 'profile', 1:22, 'channel', {'velocity'});

% remove loops
%oct1loops0 = RSKremoveloops(oct1down, 'threshold', 0.25, 'visualize', [16, 18]);
%oct1loops1 = RSKremoveloops(oct1down, 'threshold', 0.2, 'visualize', [16, 18]);
%oct1loops2 = RSKremoveloops(oct1down, 'threshold', 0.15, 'visualize', [16, 18]);

oct1down = RSKremoveloops(oct1down, 'threshold', 0.2);
%RSKplotprofiles(oct1down, 'profile', 1:22, 'channel', {'temperature', 'conductivity'});

oct2down = RSKremoveloops(oct2down, 'threshold', 0.2);
%RSKplotprofiles(oct2down, 'profile', [1:24, 26:47], 'channel', {'temperature', 'conductivity'});

%no loops in profile 12 upcast

oct3down = RSKremoveloops(oct3down, 'threshold', 0.2);
%RSKplotprofiles(oct3down, 'profile', [1:15, 17:30, 32:39, 41:42, 44:50], 'channel', {'temperature', 'conductivity'});

% derive salinity
oct1down = RSKderivesalinity(oct1down);
%RSKplotprofiles(oct1down, 'profile', 1:22, 'channel', {'temperature', 'conductivity', 'salinity'});

oct2down = RSKderivesalinity(oct2down);
%RSKplotprofiles(oct2down, 'profile', [1:24, 26:47], 'channel', {'temperature', 'conductivity', 'salinity'});

oct2up = RSKderivesalinity(oct2up);
%RSKplotprofiles(oct2up, 'profile', 12, 'channel', {'temperature', 'conductivity', 'salinity'});

oct3down = RSKderivesalinity(oct3down);
%RSKplotprofiles(oct3down, 'profile', [1:15, 17:30, 32:39, 41:42, 44:50], 'channel', {'temperature', 'conductivity', 'salinity'});

%% Bin-average profiles; then compare raw vs. processed data

% bin-average by sea pressure (oct1)
oct1down = RSKbinaverage(oct1down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct1)
oct1 = RSKreadprofiles(oct1);
oct1 = RSKderivesalinity(oct1);

a = 1:6; %#ok<*NASGU> 
b = 7:12;
c = 13:17;
d = 18:22;

%figure
%channel = {'temperature', 'salinity', 'dissolved O2'};
%profile = [a b c d];
%[h1, ax] = RSKplotprofiles(oct1, 'profile', profile, 'channel', channel, 'direction', 'up'); %#ok<*ASGLU> 
%h2 = RSKplotprofiles(oct1down, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

%%% profiles 16 & 18 each still include a sal blip, but surface & bottom values seem reliable; moving on for now

% bin-average by sea pressure (oct2)
oct2down = RSKbinaverage(oct2down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct2)
oct2 = RSKreadprofiles(oct2);
oct2 = RSKderivesalinity(oct2);

a = 1:6;
b = 7:12;
c = 13:18;
d = 19:24;
e = 26:31;
f = 32:37;
g = 38:42;
h = 43:47;

% trim profile 9 surface
oct2down = RSKtrim(oct2down, 'reference', 'depth', 'range', [0, 2.5], 'profile', 9, 'action', 'remove'); 

%figure
%channel = {'temperature', 'salinity', 'dissolved O2'};
%profile = [a b c d e f g h];
%[h1, ax] = RSKplotprofiles(oct2, 'profile', profile, 'channel', channel, 'direction', 'up');
%h2 = RSKplotprofiles(oct2down, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

% bin-average by sea pressure (oct2 -- upcasts)
## %get this to bound at 2.5m
oct2up = RSKbinaverage(oct2up, 'direction', 'up', 'binBy', 'Depth', 'binSize', 1, 'boundary', [50 3]);
%h = findobj(gcf, 'type', 'line');
%set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data
a = 12;

%figure
%channel = {'temperature', 'salinity', 'dissolved O2'};
%profile = a;
%[h1, ax] = RSKplotprofiles(oct2, 'profile', profile, 'channel', channel, 'direction', 'down');
%h2 = RSKplotprofiles(oct2up, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

% bin-average by sea pressure (oct3)
oct3down = RSKbinaverage(oct3down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct3)
oct3 = RSKreadprofiles(oct3);
oct3 = RSKderivesalinity(oct3);

a = 1:6;
b = 7:12;
c = [13:15, 17:19];
d = 20:25;
e = 26:30;
f = 32:37;
g = [38:39, 41:42, 44:45];
h = 46:50;

% trim profile 1 surface
oct3down = RSKtrim(oct3down, 'reference', 'depth', 'range', [0, 2.5], 'profile', 1, 'action', 'remove'); 

%figure
%channel = {'temperature', 'salinity', 'dissolved O2'};
%profile = [a b c d e f g h];
%[h1, ax] = RSKplotprofiles(oct3, 'profile', profile, 'channel', channel, 'direction', 'up');
%h2 = RSKplotprofiles(oct3down, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

%%% profile 6 surface DO is a bit wacky

%% Assign station numbers to profiles

% oct1 file
% chronological sites 001-021

list1 = [1:3, 5, 4, 6:11, 11:21];
profiles1 = 1:22;
% profile 12 shares station ID with previous profile
compare1 = [list1; profiles1];

% duplicated site: 11
stations1 = {'1', '2', '3', '5', '4', '6', '7', '8', '9', '10', '11', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21'};

oct1down = RSKaddstationdata(oct1down, 'profile', profiles1, 'station', stations1);

% oct2 file
% no data from sites 022, 023
% chronological sites 024-064; includes 024-068

list2 = [24:32, 35, 34, 33, 36:48, 50:51, 56, 55, 52, 49, 49, 53:54, 57, 61, 67:68, 66, 62, 60, 65, 63, 58, 59, 64];
profiles2 = [1:24, 26:47];

% profile 33 shares station ID with previous profile
    %profiles2(31)
    %list2(31)
compare2 = [list2; profiles2];

% duplicated site: 49
stations2 = {'24', '25', '26', '27', '28', '29', '30', '31', '32', '35', '34', '33', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '50', '51', '56', '55', '52', '49', '49', '53', '54', '57', '61', '67', '68', '66', '62', '60', '65', '63', '58', '59', '64'};

oct2down = RSKaddstationdata(oct2down, 'profile', profiles2, 'station', stations2);
oct2up = RSKaddstationdata(oct2up, 'profile', profiles2, 'station', stations2);

% oct3 file
% no data from site 104
% sites 069-114

list3 = [69:72, 76:78, 73:74, 79, 75, 80:84, 86:87, 93, 88, 85, 89:91, 97, 96, 92, 92, 95, 94, 103, 102, 98, 100, 99, 101, 105:106, 109:110, 108, 107, 111:114];
profiles3 = [1:15, 17:30, 32:39, 41:42, 44:50];

% profile 29 shares station ID with previous profile
    %profiles3(27)
    %list3(27)

compare3 = [list3; profiles3];
% duplicated site = 92
stations3 = {'69', '70', '71', '72', '76', '77', '78', '73', '74', '79', '75', '80', '81', '82', '83', '84', '86', '87', '93', '88', '85', '89', '90', '91', '97', '96', '92', '92', '95', '94', '103', '102', '98', '100', '99', '101', '105', '106', '109', '110', '108', '107', '111', '112', '113', '114'};

oct3down = RSKaddstationdata(oct3down, 'profile', profiles3, 'station', stations3);

%% Extract salinity data
stations = cell(112, 1);
CTD_depth = NaN(112, 1);
bottom_depth = NaN(112, 1);
bottom_temp = NaN(112, 1);
bottom_sal = NaN(112, 1);
surface_depth = NaN(112, 1);
surface_temp = NaN(112, 1);
surface_sal = NaN(112, 1);

% oct1 file
for i = 1:22
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    CTD_depth(i) = max(oct1down_uncut.data(p).values(:, 7));
    [depth, index] = max(oct1down.data(p).values(:, 7));
    sal = oct1down.data(p).values(index, 9);
    while isnan(sal)
        index = index - 1;
        depth = oct1down.data(p).values(index, 7);
        temp = oct1down.data(p).values(index, 2);
        sal = oct1down.data(p).values(index, 9);
    end
    bottom_depth(i) = depth;
    bottom_temp(i) = temp;
    bottom_sal(i) = sal;
    if p == 12 %don't include surface data
        surface_depth(i) = NaN;
        surface_temp(i) = NaN;
        surface_sal(i) = NaN;
    else
        [m, index] = min(abs(oct1down.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(i) = oct1down.data(p).values(index, 7);
        surface_temp(i) = oct1down.data(p).values(index, 2);
        surface_sal(i) = oct1down.data(p).values(index, 9);
    end
end

% oct2 file
for i = 1:46
    p = profiles2(i);
    k = i + 22; % account for profiles in oct1 file
    stations(k) = oct2down.data(p).station;
    CTD_depth(k) = max(oct2down_uncut.data(p).values(:, 7));
    [depth, index] = max(oct2down.data(p).values(:, 7));
    sal = oct2down.data(p).values(index, 9);
    while isnan(sal)
        index = index - 1;
        depth = oct2down.data(p).values(index, 7);
        temp = oct2down.data(p).values(index, 2);
        sal = oct2down.data(p).values(index, 9);
    end
    bottom_depth(k) = depth;
    bottom_temp(k) = temp;
    bottom_sal(k) = sal;
    if p == 12 %use upcast data
        [m, index] = min(abs(oct2up.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(k) = oct2up.data(p).values(index, 7);
        surface_temp(k) = oct2up.data(p).values(index, 2);
        surface_sal(k) = oct2up.data(p).values(index, 9);
    elseif p == 33 %don't include surface data
        surface_depth(k) = NaN;
        surface_temp(k) = NaN;
        surface_sal(k) = NaN;
    else
        [m, index] = min(abs(oct2down.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(k) = oct2down.data(p).values(index, 7);
        surface_temp(k) = oct2down.data(p).values(index, 2);
        surface_sal(k) = oct2down.data(p).values(index, 9);
    end
end

% oct3 file
for i = 1:46
    p = profiles3(i);
    k = i + 68; % account for profiles in oct1 & oct2 files
    stations(k) = oct3down.data(p).station;
    CTD_depth(k) = max(oct3down_uncut.data(p).values(:, 7));
    [depth, index] = max(oct3down.data(p).values(:, 7));
    sal = oct3down.data(p).values(index, 9);
    while isnan(sal)
        index = index - 1;
        depth = oct3down.data(p).values(index, 7);
        temp = oct3down.data(p).values(index, 2);
        sal = oct3down.data(p).values(index, 9);
    end
    bottom_depth(k) = depth;
    bottom_temp(k) = temp;
    bottom_sal(k) = sal;
    if p == 29 %don't include surface data
        surface_depth(k) = NaN;
        surface_temp(k) = NaN;
        surface_sal(k) = NaN;
    else
        [m, index] = min(abs(oct3down.data(p).values(:, 7) - 1)); %find closest datapoint to 1m
        surface_depth(k) = oct3down.data(p).values(index, 7);
        surface_temp(k) = oct3down.data(p).values(index, 2);
        surface_sal(k) = oct3down.data(p).values(index, 9);
    end
end

stations = str2double(stations);

oct_salinity = [stations CTD_depth bottom_depth bottom_temp bottom_sal surface_depth surface_temp surface_sal];

% determine whether doubled-up profiles are necessary
%oct_salinity(stations==49, :) % keep second!

%oct_salinity(stations==11, :) % salinity & temp on first seem more accurate; remove second
%RSKplotprofiles(oct1down_uncut, 'profile', 11:12, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(oct1down, 'profile', 11:12, 'channel', {'temperature', 'salinity'});

%oct_salinity(stations==92, :) % salinity & temp on first seem more accurate; remove second
%RSKplotprofiles(oct3down_uncut, 'profile', 28:29, 'channel', {'temperature', 'conductivity'});
%SKplotprofiles(oct3down, 'profile', 28:29, 'channel', {'temperature', 'salinity'});

% reconcile station 49 profiles
i = 31;
k = i + 22; 
p = profiles2(i);
n = p + 1;
CTD_depth(k) = max(oct2down_uncut.data(n).values(:, 7));
[depth, index] = max(oct2down.data(n).values(:, 7));
sal = oct2down.data(n).values(index, 9);
while isnan(sal)
    index = index - 1;
    depth = oct2down.data(n).values(index, 7);
    temp = oct2down.data(n).values(index, 2);
    sal = oct2down.data(n).values(index, 9);
end
bottom_depth(k) = depth;
bottom_temp(k) = temp;
bottom_sal(k) = sal;

oct_salinity = [stations CTD_depth bottom_depth bottom_temp bottom_sal surface_depth surface_temp surface_sal];

% remove duplicate station lines
oct_salinity = array2table(oct_salinity);
oct_salinity(isnan(surface_depth), :) = [];

oct_salinity.Properties.VariableNames = {'Station', 'CTDDepth', 'BottomDepth', 'BottomTemp', 'BottomSalinity', 'SurfaceDepth', 'SurfaceTemp', 'SurfaceSalinity'};

writetable(oct_salinity, "data/CTD/oct_CTD.csv");












%% [SKIP] Find false downcasts in may1 file

% why does it let me go past 1:58 in RSKreadprofiles when there should be 58 profiles?
% bc it is including false "downcasts"
plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
plot(may1down.data(95).tstamp, may1down.data(95).values(:, 3))
hold off

% 20 peaks a/o profile 27
% 30 peaks a/o profile 44
% 50 peaks a/o profile 79

% false downcasts: 5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80,
% 82, 84, 86, 89, 91, 93, 95

% true downcasts: 1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68,
% 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94

plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
for i=[5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95]
    plot(may1down.data(i).tstamp, may1down.data(i).values(:, 3))
end
hold off

% find sites where "false" downcast(s) need to be included
depths = NaN(95, 1);
for i = 1:95
  depths(i) = max(may1down.data(i).values(:, 7));
end

comp = NaN(26, 3);
true = [4, 7, 13, 22, 30, 33, 36, 44, 50, 52, 60, 62, 64, 66, 68, 71, 75, 77, 79, 81, 83, 85, 88, 90, 92, 94];
false = [5, 8, 14, 23, 31, 34, 37, 45, 51, 53, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95];
for i = 1:26
    comp(i, 1) = max(depths(true(1, i)));
    comp(i, 2) = max(depths(false(1, i)));
    comp(i, 3) = comp(i, 1) > comp(i, 2);
    if comp(i, 3) == 0
        disp(false(1, i));
    end
end

% 14, 78, 80, 84 should be included

% manually check: [16, 27, 39, 47, 57]
% against: [17:19, 28:29, 40:41, 48:49, 58:59]
a = max(depths(57));
b = max(depths(58:59));
a > b; %#ok<*VUNUS> 
% all okay

% full list of may1 profiles to include: 1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60,
% 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94

%% [SKIP] Find false downcasts in may2 file
plot(may2.data.tstamp, may2.data.values(:, 3))
hold on
plot(may2down.data(71).tstamp, may2down.data(71).values(:, 3))
hold off

% 8 peaks a/o profile 12
% 17 peaks a/o profile 22
% 30 peaks a/o profile 43

% false downcasts: 3, 5, 8, 10, 13, 24, 28, 30, 33, 38:39, 41:42, 45, 47, 49:50, 52, 54, 57, 59, 63, 71

% true downcasts: 1:2, 4, 6:7, 9, 11:12, 14:23, 25:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53, 55:56, 58, 60:62, 64:70

plot(may2.data.tstamp, may2.data.values(:, 3))
hold on
for i=[3, 5, 8, 10, 13, 24, 28, 30, 33, 38:39, 41:42, 45, 47, 49:50, 52, 54, 57, 59, 63, 71]
    plot(may2down.data(i).tstamp, may2down.data(i).values(:, 3))
end
hold off

% find sites where "false" downcast(s) need to be included
depths = NaN(71, 1);
for i = 1:71
  depths(i) = max(may2down.data(i).values(:, 7));
end

comp = NaN(17, 3);
true = [2, 4, 7, 9, 12, 23, 27, 29, 32, 44, 46, 51, 53, 56, 58, 62, 70];
false = [3, 5, 8, 10, 13, 24, 28, 30, 33, 45, 47, 52, 54, 57, 59, 63, 71];
for i = 1:17
    comp(i, 1) = max(depths(true(1, i)));
    comp(i, 2) = max(depths(false(1, i)));
    comp(i, 3) = comp(i, 1) > comp(i, 2);
    if comp(i, 3) == 0
        disp(false(1, i));
    end
end

% 24, 54 should be included

% manually check: [37, 40, 48]
% against: [38:39, 41:42, 49:50]
a = max(depths(48));
b = max(depths(49:50));
a > b;
% all okay

% full list of may2 profiles to include: 1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58,
% 60:62, 64:70






%% [SKIP] Find incomplete downcasts in oct1 file
i = 22;
plot(oct1.data.tstamp, oct1.data.values(:, 3))
hold on
plot(oct1down.data(i).tstamp, oct1down.data(i).values(:, 3))
hold off

% incomplete downcast: 12
% true downcasts: 1:11, 13:22

plot(oct1.data.tstamp, oct1.data.values(:, 3))
hold on
for i=12
    plot(oct1down.data(i).tstamp, oct1down.data(i).values(:, 3))
end
hold off

% find sites where "false" downcast(s) need to be included
depths = NaN(22, 1);
for i = 1:22
  depths(i) = max(oct1down.data(i).values(:, 7));
end

comp = NaN(1, 3);
true = 11;
false = 12;
for i = 1
    comp(i, 1) = max(depths(true(1, i)));
    comp(i, 2) = max(depths(false(1, i)));
    comp(i, 3) = comp(i, 1) > comp(i, 2);
    if comp(i, 3) == 0
        disp(false(1, i));
    end
end

% 12 should be included

% full list of oct1 profiles to include: 1:22

%% [SKIP] Find incomplete downcasts in oct2 file
i = 11;
plot(oct2.data.tstamp, oct2.data.values(:, 3))
hold on
plot(oct2down.data(i).tstamp, oct2down.data(i).values(:, 3))
hold off

% incomplete downcasts: 25, 33
% true downcasts: 1:24, 26:32, 34:47; profile 12 is not a full downcast

plot(oct2.data.tstamp, oct2.data.values(:, 3))
hold on
for i=[25, 33]
    plot(oct2down.data(i).tstamp, oct2down.data(i).values(:, 3))
end
hold off

% find sites where "false" downcast(s) need to be included
depths = NaN(47, 1);
for i = 1:47
  depths(i) = max(oct2down.data(i).values(:, 7));
end

comp = NaN(2, 3);
true = [24, 32];
false = [25, 33];
for i = 1:2
    comp(i, 1) = max(depths(true(1, i)));
    comp(i, 2) = max(depths(false(1, i)));
    comp(i, 3) = comp(i, 1) > comp(i, 2);
    if comp(i, 3) == 0
        disp(false(1, i));
    end
end

% 33 should be included

% full list of oct2 profiles to include: 1:24, 26:47

%% Check oct2up profile
plot(oct2.data.tstamp, oct2.data.values(:, 3))
hold on
plot(oct2up_12.data(1).tstamp, oct2up_12.data(1).values(:, 3))
hold off

%% [SKIP] Find incomplete downcasts in oct3 file
i = 50;
plot(oct3.data.tstamp, oct3.data.values(:, 3))
hold on
plot(oct3down.data(i).tstamp, oct3down.data(i).values(:, 3))
hold off

% incomplete downcasts: 16, 29, 31, 40, 43
% true downcasts: 1:15, 17:28, 30, 32:39, 41:42, 44:50

plot(oct3.data.tstamp, oct3.data.values(:, 3))
hold on
for i=[16, 29, 31, 40, 43]
    plot(oct3down.data(i).tstamp, oct3down.data(i).values(:, 3))
end
hold off

% find sites where "false" downcast(s) need to be included
depths = NaN(50, 1);
for i = 1:50
  depths(i) = max(oct3down.data(i).values(:, 7));
end

comp = NaN(5, 3);
true = [15, 28, 30, 39, 42];
false = [16, 29, 31, 40, 43];
for i = 1:5
    comp(i, 1) = max(depths(true(1, i)));
    comp(i, 2) = max(depths(false(1, i)));
    comp(i, 3) = comp(i, 1) > comp(i, 2);
    if comp(i, 3) == 0
        disp(false(1, i));
    end
end

% 29 should be included

% full list of oct3 profiles to include: 1:15, 17:30, 32:39, 41:42, 44:50












%% [Not using] Load csv files

% may1 = readmatrix('./data/CTD_raw/RSA_20210504_060.csv');
% may2 = readmatrix('./data/CTD_raw/RSA_20210506_113.csv');
% allMay = [may1; may2];

% oct1 = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess