% Assignment 2

% Hanra Jeong
% 301449735

function [c, d] = Harris_detector(image,  threshold);

    % Step 0 : input image
    image2 = cell2mat(image);
    img = imread(image2);
    img = im2double(img);
    image = rgb2gray(img);

    % Step 1: Compute image derivative
    % Optionally blur first
    Gaussian=fspecial('gaussian', 9, 1);
    image = imfilter(image, Gaussian);
    
    dx = [-1 0 1;
          -1 0 1;
          -1 0 1];
    
    dy = [-1 -1 -1;
           0  0  0;
           1  1  1];

    Img_dx = imfilter(image,dx,'replicate');
    Img_dy = imfilter(image,dy,'replicate');

    % Step 3: Compute components of A
    Ixx = Img_dx .* Img_dx;
    Iyy = Img_dy .* Img_dy;
    Ixy = Img_dx .* Img_dy;

    % Step 4: Gaussian filter
    Ixx = imfilter(Ixx,Gaussian);
    Ixy = imfilter(Ixy,Gaussian);
	Iyy = imfilter(Iyy,Gaussian);
    
    % Compute cornerness
    % 𝐶=det𝑀 −𝛼trace𝑀2
    % = =𝑔𝐼2 ∘𝑔𝐼2 −𝑔𝐼∘𝐼 2 + −𝛼𝑔𝐼2 +𝑔𝐼2 2
    alpha = 0.05;
    detM = Ixx.*Iyy-Ixy.*Ixy;
    traceM = Ixx+Iyy;
    C = detM-alpha*traceM.*traceM;

    c = [];
    d = [];

   
    [a b] = size(image);
    % Through the 3 x 3 windows, 
    % Threshold on 𝐶 to pick high cornerness
    % Non-maximal suppression to pick peaks
    for i = 2:b-1
        for j = 2:a-1
            Xi = j-1;
            Xe = j+1;
            Yi = i-1;
            Ye = i+1;
            window = C(Xi:Xe, Yi:Ye);
            window = reshape(window, [9, 1]);
            window = sort(window, 'descend');
            max_value = window(1);
            if C(j, i) > threshold & C(j, i) == max_value
                c = [c i];
                d = [d j];
            end
        end
    end
end
