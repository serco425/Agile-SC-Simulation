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

%Please refer to the manuscript Figure 5 (b)

%CT.m is required and it returns any of the correlation approach:
%[dummy, dummy, a_best(i), a_min(i), a_max(i)] = CT(X1, X2, N);

clear all
close all

%YOU MAY CHANGE N
N = 1024; %stream size; parametric, N-> 8, 16, 32, 64, 128, 256, 512, 1024
i = 1; %for iteration and vector index
number_of_test_iteration = 1000; % total random tests

for k = 1:1:number_of_test_iteration %total test iteration, above, you may change the final value

    %-----------------Random scalar selection--------------------
    % https://www.mathworks.com/help/matlab/ref/randi.html
    X1 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_X1 = X1/N;
    X2 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_X2 = X2/N;
    X4 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_X4 = X4/N;
    X5 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_X5 = X5/N;
    X8 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_X8 = X8/N;

    %Calculations
    P_X3 = P_X1 + P_X2 - (2*(P_X1*P_X2));
    P_X6 = P_X3 + P_X4 - (P_X3*P_X4);
    P_X7 = 1-(P_X5 + P_X6 - (2*P_X5*P_X6));
    %-----------------------Expected Value---------------------------------
    expected_value(i) = P_X7 * P_X8;
    %-----------------------Expected Value---------------------------------


    %--------------------BIT-BY-BIT PROCESSING-----------------------------
    % Using Bernoulli Rand Var. (RV) by obtaining Binomial distribution
    % Each bit has X/N prob. to be either success (logic-1) or fail (logic-0)
    % N trials are applied
    X1_binom = binornd(N, (X1/N));
    X1_temp = false(1,(N)) ; %full zeros temporarily
    X1_temp(1:(X1_binom)) = true ;
    X1_stream = X1_temp(randperm(numel(X1_temp)));

    X2_binom = binornd(N, (X2/N));
    X2_temp = false(1,(N)) ; %full zeros temporarily
    X2_temp(1:(X2_binom)) = true ;
    X2_stream = X2_temp(randperm(numel(X2_temp)));

    X4_binom = binornd(N, (X4/N));
    X4_temp = false(1,(N)) ; %full zeros temporarily
    X4_temp(1:(X4_binom)) = true ;
    X4_stream = X4_temp(randperm(numel(X4_temp)));

    X5_binom = binornd(N, (X5/N));
    X5_temp = false(1,(N)) ; %full zeros temporarily
    X5_temp(1:(X5_binom)) = true ;
    X5_stream = X5_temp(randperm(numel(X5_temp)));

    X8_binom = binornd(N, (X8/N));
    X8_temp = false(1,(N)) ; %full zeros temporarily
    X8_temp(1:(X8_binom)) = true ;
    X8_stream = X8_temp(randperm(numel(X8_temp)));


    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%
    X3_stream = xor(X1_stream, X2_stream);
    X6_stream = or(X3_stream, X4_stream);
    X7_stream = not(xor(X6_stream, X5_stream));
    output_bitstream = and(X7_stream, X8_stream);
    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%

    %TCO at the output (SINCE THIS IS A PHYSICAL BIT PROCESSING, FOLLOWING 'FOR' LOOP COUNTS THE "ONES")
    TCO_bitstream(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream)
    for m=1:1:N % looping for N times
        if output_bitstream(m) == true
            TCO_bitstream(i) = TCO_bitstream(i) + 1;
        end
    end

    % Error using BIT-BY-BIT PROCESSING
    % Mean Sqaure Error (MSE)
    MUL_MSE_bit_by_bit(i) = (expected_value(i) - (TCO_bitstream(i)/N))^2; % accumulating the squared error

    actualstream_probability(i) = TCO_bitstream(i)/N;

    %--------------------BIT-BY-BIT PROCESSING-----------------------------


    %%%-*-*-*-*-*-*-*-*NO MORE BIT_BY_BIT OPERATIONS-*-*-*-*-*-*-*-*-*-*%%%


    %-----------------------------CT---------------------------------------

    [~, ~, a_CT_in1, ~, ~] = CT(X1, X2, N); %For AND(X1, S=N/2) CT1
    %-------------------------------------------Random Fluc.
    P_Y3_AND = (X1/N) * (X2/N);
    compansate_1 = sqrt((P_Y3_AND*(1-P_Y3_AND))/N);
    a_CT_in1 = round(((a_CT_in1/N) + (compansate_1))*N);

    b = X1 - a_CT_in1;
    c = X2 - a_CT_in1;
    X3 = b + c;
    %-------------------------------------------Random Fluc.

    [~, ~, a_CT_in2, ~, ~] = CT(X3, X4, N); %For AND(X2, ~S=N/2) CT2
    %-------------------------------------------Random Fluc.
    P_Y6_AND = (X3/N) * (X4/N);
    compansate_2 = sqrt((P_Y6_AND*(1-P_Y6_AND))/N);
    a_CT_in2 = round(((a_CT_in2/N) + (compansate_2))*N);

    b = X3 - a_CT_in2;
    c = X4 - a_CT_in2;
    X6 = a_CT_in2 + b + c;
    %-------------------------------------------Random Fluc.

    [~, ~, a_CT_in3, ~, ~] = CT(X5, X6, N); %For AND(X2, ~S=N/2) CT2
    %-------------------------------------------Random Fluc.
    P_Y7_AND = (X5/N) * (X6/N);
    compansate_3 = sqrt((P_Y7_AND*(1-P_Y7_AND))/N);
    a_CT_in3 = round(((a_CT_in3/N) + (compansate_3))*N);

    b = X5 - a_CT_in3;
    c = X6 - a_CT_in3;
    d = N - (a_CT_in3 + b + c);
    X7 = a_CT_in3 + d;
    %-------------------------------------------Random Fluc.

    [~, ~, a_CT_in4(i), ~, ~] = CT(X7, X8, N); %For AND(X2, ~S=N/2) CT2
    %-------------------------------------------Random Fluc.
    P_Y9_AND = (X7/N) * (X8/N);
    compansate_4 = sqrt((P_Y9_AND*(1-P_Y9_AND))/N);
    a_CT_in4(i) = round(((a_CT_in4(i)/N) + (compansate_4))*N);

    %-------------------------------------------Random Fluc.

    MUL_MSE_CT_a_best_fluctuation(i) = (expected_value(i) - ((a_CT_in4(i))/N))^2;

    CT_probability(i) = (a_CT_in4(i))/N;

    i = i + 1; %for counting iteration

end

format long

abs_error = sum(abs(CT_probability - actualstream_probability));

abs_error / number_of_test_iteration
