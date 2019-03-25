function [Data] = readtank_sdk(folder_path,BlockNumber,ChannelNumber,preamp)
%
%function [Data] = readtank_sdk(folder_path,BlockNumber,ChannelNumber)
%	FILE NAME 	: Read Tank using SDK
%	DESCRIPTION : Reads a block, splitting data into 2 preamps. following
%ML XPZ5 1-64 XPZ2 1-32 (A1 for Sly)
%AL XPZ2 33-128
%
%	folder_path 	: folder of tank (i.e. 'D:\SpikeSortingPipeline\Tanks_192ch\Sly-180823') 
%	BlockNumber     : Block Number
%   ChannelNumber   : Channel Number 1-96
%   Preamp           
%   XPZ5            : ML, is contained in 1-64 XPZ5 (eeNU) and  XPZ2 (eeN1) 1-32 
%   XPZ2            : AL contained in XPZ2 33-128 (eeN1)
% RETURNED DATA
%%	Data	: Data Structure containing all relevant data
%
%           Data.Snips              - Snipet Time Stamps,chan,sortcode
%           Data.info

BLOCK_PATH=[folder_path '\Block-' num2str(BlockNumber) '\'];
if strcmp(preamp,'XPZ2')
    ChannelNumber = ChannelNumber+32;
        data = TDTbin2mat(BLOCK_PATH,'TYPE',[2 3],'CHANNEL',ChannelNumber,'NODATA',1); %'eeN1
        data.snips.eeNu=[];
        data.Fs=data.snips.eeN1.fs;
        data.Trig=data.epocs.Trir.data/data.Fs;
         
elseif strcmp(preamp,'XPZ5')
    if ChannelNumber <= 64
        data = TDTbin2mat(BLOCK_PATH,'TYPE',[2 3],'CHANNEL',ChannelNumber,'NODATA',1); %eeNu
        data.snips.eeN1=[];
        data.Fs=data.snips.eeNu.fs;
        data.Trig=data.epocs.Trir.data/data.Fs;
        
    elseif ChannelNumber > 64
        data = TDTbin2mat(BLOCK_PATH,'TYPE',[2 3],'CHANNEL',ChannelNumber-64,'NODATA',1); %eeN1
        data.snips.eeNu=[];
        data.Fs=data.snips.eeN1.fs;
        data.Trig=data.epocs.Trir.data/data.Fs;
        
    end
end
Data = data;











