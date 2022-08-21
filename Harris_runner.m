% Assignment 2

% Hanra Jeong
% 301449735

% import the images
clc;
clear;

img_list = {'level1_1.png', 'level1_2.png', 'level1_3.png', 'level1_4.png','level2_1.png', 'level2_2.png','level2_3.png', 'level2_4.png', 'level3_1.png', 'level3_2.png', 'level3_3.png', 'level3_4.png'};

for i = 1:length(img_list)
    img_list2 = {};
    img_list2 = img_list(i);
    [c, d] = Harris_detector(img_list2, 0.0001);
    image = img_list(i);
    image2 = cell2mat(image);
    img = imread(image2);
    imshow(img);
    hold on;
    plot(c, d, 'r.', 'MarkerSize', 5);
    hold off;
    saveas(gcf, strcat('Harris_level',num2str(i),'.png'));
end
