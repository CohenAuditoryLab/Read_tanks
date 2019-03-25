sevpath='D:\SpikeSortingPipeline\Tanks\SAM-190128';
nChan=64;
method='median';
for n=1:4
fdest=['C:\work\ToSort\SAM-190128_b' num2str(n)];
block=n;
pre_amp='xpz2';
ax_area='ML';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)

pre_amp='xpz5';
ax_area='AL';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)

pre_amp='xpz2';
ax_area='A1';
pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
end

%%
d=dir('C:\work\ToSort');
for n=3:length(d)
fpath=fullfile(d(n).folder,d(n).name);

matToKiloSort__original64(fpath,64)

end