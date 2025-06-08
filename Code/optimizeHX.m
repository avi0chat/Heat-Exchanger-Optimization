function [x_opt, total_cost] = optimizeHX(current_hour)
    % Optimization engine for heat exchanger design
    m_dot_h = 0.5;     % kg/s (fixed hot side flow)
    cp_h = 4180;       % J/kg·K (water)
    cp_c = 4180;       % J/kg·K (water)
    Th_in = 80 + 273.15; % K (fixed inlet)
    Tc_in = 20 + 273.15; % K (fixed inlet)
    U = 850;           % W/m²·K (baseline)
    
    % Economic parameters (tuned for realistic tradeoffs)
    Cost_Area = 1500;   % $/m² (emphasizes compact designs)
    Cost_Energy = 0.45; % $/kWh (industrial electricity rate)
    
    % Physical constraints
    deltaP_max = 5e3;  % 5 kPa pressure drop limit
    k = 3e4;           % Pa·s²/kg² (system resistance)
    
    % Demand profile and energy pricing
    [q_min, Cost_Energy] = getTimeDependentValues(current_hour);
    
    % Dynamic bounds
    m_dot_max = sqrt(deltaP_max / k); % Physics-based flow limit
    ub = [m_dot_max, 6];              % Area ≤ 6 m²
    
    % Optimization setup
    x0 = [0.35, 3.5];  % Balanced initial guess
    lb = [0.1, 1];     % Practical lower bounds
    
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    
    [x_opt, total_cost] = fmincon(@(x)objective(x, current_hour, m_dot_h, cp_h, cp_c,...
                                      Th_in, Tc_in, U, Cost_Area, Cost_Energy, k),...
                                      x0, [], [], [], [], lb, ub,...
                                      @(x)constraints(x, k, deltaP_max, q_min,...
                                      m_dot_h, cp_h, cp_c, Th_in, Tc_in, U), options);

    % Nested functions
    function cost = objective(x, hour, m_dot_h, cp_h, cp_c, Th_in, Tc_in,...
                             U, Cost_Area, Cost_Energy, k)
        m_dot_c = x(1);
        A = x(2);
        
        [q, ~, ~] = heatExchangerNTU(m_dot_h, m_dot_c, cp_h, cp_c, Th_in, Tc_in, U, A);
        
        % Time-dependent heat valuation
        base_value = 0.008;        % Base $/W-year
        peak_multiplier = 0.005*(hour >= 8 && hour <= 20); % Peak incentive
        heat_value = q * (base_value + peak_multiplier);
        
        % Cost calculations
        pumping_power = (k * m_dot_c^3)/3600; % kW
        annual_energy_cost = pumping_power * 24 * 365 * Cost_Energy;
        capital_cost = Cost_Area * A;
        
        cost = (annual_energy_cost + capital_cost) - heat_value;
    end

    function [c, ceq] = constraints(x, k, deltaP_max, q_min,...
                                   m_dot_h, cp_h, cp_c, Th_in, Tc_in, U)
        m_dot_c = x(1);
        A = x(2);
        
        [q, ~, ~] = heatExchangerNTU(m_dot_h, m_dot_c, cp_h, cp_c, Th_in, Tc_in, U, A);
        
        c = [k * m_dot_c^2 - deltaP_max;  % Pressure constraint
             q_min - q];                  % Minimum heat transfer
        ceq = [];
    end

    function [q_min, energy_cost] = getTimeDependentValues(hour)
        % Realistic industrial demand profile
        q_profile = [50 50 50 50 85 120 155 175 185 180 160 135 ...
                     110 85 50 50 50 50 50 50 50 50 50 50];
        energy_rates = [0.25*ones(1,7), 0.45*ones(1,13), 0.25*ones(1,4)];
        
        q_min = q_profile(hour+1) * 1e3;  % Convert to Watts
        energy_cost = energy_rates(hour+1);
    end
end