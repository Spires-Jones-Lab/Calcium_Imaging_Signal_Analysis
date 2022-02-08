function Find_DeltaF()

% DeltaF is calculated with the minimum value of each cell during the whole
% experiment. Not set to Frame 0 (f0) because is spontaneus activity and
% some cells started firing.

% IMPORTANT: The input table include variables obtained after "split
% conditions" script". Change if needed (as commented in line 30).

%% Load file
[FileName,PathName] = uigetfile();
fullFileName = fullfile(PathName, FileName);
data = readtable(fullFileName);
% If there is a problem loading the .csv, may be due the delimiters.
%data = readtable(fullFileName,'Delimiter',',');

% Find variables
Case_list=unique(data.Case);
data.Case=nominal(data.Case);

%% Loop for analysis  
        for j=1:length(Case_list)
            
            Working_case=data(data.Case==Case_list{j},:);
            
            Object_list=unique(Working_case.Object);
            
                for k=1:length(Object_list)

                    Working_cell=Working_case(Working_case.Object==k,:);
                    
                    % Change in case the input table does not contain those
                    % columns. Choose the columns to be summarised.
                    Working_cell_summary=groupsummary(Working_cell,{'Case','Object','Area','Treatment','Abeta','Drug'},{'mean','min','max'},'Intensity');
                                      
                    Working_cell.Intensity=Working_cell.Intensity-min(Working_cell_summary.min_Intensity);
                    
                    if k==1
                        All_cells=Working_cell;
                    else
                        All_cells=vertcat(All_cells,Working_cell);
                    end
                end
            
           if j==1
               All_cases=All_cells;
           else
               All_cases=vertcat(All_cases,All_cells);
           end
        end


   writetable (All_cases, (strcat(PathName,[filesep 'DeltaF_Intensity.csv'])));


end
