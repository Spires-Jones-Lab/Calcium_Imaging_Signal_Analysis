function Segmentation_mip()

% SEGMENTATION FOR GCAMP


srcPath = uigetdir('Select the sequence path'); %Images Location
mkdir(srcPath, [filesep '4_Masks']);
srcFiles = strcat(srcPath,[filesep '*.tif']);  % the folder in which ur images exists
srcFiles = dir(srcFiles);
[x,y] = size(srcFiles);


prompt = {'filter size', 'background', 'minimum object size', 'maximum object size'};
title = 'Parameters';
definput = {'7', '0.01', '50','9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'};
answer = inputdlg(prompt,title,[1 50],definput);
filter_size= str2double(answer{1});
background= str2double(answer{2});
minsize= str2double(answer{3});
maxsize= str2double(answer{4});

    % Prepare the table for parameters
    table (:,1) = vertcat({'Filter_size'},{'Background'}, {'Min_size'},{'Max_size'});
    table (:,2) = vertcat({filter_size},{background}, {minsize},{maxsize});
    results = cell2table (table(1:end,:));
    writetable (results, (strcat(srcPath,[filesep '4_Masks' filesep 'Parameters.xls'])));

%% The segmentation

    for Files=1:x
       
        % Load images
        disp(strcat('analysing',{' '}, srcFiles(Files).name))
 tic  
        I = read_stackTiff(strcat(srcPath,'/',srcFiles(Files).name));
        
        % Get file name
        FileName=(char(srcFiles(Files).name));
        FileName=FileName (:,1:end-4);
        
        % Get image size
        [f,c,p]=size(I);
        
       % Convert to numeric (0 to 1)
        Imat = mat2gray(I);

       % Create empty images (matrix)
        meanImat=zeros(size(Imat));
        sImat=meanImat;
        medianImat=zeros(size(Imat));
        bwImat=meanImat;
        join1D = false([f c]);
        join2D =false(size(bwImat));
        
        % Mean filter-based segmentation
               for i=1:p

                    meanImat(:,:,i)=imfilter(Imat(:,:,i),fspecial('average',filter_size),'replicate');

                    sImat(:,:,i)=meanImat(:,:,i)-(double(Imat(:,:,i)))+background;
                    bwImat(:,:,i)=im2bw(sImat(:,:,i),0);
                    bwImat(:,:,i)=imcomplement(bwImat(:,:,i));
          
                    %remove small dots in 2D
                    CCbwImat(i).CC=bwconncomp(bwImat(:,:,i),4);
                    for ii=1:CCbwImat(i).CC.NumObjects
                            pixId=CCbwImat(i).CC.PixelIdxList{ii};
                                if (length(pixId)>2) 
                                    join1D(CCbwImat(i).CC.PixelIdxList{ii})=true;
                                end
                     end   
                     join2D(:,:,i)=join1D;
                     join1D = false([f c]);
               end 
               
        % max projection
        mip = max(join2D, [], 3);   
        
        % Filter by object size (in 3D)
        BW = bwareafilt(mip,[minsize maxsize]);
        
    
        % Save images
        disp('saving images')
                  outputFileName = strcat(srcPath,'\4_Masks\', FileName, '_mask.tif');
                  imwrite(logical(BW),outputFileName, 'WriteMode', 'append',  'Compression','none');
               
  toc                  
            
    end
    
                       
         disp('Done - enjoy! :)')
    
    
    



