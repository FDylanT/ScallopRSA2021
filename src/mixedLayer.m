cd Repos/ScallopRSA2021

%% Calculate Oct mixed-layer depths

% run CTDprocess_Oct.m through line 205 % line 155 at the moment; remove loops causes issues

RSKprintchannels(oct1down);

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

oct1down = RSKtrim(oct1down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
oct2down = RSKtrim(oct2down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
oct2up = RSKtrim(oct2up, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
oct3down = RSKtrim(oct3down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');

stations = cell(111, 1);
MLtemp = NaN(111, 1);
surfaceCond = NaN(111, 1);
MLD = NaN(111, 1);

%RSKplotprofiles(oct1down, 'profile', 1:5, 'channel', 'temperature');

% oct1 file
for i = 1:21
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    index = find(oct1down.data(p).values(:, 1) > 38, 1);
    % where temp is not NaN & conductivity is > 38
    cond = oct1down.data(p).values(index, 1);
    depth = oct1down.data(p).values(index, 7);
    temp = oct1down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(oct1down.data(p).values)
            break
        end
        if isnan(oct1down.data(p).values(index, 2)) || isnan(oct1down.data(p).values(index, 7))
            continue
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
        if isnan(oct2down.data(p).values(index, 2)) || isnan(oct2down.data(p).values(index, 7))
            continue
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
    if isnan(oct2up.data(p).values(index, 2)) || isnan(oct2up.data(p).values(index, 7))
        continue
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
        if isnan(oct3down.data(p).values(index, 2)) || isnan(oct3down.data(p).values(index, 7))
            continue
        end
        temp = oct3down.data(p).values(index, 2);
        depth = oct3down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLD(k) = depth;
end

% check MLDs for: 56, 55, 64

%RSKplotprofiles(oct2down, 'profile', profiles2([28:29, 45]), 'channel', {'temperature', 'conductivity'});

stations = str2double(stations);

oct_MLD = [stations MLD MLtemp];
oct_MLD = array2table(oct_MLD);
oct_MLD.Properties.VariableNames = {'Station', 'MLD', 'MLtemp'};

writetable(oct_MLD, "data/CTD/oct_MLD.csv");

%% Calculate May MLDs

% run CTDprocess_May.m through line 205 % line 148 at the moment; remove loops causes issues

RSKprintchannels(may1down);

% Hofmann 2008:
% depth at which temp change from surface is 0.5°C

profiles1 = [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94];
profiles2 = [1:2, 4, 6:7, 9, 11:12, 14:23, 25:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53, 55:56, 58, 60:62, 64:70];

stations1 = {'1', '2', '3', '5', '4', '7', '8', '9', '10', '11', '13', '14', '15', '17', '18', '19', '20', '21', '23', '24', '25', '26', '27', '28', '29', '31', '32', '35', '34', '33', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '50', '51', '56', '55', '52', '49', '53', '54', '57', '61', '67', '68', '66', '62', '60'};
stations2 = {'65', '63', '58', '59', '64', '69', '70', '71', '72', '76', '77', '78', '73', '74', '79', '75', '80', '82', '83', '84', '86', '87', '93', '88', '85', '89', '90', '91', '97', '96', '92', '95', '94', '104', '103', '102', '98', '100', '99', '101', '105', '106', '109', '110', '108', '107', '112', '113'};

may1down = RSKaddstationdata(may1down, 'profile', profiles1, 'station', stations1);
may2down = RSKaddstationdata(may2down, 'profile', profiles2, 'station', stations2);

may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [0, 2], 'action', 'remove');
% remove an extra meter from this one; 2m conductivity spike
may1down = RSKtrim(may1down, 'reference', 'depth', 'profile', profiles1(35), 'range', [2, 3], 'action', 'remove');

RSKplotprofiles(may1down, 'profile', profiles1(35), 'channel', {'temperature', 'conductivity'});
RSKplotprofiles(may1down, 'profile', profiles1([52, 56:58]), 'channel', {'temperature', 'conductivity'});

may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [0, 2], 'action', 'remove');

stations = cell(106, 1);
MLtemp = NaN(106, 1);
surfaceCond = NaN(106, 1);
MLD = NaN(106, 1);

% may1 file
for i = 1:58
    p = profiles1(i);
    stations(i) = may1down.data(p).station;
    index = find(~isnan(may1down.data(p).values(:, 2)) & may1down.data(p).values(:, 7) >= 0, 1);
        % ^where temp is not NaN & depth is not negative
    cond = may1down.data(p).values(index, 1);
    depth = may1down.data(p).values(index, 7);
    temp = may1down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(may1down.data(p).values)
            break
        end
        if isnan(may1down.data(p).values(index, 2)) || isnan(may1down.data(p).values(index, 7))
            continue
        end
        temp = may1down.data(p).values(index, 2);
        depth = may1down.data(p).values(index, 7);
    end
    surfaceCond(i) = cond;
    MLtemp(i) = temp;
    MLD(i) = depth;
end

% may2 downcast file
for i = 1:48
    p = profiles2(i);
    k = i + 58; % account for profiles in may1 file
    stations(k) = may2down.data(p).station;
    index = find(~isnan(may2down.data(p).values(:, 2)) & may2down.data(p).values(:, 7) >= 0, 1);
    cond = may2down.data(p).values(index, 1);
    depth = may2down.data(p).values(index, 7);
    temp = may2down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(may2down.data(p).values)
            break
        end
        if isnan(may2down.data(p).values(index, 2)) || isnan(may2down.data(p).values(index, 7))
            continue
        end
        temp = may2down.data(p).values(index, 2);
        depth = may2down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLD(k) = depth;
end

stations = str2double(stations);

may_MLD = [stations MLD MLtemp];
may_MLD = array2table(may_MLD);
may_MLD.Properties.VariableNames = {'Station', 'MLD', 'MLtemp'};

writetable(may_MLD, "data/CTD/may_MLD.csv");
