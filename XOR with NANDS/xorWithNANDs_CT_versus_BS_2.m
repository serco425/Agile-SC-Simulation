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

%Implementation of XOR with NANDs - Reconvergent Paths - considering in CT

%CT.m is required and it returns any of the correlation approach:
%[dummy, dummy, a_best(i), a_min(i), a_max(i)] = CT(X1, X2, N);

clear all
close all

%YOU MAY CHANGE N
N = 1024; %stream size; parametric, N-> 8, 16, 32, 64, 128, 256, 512, 1024
i = 1; %for iteration and vector index %STATIC
number_of_test_iteration = 10000; % total random tests %CAN BE UPDATED

for k = 1:1:number_of_test_iteration %total test iteration, above, you may change the final value

    %-----------------Random scalar selection--------------------
    % This is for the testing purposes. All Xis are gate inputs.
    % Some can have any scalar values in a range 0..N. {INDEPENDENTS}
    % But some bind to previous gate out. {DEPENDENTS}
    % https://www.mathworks.com/help/matlab/ref/randi.html

    % Please refer to the figure: 
    % for the following example:

    % {INDEPENDENTS}
    A = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_A = A/N;

    B = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_B = B/N;


    % SC Domain Expected Value Calculations {DEPENDENTS} 
    % All is control node
    P_G1 = 1 - (P_A * P_B); %NAND
    P_control1(i) = P_G1;

    P_G2 = 1 - (P_A * P_G1); %NAND
    P_control2(i) = P_G2;

    P_G3 = 1 - (P_B * P_G1); %NAND
    P_control3(i) = P_G3;

    P_G4 = 1 - (P_G2 * P_G3); %NAND
    P_control4(i) = P_G4;
    %----------------------------------------------------------------------
    %Reference binary-based operations completed.
    %Expected Values may be used for error calculations.


    %Now, first actual bitstream processing, and then CT-based processing:

    
    %-----------------------First Approach---------------------------------
    %--------------------BIT-BY-BIT PROCESSING-----------------------------
    % Using Bernoulli Rand Var. (RV) by obtaining Binomial distribution
    % Each bit has X/N prob. to be either success (logic-1) or fail (logic-0)
    % N trials are applied

    % {INDEPENDENTS}
    A_binom = binornd(N, (A/N));
    A_temp = false(1,(N)) ; %full zeros temporarily
    A_temp(1:(A_binom)) = true ;
    A_stream = A_temp(randperm(numel(A_temp)));
    
    B_binom = binornd(N, (B/N));
    B_temp = false(1,(N)) ; %full zeros temporarily
    B_temp(1:(B_binom)) = true ;
    B_stream = B_temp(randperm(numel(B_temp)));

    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%
    G1_stream = not(and(A_stream, B_stream));
    output_bitstream_G1 = G1_stream; % First control node

    G2_stream = not(and(A_stream, G1_stream));
    output_bitstream_G2 = G2_stream; % Second control node

    G3_stream = not(and(G1_stream, B_stream));
    output_bitstream_G3 = G3_stream; % Third control node

    G4_stream = not(and(G2_stream, G3_stream));
    output_bitstream_G4 = G4_stream; % Third control node

    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%
    
    %TCO: Total Count of 1s at the output
    %TCO at the output (SINCE THIS IS A PHYSICAL BIT PROCESSING, FOLLOWING 'FOR' LOOPs COUNT THE "ONES")

    %Four Control Nodes:
    %output_bitstream_G1
    %output_bitstream_G2
    %output_bitstream_G3
    %output_bitstream_G4
    %I. G1
    TCO_bitstream_G1(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 1
    for m=1:1:N % looping for N times
        if output_bitstream_G1(m) == true
            TCO_bitstream_G1(i) = TCO_bitstream_G1(i) + 1;
        end
    end
    
    %II. G2
    TCO_bitstream_G2(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 2
    for m=1:1:N % looping for N times
        if output_bitstream_G2(m) == true
            TCO_bitstream_G2(i) = TCO_bitstream_G2(i) + 1;
        end
    end
    
    %III. G3
    TCO_bitstream_G3(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 3
    for m=1:1:N % looping for N times
        if output_bitstream_G3(m) == true
            TCO_bitstream_G3(i) = TCO_bitstream_G3(i) + 1;
        end
    end

    %IV. G4
    TCO_bitstream_G4(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 4
    for m=1:1:N % looping for N times
        if output_bitstream_G4(m) == true
            TCO_bitstream_G4(i) = TCO_bitstream_G4(i) + 1;
        end
    end

    % Getting ready for error calculation, P_actual_bitstream
    actualstream_probability_G1(i) = TCO_bitstream_G1(i)/N;
    actualstream_probability_G2(i) = TCO_bitstream_G2(i)/N;
    actualstream_probability_G3(i) = TCO_bitstream_G3(i)/N;
    actualstream_probability_G4(i) = TCO_bitstream_G4(i)/N;

    %--------------------BIT-BY-BIT PROCESSING-----------------------------
    %---------------------------done---------------------------------------   
    %%%-*-*-*-*-*-*-*-*NO MORE BIT_BY_BIT OPERATIONS-*-*-*-*-*-*-*-*-*-*%%%
    
    

    %------------------------Second Approach-------------------------------    
    %-----------------------------CT---------------------------------------

    %CT1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %NAND
    [~, ~, a_CT1, ~, ~] = CT(A, B, N);
    %-------------------------------------------Random Fluc.
    P_G1_CT = (A/N) * (B/N); %reference gate AND (temporary)
    epsilon_1 = sqrt((P_G1_CT*(1-P_G1_CT))/N);
    a_CT1 = round(((a_CT1/N) + (epsilon_1))*N);

    %CT-based logic
    b = A - a_CT1;
    c = B - a_CT1;
    d = N - (a_CT1 + b + c);
    G1 = b + c + d;
    Controlnode1_CT(i) = G1;
    %CT1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    %CT2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %NAND
    [~, ~, ~, a_CT2, ~] = CT(A, G1, N);
    %-------------------------------------------Random Fluc.
    P_G2_CT = (A/N) * (G1/N); %reference gate AND (temporary)
    epsilon_2 = sqrt((P_G2_CT*(1-P_G2_CT))/N);
    a_CT2 = round(((a_CT2/N) + (epsilon_2))*N);

    %CT-based logic
    b = A - a_CT2;
    c = G1 - a_CT2;
    d = N - (a_CT2 + b + c);
    G2 = b + c + d;
    Controlnode2_CT(i) = G2;
    %CT2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    %CT3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %NAND
    [~, ~, ~, a_CT3, ~] = CT(B, G1, N);
    %-------------------------------------------Random Fluc.
    P_G3_CT = (B/N) * (G1/N); %reference gate AND (temporary)
    epsilon_3 = sqrt((P_G3_CT*(1-P_G3_CT))/N);
    a_CT3 = round(((a_CT3/N) + (epsilon_3))*N);

    %CT-based logic
    b = B - a_CT3;
    c = G1 - a_CT3;
    d = N - (a_CT3 + b + c);
    G3 = b + c + d;
    Controlnode3_CT(i) = G3;
    %CT3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    %CT4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %NAND
    [~, ~, ~, a_CT4, ~] = CT(G2, G3, N);
    %-------------------------------------------Random Fluc.
    P_G4_CT = (G2/N) * (G3/N); %reference gate AND (temporary)
    epsilon_4 = sqrt((P_G4_CT*(1-P_G4_CT))/N);
    a_CT4 = round(((a_CT4/N) + (epsilon_4))*N);

    %CT-based logic
    b = G2 - a_CT4;
    c = G3 - a_CT4;
    d = N - (a_CT4 + b + c);
    G4 = b + c + d;
    Controlnode4_CT(i) = G4;
    %CT4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    %----------------------------------------------------------------------

    % Getting ready for error calculation, P_CT
    CT1_probability(i) = (Controlnode1_CT(i))/N;
    CT2_probability(i) = (Controlnode2_CT(i))/N;
    CT3_probability(i) = (Controlnode3_CT(i))/N;
    CT4_probability(i) = (Controlnode4_CT(i))/N;

    i = i + 1; %for counting iteration
    
    %-----------------------------CT---------------------------------------
    %---------------------------done---------------------------------------  

end

%Error Calculations
format long %for sensitive observations

abs_error_node1_G1 = sum(abs(CT1_probability - actualstream_probability_G1));
abs_error_node1_G2 = sum(abs(CT2_probability - actualstream_probability_G2));
abs_error_node1_G3 = sum(abs(CT3_probability - actualstream_probability_G3));
abs_error_node1_G4 = sum(abs(CT4_probability - actualstream_probability_G4));

%`Mean`ing the absolute errors for MAE of 4 conrol nodes
control1_G1 = abs_error_node1_G1 / number_of_test_iteration
control2_G2 = abs_error_node1_G2 / number_of_test_iteration
control3_G3 = abs_error_node1_G3 / number_of_test_iteration
control4_G4 = abs_error_node1_G4 / number_of_test_iteration
