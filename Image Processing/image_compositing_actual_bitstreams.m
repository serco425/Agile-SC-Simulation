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
% "Agile Simulation of Stochastic Computing Image Processing with Contingency Tables"
% PostDoc. Sercan AYGUN, Asst. Prof. M. Hassan NAJAFI, Asst. Prof. Mohsen IMANI, Prof. Ece Olcay GUNES
% for further info: sercan.aygun@louisiana.edu

%Image compositing - Binary Processing vs. Actual Bitstream Processing

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

%pre-allocation
SC_composite_image = zeros(size(background, 1), size(background, 2));

for i=1:1:size(background, 1)
    for j=1:1:size(background, 2)

        %Background in actual SC bitstreams
        background_SC = random_number_BINOM(background(i,j),N);
        
        %In case of any overflow
        if image(i,j) > 1
            image(i,j) = 1;
        end
        %Image in actual SC bitstreams
        image_SC = random_number_BINOM(abs(image(i,j)),N);
        
        %In case of any overflow
        if alpha(i,j) > 1
            alpha(i,j) = 1;
        end
        %Alpha in actual SC bitstreams
        alpha_SC = random_number_BINOM(abs(alpha(i,j)),N);
         
        %Bit-by-bit processing using MUX
        temp = mux2_to_1_adder(background_SC, image_SC, alpha_SC);

        %Summing 1s in a bitstream
        SC_composite_image(i,j) = sum(temp);
        
    end
end

%PSNR value
p = psnr(uint8(SC_composite_image), uint8(N*reference_conventional));
