%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%    TA DATA Processor 15     %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%   written by DJM 9/6/2014   %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%   Dmartynowych@gmail.com    %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% global variables
volume=18;
volumeSample=250;
comma= ',';
doublecomma=',,';
space=' ';
skip='   ,';
skipLine={skip,skip,skip,skip,skip,skip,skip,skip,skip,skip,skip,skip,skip,skip};
%asks user for file to process
prompt = 'What is the file to be processed? ';
result = input(prompt, 's');
%checks for and, if needed, creates processed folder 
if ~exist('processed_data','dir')
mkdir('processed_data');
end

%opens file to be processed, and creates processed file
fileName = strcat(result, '.txt');
processedFile = strcat(result,'_processed_TA','.txt');
logFile = strcat('TA_log.txt');
ancfile = strcat(result,'_ancillary.csv');


fileID = fopen(processedFile,'w');


%get header constants from ancillary file

ancillary = fopen(ancfile);
i=-2;
while 1
    i=i+1;
    tline = fgetl(ancillary);
    if i==1
        z=strfind(tline,',');
        [m,n] = size(tline);
        operator = tline(z(1)+1:n-2);
    end
    
    if i==2
        z=strfind(tline,',');
        [m,n] = size(tline);
        acidBatch = tline(z(1)+1:n-2);
    end
    
    
    if i==3
        z=strfind(tline,',');
        [m,n] = size(tline);
        certCRMTAumolkg = tline(z(1)+1:n-2);
        calTemp = tline(z(2)+1:n);
    end
    
    if i==4
        z=strfind(tline,',');
        [m,n] = size(tline);
        certCRMSalinity = tline(z(1)+1:n-2);
    end
    
    if i==5
        z=strfind(tline,',');
        [m,n] = size(tline);
        calTemp = tline(z(1)+1:n-2);
    end
    
    
    if ~ischar(tline), break, end    
end    
fclose(ancillary);

%calulate CRMdensity
S=str2double(certCRMSalinity);
T=str2double(calTemp);

A = 0.824493-0.0040899*T+0.000076438*T^2-0.00000082467*T^3+0.0000000053875*T^4;
B = -0.00572466 + 0.00010227*T - 0.0000016546*T^2;
C = 0.00048314;
p=999.842594+0.06793952*T-0.00909529*T^2+0.0001001685*T^3-0.000001120083*T^4+0.000000006536332*T^5;
  
CRMdensity = (p+A*S+B*S^1.5+C*S^2)/1000;


%get endOfCal, Slope, and concHCl
flag=0;
j=0;
i=0;
fid=fopen(fileName);
while 1
    i=i+1;
    tline=fgetl(fid);
    z=strfind(tline,'Calibration Date & Time');
    TF = isempty(z);
    if TF==0 && flag==1
        j=i;
    end    
    if TF==1
       flag=1;
    end    
    if ~ischar(tline), break, end 
end
fclose(fid);



%get values for and generate header in processed file
fprintf(fileID,'%12s\n','TOTAL ALKALINITY');
fid=fopen(fileName);
crmcheck=0;
i=0;
while 1
    i=i+1;   
    tline = fgetl(fid);
    z=strfind(tline, 'BATCH');
    if i==1
    rundate=strcat(tline(1:11),',');    
    fprintf(fileID,'%10s',strcat('Run Date:,',rundate,skip));
    end
    
    TF=isempty(z);
    if TF==0
    if crmcheck==0;
    crmcheck=1;
    crmbatch=strcat(tline(1:8),',');
    fprintf(fileID,'%10s',strcat('CRM Batch:,',crmbatch,skip));
    fprintf(fileID,'%10s','CRM Density:,');
    fprintf(fileID,'%6.4f',CRMdensity);
    fprintf(fileID,'%1s',',');
    fprintf(fileID,'%5s',skip);
    end
    end
    if i==j-10
        endOfCal=tline(7:14);
        fprintf(fileID,'%8s\n',strcat('End of Cal:,',endOfCal));
    end
    if i==j+6
        slope =tline(16:29);
    end
    
    if i==j+7
         h = strfind(tline,'C(HCl)(mM)');
         [m,n] = size(tline);
        concHCl=tline(h+10:n);
    end    
    
    h = strfind(tline,'Alk(Std,mM)=');
    g = strfind(tline,'V(end,ml) =');
    if i==j-2
        CRMTAinput = tline(h+12:g-1);
    end
    
    if ~ischar(tline), break, end
