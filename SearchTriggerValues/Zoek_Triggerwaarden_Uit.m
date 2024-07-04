%%
location = 'D:\EEG_ANALYSES\TRIGGERS FCACLR\';
all_data = readtable([location 'All_Data.csv']);

%%
time_start = all_data.time_Pynetstation_Start;

%%

name ='011'

%% 
T_triggerX = eval(['all_data.time_T_' name]);
nrLoop = 10;
T_diff = 3282;

time_delta = round(((T_triggerX - time_start)./1000)*200);

T_triggers = nan(40, nrLoop);
T_triggers(:,1) = time_delta;
for i = 1:nrLoop-1
    T_triggers(:,i+1) = time_delta - (i* T_diff)
end
T_triggers = T_triggers'

xlswrite('TriggervaluesCorrected.xlsx',T_triggers,['T_' name])


