% Assignment 2

% Hanra Jeong
% 301449735

function [result] = Sift_detector(image, c, d)

dx = [-1 0 1;
      -1 0 1;
      -1 0 1];

dy = [-1 -1 -1;
       0  0  0;
       1  1  1];

    img = im2double(image);
    img = im2gray(img);
    % put the size 9 and sigma 1
    Gaussian = fspecial('gaussian', [9 9], 1);
    % Compute gradients weighted by a Gaussian of variance halfthe window (for smooth falloff).
    dx = imfilter(dx, Gaussian);
    dy = imfilter(dy, Gaussian);
    % derivate of image
    img_dx = imfilter(img, dx, 'conv');
    img_dy = imfilter(img, dy, 'conv');
    
    [a b] = size(img_dx);
    m = zeros(size(img));
    z = zeros(size(img));
%     L = imfilter(img, Gaussian);
    
    z = atan2d(img_dy, img_dx);

    [a1 b1] = size(z);

    for x = 2:a1-1
        for y = 2:b1-1
            % Compute gradients weighted by a Gaussian of variance half the
            % window
%             m(x,y) = sqrt((L(x+1, y) - L(x-1, y)).^2 + (L(x, y+1) - L(x, y-1)).^2);
%             tmpz = (L(x, y+1) - L(x, y-1)) / (L(x+1, y) - L(x-1, y));
%             z(x,y) = atand(tmpz);
            % From the lecture note : Bin into 8 orientations x 4x4 array = 128 dimensions.
            % Thus manipulate the calculated theta value to 8 orientations
            % and store them
            % https://www.mathworks.com/help/matlab/ref/isnan.html
            if z(x,y) < 0
                z(x,y) = z(x,y) + 360;
            elseif z(x,y) >= 360
                z(x,y) = z(x,y) - 360;
            end
            if z(x,y) == 0
                z(x,y) = 1;
            else
                z(x,y) = ceil(z(x,y)/45);
            end
        end
    end

    result = [];
    for p = 1:length(c)
        % Compute on local 16 x 16 window around detection.
        % This is for boundary check to make sure the indexing is not out
        % of boundary
        if c(p) <= 8 | c(p) + 12 >= b | d(p) <= 8 | d(p)+12 >= a
            continue
        end
        % Assign the values for the edge points of window
        % By considering the current point
        % I computed 7 values before current point
        % and 8 values after the current point
        % so the total number of values are 16
        x_start = c(p)-7;
        y_start = d(p)-7;
        x_end =  x_start+3;
        y_end = y_start + 3;

        % Rotate and scale window according to discovered orientation ϴ and scale σ
        % This normalized neighborhood is divided into 4x4 sample regions
        % with 8 orientation bins in each
        tmp_result = [];
        % This is for iterating the window
        for p1 = 1:16
            % When the window is moved down
            if p1 ~= 1 & mod(p1, 4) == 1
                x_start = c(p) -7;
                x_end =  x_start + 3;
                y_start = y_start + 4;
                y_end = y_start + 3;
            else
                % When the window is moved right
                x_start = x_start + 4;
                x_end = x_start + 3;
            end
            % with the computed boundaries above, assign the window
            window = z(y_start:y_end, x_start: x_end);
            % A given gradient contributes to 8 bins
            histogram = zeros(1, 8);
            [a2 b2] = size(window);
            % iterate through the window
            % I didn't fix this size, just for the case when the window
            % size is not 16, but after fixed the code as this, this can be
            % just replaced as 16
            for i = 1: a2*b2
                tmp = window(i);
                histogram(tmp) = histogram(tmp) + 1;
            end
            tmp_result = [tmp_result histogram];
        end
        % 128-dim vector normalized to 1
        temp = normalize(tmp_result, 'norm', 1);
        % Therefore, we reduce the influence of large gradient magnitudes by thresholding the values in the unit feature vector to each be no larger than 0.2, and then renormalizing to unit length. This means that matching the magnitudes for large gradients is no longer as important, and that the distribution of orientations has greater emphasis.
        % from lowe's paper
        % Threshold gradient magnitudes to avoid excessive influence of high gradients caused by specular highlightso After normalization, clamp gradients > 0.2
        for p2 = 1:length(temp)
            if temp(p2) >= 0.2
                temp(p2) = 0.2;
            end
        end
        % Renormalize
        temp = normalize(temp, 'norm', 1);
        % Return the result
        result = [result; temp];
    end
end