end
fclose(fid);

%generates block of text with cal info
fid=fopen(fileName);
i=0;
calLine1={};
calLine2={};
calLine3={};
calLine4={};
calLine5={};
calLine6={};
calLine7={};
calLine8={};

while 1
    i=i+1;   
    tline = fgetl(fid);
    if i==j
        calLine1{1,1}=tline;
    end  
    if i==j+1
        calLine2{1,1}=tline;
    end
    if i==j+2
        calLine3{1,1}=tline;
    end
    if i==j+3
        calLine4{1,1}=tline;
    end
    if i==j+4
        calLine5{1,1}=tline;
    end
    if i==j+5
        calLine6{1,1}=tline;
    end
    if i==j+6
        calLine7{1,1}=tline;
    end
    if i==j+7
        calLine8{1,1}=tline;
    end
    
    if ~ischar(tline), break, end
end
fclose(fid);

%prints 2nd row of header
fprintf(fileID,'%5s',strcat('Operator:,',operator,comma,skip));
fprintf(fileID,'%10s',strcat('CRM TA:,',certCRMTAumolkg,comma,skip));
certCRMTAumolkg=str2double(certCRMTAumolkg);
CRMTAmmolL=(certCRMTAumolkg*CRMdensity)/1000.00;
fprintf(fileID,'%8s','CRM TA:,');
fprintf(fileID,'%7.6f',CRMTAmmolL);
fprintf(fileID,'%1s', comma,skip);
fprintf(fileID,'%12s\n',strcat('Slope:,',slope));

%print 3rd row of header
fprintf(fileID,'%10s',strcat('Acid Batch:,',acidBatch,comma,skip));
fprintf(fileID,'%7s',strcat('CRM Salinity:,',certCRMSalinity,comma,skip));
CRMTAinput = strtrim(CRMTAinput);
fprintf(fileID,'%8s',strcat('Input TA:,',CRMTAinput,comma,skip));
concHCl=strtrim(concHCl);
fprintf(fileID,'%10s\n',strcat('[HCl](mM):,',concHCl));

%print 4th row of header
fprintf(fileID,'%7s','Volume:,');
fprintf(fileID,'%2d',volume);
fprintf(fileID,'%1s', comma,skip);
fprintf(fileID,'%10s\n',strcat('CRM Temp:,',calTemp));
fprintf(fileID,'%1s\n',space);
fprintf(fileID,'%1s\n',space);
fprintf(fileID,'%1s\n',space);

%print column headers
fprintf(fileID,'%8s',strcat( 'SampleID',comma));
fprintf(fileID,'%4s',strcat( 'Time',comma));
fprintf(fileID,'%6s',strcat( 'TA(mM)',comma));
fprintf(fileID,'%6s',strcat( 'Init. pH',comma));
fprintf(fileID,'%6s',strcat( 'TA(uM)',comma));
fprintf(fileID,'%16s',strcat( 'TA(uM) Corrected',comma));
fprintf(fileID,'%8s',strcat( 'Salinity',comma));
fprintf(fileID,'%11s',strcat( 'Temperature',comma));
fprintf(fileID,'%8s',strcat( 'Density',comma));
fprintf(fileID,'%11s',strcat( 'TA(umolkg-1)',comma));
fprintf(fileID,'%15s',strcat( 'Volume HgCl2(uL)',comma));
fprintf(fileID,'%17s',strcat( 'Volume Sample(mL)',comma));
fprintf(fileID,'%8s',strcat( 'HgCl2 CF',comma));
fprintf(fileID,'%11s',strcat( 'TA(umolkg-1)',comma));
fprintf(fileID,'%6s',strcat( 'TA_avg (umolkg-1)',comma));
fprintf(fileID,'%6s\n',strcat( 'TA_std (umolkg-1)',comma));




