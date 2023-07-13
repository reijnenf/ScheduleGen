%% ScheduleGenerator
% Generates a festival schedule from a collection of shows with start and end times.

%% Clear previous data.
clear all %#ok<CLALL> 

%% Import data
data  = importdata("shows.txt");

%% Initialize show data
nShows = length(data.data);

shows(nShows) = struct("name", '', "startTime", 0, "endTime", 0);
for iShow = 1 : nShows
    shows(iShow).name = data.textdata{iShow};
    shows(iShow).startTime = data.data(iShow, 1);
    shows(iShow).endTime   = data.data(iShow, 2);
end

%% Order shows based on startTime
[~, idx] = sort([shows.startTime]);
shows = shows(idx);

%% Allocate shows to stages
nStages = 0;
for jShow = 1 : nShows
    % Try to allocate show to existing stage.
    showAllocated = false;
    for iStage = 1 : nStages
        if stages{iStage}(end).endTime < shows(jShow).startTime
            stages{iStage}(end + 1) = shows(jShow); %#ok<SAGROW> 
            showAllocated = true;

            break; % Stop looping over stages.
        end
    end

    % If show has not been allocated, add an extra stage.
    if ~showAllocated
        nStages = nStages + 1;
        stages{nStages} = shows(jShow);
    end
end

%% Print output
for iStage = 1 : nStages
    fprintf("On stage %d, the following shows are planned:\n", iStage);
    for iShow = 1 : length(stages{iStage})
        fprintf("- %8s : %2d - %2d.\n", stages{iStage}(iShow).name, stages{iStage}(iShow).startTime, stages{iStage}(iShow).endTime);
    end
    fprintf("\n");
end
