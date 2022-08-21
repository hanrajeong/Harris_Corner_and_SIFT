% Assignment 2

% Hanra Jeong
% 301449735

% import the images
clc;
clear;

img_list = {'level1_1.png', 'level2_1.png', 'level3_1.png'};
img_list2 = {'level1_2.png', 'level1_3.png', 'level1_4.png', 'level2_2.png', 'level2_4.png', 'level3_2.png', 'level3_3.png', 'level3_4.png'};

for i = 1:length(img_list)
    for ii1 = 1:3
        ii2 = ii1;
        ii1 = ii1 + (i-1)*3;
        image111= img_list(i);
        
        image121 = img_list2(ii1);
    
        image11 = cell2mat(image111);
        img11 = imread(image11);
        img11 = im2double(img11);
    
        image12 = cell2mat(image121);
        img12 = imread(image12);
        img12 = im2double(img12);
        % Compute the harris_detector
        [c, d] = Harris_detector(image111, 0.0001);
    %     figure(1);
    %     imshow(img11);
    %     hold on;
    %     plot(c, d, 'ro');
    %     hold off;
    
        [c2, d2] = Harris_detector(image121, 0.0001);
    %     figure(2);
    %     imshow(img12);
    %     hold on;
    %     plot(c2, d2, 'ro');
    %     hold off;
        % With the results from harris detector,
        % Compute the results from Sift detector
        [result1] = Sift_detector(img11, c, d);
        [result2] = Sift_detector(img12, c2, d2);
    
    
        [a1, b1, ~]= size(img11);
        [a2, b2,~] = size(img12);
        % and by using this results from sift detector,
        % get the matching data from match
        [matching, confidence] = match(result1, result2);
        l = size(matching, 1);
        data_x1 = c(matching(1:l, 1)); 
        data_y1 = d(matching(1:l, 1));
        data_x2 = c2(matching(1:l, 2));
        data_y2 = d2(matching(1:l, 2));
        % This is for gathering two images into one frame
        % I will pad the smaller image with the black color surrounding it
        if a1 < a2
            img11 = padarray(img11, a2-a1, 0, 'post');
        else
            img12 = padarray(img12, a1-a2, 0, 'post');
        end
        % Concaternation two images
        concat = [img11 img12];
        figure(3);
        imshow(concat);
        hold on;
        % This is for plotting the computed data on concatenated images
        data_x2 = data_x2 + b1;
        for iii = 1:size(data_x1, 2)
            % Tuned parameter
            if confidence(iii) < 0.97
                plot(data_x1(iii), data_y1(iii), 'ro', 'MarkerSize', 3);
                plot(data_x2(iii), data_y2(iii), 'ro', 'MarkerSize', 3);
                line([data_x1(iii), data_x2(iii)], [data_y1(iii), data_y2(iii)], 'Color', 'b');
            end
        end
        hold off;
        saveas(gcf, strcat('SIFT','_',num2str(i),'_',num2str(ii2),'.png'));
    end
end


