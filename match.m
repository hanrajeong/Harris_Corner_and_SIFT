% % Assignment 2

% Hanra Jeong
% 301449735

function [matching, confidence] = match(result1, result2)
    % https://www.mathworks.com/help/matlab/ref/size.html
    % The size of result1 and resul2 is in the format of x * 128
    % compute the size : x
    a = size(result1, 1);
    b = size(result2, 1);
    % This is for storing the result
    matching = [];
    % For storing the confidence value which is required at the last to
    % sorting the result
    confidence = [];
    % For storing the min_distance_index
    idx = [];

    
    for i = 1:a
        distance = [];
        min_distance_1 = 0;
        min_distance_2 = 0;
        min_distance_index = 0;
        % Compute the distance
        for j = 1:b
            % From the lecture note: features_image1 * features_image2T
            distance = [distance norm((result1(i,:) - result2(j,:)), 2)];
        end
        % and then sort the distance to find the 2 smallest distance
        [sorted_dis, idx_dis] = sort(distance);
        % Store the 2 smallest distance
        min_distance_1 = sorted_dis(1);
        min_distance_2 = sorted_dis(2);
        % and get the index of the minimum distance
        min_distance_index = idx_dis(1);
        % compute the ratio of two distances
        % this is for compute the confidence
        % as we need to 
        ratio = double(min_distance_1) / double(min_distance_2);
        confidence = [confidence ratio];
        idx = [idx min_distance_index];
    end
    for ia = 1:length(idx)
        matching(ia, 1) = ia;
        matching(ia, 2) = idx(ia);
    end
    % https://www.cc.gatech.edu/classes/AY2016/cs4476_fall/results/proj2/html/mbalusu3/index.html
    % So, sorting the matches in ascending order with respect to the nearest neighbor distance ratio will give you matches in the order of confidence. This is the Ratio test. 
    [confidence, idx_conf] = sort(confidence, 'descend');
    matching = matching(idx_conf,:);
end