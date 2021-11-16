%% Load rsk files

% cd Repos/ScallopRSA2021

may1 = RSKopen('data/CTD_raw/RSA_20210504_060.rsk');
may1 = RSKreaddata(may1, 't1', datenum(2021, 05, 01), 't2', datenum(2021, 05, 06));
may2 = RSKopen('data/CTD_raw/RSA_20210506_113.rsk');
may2 = RSKreaddata(may2, 't1', datenum(2021, 05, 01), 't2', datenum(2021, 05, 06));

oct1 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
oct1 = RSKreaddata(oct1, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));
oct2 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
oct2 = RSKreaddata(oct2, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));
oct3 = RSKopen('data/CTD_raw/RSA_20211006_021.rsk');
oct3 = RSKreaddata(oct3, 't1', datenum(2021, 10, 05), 't2', datenum(2021, 10, 10));

%% Work with data

% print list of all channels
RSKprintchannels(may1)

% read downcasts from profiles 1-22 (all?)
may1down = RSKreadprofiles(may1, 'profile', 1:95, 'direction', 'down');

% plot a few profiles of temp, conductivity, & dissolved O2
RSKplotprofiles(may1down, 'profile', [1 10 20], 'channel', {'temperature', 'conductivity', 'dissolved O21'});
    % downcasts were read!

% why does it let me go past 1:58 in RSKreadprofiles when there should be 58 profiles?
% bc it is including some non-downcasts
plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
plot(may1down.data(95).tstamp, may1down.data(95).values(:, 3))
hold off

% 20 peaks a/o profile 27
% 30 peaks a/o profile 44
% 50 peaks a/o profile 79

% false downcasts: 5, 8, 14?, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45,
% 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84?, 86,
% 89, 91, 93, 95

% profile 14: might need to include? examine 13 & 14
% profile 84: might need to include? examine 83 & 84

plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
for i=[5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95]
    plot(may1down.data(i).tstamp, may1down.data(i).values(:, 3))
end
hold off

% plot false downcasts
RSKplotprofiles(may1down, 'profile', [5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot 13 & 14
RSKplotprofiles(may1down, 'profile', [13:14], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot 83 & 84
RSKplotprofiles(may1down, 'profile', [83:84], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot true downcasts
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

% derive salinity
may1down = RSKderivesalinity(may1down);
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94], 'channel', {'temperature', 'salinity'});

%%%% Pick up at bin averaging

%% [Not using] Load csv files

% may1 = readmatrix('./data/CTD_raw/RSA_20210504_060.csv');
% may2 = readmatrix('./data/CTD_raw/RSA_20210506_113.csv');
% allMay = [may1; may2];

% oct1_nope = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess