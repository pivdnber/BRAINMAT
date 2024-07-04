function [current_name] = Remove_Padding_From_MAT_File(path_from, path_to, epoch_size,NamesEpochs)

%%%
% 
% Function which removes padding from between the epochs of interest.
%
% INPUT: 
%   epoch_size: integer -> size of epochs (samples (= epoch length (seconds) * sampling frequency (samples/seconds))
%   padding_size: integer -> size of the padding (samples)
%
% OUTPUT:
%   nothing, function saves the depadded files
%
% Gert Vanhollebeke (04/01/2023)
%
%%%


%generate all paths together
all_paths = Generate_Paths_All_Together(path_from);
%loop over every file
for file_i = 1:size(all_paths,1)
    %extract current file
    current_file = Extract_Object_From_Structure(all_paths(file_i));
    data_FileImported = current_file;
    %get length of the imported data file
    LengthData = size(data_FileImported,2);
    %get name of current_file
    current_name = extractAfter(all_paths(file_i), strcat(path_from,"\"));
    [~,ConvertedFile] = fileparts(current_name); % extract the file name without the extension
    %retrieve the number of epochs for the imported data file
    FindFilename = strcmp(ConvertedFile,NamesEpochs(:,1));
    NrEpochs = NamesEpochs{find(FindFilename),2}; % amount of epochs in the trial
    %get the length of the padding 
    padding_size = (LengthData - (epoch_size * NrEpochs))/NrEpochs;
    %get epoch_amount
    epoch_amount = size(current_file,2)/(epoch_size + padding_size);
    %check if epoch_amount does not have decimals
    if(epoch_amount == round(epoch_amount))
        %do nothing, epoch amount is correct
    else
        throw("Epoch amount is not a natural number, this means that the size of (epoch_size + padding_is not correct for this file.");
    end
    %build empty array of new size to store depadded epochs in
    data = zeros(size(current_file,1),epoch_amount * epoch_size);
    %for loop which extracts each epoch, and removes the padding
    for epoch_i = 1:epoch_amount
        %get epoch_data
        current_epoch_data = current_file(:,1:epoch_size);
        %save epoch in new data
        data(:,(epoch_i - 1)*epoch_size + 1:(epoch_i - 1)*epoch_size + epoch_size) = current_epoch_data;
        %remove epoch + padding from original file
        current_file(:,1:epoch_size + padding_size) = [];
    end
    %set name of the depadded file
    current_name = strcat('dep_',current_name);
    %go to "path_to" and save depadded file
    cd(path_to);
    save(current_name,'data');
    % Show the RAW and DEPADDED data - added by PVdB
    h1 = figure('WindowState','maximized'); %('Name','VizData','Position',get(0,'ScreenSize'));
    subplot(2,1,1)
        h1 = plot(data_FileImported(1,:),'r');
        ylabel('RAW')
        xlabel('Frames')
        axis([0 length(data_FileImported) -Inf Inf])
    legend
    title(['File' ConvertedFile], 'Interpreter', 'none')
    subplot(2,1,2)
        plot(data(1,:))
        ylabel('DEPADDED')
        xlabel('Frames')
        axis([0 length(data_FileImported) -Inf Inf])
    box off
end
disp("All files depadded...");
end