%loop for reading rows from raw file, broken when line returns ~char
meta1={};
metaData={};
TF=1;
i=0;
flag2=0;
complete=0;

 fid=fopen(fileName);

 while 1
     
     %increments row counter
     i=i+1;
     %reads first line from raw file test
     tline = fgetl(fid);
     done=0;
     k= strfind(tline, 'Sample#:');
     l= strfind(tline, '0');
     f= strfind(tline, 'TA(mM)');
     g= strfind(tline, 'Count');
     [m,n]=size(tline);
     
     %if statement to avoid intial junksw
     d=strfind(tline,'Calibration Date & Time');
     TF2=isempty(d);
     if TF2==0
         flag2=flag2+1;
     end
     if flag2>=2
         %finds sample name and writes to variable "a"
         if k==1
             a=tline(10:n);
             a=strtrim(a);
             j=i;
         end
         
         
         %finds start time and pH of analysis and writes to cellArray
         
         TF=isempty(l);
         if TF==0
             if i==j+3 && l(1,1)==2
                 meta1{1,1}=a;
                 lastSampleName = a;
                 b=tline(6:14);
                 b=strtrim(b);
                 meta1{1,2}=b;
                 c=tline(22:27);
                 c=strtrim(c);
                 d=strfind(c,'.');
                 IP=isempty(d);
                 if IP==0
                 meta1{1,4}=c;
                 else
                 meta1{1,4}='enter manually';    
                 end
             end
         end
         
         %finds TA and writes to cell Array
         TF=isempty(f);
         if TF==0
             x=tline(f+10:g-1);
             x=strtrim(x);
             y=str2double(x)*1000;
             meta1{1,3}=x;
             meta1{1,5}=y;
             lll = str2double(CRMTAinput);
             TAcorrected = (y)*(CRMTAmmolL/lll);
             meta1{1,6}=sprintf('%6.1f',TAcorrected);
             complete=1;
         end
         %finds pH and writes to cellArray
         
         
         if complete==1
             ancillary = fopen(ancfile);
             while 1
                 tline2 = fgetl(ancillary);
                 q=strfind(tline2,lastSampleName);
                 TF3=isempty(q);
                 if done==0
                     if TF3==0
                         commas=strfind(tline2,comma);
                         loc1=commas(1);
                         loc2=commas(2);
                         loc3=commas(3);
                         [m,n]=size(tline2);
                         sampleTemp=tline2(loc1+1:loc2-1);
                         sampleSalinity=tline2(loc2+1:loc3-1);
                         sampleHgCl2volume=tline2(loc3+1:n);
                         meta1{1,7}=sampleSalinity;
                         meta1{1,8}=sampleTemp;
                         %calulate sample density
                         S=str2double(sampleSalinity);
                         T=str2double(sampleTemp);
                         A = 0.824493-0.0040899*T+0.000076438*T^2-0.00000082467*T^3+0.0000000053875*T^4;
                         B = -0.00572466 + 0.00010227*T - 0.0000016546*T^2;
                         C = 0.00048314;
                         p=999.842594+0.06793952*T-0.00909529*T^2+0.0001001685*T^3-0.000001120083*T^4+0.000000006536332*T^5;
                         sampleDensity = (p+A*S+B*S^1.5+C*S^2)/1000;
                         
                         meta1{1,9}=sampleDensity;
                         TA=TAcorrected/sampleDensity;
                         meta1{1,10}=TA;
                         meta1{1,11}=sampleHgCl2volume;
                         meta1{1,12}=volumeSample;
                         
                         
                         sampleHgCl2volume = str2double(sampleHgCl2volume);
                         hgcl2CF=1+((sampleHgCl2volume/1000)/volumeSample);
                         
                         meta1{1,13}=hgcl2CF;
                         TA=TA*hgcl2CF;
                         meta1{1,14}=TA;
                         metaData = vertcat(metaData,meta1);%#ok
                         done=1;
                     end
                 end
                 TF3=1;
                 if ~ischar(tline2), break, end
             end
             complete=0;
             fclose(ancillary);
             
         end
     end
     
     %breaks while loop when line returns no characters
     if ~ischar(tline), break, end
     
 end
 fclose(fid);

 %calulates TA average and standard deveation
 metaData = vertcat(metaData,skipLine);
 temp1={};
 temp2={};
 [d,n]=size(metaData);
 numberOfRuns = d;
 hh=1;
 ii=1;
 jj=0;
 while jj<numberOfRuns
     jj=jj+1;
     if jj==1 %first sample
         temp1{1,1}=metaData{1,1};
         temp1{1,4}=jj;
         hh=hh+1;
         temp2{1,1}=metaData{1,14};
         ii=ii+1;
     else %all other samples
         tempName=metaData{jj,1};
         bb=strfind(temp1{hh-1,1},tempName);
         bb=isempty(bb);
         if bb==0 %when names do match
             temp2{ii,1}=metaData{jj,14};%#ok
             ii=ii+1;
         elseif bb==1 %when names dont match
             ii=1;
             temp1{hh,1}=tempName;%#ok
             temp1{hh,4}=jj;%#ok
             hh=hh+1;
             %calulate TA avg here
             TA1=0;
             TA2=0;
             [rows,columns]=size(temp2);%#ok
             if rows==1
                 TAavg=sprintf('%0.1f',temp2{1,1});
                 TAstd='n/a';
             elseif rows==2
                 temp2=cell2mat(temp2);
                 TAavg=mean(temp2);
                 TAavg=sprintf('%0.1f',TAavg);
                 TAstd=sprintf('%6.4f',std(temp2));
             else
                 kk=0;
                 [mm,nn]=size(temp2);
                 while 1
                     kk=kk+1;
                     TA1=temp2{kk,1};
                     if kk==mm ,option=2; break, end
                     TA2=temp2{kk+1,1};
                     if abs(TA1-TA2)<=2,option=1; break, end
                 end
                 if option==1
                     temp2={};
                     temp2{1,1}=TA1;
                     temp2{2,1}=TA2;
                     temp2=cell2mat(temp2);
                     TAavg=mean(temp2);
                     TAavg=sprintf('%0.1f',TAavg);
                     TAstd=sprintf('%6.4f',std(temp2));
                 else
                     TAavg='flag';
                     TAstd='flag';
                 end
                 
             end
             temp1{hh-2,2}=TAavg;%#ok
             temp1{hh-2,3}=TAstd;%#ok
             %%%%
             temp2={};
             temp2{ii,1}=metaData{jj,14};%#ok
             ii=ii+1;
             
         end
     end
 end
