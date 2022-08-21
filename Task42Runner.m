% Assignment 2

% Hanra Jeong
% 301449735

% import the images
clc;
clear;

img_list = {'level1_1.png','level2_1.png', 'level3_1.png'}; % 
img_list2 = {'level1_2.png', 'level1_3.png', 'level1_4.png',    'level2_2.png', 'level2_3.png', 'level2_4.png',    'level3_2.png', 'level3_3.png', 'level3_4.png' }; %    
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
   % 1.	Compute the Harris corner detection and get the coordinates
        [c, d] = Harris_detector(image111, 0.0001);
    %     figure(1);
    %     imshow(img11);
    %     hold on;
    %     plot(c, d, 'ro');er

    %     hold off;
    
        [c2, d2] = Harris_detector(image121, 0.0001);
        figure(2);
        imshow(img12);
        hold on;
    %     plot(c2, d2, 'ro');
    %     hold off;
    % 2.	Using these coordinates, compute SIFT-like detector by using Sift_detector function from task 3, and finding the matching point by using match function from Task 3.

        [result1] = Sift_detector(img11, c, d);
        [result2] = Sift_detector(img12, c2, d2); 

    
    
        [a1, b1, ~]= size(img11);
        [a2, b2,~] = size(img12);
    
        [matches, confidence] = match(result1, result2);
        l = size(matches, 1);
        data_x1 = c(matches(1:l, 1)); 
        data_y1 = d(matches(1:l, 1));
        data_x2 = c2(matches(1:l, 2));
        data_y2 = d2(matches(1:l, 2));
        % This part is not used, just from the front code
        if a1 < a2
            img11 = padarray(img11, a2-a1, 0, 'post');
        else
            img12 = padarray(img12, a1-a2, 0, 'post');
        end
        
        concat = [img11 img12];
    %     figure(3);
    %     imshow(concat);
    %     hold on;
        x = [];
        y = [];
    %     data_x2 = data_x2 + b1;
        for iii = 1:size(data_x1, 2)
            if confidence(iii) < 0.97
                x = [x data_x2(iii)];
                y = [y data_y2(iii)];
    %             plot (x, y, 'ro', 'MarkerSize', 3);
    %             plot(data_x1(iii), data_y1(iii), 'ro', 'MarkerSize', 3);
                plot(data_x2(iii), data_y2(iii), 'ro', 'MarkerSize', 3);
    %             line([data_x1(iii), data_x2(iii)], [data_y1(iii), data_y2(iii)], 'Color', 'b');
            end
        end
        co = [];
        for i2 = 1:length(x)
            co(i2, 1) = x(i2);
            co(i2, 2) = y(i2);
        end
        % 3.	Clustering algorithm
        % a.	Sort the matching points’ coordinates by x values
        sorted_co = sortrows(co, 1);
%         sorted_co = unique( sorted_co(:,[1 2]), 'rows');
    
        distance =[];
        group = [];
        for i3 = 1:length(sorted_co)
            group(i3, 1) = i3;
            group(i3, 2) = 1;
        end
        % b.	Compute the distance of x-axis between (sorted) adjacent coordinates
        for i4 = 1:length(sorted_co)-1
            d = sorted_co(i4+1,1) - sorted_co(i4,1);
            distance = [distance d];
        end
        for i5 = 1:length(sorted_co)-1
         % c.	Making the group (clustering) by comparing the distance with parameter
        %  By considering the size of image, the parameter for my data is 20
            if distance(i5) > 20
                for i6 = i5+1:length(sorted_co)
                    group(i6, 2) = group(i5, 2) + 1;
                end
%                 group(i5, 2) = group(i5-1, 2);
            else
                group(i5+1,2) = group(i5, 2);
            end
        end
        count = group(end, 2);
        num = [];
        for i11 = 1:count
            num(i11, 1) = i11;
            num(i11, 2) = 0;
            num(i11, 3) = i11;
        end
        for i12 = 1:length(sorted_co)
            num(group(i12, 2), 2) = num(group(i12, 2), 2) + 1;
        end
         % d.	Ignore the group with equal or less than 5 points (coordinates), to minimize the error and variance
        for i7 = 1:count
            if num(i7, 2) <= 5
                num(i7, 3) = 0;
            end
        end
        fixed_count = 1;

        for i8 = 1:count
            if num(i8, 2) > 5
                num(i8, 3) = fixed_count;
                fixed_count = fixed_count + 1;
            end
        end
        for i13 = 1:length(group)
            for i14 = 1:count
                if group(i13, 2) == num(i14, 1)
                    group(i13, 2) = num(i14, 3);
                end
            end
        end
    % Commented code is just for checking the correctness of grouping
    % by coloring the plots
    %     color_list = ['r', 'g', 'b', 'c', 'm', 'y', 'k', 'w'];
        [sorted_group,group_idx] = sort(group(:,2));
    %     for i7 = 1:count
    %         aaa = color_list(i7);
    %         for i8 = 1:length(x)
    %             if sorted_group(i8) == i7
    % %                 plot(x(group_idx(i8)), y(group_idx(i8)), '*', 'markerSize', 10, 'Color', aaa);
    %             end
    %         end
    %     end
        max_count = 0;
        max_idx = 0;
        for i15 = 1:length(num(:,1))
            if max_count < num(i15, 2)
                max_count = num(i15, 2);
                max_idx = num(i15, 3);
            end
        end
        % e.	Draw the square box withing the clustered coordinates/ points to show the detected objects      
        for i9 = 1:fixed_count-1
            x_line = [];
            y_line = [];
            for i10 = 1:length(sorted_co)
                if group(i10,2) == i9
                    x_line = [x_line sorted_co(i10, 1)];
                    y_line = [y_line sorted_co(i10, 2)];
                end
            end
            x_line = sort(x_line);
            y_line = sort(y_line);
            x_min = x_line(1);
            x_max = x_line(end);
            y_min = y_line(1);
            y_max = y_line(end);
            if i9 == max_idx
                rectangle('Position',[x_min, y_min, x_max-x_min, y_max-y_min],'LineWidth',2,'LineStyle','--', 'EdgeColor','r');
            else
                rectangle('Position',[x_min, y_min, x_max-x_min, y_max-y_min],'LineWidth',2,'LineStyle','--', 'EdgeColor','b');
            end
            hold off;
            saveas(gcf, strcat('Task4_2','_',num2str(i),'_',num2str(ii2),'.png'));
        end
    end
end



