%% Brain Research Analysis in Matlab (BRAINMAT - main script)
% This script loads EEG data files to analyse human brain activity. 
% It is designed to standardize the reading of these files. 
% Execute the script by typing 'brainmat' in the command window, and 
% select the appropriate folders in the explorer window popping up.
% It was tested on a dataset collected by researchers affiliated  
% with the department of Rehabilitation Sciences at Ghent University. 
% That dataset was collected using an EGI NetAamps400 series and a 
% Hydrogel Geodesic Sensor nets of 128 electrodes. 

%% Make a fresh start
clear; clc; close all

%% Set the parameters
% Select the number and name of the electrodes for analysis
electrode_names = {"EEG36","EEG104","EEGVREF","EEG24","EEG124","EEG33","EEG122","EEG11","EEG70","EEG83","EEG52","EEG92","EEG45","EEG62","EEG108"}; % input the names of the electrodes of interest between the {}

% Select the sampling frequency and the epoch duration 
samplingFreq = 200; % (samples/seconds)
epochDuration = 3; % (seconds)
%% Select your folders
% Select a folder containing the EEG files in .edf format
selpathEDF = uigetdir('S:\shares\miracl\5_EEGACL\Workspace FCACLR_MP\Export files', 'Select a folder containing EEG files'); % 

% Select a folder to store the MAT files 
selpathMAT = uigetdir('S:\shares\miracl\5_EEGACL\Workspace FCACLR_MP\MAT', 'Select the folder for the MAT files'); 

%% Convert the file format
% Convert an EEG file to .mat with separate data and channel labels from the .edf file format
LocationFromEDF = selpathEDF; 
LocationToMAT = selpathMAT;
mapname_dataset = 'datafiles';
mapname_channel_order = 'channel_order';

Convert_EDF_to_MATLAB(LocationFromEDF, LocationToMAT,mapname_dataset,mapname_channel_order);

%% Initiate and visualize the EEG preprocessing
% Get a list of the file names and the associated number of epochs
[baseFileName, folder] = uigetfile('S:\miracl\5_EEGACL\Workspace FCACLR_MP','*.mat');
fullFileName = fullfile(folder, baseFileName);
NamesEpochs = load(fullFileName);
NamesEpochs = NamesEpochs.NamesEpochs;

% define the epoch_size
LengthEpoch = samplingFreq * epochDuration;

% set the folder to store the depadded files
[~, msg, ~] = mkdir (selpathMAT, 'depadded');% Create new folder for path_to
path_to = [selpathMAT '\depadded'];

% get depadded files
data_depadded = Remove_Padding_Retrieve_EpochNumber(cd, path_to, LengthEpoch,NamesEpochs)
% data_depadded = Remove_Padding_And_Retrieve_EpochNumber(cd, path_to,
% LengthEpoch,NamesEpochs,ListNames,ListEpochs); % Sander Denolf and I manually imported a spreadsheet in the workfspace with 
% variables ListNames and ListEpochs and set the NamesEpochs = FindFilename;

%% Run a sensor sevel analysis 
% Based on the 'Start_New_Analysis' script available at https://github.com/dx2r/PhD_EEG_Pipeline
% Select the time-frequency analysis which calculates the average relative 
% power of a frequency range of interest and uses 1/f correction.
analysis_choice_power = "average_relative_power_specific_fcorrected"; %voor het berekenen van de RELATIEVE power 

% Run the analysis for each bandwith 
for n = 1:5 
    if n ~= 1
        cd(location_data_from)
    end

    % Define and select the frequency band, and input it as an argument
    % Based on articles by Baumeister & Lehmann - Sander Denolf, March 2023
    if n == 1 % Delta
        Band = [0.5 4]; pow_results_map_name = 'RelPow_Delta';
    elseif n == 2 %Theta
        Band = [4 8]; pow_results_map_name = 'RelPow_Theta';
    elseif n == 3 %Alpha1
        Band = [8 10]; pow_results_map_name = 'RelPow_Alpha1';
    elseif n == 4 %Alpha2
        Band = [10 13]; pow_results_map_name = 'RelPow_Alpha2';
    elseif n == 5 %Beta
        Band = [13 19]; pow_results_map_name = 'RelPow_Beta';
    end
    
    % Define the Bin width, frequency range of interest, whole_frequency_range
    pow_varargin = {0.5, Band, [1 40], 1}; % parameters gekozen op 3/02/2023 tijdens demo GV
    
    % Extract the label information of the electrodes
    electrode_layout_information = [LocationToMAT '\' mapname_channel_order '\Channel_Order.mat'];
    
    % Auto select the locations FROM and TO
    location_data_from = cd; %full path to the directory where the data is located.
    [dataset_files, dataset_names] = Generate_Paths_All_Together(location_data_from);
    dataset_size = size(dataset_names,1);
    location_data_to = LocationToMAT; %full path to the directory where the new data needs to be stored.
    [Power_Results_map] = Create_Directory(location_data_to,pow_results_map_name);
    
    % Define the number of electrodes of interest
    electrode_amount = size(electrode_names,2);
   
    %%%
    % MAIN FOR LOOP
    %%%
    %first, write the loop for every participant (use parfor for parallel computing)
    for participant_i = 1:1:dataset_size
        %get the name of the current participant
        current_participant_name = dataset_names(participant_i);
        %Tell what is going on (which participant is worked on)
        disp(current_participant_name);
        %load the timeseries of the current participant
        current_participant_datafile = Extract_Timeseries_From_Sensor_Structure(dataset_files(participant_i));
        %build the complete argument list to be able to extract the specific timeseries
        current_participant_table = Build_Sensor_Celltable(current_participant_datafile,...
            electrode_amount,...
            electrode_names);
        %extract only the specific timeseries on which the calculations need to be performed on
        [current_participant_region_timeseries, current_participant_region_names] = Extract_Sensor_Time_Series_And_Names(current_participant_table,...
            electrode_layout_information);
        %run the power analysis
        current_participant_values = TF_Calculate_Power(current_participant_region_timeseries,...
            samplingFreq,...
            epochDuration,...
            analysis_choice_power,...
            pow_varargin);
        
        %save the individual results in the previously defined map
        Save_Results_To_Directory(current_participant_values,current_participant_name,Power_Results_map);
    end
    
    %%%
    % BUILD STATISTICAL ANALYSIS FILE AND EXPORT THE RESULTS
    %%%
    %build a table with all obtained results and save it as a .csv file
    group_power_results = Generate_Paths_All_Together(strcat(location_data_to,"\",pow_results_map_name));
    statistical_table = Build_Statistical_Table(group_power_results,...
        pow_results_map_name,...
        analysis_choice_power,...
        electrode_amount,...
        electrode_names);
    %go to destined location
    mkdir (selpathMAT(1:end-3), 'Results');
    location_data_results = [selpathMAT(1:end-3) 'Results'];
    cd(location_data_results);
    %save table as .csv file in the destined folder
    writetable(statistical_table, strcat(pow_results_map_name,".csv"));
    writetable(statistical_table, strcat(pow_results_map_name,".xlsx")); % Write the results to a spreadsheet
end

%% Animation with the use of a topographical scalp map
electrode_location = "C:\Users\pivdnber\OneDrive - UGent\Documenten\GitHub\EEGACL\PlotTopography\electrode_information_d2.mat"; 

for j=1:size(current_participant_datafile,2)
    Plot_Sensor_Topography(current_participant_datafile(:,j),electrode_location)
    hold on
    pause(0.00001)
end