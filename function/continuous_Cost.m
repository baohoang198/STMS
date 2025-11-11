function C = continuous_Cost(ind)
% ind = [W1, L1, W2, L2]
    W1 = ind(1);
    L1 = ind(2);
    W2 = ind(3);
    L2 = ind(4);

    % ===== TODO: your antenna evaluation here =====
    % Example placeholder (replace with real code):
    % [gain, BW, S11] = my_antenna_simulator(W1,L1,W2,L2);
    % C = (gain_target - gain)^2 + w1*(BW - BW_target)^2 + w2*max(0, S11 - S11_max)^2;

    % Temporary simple test cost (delete later):
    W1_t = 1.0; L1_t = 2.0; W2_t = 1.0; L2_t = 2.0;
    C = (W1-W1_t)^2 + (L1-L1_t)^2 + (W2-W2_t)^2 + (L2-L2_t)^2;
end
