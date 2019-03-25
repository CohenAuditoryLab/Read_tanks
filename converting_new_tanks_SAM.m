%Convertiong new tanks
% XPZ5    1-64 AL
% XPZ2    1-64 A1 
%         65-128 ML

sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190220';
block=1;
fdest='C:\work\ToSort_Sam\SAM-190220_b1';
method='median';
pre_amp='xpz5';
nChan=64;
ax_area='AL';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
%%
sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190220';
block=1;
fdest='C:\work\ToSort_sam\SAM-190220_b1';
method='median';
pre_amp='xpz2';
nChan=64;clc
ax_area='A1';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
%%
sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190220';
block=1;
fdest='C:\work\ToSort_sam\SAM-190220_b1';
method='median';
pre_amp='xpz2';
nChan=64;
ax_area='ML';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)

%%
sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190306';
method='median';nChan=96;
%%
block=1;
fdest='C:\work\ToSort_Sam\SAM-190306_b1';

pre_amp='xpz5';

ax_area='AL';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
%%
pre_amp='xpz2';
ax_area='A1';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area)

%%
block=2;
fdest='C:\work\ToSort_Sam\SAM-190306_b2';
pre_amp='xpz5';
ax_area='AL';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
%%
pre_amp='xpz2';
nChan=96;
ax_area='A1';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area)



%%
sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190318';
method='median';
nChan=96;

block=1;
fdest='C:\work\ToSort_Sam\SAM-190318_b1';
pre_amp='xpz5';
ax_area='AL';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area);

pre_amp='xpz2';
ax_area='A1';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area);


block=2;
fdest='C:\work\ToSort_Sam\SAM-190318_b2';
pre_amp='xpz5';
ax_area='AL';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area);
pre_amp='xpz2';
nChan=96;
ax_area='A1';
pre_process_new_sam_96(sevpath,block,fdest,method,pre_amp,nChan,ax_area);



