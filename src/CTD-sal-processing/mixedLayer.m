%cd Repos/ScallopRSA2021

%% Calculate Oct mixed-layer depths

% run CTDprocess_Oct.m through line 155; remove loops causes issues

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

% calculate potential density
oct1down = RSKderivesalinity(oct1down);
oct1down = RSKderivesigma(oct1down);
oct2down = RSKderivesalinity(oct2down);
oct2down = RSKderivesigma(oct2down);
oct2up = RSKderivesalinity(oct2up);
oct2up = RSKderivesigma(oct2up);
oct3down = RSKderivesalinity(oct3down);
oct3down = RSKderivesigma(oct3down);

RSKprintchannels(oct1down);

% trim surface 2m
%oct1down = RSKtrim(oct1down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
%oct2down = RSKtrim(oct2down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
%oct2up = RSKtrim(oct2up, 'reference', 'depth', 'range', [0 2], 'action', 'remove');
%oct3down = RSKtrim(oct3down, 'reference', 'depth', 'range', [0 2], 'action', 'remove');

stations = cell(111, 1);
MLtemp = NaN(111, 1);
MLsigma = NaN(111, 1);
surfaceCond = NaN(111, 1);
MLD = NaN(111, 1);

%RSKplotprofiles(oct1down, 'profile', 1:5, 'channel', 'temperature');

% oct1 file
for i = 1:21
    p = profiles1(i);
    stations(i) = oct1down.data(p).station;
    index = find(oct1down.data(p).values(:, 1) > 38, 1);
    % where conductivity > 38
    cond = oct1down.data(p).values(index, 1);
    depth = oct1down.data(p).values(index, 7);
    temp = oct1down.data(p).values(index, 2);
    sigma = oct1down.data(p).values(index, 10);
    surfSigma = sigma;
    while abs(surfSigma - sigma) < 0.125
        index = index + 1;
        if index > length(oct1down.data(p).values)
            break
        end
        if isnan(oct1down.data(p).values(index, 10)) || isnan(oct1down.data(p).values(index, 7))
            continue
        end
        temp = oct1down.data(p).values(index, 2);
        sigma = oct1down.data(p).values(index, 10);
        depth = oct1down.data(p).values(index, 7);
    end
    surfaceCond(i) = cond;
    MLtemp(i) = temp;
    MLsigma(i) = sigma;
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
    sigma = oct2down.data(p).values(index, 10);
    surfSigma = sigma;
    while abs(surfSigma - sigma) < 0.125
        index = index + 1;
        if index > length(oct2down.data(p).values)
            break
        end
        if isnan(oct2down.data(p).values(index, 10)) || isnan(oct2down.data(p).values(index, 7))
            continue
        end
        temp = oct2down.data(p).values(index, 2);
        sigma = oct2down.data(p).values(index, 10);
        depth = oct2down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLsigma(k) = sigma;
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
sigma = oct2up.data(p).values(index, 10);
surfSigma = sigma;
while abs(surfSigma - sigma) < 0.125
    index = index + 1;
    if index > length(oct2up.data(p).values)
        break
    end
    if isnan(oct2up.data(p).values(index, 10)) || isnan(oct2up.data(p).values(index, 7))
        continue
    end
    temp = oct2up.data(p).values(index, 2);
    sigma = oct2up.data(p).values(index, 10);
    depth = oct2up.data(p).values(index, 7);
end
surfaceCond(k) = cond;
MLtemp(k) = temp;
MLsigma(k) = sigma;
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
    sigma = oct3down.data(p).values(index, 10);
    surfSigma = sigma;
    while abs(surfSigma - sigma) < 0.125
        index = index + 1;
        if index > length(oct3down.data(p).values)
            break
        end
        if isnan(oct3down.data(p).values(index, 10)) || isnan(oct3down.data(p).values(index, 7))
            continue
        end
        temp = oct3down.data(p).values(index, 2);
        sigma = oct3down.data(p).values(index, 10);
        depth = oct3down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLsigma(k) = sigma;
    MLD(k) = depth;
end

% check MLDs for: 56, 55, 64

%RSKplotprofiles(oct2down, 'profile', profiles2([28:29, 45]), 'channel', {'temperature', 'conductivity'});

stations = str2double(stations);

oct_MLD = [stations MLD MLtemp MLsigma];
oct_MLD = array2table(oct_MLD);
oct_MLD.Properties.VariableNames = {'Station', 'MLD', 'MLtemp', 'MLsigma'};

writetable(oct_MLD, "data/CTD/oct_MLD.csv");

%% Calculate May MLDs

% run CTDprocess_May.m through line 122; then derive sigmas; then bin-average

% Hofmann 2008:
% depth at which temp change from surface is 0.5°C

profiles1 = [1:4, 6:7, 9:13, 15:16, 20:22, 24:27, 30, 32:33, 35:36, 38:39, 42:44, 46:47, 50, 52, 54:57, 60, 62, 64, 66, 68, 70:71, 73:75, 77, 79, 81, 83, 85, 87:88, 90, 92, 94];
profiles2 = [1:2, 4, 6:7, 9, 11:12, 14:23, 25:27, 29, 31:32, 34:37, 40, 43:44, 46, 48, 51, 53, 55:56, 58, 60:62, 64:70];

stations1 = {'1', '2', '3', '5', '4', '7', '8', '9', '10', '11', '13', '14', '15', '17', '18', '19', '20', '21', '23', '24', '25', '26', '27', '28', '29', '31', '32', '35', '34', '33', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '50', '51', '56', '55', '52', '49', '53', '54', '57', '61', '67', '68', '66', '62', '60'};
stations2 = {'65', '63', '58', '59', '64', '69', '70', '71', '72', '76', '77', '78', '73', '74', '79', '75', '80', '82', '83', '84', '86', '87', '93', '88', '85', '89', '90', '91', '97', '96', '92', '95', '94', '104', '103', '102', '98', '100', '99', '101', '105', '106', '109', '110', '108', '107', '112', '113'};

may1down = RSKaddstationdata(may1down, 'profile', profiles1, 'station', stations1);
may2down = RSKaddstationdata(may2down, 'profile', profiles2, 'station', stations2);

% calculate potential density
may1down = RSKderivesalinity(may1down);
may1down = RSKderivesigma(may1down);
may2down = RSKderivesalinity(may2down);
may2down = RSKderivesigma(may2down);

RSKprintchannels(may1down);

%may1down = RSKtrim(may1down, 'reference', 'depth', 'range', [-1 2], 'action', 'remove');
% remove an extra meter from this one; ~2.5m conductivity spike
%may1down = RSKtrim(may1down, 'reference', 'depth', 'profile', profiles1(35), 'range', [2 3], 'action', 'remove');

%RSKplotprofiles(may1down, 'profile', profiles1(35), 'channel', {'temperature', 'conductivity'});
%RSKplotprofiles(may1down, 'profile', profiles1([52, 56:58]), 'channel', {'temperature', 'conductivity'});

%may2down = RSKtrim(may2down, 'reference', 'depth', 'range', [-1 2], 'action', 'remove');

%RSKplotprofiles(may1down, 'profile', profiles1, 'channel', {'temperature', 'conductivity'});

stations = cell(106, 1);
MLtemp = NaN(106, 1);
MLsigma = NaN(106, 1);
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
    sigma = may1down.data(p).values(index, 13);
    surfSigma = sigma;
    %surfTemp = temp;
    %while abs(surfSigma - sigma) < 0.03
    while abs(surfSigma - sigma) < 0.125
    %while abs(surfTemp - temp) < 0.5
        index = index + 1;
        if index > length(may1down.data(p).values)
            break
        end
        if isnan(may1down.data(p).values(index, 13)) || isnan(may1down.data(p).values(index, 7))
        %if isnan(may1down.data(p).values(index, 2)) || isnan(may1down.data(p).values(index, 7))
            continue
        end
        temp = may1down.data(p).values(index, 2);
        sigma = may1down.data(p).values(index, 13);
        depth = may1down.data(p).values(index, 7);
    end
    surfaceCond(i) = cond;
    MLtemp(i) = temp;
    MLsigma(i) = sigma;
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
    sigma = may2down.data(p).values(index, 13);
    surfSigma = sigma;
    %surfTemp = temp;
    %while abs(surfSigma - sigma) < 0.03
    while abs(surfSigma - sigma) < 0.125
    %while abs(surfTemp - temp) < 0.5
        index = index + 1;
        if index > length(may2down.data(p).values)
            break
        end
        if isnan(may2down.data(p).values(index, 13)) || isnan(may2down.data(p).values(index, 7))
        %if isnan(may2down.data(p).values(index, 2)) || isnan(may2down.data(p).values(index, 7))
            continue
        end
        temp = may2down.data(p).values(index, 2);
        sigma = may2down.data(p).values(index, 13);
        depth = may2down.data(p).values(index, 7);
    end
    surfaceCond(k) = cond;
    MLtemp(k) = temp;
    MLsigma(k) = sigma;
    MLD(k) = depth;
end

stations = str2double(stations);

may_MLD = [stations MLD MLtemp MLsigma];
may_MLD = array2table(may_MLD);
may_MLD.Properties.VariableNames = {'Station', 'MLD', 'MLtemp', 'MLsigma'};

writetable(may_MLD, "data/CTD/may_MLD.csv");




% Jennie's code

% Define MLD as the depth where the difference between interpolated potential density referenced to the surface glorys layer (~0.5m) is > 0.03 kg/m3:

rho_0(z)-rho_0(1) > 0.03 %(Jones et al. 2014, Gill 1982, de Boyer Montegut et al. 2004)

%read in the 3D data

thetao = oct1down.data(i).values(:, 9) + 1000; %potential temperature (degC)
lat = ncread('GLORYS12V1_NW_Atlantic_2018_daily.nc','latitude'); %lat
lon = ncread('GLORYS12V1_NW_Atlantic_2018_daily.nc','longitude'); %lon
so = ncread('GLORYS12V1_NW_Atlantic_2018_daily.nc','so'); %salinity (psu)
depth = ncread('GLORYS12V1_NW_Atlantic_2018_daily.nc','depth'); %depth (m)

%create a meshgrid
[g_lat, g_lon, g_depth] = meshgrid(lat,lon,depth);
 
%calculate sea pressure from depth, lat
g_press = gsw_p_from_z(-g_depth,g_lat);
[n,m,l] = size(g_press);
 
%preallocate MLD
mld = nan(n,m,365); %mld (m)
 
%parallel pool
parpool('local',8);
Starting parallel pool (parpool) using the 'local' profile ... Connected to the parallel pool (number of workers: 8).
tic

%loop through all the data to calculate MLD
parfor i = 1:365
%     if mod(i,50) == 0
%         disp(i);
%     end
sa = gsw_SA_from_SP(so(:,:,:,i),g_press,g_lon,g_lat); %calculate absolute salinity from practical salinity
ct = gsw_CT_from_pt(sa,thetao(:,:,:,i)); %calculate conservative temperature from potential temperature and absolute salinity
rho = gsw_rho(sa,ct,repmat(g_press(:,:,1),1,1,50)); %calculate potential density referenced to the surface glorys layer

for j = 1:n
    for k = 1:m
        if sum(isnan(squeeze(rho(j,k,:)))) == 50 % if there's no data, move on
        else
            Ifind = find(squeeze(rho(j,k,:)-rho(j,k,1)) > 0.03,1,'first'); % find the first depth where > 0.03
            if isempty(Ifind) % if this is never true, MLD is the full water column depth
                mld(j,k,i) = depth(find(~isnan(squeeze(rho(j,k,:)-rho(j,k,1))) == 1,1,'last'));
            else
                I = 1:find(squeeze(-rho(j,k,1)+rho(j,k,:)) > 0.03,1,'first'); %find all the depths that are in the mixed layer
                x = depth(I); %get x data to interpolate
                y = squeeze(rho(j,k,I)); %get y data to interpolate
                x_i = x(1):0.1:(x(end)+1); %use interpolation scale of 0.1 m
                y_i = interp1(x,y,x_i); %1D interpolation
                d = y_i-y_i(1); %calculate density difference
                mld(j,k,i) = x_i(find(d <= 0.03,1,'last')); %the last value where diff < 0.03 is the MLD
            end
        end
    end
end

end

toc

