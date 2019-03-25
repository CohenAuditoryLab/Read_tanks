%SnipTimeStamp (goes from 1-64)+SnipTimeStamp1(1-32)=>ML
%SnipTimeStamp1 (goes from 33-128)=>AL
fs=24414.0625;
block=2;
paramfile='C:\work\STRF\Moving_ripple\DMR_50HZ\DNR_Cortex_96k5min_4_50_param.mat';
path='D:\SpikeSortingPipeline\Tanks\SAM-190318\Block-1\SAM-190318_Block-1_xpz5_ch66.sev';
disp(['Getting Triggers....'])
[TrigA,TrigB]=getting_triggers(path);
warning('off','MATLAB:interp1:UsePCHIP')
sprfile='C:\work\STRF\Moving_ripple\DMR_50HZ\DNR_Cortex_96k5min_4_50.spr';
%savepath='H:\DataTanks\SAM-180417\Block-1\';
savepath='C:\work\ToSort_Sam\SAM-190318_b1_xpz5AL\STRF\';
s_bin=0.15;
cs=1;
%Getting spet from kilosort result
%%
load('C:\work\ToSort_Sam\SAM-190318_b1_xpz5AL\rez2.mat');
spikes=rez.st3;
%for ks2 cluster is at column 2
index_clusters=unique(spikes(:,2));
%index_clusters=unique(spikes(:,5));
conta=1;
for s=55:length(index_clusters) 
    index_temp=find(spikes(:,2)==index_clusters(s));
    spet=spikes(index_temp,1);
    cluster_number=index_clusters(s);
   
 try   
        
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(sprfile,0,s_bin,spet',TrigA,fs,80,30,'dB','MR',1700,5,'float');
 catch me
      STRF1A=[];STRF2A=[];No1A=[];Wo1A=[];No1A=[];Wo1A=[];
 end
 
 try
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(sprfile,0,s_bin,spet',TrigB,fs,80,30,'dB','MR',1700,5,'float');
 catch me
  STRF1B=[];STRF2B=[];No1B=[];Wo1B=[];No1B=[];Wo1B=[]; 
 end
        
   if ~isempty(STRF1A) && ~isempty(STRF1B)
     STRF1 = (STRF1A+STRF1B)/2;
    STRF2 = (STRF2A+STRF2B)/2;
    No1   =  No1A+No1B;
    Wo1   =  (Wo1A+Wo1B)/2;
    No2   =  No2A+No2B;
    Wo2   =  (Wo2A+Wo2B)/2;
     
        [STRF1s,Tresh1]=wstrfstat(STRF1,0.001,No1,Wo1,PP,30,'dB','MR','dB');
        [STRF2s,Tresh2]=wstrfstat(STRF2,0.001,No2,Wo2,PP,30,'dB','MR','dB');
        %Getting STRF param
        [RF1P]=strfparam(taxis,faxis,STRF1s,Wo1,PP,'MR',500,4,0.5,0.05,0.1,'n');
       % [RF2P]=strfparam(taxis,faxis,STRF2s,Wo2,PP,'MR',500,4,0.5,0.05,0.1,'n');
         [RDHist1,FMHist1,RDHist2,FMHist2,Time1,Time2]      =rtfhist(paramfile,spet',TrigA,fs);
        [Xa,Ya,Na]=hist2(FMHist1,RDHist2,20,20,'n');
        [RDHist1b,FMHist1b,RDHist2b,FMHist2b,Time1b,Time2b]=rtfhist(paramfile,spet',TrigB,fs);
        [Xb,Yb,Nb]=hist2(FMHist1,RDHist2,20,20,'n');
  
  elseif isempty(STRF1A) && ~isempty(STRF1B)
    STRF1 = STRF1B;
    STRF2 = STRF2B;
    No1   =  No1B;
    Wo1   =  Wo1B;
    No2   =  No2B;
    Wo2   =  Wo2B;
  elseif isempty(STRF1B) && ~isempty(STRF1A)
    STRF1 = STRF1A;
    STRF2 = STRF2A;
    No1   =  No1A;
    Wo1   =  Wo1A;
    No2   =  No2A;
    Wo2   =  Wo2A;
    elseif isempty(STRF1B) && isempty(STRF1A)
     STRF1 = [];
    STRF2 = [];
    No1   =  [];
    Wo1   =  [];
    No2   =  [];
    Wo2   =  [];
    taxis =  [];
    faxis =  [];
    PP=[];
    SPLN=[];
   end

STRFDataxpz5_AL(conta) = struct('cluster',cluster_number,'No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN,'Xa',Xa,'Ya',Ya,'Na',Na,'Xb',Xb,'Yb',Yb,'Nb',Nb);
figure;
taxis = (taxis)*1e3;
faxis = (faxis)*1e3;
%subplot(2,1,1)
if ~isempty(STRF1)
    subplot(1,3,1)
pcolor(taxis,log2(faxis/faxis(1)),STRF1);
colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;
subplot(1,3,2)
pcolor(RF1P.Fm,RF1P.RD,RF1P.RTF);
axis([-100 100 0 3.9]);colormap jet;
subplot(1,3,3)
hist2(FMHist1,RDHist1,40,40,'y');

%subplot(2,1,2)
%pcolor(taxis,log2(faxis/faxis(1)),STRF2);
%colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;

save_strf='C:\work\ToSort_Sam\SAM-190318_b1_xpz5AL\STRF\';
if ~exist(save_strf,'dir')
    mkdir(save_strf)
end
print([save_strf 'STRF_Cluster' num2str(cluster_number)],'-djpeg');
close all
conta=conta+1;
end

end
save(save_strf,'STRFDataxpz5_AL','-v7.3');     
%%
%%%%%%%%%%%
load('C:\work\ToSort_Sam\SAM-190318_b1_xpz2A1\rez2.mat');
spikes=rez.st3;
%for ks2 cluster is at column 2
index_clusters=unique(spikes(:,2));
%index_clusters=unique(spikes(:,5));
conta=1;
for s=24:length(index_clusters) 
    index_temp=find(spikes(:,2)==index_clusters(s));
    spet=spikes(index_temp,1);
    cluster_number=index_clusters(s);
   
 try   
        
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(sprfile,0,s_bin,spet',TrigA,fs,80,30,'dB','MR',1700,5,'float');
 catch me
      STRF1A=[];STRF2A=[];No1A=[];Wo1A=[];No1A=[];Wo1A=[];
 end
 
 try
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(sprfile,0,s_bin,spet',TrigB,fs,80,30,'dB','MR',1700,5,'float');
 catch me
  STRF1B=[];STRF2B=[];No1B=[];Wo1B=[];No1B=[];Wo1B=[]; 
 end
        
   if ~isempty(STRF1A) && ~isempty(STRF1B)
    STRF1 = (STRF1A+STRF1B)/2;
    STRF2 = (STRF2A+STRF2B)/2;
    No1   =  No1A+No1B;
    Wo1   =  (Wo1A+Wo1B)/2;
    No2   =  No2A+No2B;
    Wo2   =  (Wo2A+Wo2B)/2;
     
         [STRF1s,Tresh1]=wstrfstat(STRF1,0.001,No1,Wo1,PP,30,'dB','MR','dB');
        [STRF2s,Tresh2]=wstrfstat(STRF2,0.001,No2,Wo2,PP,30,'dB','MR','dB');
        %Getting STRF param
        [RF1P]=strfparam(taxis,faxis,STRF1s,Wo1,PP,'MR',500,4,0.5,0.05,0.1,'n');
       % [RF2P]=strfparam(taxis,faxis,STRF2s,Wo2,PP,'MR',500,4,0.5,0.05,0.1,'n');
         [RDHist1,FMHist1,RDHist2,FMHist2,Time1,Time2]      =rtfhist(paramfile,spet',TrigA,fs);
        [Xa,Ya,Na]=hist2(FMHist1,RDHist2,20,20,'n');
        [RDHist1b,FMHist1b,RDHist2b,FMHist2b,Time1b,Time2b]=rtfhist(paramfile,spet',TrigB,fs);
        [Xb,Yb,Nb]=hist2(FMHist1,RDHist2,20,20,'n');
  
  elseif isempty(STRF1A) && ~isempty(STRF1B)
    STRF1 = STRF1B;
    STRF2 = STRF2B;
    No1   =  No1B;
    Wo1   =  Wo1B;
    No2   =  No2B;
    Wo2   =  Wo2B;
  elseif isempty(STRF1B) && ~isempty(STRF1A)
    STRF1 = STRF1A;
    STRF2 = STRF2A;
    No1   =  No1A;
    Wo1   =  Wo1A;
    No2   =  No2A;
    Wo2   =  Wo2A;
    elseif isempty(STRF1B) && isempty(STRF1A)
     STRF1 = [];
    STRF2 = [];
    No1   =  [];
    Wo1   =  [];
    No2   =  [];
    Wo2   =  [];
    taxis =  [];
    faxis =  [];
    PP=[];
    SPLN=[];
   end

STRFDataxpz2_ml(conta) = struct('cluster',cluster_number,'No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN,'Xa',Xa,'Ya',Ya,'Na',Na,'Xb',Xb,'Yb',Yb,'Nb',Nb);
figure;
taxis = (taxis)*1e3;
faxis = (faxis)*1e3;
%subplot(2,1,1)
if ~isempty(STRF1)
    subplot(1,3,1)
pcolor(taxis,log2(faxis/faxis(1)),STRF1);
colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;
subplot(1,3,2)
pcolor(RF1P.Fm,RF1P.RD,RF1P.RTF);
axis([-100 100 0 3.9]);colormap jet;
subplot(1,3,3)
hist2(FMHist1,RDHist1,40,40,'y');

%subplot(2,1,2)
%pcolor(taxis,log2(faxis/faxis(1)),STRF2);
%colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;

save_strf='C:\work\ToSort_Sam\SAM-190318_b1_xpz2A1\STRF\';
if ~exist(save_strf,'dir')
    mkdir(save_strf)
end
print([save_strf 'STRF_Ch' num2str(cluster_number)],'-djpeg');
close all
conta=conta+1;
end

end
save(save_strf,'STRFDataxpz2_ml','-v7.3');     
