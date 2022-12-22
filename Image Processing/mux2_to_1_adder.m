function [result] = mux2_to_1_adder(x1, x2, s1)
                                
result = ((~s1)&x1 | (s1)&x2);

end