%write TA avg and TA std into metaData
[rows,columns]=size(temp1);%#ok
t=0;
while t<=rows-1
    t=t+1;
    metaData{temp1{t,4},15}=temp1{t,2};
    metaData{temp1{t,4},16}=temp1{t,3};
end

%write metaData to processed file

[rows,columns]=size(metaData);%#ok
t=0;
while t<rows
        meta2={};%#ok
        t=t+1;
        meta2=metaData(t,1:16);
        dlmcell(processedFile,meta2,',','-a');
end    

%write data to log file
%%%%%%%%%%%%%%%%%%%%%%%%

 %loop to write sample names and date into logData
 [rows,columns]=size(temp1);
 logData={};
 t=0;
 while t<rows-1
        t=t+1;
        logData{t,1}=rundate;%#ok
        logData{t,3}=temp1{t,1};%#ok
 end
 %loop for finding and entering run time into logData
[rows,comlumns]=size(metaData);%#ok
t=0;
o=1;
while t<rows-1
       t=t+1;
       if t==temp1{o,4}
          logData{o,2}=metaData{t,2};%#ok
          o=o+1;
       end    
end
 

%loop for writing logData to log file
[rows,comlumns]=size(logData);
t=0;
while t<rows
        logMeta={};%#ok
        t=t+1;
        logMeta=logData(t,1:3);
        dlmcell(logFile,logMeta,',','-a');
end    

%prints cal data at bottom
dlmcell(processedFile,calLine1,'-a');
dlmcell(processedFile,calLine2,'-a');
dlmcell(processedFile,calLine3,'-a');
dlmcell(processedFile,calLine4,'-a');
dlmcell(processedFile,calLine5,'-a');
dlmcell(processedFile,calLine6,'-a');
dlmcell(processedFile,calLine7,'-a');
dlmcell(processedFile,calLine8,'-a');

%closes processed data files
fclose(fileID);