%cd Repos/ScallopRSA2021

%% Load October rsk files

oct1 = RSKopen('data/CTD/RSK_raw/RSA_20211006_021.rsk');
oct1 = RSKreaddata(oct1, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct2 = RSKopen('data/CTD/RSK_raw/RSA_20211008_064.rsk');
oct2 = RSKreaddata(oct2, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

oct3 = RSKopen('data/CTD/RSK_raw/RSA_20211010_114.rsk');
oct3 = RSKreaddata(oct3, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

% print list of all channels
%RSKprintchannels(oct1)

% Use downcast data: CTD is oriented so that intake sees new water before the rest of the package causes
% any mixing or has an effect on water temperature

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
        a = max(oct2down.data(i).values(:, 7))-1.0;
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

oct1down = RSKderiveO2(oct1down, 'toDerive', 'saturation');
%RSKprintchannels(oct1down)
%RSKplotprofiles(oct1down, 'channel', {'dissolved O2', 'dissolved O22'});

oct2down = RSKderiveO2(oct2down, 'toDerive', 'saturation');
%RSKplotprofiles(oct2down, 'channel', {'dissolved O2', 'dissolved O22'});

oct2up = RSKderiveO2(oct2up, 'toDerive', 'saturation');

oct3down = RSKderiveO2(oct3down, 'toDerive', 'saturation');
%RSKplotprofiles(oct3down, 'channel', {'dissolved O2', 'dissolved O22'});

%% Bin-average profiles; then compare raw vs. processed data

% bin-average by sea pressure (oct1)
oct1down = RSKbinaverage(oct1down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
%h = findobj(gcf, 'type', 'line');
%set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct1)
%oct1 = RSKreadprofiles(oct1);
%oct1 = RSKderivesalinity(oct1);

%a = 1:6; %#ok<*NASGU> 
%b = 7:12;
%c = 13:17;
%d = 18:22;

%figure
%channel = {'temperature', 'salinity', 'dissolved O22'};
%profile = [a b c d];
%[h1, ax] = RSKplotprofiles(oct1, 'profile', profile, 'channel', channel, 'direction', 'up'); %#ok<*ASGLU> 
%h2 = RSKplotprofiles(oct1down, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

%%% profiles 16 & 18 each still include a sal blip, but surface & bottom values seem reliable; moving on for now

% bin-average by sea pressure (oct2)
oct2down = RSKbinaverage(oct2down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
%h = findobj(gcf, 'type', 'line');
%set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct2)
%oct2 = RSKreadprofiles(oct2);
%oct2 = RSKderivesalinity(oct2);

%a = 1:6;
%b = 7:12;
%c = 13:18;
%d = 19:24;
%e = 26:31;
%f = 32:37;
%g = 38:42;
%h = 43:47;

% trim profile 9 surface
oct2down = RSKtrim(oct2down, 'reference', 'depth', 'range', [0, 2.5], 'profile', 9, 'action', 'remove'); 

%figure
%channel = {'temperature', 'salinity', 'dissolved O22'};
%profile = [a b c d e f g h];
%[h1, ax] = RSKplotprofiles(oct2, 'profile', profile, 'channel', channel, 'direction', 'up');
%h2 = RSKplotprofiles(oct2down, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

% bin-average by sea pressure (oct2 -- upcasts)
oct2up = RSKbinaverage(oct2up, 'direction', 'up', 'binBy', 'Depth', 'binSize', 1, 'boundary', [50 3]);
%h = findobj(gcf, 'type', 'line');
%set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data
%a = 12;

%figure
%channel = {'temperature', 'salinity', 'dissolved O22'};
%profile = a;
%[h1, ax] = RSKplotprofiles(oct2, 'profile', profile, 'channel', channel, 'direction', 'down');
%h2 = RSKplotprofiles(oct2up, 'profile', profile, 'channel', channel);
%set(h2, 'linewidth', 3)

% bin-average by sea pressure (oct3)
oct3down = RSKbinaverage(oct3down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 2);
%h = findobj(gcf, 'type', 'line');
%set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data (oct3)
%oct3 = RSKreadprofiles(oct3);
%oct3 = RSKderivesalinity(oct3);

%a = 1:6;
%b = 7:12;
%c = [13:15, 17:19];
%d = 20:25;
%e = 26:30;
%f = 32:37;
%g = [38:39, 41:42, 44:45];
%h = 46:50;

% trim profile 1 surface
oct3down = RSKtrim(oct3down, 'reference', 'depth', 'range', [0, 2.5], 'profile', 1, 'action', 'remove'); 

%figure
%channel = {'temperature', 'salinity', 'dissolved O22'};
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

%% Plot end-member profiles
% surface EMs: 9, 113, 30, + 5
% bottom EMs: 21, 33, 53

stations1(22)
profiles1(22)

% surface
figure
channel = {'temperature', 'salinity', 'dissolved O2'};
h = RSKplotprofiles(oct1down, 'profile', 9, 'channel', channel); % 009
j = RSKplotprofiles(oct2down, 'profile', 7, 'channel', channel); % 030
k = RSKplotprofiles(oct3down, 'profile', 49, 'channel', channel); % 113
l = RSKplotprofiles(oct1down, 'profile', 4, 'channel', channel); % 005
set(h, 'linewidth', 3, 'linestyle', ':', 'color', '#4169E1')
set(j, 'linewidth', 3, 'linestyle', ':', 'color', '#4169E1')
set(k, 'linewidth', 3, 'linestyle', ':', 'color', '#4169E1')
set(l, 'linewidth', 3, 'linestyle', ':', 'color', '#4169E1')

% bottom
figure
channel = {'temperature', 'salinity', 'dissolved O2'};
h = RSKplotprofiles(oct1down, 'profile', 22, 'channel', channel); % 021
j = RSKplotprofiles(oct2down, 'profile', 12, 'channel', channel); % 033
k = RSKplotprofiles(oct2up, 'profile', 12, 'channel', channel); % 033
l = RSKplotprofiles(oct2down, 'profile', 34, 'channel', channel); % 053
set(h, 'linewidth', 3, 'color', '#4169E1')
set(j, 'linewidth', 3, 'color', '#4169E1')
set(k, 'linewidth', 3, 'color', '#4169E1')
set(l, 'linewidth', 3, 'color', '#4169E1')

%% Check indiv profile

%oct1 = RSKreadprofiles(oct1);
%oct1 = RSKderivesalinity(oct1);

figure
channel = {'temperature', 'salinity', 'dissolved O2'};
profile = 25; % station 91
%[h1, ax] = RSKplotprofiles(oct1, 'profile', profile, 'channel', channel, 'direction', 'up'); %#ok<*ASGLU> 
h2 = RSKplotprofiles(oct3down, 'profile', profile, 'channel', channel);
set(h2, 'linewidth', 3)

%% Extract sal & O2 data
stations = cell(114, 1);
CTD_depth = NaN(114, 1);
bottom_temp = NaN(114, 1);
bottom_press = NaN(114, 1);
bottom_seapress = NaN(114, 1);
bottom_depth = NaN(114, 1);
bottom_sal = NaN(114, 1);
bottom_o2 = NaN(114, 1);
bottom_o2_sat = NaN(114, 1);
surface_temp = NaN(114, 1);
surface_press = NaN(114, 1);
surface_seapress = NaN(114, 1);
surface_depth = NaN(114, 1);
surface_sal = NaN(114, 1);
surface_o2 = NaN(114, 1);
surface_o2_sat = NaN(114, 1);

%RSKprintchannels(oct1down)

% oct1 file
for i = 1:length(oct1down.data)
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    CTD_depth(i) = max(oct1down_uncut.data(p).values(:, 7));
    [depth, index] = max(oct1down.data(p).values(:, 7));
    sal = oct1down.data(p).values(index, 9);
    while isnan(sal)
        index = index - 1;
        temp = oct1down.data(p).values(index, 2);
        press = oct1down.data(p).values(index, 3);
        seapress = oct1down.data(p).values(index, 6);
        depth = oct1down.data(p).values(index, 7);
        sal = oct1down.data(p).values(index, 9);
        o2 = oct1down.data(p).values(index, 5);
        o2_sat = oct1down.data(p).values(index, 10);
    end
    bottom_temp(i) = temp;
    bottom_press(i) = press;
    bottom_seapress(i) = seapress;
    bottom_depth(i) = depth;
    bottom_sal(i) = sal;
    bottom_o2(i) = o2;
    bottom_o2_sat(i) = o2_sat;
    if p == 12 %don't include surface data
        surface_depth(i) = NaN;
    else
        [m, index] = min(oct1down.data(p).values(:, 7));
        surface_temp(i) = oct1down.data(p).values(index, 2);
        surface_press(i) = oct1down.data(p).values(index, 3);
        surface_seapress(i) = oct1down.data(p).values(index, 6);
        surface_depth(i) = oct1down.data(p).values(index, 7);
        surface_sal(i) = oct1down.data(p).values(index, 9);
        surface_o2(i) = oct1down.data(p).values(index, 5);
        surface_o2_sat(i) = oct1down.data(p).values(index, 10);
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
        temp = oct2down.data(p).values(index, 2);
        press = oct2down.data(p).values(index, 3);
        seapress = oct2down.data(p).values(index, 6);
        depth = oct2down.data(p).values(index, 7);
        sal = oct2down.data(p).values(index, 9);
        o2 = oct2down.data(p).values(index, 5);
        o2_sat = oct2down.data(p).values(index, 10);
    end
    bottom_temp(k) = temp;
    bottom_press(k) = press;
    bottom_seapress(k) = seapress;
    bottom_depth(k) = depth;
    bottom_sal(k) = sal;
    bottom_o2(k) = o2;
    bottom_o2_sat(k) = o2_sat;
    if p == 12 %use upcast data
        [m, index] = min(oct2up.data(p).values(:, 7));
        surface_temp(k) = oct2up.data(p).values(index, 2);
        surface_press(k) = oct2up.data(p).values(index, 3);
        surface_seapress(k) = oct2up.data(p).values(index, 6);
        surface_depth(k) = oct2up.data(p).values(index, 7);
        surface_sal(k) = oct2up.data(p).values(index, 9);
        surface_o2(k) = oct2up.data(p).values(index, 5);
        surface_o2_sat(k) = oct2up.data(p).values(index, 10);
    elseif p == 33 %don't include surface data
        surface_depth(k) = NaN;
    else
        [m, index] = min(oct2down.data(p).values(:, 7));
        surface_temp(k) = oct2down.data(p).values(index, 2);
        surface_press(k) = oct2down.data(p).values(index, 3);
        surface_seapress(k) = oct2down.data(p).values(index, 6);
        surface_depth(k) = oct2down.data(p).values(index, 7);
        surface_sal(k) = oct2down.data(p).values(index, 9);
        surface_o2(k) = oct2down.data(p).values(index, 5);
        surface_o2_sat(k) = oct2down.data(p).values(index, 10);
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
        temp = oct3down.data(p).values(index, 2);
        press = oct3down.data(p).values(index, 3);
        seapress = oct3down.data(p).values(index, 6);
        depth = oct3down.data(p).values(index, 7);
        sal = oct3down.data(p).values(index, 9);
        o2 = oct3down.data(p).values(index, 5);
        o2_sat = oct3down.data(p).values(index, 10);
    end
    bottom_temp(k) = temp;
    bottom_press(k) = press;
    bottom_seapress(k) = seapress;
    bottom_depth(k) = depth;
    bottom_sal(k) = sal;
    bottom_o2(k) = o2;
    bottom_o2_sat(k) = o2_sat;
    if p == 29 %don't include surface data
        surface_depth(k) = NaN;
    else
        [m, index] = min(oct3down.data(p).values(:, 7));
        surface_temp(k) = oct3down.data(p).values(index, 2);
        surface_press(k) = oct3down.data(p).values(index, 3);
        surface_seapress(k) = oct3down.data(p).values(index, 6);
        surface_depth(k) = oct3down.data(p).values(index, 7);
        surface_sal(k) = oct3down.data(p).values(index, 9);
        surface_o2(k) = oct3down.data(p).values(index, 5);
        surface_o2_sat(k) = oct3down.data(p).values(index, 10);
    end
end

stations = str2double(stations);

oct_salinity = [stations CTD_depth bottom_depth bottom_temp bottom_press bottom_seapress bottom_sal bottom_o2 bottom_o2_sat surface_depth surface_temp surface_press surface_seapress surface_sal surface_o2 surface_o2_sat];

% determine whether doubled-up profiles are necessary
%oct_salinity(stations==49, :) % keep second!

%oct_salinity(stations==11, :) % salinity & temp on first seem more accurate; remove second
%RSKplotprofiles(oct1down_uncut, 'profile', 11:12, 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(oct1down, 'profile', 11:12, 'channel', {'temperature', 'salinity'});

%oct_salinity(stations==92, :) % salinity & temp on first seem more accurate; remove second
%RSKplotprofiles(oct3down_uncut, 'profile', 28:29, 'channel', {'temperature', 'conductivity'});
%SKplotprofiles(oct3down, 'profile', 28:29, 'channel', {'temperature', 'salinity'});

% reconcile station 49 profiles % actually don't do this because then sal is way off compared to bottle
%i = 31;
%k = i + 22; 
%p = profiles2(i);
%n = p + 1;
%CTD_depth(k) = max(oct2down_uncut.data(n).values(:, 7));
%[depth, index] = max(oct2down.data(n).values(:, 7));
%sal = oct2down.data(n).values(index, 9);
%while isnan(sal)
%    index = index - 1;
%    depth = oct2down.data(n).values(index, 7);
%    temp = oct2down.data(n).values(index, 2);
%    sal = oct2down.data(n).values(index, 9);
%end
%bottom_depth(k) = depth;
%bottom_temp(k) = temp;
%bottom_sal(k) = sal;

%oct_salinity = [stations CTD_depth bottom_depth bottom_temp bottom_sal surface_depth surface_temp surface_sal];

% remove duplicate station lines
oct_salinity = array2table(oct_salinity);
oct_salinity(isnan(surface_depth), :) = [];

oct_salinity.Properties.VariableNames = {'Station', 'CTDDepth', 'BottomDepth', 'BottomTemp', 'BottomPress', 'BottomSeaPress', 'BottomSalinity', 'BottomO2', 'BottomO2Sat', 'SurfaceDepth', 'SurfaceTemp', 'SurfacePress', 'SurfaceSeaPress', 'SurfaceSalinity', 'SurfaceO2', 'SurfaceO2Sat'};

writetable(oct_salinity, "data/CTD/oct_CTD.csv");












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

% oct1 = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess