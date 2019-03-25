function pre_process_new_sam(sevpath,block,fdest,method,pre_amp,nChan,ax_area)
fs=24414.0625;
%Notch 60Hz IIR
bsFilti = designfilt('bandstopiir','FilterOrder',20, ...
         'HalfPowerFrequency1',50,'HalfPowerFrequency2',70, ...
         'SampleRate',fs);
%iir BP     
bpFilti = designfilt('bandpassiir','FilterOrder',20, ...
         'HalfPowerFrequency1',300,'HalfPowerFrequency2',5e3, ...
         'SampleRate',fs);
%nChan = 96;%64 for Jan03_19 look at notes 96;
sevpath=[sevpath '\Block-' num2str(block) '\'];
% %ML XPZ5 1-64 XPZ2 1-32
% %AL XPZ2 33-128
% session     =   raw{indexn(n),4};
% block       =   raw{indexn(n),6};
% task        =   raw{indexn(n),7};
% if strcmp(task(1),'S') && (length(task)>4) 
fns=dir([sevpath '*.sev']);
in_block=strfind(fns(1).name,'xpz');
%for XPZ2
if strcmp(pre_amp,'xpz2')||strcmp(pre_amp,'XPZ2') && (strcmp(ax_area,'A1')||strcmp(ax_area,'a1'))
    folder_path=['C:\work\temp_fil\a1'];
    folder_pathd=[fdest '_xpz2A1'];
    if ~exist(folder_path,'dir')
        mkdir(folder_path)
    end
    flag=2;
elseif (strcmp(pre_amp,'xpz2')||strcmp(pre_amp,'XPZ2')) && (strcmp(ax_area,'M1')||strcmp(ax_area,'m1'))
    folder_path=['C:\work\temp_fil\m1'];
    folder_pathd=[fdest '_xpz2M1'];
    if ~exist(folder_path,'dir')
        mkdir(folder_path)
    end
    flag=3;
 elseif strcmp(pre_amp,'xpz5')||strcmp(pre_amp,'XPZ5')
    folder_path=['C:\work\temp_fil\al'];
    folder_pathd=[fdest '_xpz5AL'];
    if ~exist(folder_path,'dir')
        mkdir(folder_path)
    end
    flag=5;
end
if ~exist(folder_pathd,'dir')
    mkdir(folder_pathd)
end
fnOut_c = fullfile(folder_pathd,'continous.dat');
fidOut_c = fopen(fnOut_c,'W');

pf=tic;
first_part_file=fns(1).name(1:in_block+2);
parfor i = 1:nChan %will do filtering and re-reference in this loop
    tic
    if flag==2
    sevfilename=[first_part_file num2str(2) '_ch' num2str(i+32) '.sev'];
    elseif flag==3
    sevfilename=[first_part_file num2str(2) '_ch' num2str(i+32) '.sev'];
    elseif flag==5
        if i<=64
            sevfilename=[first_part_file num2str(5) '_ch' num2str(i) '.sev'];
            elseif i>64
                sevfilename=[first_part_file num2str(2) '_ch' num2str(i-64) '.sev'];
        end   
    end
    fprintf('Channel %02d/%02d: ',i,nChan);
    fn = fullfile(sevpath,sevfilename);
    fid = fopen(fn,'r'); %open channel
    header = fread(fid,10,'*single'); %#ok<NASGU>
    dat_temp = fread(fid,[1,inf],'*single');
    fclose(fid);
    %filtering
    dataBS=filtfilt(bsFilti,double(dat_temp));     
    dataIIR=filtfilt(bpFilti,dataBS);
    %reference
    tic;
        fprintf('offset removal... ');
        if strcmp(method,'median')  % subtract the median
            dataIIR = dataIIR - median(dataIIR);
        elseif strcmp(method,'mean')% subtract the mean
            dataIIR = dataIIR - mean(dataIIR);
        end
        fprintf('(%4.2f secs) ',toc);
    %saving to C:\work\temp_fil
    fidOut = fopen(fullfile(folder_path,sevfilename),'w'); %open channel, stay open.
    while fidOut ==-1 %waiting for writer
        pause(1)
        fidOut = fopen(fullfile(folder_path,sevfilename),'w');
    end
    fwrite(fidOut,dataIIR,'*single');
    fclose(fidOut);
    fprintf('%4.2f secs\n',toc);
end
  fprintf('ParFor:(%4.2f secs)\n',toc(pf));
%Second pass re-reference 
fprintf('PASS 2: COMMON AVERAGE REFERENCING.\n')
      % open the output file
    chunkSize   = 10e6;
    d           = dir((fullfile(folder_path ,'*.sev')));
    nSampsTotal = d(1).bytes/4;
    chunkSize    = min(chunkSize,nSampsTotal);
    ChunksTotal = ceil(nSampsTotal/chunkSize);
    ca          = tic;
% loop through the data, loading and re-referencing
    chunkInd = 1;
    while 1
        t1 = tic;
        if chunkInd <= nChunksTotal
            fprintf('PASS 2: Chunk %03d/%03d: loading... ',chunkInd,nChunksTotal);
            tic
            if chunkInd < nChunksTotal
                buff = chunkSize;
            elseif chunkInd == nChunksTotal
                buff = nSampsTotal - chunkSize*(chunkInd-1);
            end
            dat = zeros(nChan,buff);
            for i = 1:nChan
                % open for the first chunk
                if chunkInd == 1
                    sevfilename=[d(1).name(1:in_block+2) num2str(2) '_ch' num2str(i+32) '.sev'];
                    chfid(i) = fopen(fullfile(folder_path,sevfilename),'r');
                end
                % read the data
                dat(i,:) = fread(chfid(i),[1,buff],'*single');
            end
            fprintf('(%4.2f secs) ',toc);
            tic
            fprintf('re-referencing... ');
            % remove the 'average', 
            if strcmp(method,'median')  %% Need to change to . operation faster
               % tm = median(dat,1);
                dat=dat-(median(dat));
                %dat = bsxfun(@minus, dat, tm); % subtract median of each time point
            elseif strcmp(method,'mean')
               % tm = mean(dat(connected,:),1);
                dat=dat-(mean(dat));
                %dat = bsxfun(@minus, dat, tm); % subtract mean of each time point
            end
            fprintf('(%4.2f secs) ',toc);
            tic
            fprintf('writing... ');
            dat=int16(dat.*1e6);
            fwrite(fidOut_c, dat, '*int16');
            fprintf('(%4.2f secs)\n',toc);
        else
            break
        end
        chunkInd = chunkInd + 1;
        fprintf('\tChunk time: %4.2f secs\n',toc(t1));
    end
 fclose(fidOut_c);
 fclose all;
toc(ca);
clear datf dat
end