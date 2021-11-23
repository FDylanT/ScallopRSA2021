%% Load rsk files

% cd Repos/ScallopRSA2021

may1 = RSKopen('data/CTD_raw/RSA_20210504_060.rsk');
may1 = RSKreaddata(may1, 't1', datenum(2021, 05, 02), 't2', datenum(2021, 05, 06));
may2 = RSKopen('data/CTD_raw/RSA_20210506_113.rsk');
may2 = RSKreaddata(may2, 't1', datenum(2021, 05, 02), 't2', datenum(2021, 05, 06));

% oct1 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
% oct1 = RSKreaddata(oct1, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));
% oct2 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
% oct2 = RSKreaddata(oct2, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));
% oct3 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
% oct3 = RSKreaddata(oct3, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

% print list of all channels
%RSKprintchannels(may1)

% read downcasts from all profiles
may1down = RSKreadprofiles(may1, 'profile', 1:95, 'direction', 'down');
may2down = RSKreadprofiles(may2, 'profile', 1:71, 'direction', 'down');

% plot all profiles
%RSKplotprofiles(may1down, 'profile', [1:95], 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(may2down, 'profile', [1:71], 'channel', {'temperature', 'conductivity'});

% derive depths
may1down = RSKderivedepth(may1down);
may2down = RSKderivedepth(may2down);

% trim downcasts in may1 file
may1down_uncut = may1down;

    % (no trimming needed: 2, 6:7, 9, 11, 13, 15:16, 21:22, 33, 35:36, 38, 44, 57, 83)
    %RSKplotprofiles(may1down_uncut, 'profile', [2, 6:7, 9, 11, 13, 15:16, 21:22, 33, 35:36, 38, 44, 57, 83], 'channel', {'temperature', 'conductivity'});

for i = [1, 3:4, 10, 12, 14, 20, 24:27, 30, 32, 39, 42:43, 46:47, 50, 52, 54:56, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 84:85, 87:88, 90, 92, 94]
    if i==20 || i==25 || i==75
        a = max(may1down.data(i).values(:, 7))-0.05;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==30 || i==32 || i==42 || i==43 || i==46 || i==50 || i==54 || i==60 || i==66 || i==73 || i==79 || i==81 || i==84
        a = max(may1down.data(i).values(:, 7))-0.1;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==52 || i==64 || i==68 || i==78 || i==85 || i==90 || i==92
        a = max(may1down.data(i).values(:, 7))-0.15;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==10 || i==39 || i==47 || i==56 || i==62 || i==71 || i==74 || i==80 || i==87 || i==94
        a = max(may1down.data(i).values(:, 7))-0.2;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==1 || i==3 || i==4 || i==12 || i==26 || i==27 || i==55
        a = max(may1down.data(i).values(:, 7))-0.25;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==24 || i==88
        a = max(may1down.data(i).values(:, 7))-0.3;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==14 || i==70
        a = max(may1down.data(i).values(:, 7))-0.35;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==77
        a = max(may1down.data(i).values(:, 7))-0.45;
        b = max(may1down.data(i).values(:, 7));
        may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    end
end

% check that data were removed
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

% trim downcasts in may2 file
may2down_uncut = may2down;

    % (no trimming needed: **)
    RSKplotprofiles(may2down_uncut, 'profile', [**], 'channel', {'temperature', 'conductivity'});

#### pick up here: figure out which profiles don't need trimming; then trim others incrementally

may2down = may2down_uncut;
for i = [1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53:56, 58, 60:62, 64:70]
    a = max(may2down.data(i).values(:, 7))-0.05;
    b = max(may2down.data(i).values(:, 7));
    may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
end

    if i==20 || i==25 || i==75
        a = max(may2down.data(i).values(:, 7))-0.05;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==30 || i==32 || i==42 || i==43 || i==46 || i==50 || i==54 || i==60 || i==66 || i==73 || i==79 || i==81 || i==84
        a = max(may2down.data(i).values(:, 7))-0.1;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==52 || i==64 || i==68 || i==78 || i==85 || i==90 || i==92
        a = max(may2down.data(i).values(:, 7))-0.15;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==10 || i==39 || i==47 || i==56 || i==62 || i==71 || i==74 || i==80 || i==87 || i==94
        a = max(may2down.data(i).values(:, 7))-0.2;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==1 || i==3 || i==4 || i==12 || i==26 || i==27 || i==55
        a = max(may2down.data(i).values(:, 7))-0.25;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==24 || i==88
        a = max(may2down.data(i).values(:, 7))-0.3;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==14 || i==70
        a = max(may2down.data(i).values(:, 7))-0.35;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    elseif i==77
        a = max(may2down.data(i).values(:, 7))-0.45;
        b = max(may2down.data(i).values(:, 7));
        may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [a, b], 'profile', [i], 'action', 'remove', 'visualize', [i]); %#ok<NBRAK> 
    end
end

% check that data were removed
RSKplotprofiles(may2down, 'profile', [***], 'channel', {'temperature', 'conductivity'});

##### should I trim the beginnings?

%% process data

% correct for analog-to-digital zero-order hold
may1down.channels(12:13) = [];
may1down = RSKcorrecthold(may1down, 'action', 'interp');

% low-pass filter
may1down = RSKsmooth(may1down, 'channel', {'temperature','conductivity'}, 'windowLength', 5, 'visualize', [10, 14, 26, 71, 78, 80, 84]);

% align conductivity & temp
lag = RSKcalculateCTlag(may1down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
may1down = RSKalignchannel(may1down, 'channel', 'temperature', 'lag', lag, 'visualize', [10, 14, 26, 71, 78, 80, 84]);

% derive velocity
may1down = RSKderivevelocity(may1down);

% try to figure out optimal velocity threshold
%RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'velocity'});

