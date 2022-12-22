function X1_stream = random_number_BINOM(X1, N)
    %--------------------BIT-BY-BIT PROCESSING-----------------------------
    % Using Bernoulli Rand Var. (RV) by obtaining Binomial distribution
    % Each bit has X/N prob. to be either success (logic-1) or fail (logic-0)
    % N trials are applied
    X1_binom = binornd(N, X1); % range: 0 <= X1 =< 1, so no need X1/N
    X1_temp = false(1,(N)) ; %full zeros temporarily
    X1_temp(1:(X1_binom)) = true ;
    X1_stream = X1_temp(randperm(numel(X1_temp)));
end

