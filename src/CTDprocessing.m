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

% print list of all channels
RSKprintchannels(may1)

% read downcasts from all profiles
may1down = RSKreadprofiles(may1, 'profile', 1:95, 'direction', 'down');

%% process data

% correct for analog-to-digital zero-order hold
may1down.channels(12:13) = [];
may1down = RSKcorrecthold(may1down, 'action', 'interp', 'visualize', 15);

% low-pass filter
may1down = RSKsmooth(may1down, 'channel', {'temperature','conductivity'}, 'windowLength', 5, 'visualize', 15);

% align conductivity & temp
lag = RSKcalculateCTlag(may1down);
lag = -lag; % to advance temperature
lag = median(lag); % select best lag for consistency among profiles
may1down = RSKalignchannel(may1down, 'channel', 'temperature', 'lag', lag, 'visualize', 15);

% derive depth & velocity
may1down = RSKderivedepth(may1down);
may1down = RSKderivevelocity(may1down);

% remove loops
    % may1loops0 = RSKremoveloops(may1down, 'threshold', 0.3, 'visualize', 52);
    % doesn't trim all horizontal bars
    % may1loops1 = RSKremoveloops(may1down, 'threshold', 0.4, 'visualize', [1:4, 6:7, 9:14, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83:85, 87:88, 90, 92, 94]);
    % trims more horizontal bars but not 1, ~3?, ~30, ~42, 47, 62, 68, 77, 85, 88
    % ***check 35***
    % may1loops2 = RSKremoveloops(may1down, 'threshold', 0.45, 'visualize', [1:4, 6:7, 9:14, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83:85, 87:88, 90, 92, 94]);
    % trims more horizontal bars but not 1, ~42, 47, 77, 85, 88
    % may1loops3 = RSKremoveloops(may1down, 'threshold', 0.5);

    % RSKplotprofiles(may1loops2, 'profile', [1:95], 'channel', {'temperature', 'salinity'});
    % RSKplotprofiles(may1loops3, 'profile', [1:95], 'channel', {'temperature', 'salinity'});

may1down = RSKremoveloops(may1down, 'threshold', 0.5, 'visualize', [15, 47]);

RSKplotprofiles(may1loops, 'profile', [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94], 'channel', {'temperature', 'salinity'});

% derive salinity
may1down = RSKderivesalinity(may1down);
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:14, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83:85, 87:88, 90, 92, 94], 'channel', {'temperature', 'salinity'});

##### pick up here #####
##### after binning, check whether loop velocity threshold can be lowered #####

% bin average by sea pressure
may1bin1 = RSKbinaverage(may1down, 'binBy', 'Sea Pressure', 'binSize', 1, 'visualize', [15, 47]);
h = findobj(gcf,'type','line');
set(h(1:2:end),'marker','o','markerfacecolor','c')

% compare raw & processed data
figure
channel = {'temperature','salinity','density anomaly','chlorophyll'};
profile  = [3 10 20];
[h1,ax] = RSKplotprofiles(raw,'profile',profile,'channel',channel);
h2 = RSKplotprofiles(rsk,'profile',profile,'channel',channel);
set(h2,'linewidth',3,'marker','o','markerfacecolor','w')
set(ax(1),'xlim',[7 15])
set(ax(2),'xlim',[30 34])
set(ax(3),'xlim',[22 26])
set(ax(4),'xlim',[-2 80])
set(ax,'ylim',[0 6.5])

%% (Run previously) Test plotting things
% plot a few profiles of temp, conductivity, & dissolved O2
RSKplotprofiles(may1down, 'profile', [1 10 20], 'channel', {'temperature', 'conductivity', 'dissolved O21'});
    % downcasts were read!

% why does it let me go past 1:58 in RSKreadprofiles when there should be 58 profiles?
% bc it is including false "downcasts"
plot(may1.data.tstamp, may1.data.values(:, 3))
hold on
for i=[5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95]
    plot(may1down.data(i).tstamp, may1down.data(i).values(:, 3))
end
hold off

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

% profile 14: might need to include? examine 13 & 14
% profile 84: might need to include? examine 83 & 84

% plot false downcasts
RSKplotprofiles(may1down, 'profile', [5, 8, 14, 17:19, 23, 28:29, 31, 34, 37, 40:41, 45, 48:49, 51, 53, 58:59, 61, 63, 65, 67, 69, 72, 76, 78, 80, 82, 84, 86, 89, 91, 93, 95], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot 13 & 14
RSKplotprofiles(may1down, 'profile', [13:14], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot 83 & 84
RSKplotprofiles(may1down, 'profile', [83:84], 'channel', {'temperature', 'conductivity', 'dissolved O21'});

% plot "true" downcasts
RSKplotprofiles(may1down, 'profile', [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94], 'channel', {'temperature', 'conductivity'});

%% [Not using] Load csv files

% may1 = readmatrix('./data/CTD_raw/RSA_20210504_060.csv');
% may2 = readmatrix('./data/CTD_raw/RSA_20210506_113.csv');
% allMay = [may1; may2];

% oct1_nope = readmatrix('./data/CTD_raw/RSA_20211006_021.csv', 'NumHeaderLines', 2);   % date is a mess