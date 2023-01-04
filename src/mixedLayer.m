cd Repos/ScallopRSA2021

% run CTDprocess_Oct.m through line 205 % line 155 at the moment; remove loops causes issues

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

profiles1 = [1:11, 13:22];
profiles2 = [1:24, 26:32, 34:47];
profiles3 = [1:15, 17:28, 30, 32:39, 41:42, 44:50];

stations1 = {'1', '2', '3', '5', '4', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21'};
stations2 = {'24', '25', '26', '27', '28', '29', '30', '31', '32', '35', '34', '33', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '50', '51', '56', '55', '52', '49', '53', '54', '57', '61', '67', '68', '66', '62', '60', '65', '63', '58', '59', '64'};
stations3 = {'69', '70', '71', '72', '76', '77', '78', '73', '74', '79', '75', '80', '81', '82', '83', '84', '86', '87', '93', '88', '85', '89', '90', '91', '97', '96', '92', '95', '94', '103', '102', '98', '100', '99', '101', '105', '106', '109', '110', '108', '107', '111', '112', '113', '114'};

oct1down = RSKaddstationdata(oct1down, 'profile', profiles1, 'station', stations1);
oct2down = RSKaddstationdata(oct2down, 'profile', profiles2, 'station', stations2);
oct2up = RSKaddstationdata(oct2up, 'profile', profiles2, 'station', stations2);
oct3down = RSKaddstationdata(oct3down, 'profile', profiles3, 'station', stations3);

stations = cell(111, 1);
MLtemp = NaN(111, 1);
surfaceCond = NaN(111, 1);
MLD = NaN(111, 1);

RSKplotprofiles(oct1down, 'profile', 1:5, 'channel', {'temperature', 'depth'});

% oct1 file
for i = 1:21
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    index = find(oct1down.data(p).values(:, 1) > 38, 1); % where conductivity is > 40
    cond = oct1down.data(p).values(index, 1);
    depth = oct1down.data(p).values(index, 7);
    temp = oct1down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(oct1down.data(p).values)
            break
        end
        temp = oct1down.data(p).values(index, 2);
        depth = oct1down.data(p).values(index, 7);
    end
    surfaceCond(i) = cond;
    MLtemp(i) = temp;
    MLD(i) = depth;
end

% oct2 downcast file
for i = [1:11, 13:45] % skip 12; no downcast surface data
    p = profiles2(i);
    k = i + 21; % account for profiles in oct1 file
    stations(k) = oct2down.data(p).station;
    index = find(oct2down.data(p).values(:, 1) > 38, 1);
    cond = oct2down.data(p).values(index, 1);
    depth = oct2down.data(p).values(index, 7);
    temp = oct2down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(oct2down.data(p).values)
            break
        end
        temp = oct2down.data(p).values(index, 2);
        depth = oct2down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLD(k) = depth;
end

% oct2 upcast file
i = 12;
p = profiles2(i);
k = i + 21; % account for profiles in oct1 file
stations(k) = oct2up.data(p).station;
index = find(oct2up.data(p).values(:, 1) > 38, 1, 'last');
cond = oct2up.data(p).values(index, 1);
depth = oct2up.data(p).values(index, 7);
temp = oct2up.data(p).values(index, 2);
surfTemp = temp;
while surfTemp - temp < 0.5
    index = index - 1;
    if index < 1
        break
    end
    temp = oct2up.data(p).values(index, 2);
    depth = oct2up.data(p).values(index, 7);
end
surfaceCond(k) = cond;
MLtemp(k) = temp;
MLD(k) = depth;

% oct3 file
for i = 1:45
    p = profiles3(i);
    k = i + 66; % account for profiles in oct1 & oct2 files
    stations(k) = oct3down.data(p).station;
    index = find(oct3down.data(p).values(:, 1) > 38, 1);
    cond = oct3down.data(p).values(index, 1);
    depth = oct3down.data(p).values(index, 7);
    temp = oct3down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(oct3down.data(p).values)
            break
        end
        temp = oct3down.data(p).values(index, 2);
        depth = oct3down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLD(k) = depth;
end

stations = str2double(stations);

oct_MLD = [stations MLD MLtemp];
oct_MLD = array2table(oct_MLD);
oct_MLD.Properties.VariableNames = {'Station', 'MLD', 'MLtemp'};

writetable(oct_MLD, "data/CTD/oct_MLD.csv");

%% Visualize EM profiles
% EMs: 5, 43, 7
%      33, 53, 9

% profiles:
% 5 = profiles1(4) = oct1down(4)
% 7 = profiles1(7) = oct1down(7)
% 43 = profiles2(20) = oct2down(20)
% 9 = profiles1(9) = oct1down(9)
% 33 = profiles2(12) = oct2down(12) & oct2up(12)
% 53 = profiles2(33) = oct2down(34)

oct1down = RSKremoveloops(oct1down, 'threshold', 0.2);
%RSKplotprofiles(oct1down, 'profile', 1:22, 'channel', {'temperature', 'conductivity'});

oct2down = RSKremoveloops(oct2down, 'threshold', 0.2);
%RSKplotprofiles(oct2down, 'profile', [1:24, 26:47], 'channel', {'temperature', 'conductivity'});

%no loops in profile 12 upcast

oct1down = RSKderivesalinity(oct1down);
oct2down = RSKderivesalinity(oct2down);
oct2up = RSKderivesalinity(oct2up);

figure
channel = {'temperature', 'salinity', 'dissolved O2'};
profile = [4 7];
h = RSKplotprofiles(oct1down, 'profile', profile, 'channel', channel);
profile = [20];
j = RSKplotprofiles(oct2down, 'profile', profile, 'channel', channel);
set(h, 'linewidth', 3)
set(j, 'linewidth', 3)

figure
channel = {'temperature', 'salinity', 'dissolved O2'};
profile = 9;
h = RSKplotprofiles(oct1down, 'profile', profile, 'channel', channel);
profile = [12 34];
j = RSKplotprofiles(oct2down, 'profile', profile, 'channel', channel);
profile = 12;
k = RSKplotprofiles(oct2up, 'profile', profile, 'channel', channel);
set(h, 'linewidth', 3, 'color', 'k')
set(j, 'linewidth', 3)
set(k, 'linewidth', 3)