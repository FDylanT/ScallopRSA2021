%% Load csv files

% may1 = readmatrix('./data/CTD_raw/RSA_20210504_060.csv');
% may2 = readmatrix('./data/CTD_raw/RSA_20210506_113.csv');
% allMay = [may1; may2];

% oct1_nope = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess

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
RSKprintchannels(oct1)

% read upcast & downcast from profiles 1-22 (all?)
oct1both = RSKreadprofiles(oct1, 'profile', 1:22, 'direction', 'both');

% read downcast from profiles 1-22
oct1pro = RSKreadprofiles(oct1, 'profile', 1:22, 'direction', 'down');

% plot all profiles of temp, conductivity, & dissolved O2
RSKplotprofiles(oct1pro, 'channel', {'temperature', 'conductivity', 'dissolved O2'}, 'direction', 'down');

% plot a few profiles of temp, conductivity, and dissolved O2
RSKplotprofiles(oct1pro, 'profile', [1 10 20], 'channel', {'temperature','conductivity','dissolved O2'});
RSKplotprofiles(oct1pro, 'profile', [1 10 20], 'channel', {'temperature','conductivity','dissolved O2'}, 'direction', 'down');

disp(oct1pro.data(2))