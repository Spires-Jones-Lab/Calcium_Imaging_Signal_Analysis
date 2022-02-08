function Find_peaks()


% IMPORTANT: The input table include variables obtained after "split
% conditions" script". Change if needed (as commented in line 52).

%% Load file
[FileName,PathName] = uigetfile();
fullFileName = fullfile(PathName, FileName);
data = readtable(fullFileName,'Delimiter',',');
% If there is a problem loading the .csv, may be due the delimiters.
%data = readtable(fullFileName,'Delimiter','.');

% Find variables
Case_list=unique(data.Case);
Treatment_list=unique(data.Treatment);

data.Treatment=nominal(data.Treatment);
data.Case=nominal(data.Case);

%% OPTIONAL. In case a single cell wants to be visualitze before.
% Working_Treatment=data(data.Treatment==Treatment_list{2},:);
% Working_case=Working_Treatment(Working_Treatment.Case==Case_list{4},:);
% Working_cell=Working_case(Working_case.Object==1,:);
% 
% Min=0.28*std(Working_cell.Intensity);  % It is calculated inside ieach Treatment, do it for whole experiment?

% findpeaks(Working_cell.Intensity, 'MinPeakProminence', Min, 'Annotate', 'extents');

% [peaks_A, peaks_loc, ~, ~]  =  findpeaks(Working_cell.Intensity, 'MinPeakProminence', Min, 'Annotate', 'extents');


%% Loop for analysis
for i=1:length(Treatment_list) % It should contain this condition. Delete this level if required.
    
    Working_Treatment=data(data.Treatment==Treatment_list{i},:);
    
        for j=1:length(Case_list)
            
            Working_case=Working_Treatment(Working_Treatment.Case==Case_list{j},:);
            
            Object_list=unique(Working_case.Object);
            
                for k=1:length(Object_list)

                    Working_cell=Working_case(Working_case.Object==k,:);

                    Min=0.28*std(Working_cell.Intensity);  % It is calculated inside ieach Treatment, do it for whole experiment?

                    [peaks_A, peaks_loc, peaks_width, ~]  =  findpeaks(Working_cell.Intensity, 'MinPeakProminence', Min, 'Annotate', 'extents','WidthReference','halfheight');

                    % Change in case the input table does not contain those
                    % columns. Choose the columns to be summarised.
                    Working_cell_summary=groupsummary(Working_cell,{'Case','Object','Area','Treatment','Abeta','Drug'},{'mean','min','max'},'Intensity');
                    Working_cell_summary.GroupCount=[];
                    Working_cell_summary.Peak_number=length(peaks_A);
                    Working_cell_summary.Peak_frequency=length(peaks_A)/length(Working_cell.Frame);
                    Working_cell_summary.peaks_median_width=median(peaks_width);

                    if k==1
                        Working_case_summary=Working_cell_summary;
                    else
                        Working_case_summary=vertcat(Working_case_summary,Working_cell_summary);
                    end
                end
            
           if j==1
               Working_Treatment_summary=Working_case_summary;
           else
               Working_Treatment_summary=vertcat(Working_Treatment_summary,Working_case_summary);
           end
        end
   
    if i==1
       Peaks_summary=Working_Treatment_summary;
    else
       Peaks_summary=vertcat(Peaks_summary,Working_Treatment_summary);
    end
        
end

   writetable (Peaks_summary, (strcat(PathName,[filesep 'Peaks_summary.csv'])));


end
