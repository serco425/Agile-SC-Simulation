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

%Implementation of 2-bit ripple carry adder with inherit reconvergent paths
%(The arithmetic function itself is not the main aim.
% The combinational circuit design for Stochastic Computing simulation as a complex circuit 
% with reconvergent path analysis is important and the main aim.)

%this .m file code does not treat CT for reconvergence
%For the reconvergence awareness, please refer to
%rippleCarrywithReconvergence_CT_versus_BS_2.m

%CT.m is required and it returns any of the correlation approach:
%[dummy, dummy, a_best(i), a_min(i), a_max(i)] = CT(X1, X2, N);

clear all
close all

%YOU MAY CHANGE N
N = 1024; %stream size; parametric, N-> 8, 16, 32, 64, 128, 256, 512, 1024...
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
    C0 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_C0 = C0/N;

    A0 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_A0 = A0/N;

    B0 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_B0 = B0/N;

    A1 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_A1 = A1/N;

    B1 = randi((N+1),1)-1; %pseudorandom integer from a uniform discrete distribution
    P_B1 = B1/N;


    % SC Domain Expected Value Calculations {DEPENDENTS} 
    P_G4 = P_A0 + P_B0 - (2*(P_A0*P_B0)); %XOR

    P_G3 = P_A0 * P_B0; %AND

    P_G5 = P_C0 * P_G4; %AND

    P_G6 = P_C0 + P_G4 - (2*(P_C0*P_G4)); %XOR
    P_S0(i) = P_G6; % First control node; Expected Value

    P_G7 = P_G3 + P_G5 - (P_G3*P_G5); %OR
    P_C1(i) = P_G7; % Second control node; Expected Value

    P_G2 = P_A1 + P_B1 - (2*(P_A1*P_B1)); %XOR

    P_G1 = P_A1 * P_B1; %AND

    P_G8 = P_G2 * P_G7; %AND

    P_G10 = P_G1 + P_G8 - (P_G1*P_G8);
    P_C2(i) = P_G10; % Third control node; Expected Value

    P_G9 = P_G2 + P_G7 - (2*(P_G2*P_G7));
    P_S1(i) = P_G9; % Fourth control node; Expected Value
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
    C0_binom = binornd(N, (C0/N));
    C0_temp = false(1,(N)) ; %full zeros temporarily
    C0_temp(1:(C0_binom)) = true ;
    C0_stream = C0_temp(randperm(numel(C0_temp)));
    
    A0_binom = binornd(N, (A0/N));
    A0_temp = false(1,(N)) ; %full zeros temporarily
    A0_temp(1:(A0_binom)) = true ;
    A0_stream = A0_temp(randperm(numel(A0_temp)));

    B0_binom = binornd(N, (B0/N));
    B0_temp = false(1,(N)) ; %full zeros temporarily
    B0_temp(1:(B0_binom)) = true ;
    B0_stream = B0_temp(randperm(numel(B0_temp)));
    
    A1_binom = binornd(N, (A1/N));
    A1_temp = false(1,(N)) ; %full zeros temporarily
    A1_temp(1:(A1_binom)) = true ;
    A1_stream = A1_temp(randperm(numel(A1_temp)));

    B1_binom = binornd(N, (B1/N));
    B1_temp = false(1,(N)) ; %full zeros temporarily
    B1_temp(1:(B1_binom)) = true ;
    B1_stream = B1_temp(randperm(numel(B1_temp)));

    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%
    G4_stream = xor(A0_stream, B0_stream);
    G3_stream = and(A0_stream, B0_stream);
    G5_stream = and(C0_stream, G4_stream);

    G6_stream = xor(C0_stream, G4_stream);
    output_bitstream_S0 = G6_stream; % First control node

    G7_stream = or(G3_stream, G5_stream);
    output_bitstream_C1 = G7_stream; % Second control node

    G2_stream = xor(A1_stream, B1_stream);
    G1_stream = and(A1_stream, B1_stream);
    G8_stream = and(G7_stream, G2_stream);

    G10_stream = or(G1_stream, G8_stream);
    output_bitstream_C2 = G10_stream; % Third control node

    G9_stream = xor(G2_stream, G7_stream);
    output_bitstream_S1 = G9_stream; % Fourth control node
    %%%%%%%%%%%%%%%%%%%%%bit-by-bit logic operation%%%%%%%%%%%%%%%%%%%%%%%%
    
    %TCO: Total Count of 1s at the output
    %TCO at the output (SINCE THIS IS A PHYSICAL BIT PROCESSING, FOLLOWING 'FOR' LOOPs COUNT THE "ONES")

    %Four Control Nodes:
    %output_bitstream_S0
    %output_bitstream_C1
    %output_bitstream_C2
    %output_bitstream_S1
    %I. S0
    TCO_bitstream_S0(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 6
    for m=1:1:N % looping for N times
        if output_bitstream_S0(m) == true
            TCO_bitstream_S0(i) = TCO_bitstream_S0(i) + 1;
        end
    end
    
    %II. C1
    TCO_bitstream_C1(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 7
    for m=1:1:N % looping for N times
        if output_bitstream_C1(m) == true
            TCO_bitstream_C1(i) = TCO_bitstream_C1(i) + 1;
        end
    end
    
    %III. C2
    TCO_bitstream_C2(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 10
    for m=1:1:N % looping for N times
        if output_bitstream_C2(m) == true
            TCO_bitstream_C2(i) = TCO_bitstream_C2(i) + 1;
        end
    end

    %IV. S1
    TCO_bitstream_S1(i) = 0; %Total Count of 1s at the Output Bitstream (a physical stream): Gate 9
    for m=1:1:N % looping for N times
        if output_bitstream_S1(m) == true
            TCO_bitstream_S1(i) = TCO_bitstream_S1(i) + 1;
        end
    end

    % Getting ready for error calculation
    actualstream_probability_S0(i) = TCO_bitstream_S0(i)/N;
    actualstream_probability_C1(i) = TCO_bitstream_C1(i)/N;
    actualstream_probability_C2(i) = TCO_bitstream_C2(i)/N;
    actualstream_probability_S1(i) = TCO_bitstream_S1(i)/N;

    %--------------------BIT-BY-BIT PROCESSING-----------------------------
    %---------------------------done---------------------------------------   
    %%%-*-*-*-*-*-*-*-*NO MORE BIT_BY_BIT OPERATIONS-*-*-*-*-*-*-*-*-*-*%%%
    
    

    %------------------------Second Approach-------------------------------    
    %-----------------------------CT---------------------------------------

    %CT1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %XOR
    [~, ~, a_CT1, ~, ~] = CT(A0, B0, N);
    %-------------------------------------------Random Fluc.
    P_G4_CT = (A0/N) * (B0/N); %reference gate AND (temporary)
    epsilon_1 = sqrt((P_G4_CT*(1-P_G4_CT))/N);
    a_CT1 = round(((a_CT1/N) + (epsilon_1))*N);

    %CT-based logic
    b = A0 - a_CT1;
    c = B0 - a_CT1;
    G4 = b + c;
    %CT1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %AND
    [~, ~, a_CT2, ~, ~] = CT(A0, B0, N);
    %-------------------------------------------Random Fluc.
    P_G3_CT = (A0/N) * (B0/N); %reference gate AND (temporary)
    epsilon_2 = sqrt((P_G3_CT*(1-P_G3_CT))/N);
    a_CT2 = round(((a_CT2/N) + (epsilon_2))*N);

    %CT-based logic
    G3 = a_CT2;
    %CT2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %AND
    [~, ~, a_CT3, ~, ~] = CT(C0, G4, N);
    %-------------------------------------------Random Fluc.
    P_G5_CT = (C0/N) * (G4/N); %reference gate AND (temporary)
    epsilon_3 = sqrt((P_G5_CT*(1-P_G5_CT))/N);
    a_CT3 = round(((a_CT3/N) + (epsilon_3))*N);

    %CT-based logic
    G5 = a_CT3;
    %CT3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %XOR
    [~, ~, a_CT4, ~, ~] = CT(C0, G4, N);
    %-------------------------------------------Random Fluc.
    P_G6_CT = (C0/N) * (G4/N); %reference gate AND (temporary)
    epsilon_4 = sqrt((P_G6_CT*(1-P_G6_CT))/N);
    a_CT4 = round(((a_CT4/N) + (epsilon_4))*N);

    %CT-based logic
    b = C0 - a_CT4;
    c = G4 - a_CT4;
    G6 = b + c;
    S0(i) = G6; %First control node
    %CT4 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %OR
    [~, ~, a_CT5, ~, ~] = CT(G3, G5, N);
    %-------------------------------------------Random Fluc.
    P_G7_CT = (G3/N) * (G5/N); %reference gate AND (temporary)
    epsilon_5 = sqrt((P_G7_CT*(1-P_G7_CT))/N);
    a_CT5 = round(((a_CT5/N) + (epsilon_5))*N);

    %CT-based logic
    b = G3 - a_CT5;
    c = G5 - a_CT5;
    G7 = a_CT5 + b + c;
    C1(i) = G7;  %Second control node
    %CT5 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %XOR
    [~, ~, a_CT6, ~, ~] = CT(A1, B1, N);
    %-------------------------------------------Random Fluc.
    P_G2_CT = (A1/N) * (B1/N); %reference gate AND (temporary)
    epsilon_6 = sqrt((P_G2_CT*(1-P_G2_CT))/N);
    a_CT6 = round(((a_CT6/N) + (epsilon_6))*N);

    %CT-based logic
    b = A1 - a_CT6;
    c = B1 - a_CT6;
    G2 = b + c;
    %CT6 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %AND
    [~, ~, a_CT7, ~, ~] = CT(A1, B1, N);
    %-------------------------------------------Random Fluc.
    P_G1_CT = (A1/N) * (B1/N); %reference gate AND (temporary)
    epsilon_7 = sqrt((P_G1_CT*(1-P_G1_CT))/N);
    a_CT7 = round(((a_CT7/N) + (epsilon_7))*N);

    %CT-based logic
    G1 = a_CT7;
    %CT7 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %AND
    [~, ~, a_CT8, ~, ~] = CT(G7, G2, N);
    %-------------------------------------------Random Fluc.
    P_G8_CT = (G7/N) * (G2/N); %reference gate AND (temporary)
    epsilon_8 = sqrt((P_G8_CT*(1-P_G8_CT))/N);
    a_CT8 = round(((a_CT8/N) + (epsilon_8))*N);

    %CT-based logic
    G8 = a_CT8;
    %CT8 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %OR
    [~, ~, a_CT9, ~, ~] = CT(G1, G8, N);
    %-------------------------------------------Random Fluc.
    P_G10_CT = (G1/N) * (G8/N); %reference gate AND (temporary)
    epsilon_9 = sqrt((P_G10_CT*(1-P_G10_CT))/N);
    a_CT9 = round(((a_CT9/N) + (epsilon_9))*N);

    %CT-based logic
    b = G1 - a_CT9;
    c = G8 - a_CT9;
    G10 = a_CT9 + b + c;
    C2(i) = G10; %Third control node
    %CT9 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    %CT10 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %XOR
    [~, ~, a_CT10, ~, ~] = CT(G2, G7, N);
    %-------------------------------------------Random Fluc.
    P_G9_CT = (G2/N) * (G7/N); %reference gate AND (temporary)
    epsilon_10 = sqrt((P_G9_CT*(1-P_G9_CT))/N);
    a_CT10 = round(((a_CT10/N) + (epsilon_10))*N);

    %CT-based logic
    b = G2 - a_CT10;
    c = G7 - a_CT10;
    G9 = b + c;
    S1(i) = G9; %Fourth control node
    %CT10 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %----------------------------------------------------------------------

    % Getting ready for error calculation
    CT_probability_S0(i) = (S0(i))/N;
    CT_probability_C1(i) = (C1(i))/N;
    CT_probability_C2(i) = (C2(i))/N;
    CT_probability_S1(i) = (S1(i))/N;

    i = i + 1; %for counting iteration
    
    %-----------------------------CT---------------------------------------
    %---------------------------done---------------------------------------  

end

%Error Calculations
format long %for sensitive observations

abs_error_S0 = sum(abs(CT_probability_S0 - actualstream_probability_S0));
abs_error_C1 = sum(abs(CT_probability_C1 - actualstream_probability_C1));
abs_error_C2 = sum(abs(CT_probability_C2 - actualstream_probability_C2));
abs_error_S1 = sum(abs(CT_probability_S1 - actualstream_probability_S1));

%`Mean`ing the absolute errors for MAE of 4 conrol nodes: S0, C1, C2, and S1
control1_S0 = abs_error_S0 / number_of_test_iteration
control2_C1 = abs_error_C1 / number_of_test_iteration
control3_C2 = abs_error_C2 / number_of_test_iteration
control4_S1 = abs_error_S1 / number_of_test_iteration
