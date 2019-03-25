% %For Feb 20
% sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190220';
% method='median';
% fdest='Z:\ToSort_Sam64\SAM-190220_b1';
% pre_amp='xpz5';
% nChan=64;ax_area='Al';
% block=1;
% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
% fdest='Z:\ToSort_Sam64\SAM-190220_b1';
% pre_amp='xpz2';
% nChan=64;ax_area='A1';
% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
% fdest='Z:\ToSort_Sam64\SAM-190220_b1';
% pre_amp='xpz2';
% nChan=64;ax_area='ML';% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
% 
% 
% block=2;
% fdest='Z:\ToSort_Sam64\SAM-190220_b2';
% pre_amp='xpz5';
% nChan=64;ax_area='Al';
% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
% fdest='Z:\ToSort_Sam64\SAM-190220_b2';
% pre_amp='xpz2';
% nChan=64;ax_area='A1';
% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
% fdest='Z:\ToSort_Sam64\SAM-190220_b2';
% pre_amp='xpz2';
% nChan=64;ax_area='ML';
% pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
%%
% For Feb 27%%%%%%%%%%%%%
% A1 will be saved as AL
% AL will be saved as ML
%  sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190227';
%  method='median';
% fdest='Z:\ToSort_Sam\SAM-190227_b1';
% block=1;
% pre_process_v2(sevpath,block,fdest,method);
% block=2;
% fdest='Z:\ToSort_Sam\SAM-190227_b2';
% pre_process_v2(sevpath,block,fdest,method);
% %%
% block=3;
% fdest='Z:\ToSort_Sam\SAM-190227_b3';
% pre_amp='xpz5';
% pre_process_v2(sevpath,block,fdest,method);

%Sorting

% matToKiloSort__original_batch('Z:\ToSort_Sam64','config_original64.m');
% matToKiloSort__original_batch('Z:\ToSort_Sly','config_original96.m');

%matToKiloSort__original_batch('Z:\ToSort_Sam','config_original96.m');

matToKiloSort__original_batch('Z:\ToSort','config_original96.m');