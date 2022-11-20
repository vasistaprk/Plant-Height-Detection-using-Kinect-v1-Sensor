%% IMAGE CAPUTRE:
%vid = videoinput('kinect', 1, 'RGB_1280x960');
%src = getselectedsource(vid);
%vid.FramesPerTrigger = 1;
%preview(vid);
%[INPUT,Mdata]=getsnapshot(vid);
%imshow(INPUT);


%% Manual INPUT.
INPUT=imread("D:\VNR_VJIET\IOT-Project\Only Plant\Plant_Test_8.jpg");
%INPUT=imread("D:\VNR_VJIET\IOT-Project\Pot-Plant\Plant_Pot_1.jpg");
imshow(INPUT);


%% Converting RGB to HSV
    imageHSV=rgb2hsv(INPUT);
    %imshow(imageHSV);
    % Extract out the H, S, and V images individually
    hImage = imageHSV(:,:,1);
    sImage = imageHSV(:,:,2);
    vImage = imageHSV(:,:,3);
%montage({imageHSV,hImage,sImage,vImage},'BackgroundColor','GREEN','BorderSize',3);

%% Assign the low and high thresholds for each color band.
%Assigned for predefined Green colour.
    hueThresholdLow = 0.15;
	hueThresholdHigh = 0.60;
	saturationThresholdLow = 0.36;
	saturationThresholdHigh = 1;
	valueThresholdLow = 0;
	valueThresholdHigh = 0.90;
    
    
     %% Now apply each color band's particular thresholds to the color band
	hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
	saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
	valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);
    % Display the thresholded binary images.
    %montage({hueMask,saturationMask,valueMask},'BackgroundColor','Red','BorderSize',3);
    
    
    %% Combine the masks to find where all 3 are "true."
	% Then we will have the mask of only the green parts of the image.
	coloredObjectsMask = uint8(hueMask & valueMask);
    %coloredObjectsMask = uint8(hueMask & saturationMask & valueMask);
    imshow(coloredObjectsMask, []);
    title("Masked Image", 'FontSize', 15);
    
    
    %% BINARIZE THE OBJECT MASK.
    Object = imbinarize(coloredObjectsMask,0);
    imshow(Object);
    title("Binary Image", 'FontSize', 15);
    
    
%% Calculating are through perimeter: bwperim() and imfill()
    % New_BinaryImage = bwperim(BinaryImage,connectivity)
    Perimeter_of_Object = bwperim(Object,8);
    % New_BinaryImage = imfill(BinaryImage,connectivity,'holes') 
    Object_2 = imfill(Perimeter_of_Object,8,'holes');
    %montage({INPUT,Object,Perimeter_of_Object,Object_2},'BackgroundColor','Red','BorderSize',3);
%% Eleminating small objects
    bw = bwareaopen(Object_2,1000);
    imshow(bw)
    title("Filtered Binary Image", 'FontSize', 15);
    

%% Bounding Boxes and Calculating Height of the plant.
info = regionprops(bw,'Boundingbox') ;
I=INPUT;
for k = 1 : length(info)
     BB = info(k).BoundingBox;
     I=insertShape(I,'Rectangle',BB,'Color','Red','LineWidth',5) ;
     I=insertShape(I,'Line',[BB(1),BB(2),BB(1),BB(2)+BB(4)],"Color","BLUE","LineWidth",8);
     x=int8(BB(3)/15);
     I=insertText(I,[BB(1) BB(2)],"Height:"+BB(4)+" Units",'FontSize',x,"Boxcolor","Black",'TextColor',"GREEN");
end
disp(info);
imshow(I);
    