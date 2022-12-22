% ##     ## ##          ##          ###    ########    ###    ##    ## ######## ######## ######## ########
% ##     ## ##          ##         ## ##   ##         ## ##    ##  ##  ##          ##       ##    ##
% ##     ## ##          ##        ##   ##  ##        ##   ##    ####   ##          ##       ##    ##
% ##     ## ##          ##       ##     ## ######   ##     ##    ##    ######      ##       ##    ######
% ##     ## ##          ##       ######### ##       #########    ##    ##          ##       ##    ##
% ##     ## ##          ##       ##     ## ##       ##     ##    ##    ##          ##       ##    ##
%  #######  ########    ######## ##     ## ##       ##     ##    ##    ########    ##       ##    ########

%   _
%  |_ ._ _   _  ._ _  o ._   _
%  |_ | | | (/_ | (_| | | | (_|
%   _              _|        _|
%  /   _  ._ _  ._     _|_ o ._   _
%  \_ (_) | | | |_) |_| |_ | | | (_|
%  ___          |                 _|               _    _  ___
%   |  _   _ |_  ._   _  |  _   _  o  _   _       |_   /    |
%   | (/_ (_ | | | | (_) | (_) (_| | (/_ _>   -   |_ . \_.  |
%                               _/
%   |   _. |_
%   |_ (_| |_) o

% IEEE TCAD
% UNDER REVIEW: "Agile Simulation of Stochastic Computing Image Processing with Contingency Tables"
% PostDoc. Sercan AYGUN, Asst. Prof. M. Hassan NAJAFI, Asst. Prof. Mohsen IMANI, Prof. Ece Olcay GUNES
% for further info: sercan.aygun@louisiana.edu

%Image compositing - Binary Processing vs. CT

%CT.m is required and it returns any of the correlation approach:
%[dummy, dummy, a_best(i), a_min(i), a_max(i)] = CT(X1, X2, N);

close all
clear all

%--------------------------------------------------------------------------
N=256; % N<256 requires quantization
%--------------------------------------------------------------------------

%alpha values and image - FOREGROUND - F
[image, ~, alpha] = imread('your_alpha_image.png');
image = rgb2gray(image); %converting to grayscale
image = im2double(image); %converting image to double data format
alpha = im2double(alpha);

%BACKGROUND - B
background = imread('your_background_image.png');
background = rgb2gray(background);
background = im2double(background);

%Making the Image and Alpha matched to the Background in terms of dimensions
image = imresize(image, [size(background, 1) , size(background, 2)]);
alpha = imresize(alpha, [size(background, 1) , size(background, 2)]);

%--------------------------------------------------------------------------
%Conventional processing
reference_conventional = alpha.*image + (1-alpha).*background; % Image compositing formula
%--------------------------------------------------------------------------

%To be able to work with integers like 3 6 86 256...
background = round(N.*background);
image = round(N.*abs(image));
alpha = round(N.*abs(alpha));

%Exception handling
for i = 1:1:size(background, 1)
    for j = 1:1:size(background, 2)
        %In case of any overflow
        if image(i,j) > 256
            image(i,j) = 256;
        end
        %In case of any overflow
        if alpha(i,j) > 256
            alpha(i,j) = 256;
        end
        %In case of any overflow
        if background(i,j) > 256
            background(i,j) = 256;
        end
    end
end

%pre-allocation
SC_composite_image = zeros(size(background, 1), size(background, 2));

%CT processing
for i=1:1:size(background, 1)
    for j=1:1:size(background, 2)
        SC_composite_image(i,j) = (scaled_mux_2_to_1_CT_lite(background(i,j), image(i,j), alpha(i,j), N));
    end
end

%PSNR value
p = psnr(uint8(SC_composite_image), uint8(N*reference_conventional));