function Intensity_all_cells()

%%%%% Choose Mean or Max intensity (need to be changed in 3 lines (37, 50
%%%%% and 65.

%% Source Files
srcPath = uigetdir('Select the sequence path'); %Images Location
mkdir(srcPath, [filesep '7_Analysis']);
srcFiles = strcat(srcPath,[filesep '*.tif']);  % the folder in which ur images exists
srcFiles = dir(srcFiles);
[x,y] = size(srcFiles);

% Prepare the table for results
Table_combined  = cell2table(cell(0,5),'VariableNames',{'Case','Object', 'Frame', 'Area', 'Intensity'});

%% The Analysis
    for Files=1:x
        
        if contains (srcFiles(Files).name, 'mask')
        
            disp(strcat('analysing',{' '}, srcFiles(Files).name))

            MASK = read_stackTiff(strcat(srcPath,'/',srcFiles(Files).name));
            MASK = MASK > 0;
            
            I= read_stackTiff(strcat(srcPath,filesep, (char(strrep(srcFiles(Files).name,'_mask.tif', '.tif')))));
            
            FileName=(char(srcFiles(Files).name));
            FileName=FileName (:,1:end-4);
            

            MASK=imcomplement(MASK);
            MASK_objects = bwconncomp(MASK,4); 
            
            % create the base table with frame 1.    
            frames=1;
            
            Objects_meanintensity.frame_1 = regionprops(MASK_objects, I(:,:,frames), 'MeanIntensity','Area'); % Change here for MaxIntensity or MeanIntensity
                
            [Objects_meanintensity.frame_1(:).Frame]=deal(frames);
                
            Rows=(1:MASK_objects.NumObjects)';
            Rows=num2cell(Rows);
            [Objects_meanintensity.frame_1(:).Object]=deal(Rows{:});
            
            ALL_FRAMES = Objects_meanintensity.frame_1;
            
            % Add all the frames.    
            for frames=2:size (I,3)
                    
                Objects_meanintensity.(strcat('frame_',num2str(frames))) = regionprops(MASK_objects, I(:,:,frames), 'MeanIntensity','Area'); % Change here for MaxIntensity or MeanIntensity
                
                [Objects_meanintensity.(strcat('frame_',num2str(frames)))(:).Frame]=deal(frames);
                
                Rows=(1:MASK_objects.NumObjects)';
                Rows=num2cell(Rows);
                [Objects_meanintensity.(strcat('frame_',num2str(frames)))(:).Object]=deal(Rows{:});
               
                ALL_FRAMES= vertcat (ALL_FRAMES, Objects_meanintensity.(strcat('frame_',num2str(frames))));  

            end          
                     
            Table = struct2table(ALL_FRAMES);
            Table.Case(:)={FileName};   
            Table = Table(:,[5 4 3 1 2]);
            Table=renamevars(Table,'MeanIntensity','Intensity'); % Change here too MeanIntensity or Max Intensity
            Table_combined =vertcat(Table,Table_combined);                    

                    disp('saving results')
                    % Save Excel export                   
                    writetable (Table_combined, (strcat(srcPath,[filesep '7_Analysis' filesep 'Intensities.csv'])));
            
        end                  
    end
                    
         disp('Done - enjoy! :)')
    
    
    



