function [q_min, energy_cost] = getTimeDependentValues(hour)
    % Realistic smooth demand curve
    q_profile = [50 50 50 50 70 90 120 140 150 150 130 110 ...
                 90 70 50 50 50 50 50 50 50 50 50 50];
    energy_rates = [0.25*ones(1,7), 0.45*ones(1,13), 0.25*ones(1,4)];
    
    q_min = q_profile(hour+1) * 1e3;  % Convert to Watts
    energy_cost = energy_rates(hour+1);
end