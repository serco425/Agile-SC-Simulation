function OR_final_result = scaled_mux_2_to_1_CT_lite (X1, X2, S, N)

a_CT_in1 = ((X1 * (N-S))/N);
%-------------------------------------------Random Fluc.
Py1 = (X1/N) * ((N-S)/N);
compansate_1 = sqrt((Py1*(1-Py1))/N);
a_CT_in1 = ((a_CT_in1) + (compansate_1*N));
%-------------------------------------------Random Fluc.

a_CT_in2 = ((X2 * S)/N);
%-------------------------------------------Random Fluc.
Py2 = (X2/N) * (S/N);
compansate_2 = sqrt((Py2*(1-Py2))/N);
a_CT_in2 = ((a_CT_in2) + (compansate_2*N));
%-------------------------------------------Random Fluc.

a_CT_OR_1 = round((a_CT_in1 * a_CT_in2)/N);
%-------------------------------------------Random Fluc.
Py = (a_CT_in1/N) * (a_CT_in2/N);
compansate = sqrt((Py*(1-Py))/N);
a_CT_OR_1 = ((a_CT_OR_1) + (compansate*N));
%-------------------------------------------Random Fluc.

%The rest of CT primitives
b_CT_OR_1 = a_CT_in1 - a_CT_OR_1; %b = first_operand - a;
c_CT_OR_1 = a_CT_in2 - a_CT_OR_1; %c = second_operand - a;

%CT-based stochastic logic
%CT OR -> TCO = a_CT + b_CT + c_CT
OR_final_result = (a_CT_OR_1 + b_CT_OR_1 + c_CT_OR_1);

end