% remove loops
%may1loops0 = RSKremoveloops(may1down, 'threshold', 0.25, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
%may1loops1 = RSKremoveloops(may1down, 'threshold', 0.2, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
%may1loops2 = RSKremoveloops(may1down, 'threshold', 0.15, 'visualize', [10, 14, 26, 71, 78, 80, 84]);

may1down = RSKremoveloops(may1down, 'threshold', 0.2, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

% derive salinity
may1down = RSKderivesalinity(may1down);
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity', 'salinity'});

% bin average by sea pressure
may1binned = RSKbinaverage(may1down, 'binBy', 'Depth', 'binSize', 1, 'boundary', 0.5, 'visualize', [10, 14, 26, 71, 78, 80, 84]);
h = findobj(gcf, 'type', 'line');
set(h(1:2:end), 'marker', 'o', 'markerfacecolor', 'c')

% compare raw & processed data
may1 = RSKreadprofiles(may1);

figure
channel = {'temperature', 'salinity', 'dissolved O21'};
profile  = [1, 10, 15, 26, 47, 66, 71];
[h1, ax] = RSKplotprofiles(may1, 'profile', profile, 'channel', channel, 'direction', 'up');
h2 = RSKplotprofiles(may1binned, 'profile', profile, 'channel', channel);
set(h2, 'linewidth', 3)

may2 = RSKreadprofiles(may2);






%% Find false downcasts in may1 file

% why does it let me go past 1:58 in RSKreadprofiles when there should be 58 profiles?
% bc it is including false "downcasts"
plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
plot(may1down.data(95).tstamp, may1down.data(95).values(:, 3))
hold off

% 20 peaks a/o profile 27
% 30 peaks a/o profile 44
% 50 peaks a/o profile 79

% false downcasts: 5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45,
% 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86,
% 89, 91, 93, 95

% true downcasts: 1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36,
% 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75,
% 77, 79, 81, 83, 85, 87:88, 90, 92, 94

% profile 14: might need to include? examine 13 & 14
% profile 84: might need to include? examine 83 & 84

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
a > b; %#ok<VUNUS> 
% all okay

% full list: 1:4, 6:7, 9:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44,
% 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77:81, 83:85,
% 87:88, 90, 92, 94


%% Find false downcasts in may2 file
plot(may2.data.tstamp, may2.data.values(:, 3))
hold on
plot(may2down.data(71).tstamp, may2down.data(71).values(:, 3))
hold off

% 8 peaks a/o profile 12
% 17 peaks a/o profile 22
% 30 peaks a/o profile 43

% false downcasts: 3, 5, 8, 10, 13, 24, 28, 30, 33, 38:39, 41:42, 45, 47,
% 49:50, 52, 54, 57, 59, 63, 71

% true downcasts: 1:2, 4, 6:7, 9, 11:12, 14:23, 25:27, 29, 31:32, 34:37,
% 40, 43:44, 46, 48, 51, 53, 55:56, 58, 60:62, 64:70

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
a > b %#ok<NOPTS> 
% all okay

% full list: 1:2, 4, 6:7, 9, 11:12, 14:27, 29, 31:32, 34:37, 40, 43:44,
% 46, 48, 51, 53:56, 58, 60:62, 64:70






%% [Not using] Load csv files

% may1 = readmatrix('./data/CTD_raw/RSA_20210504_060.csv');
% may2 = readmatrix('./data/CTD_raw/RSA_20210506_113.csv');
% allMay = [may1; may2];

% oct1_nope = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess