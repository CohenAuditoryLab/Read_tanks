%SnipTimeStamp (goes from 1-64)+SnipTimeStamp1(1-32)=>ML
%SnipTimeStamp1 (goes from 33-128)=>AL
warning('off','MATLAB:interp1:UsePCHIP')
%sprfile='C:\work\STRF\Moving_ripple\slower_DMR\DNR_Cortex_96k_RD2_FM5_5min.spr';
sprfile='C:\work\STRF\Moving_ripple\DMR_50HZ\DNR_Cortex_96k5min_4_50.spr';
%savepath='H:\DataTanks\SAM-180521\Block-2\';
%savepath='H:\DataTanks\SLY-180815\Block-2\';
savepath='H:\DataTanks\SLY-180817\Block-4\';
cs=1;
contaML=1;
contaML2=65;
contaAL=1;
for s=2:96 
    disp(s)
%    [Data] = readtank_mwa_input('SAM-180521',1,s,'local');
    %[Data] = readtank_mwa_input('SAM-180521',2,s,'local');
    %[Data] = readtank_mwa_input('SLY-180815',2,s,'local');
    [Data] = readtank_mwa_input('SAM-190121',2,s,'local');
    if ~isempty(Data.Fs) 
    TrigTimes=round(Data.Fs*Data.Trig);
    else
        TrigTimes=round(Data.Fs1*Data.Trig);
    end
     [TrigA,TrigB]=trigfixstrf2(TrigTimes,400,899);
%      spet=(Data.SnipTimeStamp*Data.Fs);
%      spet1=(Data.SnipTimeStamp1*Data.Fs1);
     %looking for SortCode with Data
     s_index= unique(Data.SortCode);
     s_index1= unique(Data.SortCode1);
     %Taking out 31
     s_index=s_index(s_index<5);
     s_index1=s_index1(s_index1<5);
     for n=1:length(s_index)
         temp(n)=length(find(Data.SortCode==s_index(n)));
     end
     for n=1:length(s_index1)
         temp1(n)=length(find(Data.SortCode1==s_index1(n)));
     end
     intemp=find(temp==max(temp));    
     intemp1=find(temp1==max(temp1));    
     index=find(Data.SortCode==intemp);
     index1=find(Data.SortCode1==intemp1);
     spet=(Data.SnipTimeStamp(index)*Data.Fs);
     spet1=(Data.SnipTimeStamp1(index1)*Data.Fs1);
      if ~isempty(Data.Fs)
     fs=Data.Fs;
     else
         fs=Data.Fs1;
     end
     %ML
     if s<=64
        if length(spet)>100
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet,TrigA,fs,80,30,'dB','MR',1700,5,'float');
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet,TrigB,fs,80,30,'dB','MR',1700,5,'float');
        STRF1=(STRF1A+STRF1B)/2;
        STRF2=(STRF2A+STRF2B)/2;
        No1=No1A+No1B;
        Wo1=(Wo1A+Wo1B)/2;
        No2=No2A+No2B;
        Wo2=(Wo2A+Wo2B)/2;
        STRFDataML(contaML) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
        figure;%subplot(1,2,1)
        taxis=(taxis)*1e3;faxis=(faxis)*1e3;
        pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
        colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;
        if ~exist([savepath '\ML'], 'dir')
            mkdir([savepath '\ML']); 
        end
        print([savepath 'ML\ML_' num2str(contaML)],'-djpeg');
        end
        contaML=contaML+1;   
        close all
        
     if s<=32
         if length(spet)>100
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet1,TrigA,fs,80,30,'dB','MR',1300,5,'float');
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet1,TrigB,fs,80,30,'dB','MR',1300,5,'float');
        STRF1=(STRF1A+STRF1B)/2;
        STRF2=(STRF2A+STRF2B)/2;
        No1=No1A+No1B;
        Wo1=(Wo1A+Wo1B)/2;
        No2=No2A+No2B;
        Wo2=(Wo2A+Wo2B)/2;
        STRFDataML(contaML2) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
        figure;%subplot(1,2,1)
        taxis=(taxis)*1e3;faxis=(faxis)*1e3;
        pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
        colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;
        if ~exist([savepath '\ML'], 'dir')
            mkdir([savepath '\ML']); 
        end
        print([savepath 'ML\ML_' num2str(contaML2)],'-djpeg');
        close all
        end
        contaML2=contaML2+1;
         
     end
     end
     %AL
     if s>32
         if length(spet1)>100
        [taxis,faxis,STRF1A,STRF2A,PP,Wo1A,Wo2A,No1A,No2A,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet1,TrigA,fs,80,30,'dB','MR',1300,5,'float');
        [taxis,faxis,STRF1B,STRF2B,PP,Wo1B,Wo2B,No1B,No2B,SPLN]=rtwstrfdbint(sprfile,0,0.15,spet1,TrigA,fs,80,30,'dB','MR',1300,5,'float');
        STRF1=(STRF1A+STRF1B)/2;
        STRF2=(STRF2A+STRF2B)/2;
        No1=No1A+No1B;
        Wo1=(Wo1A+Wo1B)/2;
        No2=No2A+No2B;
        Wo2=(Wo2A+Wo2B)/2;
        STRFDataAL(contaAL) = struct('No1',No1,'Wo1',Wo1,'No2',No2,'Wo2',Wo2,'STRF1',STRF1,'STRF2',STRF2,'taxis',taxis,'faxis',faxis,'PP',PP,'SPLN',SPLN);
        figure;%subplot(1,2,1)
taxis=(taxis)*1e3;
faxis=(faxis)*1e3;
pcolor(taxis,log2(faxis/faxis(1)),(STRF1A+STRF1B)/2);
colormap jet;set(gca,'YDir','normal'); shading flat;colormap jet;
        if ~exist([savepath '\AL'], 'dir')
            mkdir([savepath '\AL']); 
        end
  print([savepath 'AL\AL_' num2str(contaAL)],'-djpeg');
     close all
         end
       contaAL=contaAL+1;  
     end
     
end




