cd Repos/ScallopRSA2021

% run CTDprocess_Oct.m through line 205

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
MLD = NaN(111, 1);

% oct1 file
for i = 1:21
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    [depth, index] = min(abs(oct1down.data(p).values(:, 7)));
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
    MLtemp(i) = temp;
    MLD(i) = depth;
end

% oct2 file
for i = 1:45
    p = profiles2(i);
    k = i + 21; % account for profiles in oct1 file
    stations(k) = oct2down.data(p).station;
    [depth, index] = min(abs(oct2down.data(p).values(:, 7)));
    temp = oct2down.data(p).values(index, 2);
    surfTemp = temp;
    while surfTemp - temp < 0.5
        index = index + 1;
        if index > length(oct2down.data(p).values)
            break
        end
        if p == 12 % use upcast data
            temp = oct2up.data(p).values(index, 2);
            depth = oct2up.data(p).values(index, 7);
        else
            temp = oct2down.data(p).values(index, 2);
            depth = oct2down.data(p).values(index, 7);
        end
    end
    MLtemp(i) = temp;
    MLD(i) = depth;
end

% oct3 file
for i = 1:45
    p = profiles3(i);
    k = i + 66; % account for profiles in oct1 & oct2 files
    stations(k) = oct3down.data(p).station;
    [depth, index] = min(abs(oct3down.data(p).values(:, 7)));
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
    MLtemp(i) = temp;
    MLD(i) = depth;
end
