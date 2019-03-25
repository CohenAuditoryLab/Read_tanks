function pre_process(sevpath,block,fdest)
clear all
fclose all
fs=24414.0625;
%Notch 60Hz IIR
bsFilti = designfilt('bandstopiir','FilterOrder',20, ...
         'HalfPowerFrequency1',50,'HalfPowerFrequency2',70, ...
         'SampleRate',fs);
%iir BP     
bpFilti = designfilt('bandpassiir','FilterOrder',20, ...
         'HalfPowerFrequency1',300,'HalfPowerFrequency2',5e3, ...
         'SampleRate',fs);
     
nChan = 96;%64 for Jan03_19 look at notes 96;
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180821\Block-2\';
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180821\Block-2\';
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180823\Block-3\';
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180823\Block-2\';
%sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190103\Block-3\';
sevpath=[sevpath '\Block-' num2str(block) '\'];
%load('SLY_short_master_list.mat');
s_bin=0.15;
%indexn=find(~isnan([raw{:,6}]'));
%for ff=1:length(indexn)
%dat = zeros(nChan,15467520,'single');
% %ML XPZ5 1-64 XPZ2 1-32
% %AL XPZ2 33-128
% session     =   raw{indexn(n),4};
% block       =   raw{indexn(n),6};
% task        =   raw{indexn(n),7};
% if strcmp(task(1),'S') && (length(task)>4) 
    
fns=dir([sevpath '*.sev']);
in_block=strfind(fns(1).name,'xpz');
%for XPZ2
%sevfilename=[fns(1).name(1:in_block+2) num2str(2) '_ch' num2str(i) '.sev'];
for i = 1:nChan
    sevfilename=[fns(1).name(1:in_block+2) num2str(2) '_ch' num2str(i+32) '.sev'];
    fprintf('Channel %02d/%02d: ',i,nChan);
    %fn = fullfile(fns(i).folder,fns(i).name);
    fn = fullfile(sevpath,sevfilename);
    tic
    fid = fopen(fn,'r');
    header = fread(fid,10,'*single');
    dat_temp = fread(fid,[1,inf],'*single');
    fclose(fid);
    dat(i,:) = dat_temp;
    dataBS=filtfilt(bsFilti,double(dat_temp));     
    dataIIR=filtfilt(bpFilti,dataBS);
    datf(i,:)=dataIIR;
    fprintf('%4.2f secs\n',toc);
end
dat = int16(dat.*1e6);
datf = int16(datf.*1e6);
tic;
folder_path=fdest;%'c:\work\SAM-190103\xpz2b3';
if ~exist(folder_path,'dir')
    mkdir(folder_path)
end
fnOut = fullfile(folder_path,'continous.dat');
fidOut = fopen(fnOut,'w');
fwrite(fidOut,dat(:),'*int16');
fclose(fidOut);
%filered
folder_path='c:\work\SAM-190103\xpz2b3f';
if ~exist(folder_path,'dir')
    mkdir(folder_path)
end
fnOut = fullfile(folder_path,'continous.dat');
fidOut = fopen(fnOut,'w');
fwrite(fidOut,datf(:),'*int16');
fclose(fidOut);
toc;

 %%
fclose all
clear all
fs=24414.0625;
%Notch 60Hz IIR
bsFilti = designfilt('bandstopiir','FilterOrder',20, ...
         'HalfPowerFrequency1',50,'HalfPowerFrequency2',70, ...
         'SampleRate',fs);
%iir BP     
bpFilti = designfilt('bandpassiir','FilterOrder',20, ...
         'HalfPowerFrequency1',300,'HalfPowerFrequency2',5e3, ...
         'SampleRate',fs);
fs = 24414;
nChan = 64;%changed to 64 for Jan01_19 96
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180821\Block-2\';
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180815\Block-2\';
%sevpath='D:\SpikeSortingPipeline\Tanks\Sly-180823\Block-3\';
sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190103\Block-3\';
%dat = zeros(nChan,15467520,'single');
%ML XPZ5 1-64 XPZ2 1-32
%AL XPZ2 33-128
fns=dir([sevpath '*.sev']);
in_block=strfind(fns(1).name,'xpz');
%for XPZ5
%sevfilename=[fns(1).name(1:in_block+2) num2str(2) '_ch' num2str(i) '.sev'];
for i = 1:nChan
    if i<=64
        sevfilename=[fns(1).name(1:in_block+2) num2str(5) '_ch' num2str(i) '.sev'];
    elseif i>64
        sevfilename=[fns(1).name(1:in_block+2) num2str(2) '_ch' num2str(i-64) '.sev'];
    end
    fprintf('Channel %02d/%02d: ',i,nChan);
    fn = fullfile(fns(i).folder,fns(i).name);
    tic
    fid = fopen(fn,'r');
    header = fread(fid,10,'*single');
     dat_temp = fread(fid,[1,inf],'*single');
    fclose(fid);
    dat(i,:) = dat_temp;
    dataBS=filtfilt(bsFilti,double(dat_temp));     
    dataIIR=filtfilt(bpFilti,dataBS);
    datf(i,:)=dataIIR;
    fprintf('%4.2f secs\n',toc);
end

dat = int16(dat.*1e6);
tic;
folder_path='c:\work\SAM-190103\xpz5b3';
if ~exist(folder_path,'dir')
    mkdir(folder_path)
end
fnOut = fullfile(folder_path,'continous.dat');
fidOut = fopen(fnOut,'w');
fwrite(fidOut,dat(:),'*int16');
fclose(fidOut);

%filered
folder_path='c:\work\SAM-190103\xpz5b3f';
if ~exist(folder_path,'dir')
    mkdir(folder_path)
end
fnOut = fullfile(folder_path,'continous.dat');
fidOut = fopen(fnOut,'w');
fwrite(fidOut,datf(:),'*int16');
fclose(fidOut);
% toc;




% toc;
%%
% matToKiloSort__original_xpz5
% matToKiloSort__original
