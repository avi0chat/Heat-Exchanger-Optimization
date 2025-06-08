function visualizeHX()
    %% Temperature Profile Plot
    figure;
    U = 850; A = 2; m_dot_h = 0.5; m_dot_c = 0.6;
    cp_h = 4180; cp_c = 4180; Th_in = 80+273.15; Tc_in = 20+273.15;
    
    xmesh = linspace(0, 1, 10);
    solinit = bvpinit(xmesh, [Th_in; Tc_in]);
    sol = bvp4c(@(x,T)odefun(x,T,U,A,m_dot_h,m_dot_c,cp_h,cp_c), ...
                 @(Ta,Tb)bcfun(Ta,Tb,Th_in,Tc_in), solinit);

    xplot = linspace(0, 1, 100);
    Tplot = deval(sol, xplot);
    Th = Tplot(1,:) - 273.15;
    Tc = Tplot(2,:) - 273.15;

    plot(xplot, Th, 'r', xplot, Tc, 'b', 'LineWidth', 2);
    legend('Hot Fluid', 'Cold Fluid', 'FontSize', 10);
    xlabel('Normalized Length', 'FontSize', 10);
    ylabel('Temperature (°C)', 'FontSize', 10);
    title('Temperature Profiles Along Heat Exchanger', 'FontSize', 12);
    grid on;
    print('Temperature_Profile.png', '-dpng', '-r300');
    
    %% Material Cost Comparison
    figure;
    materials = {'Stainless', 'Carbon', 'Polymer'};
    costs = [200 150 100];
    area_range = 1:10;
    
    hold on;
    for m = 1:length(materials)
        plot(area_range, costs(m)*area_range, 'LineWidth', 2);
    end
    legend(materials, 'Location', 'northwest', 'FontSize', 10);
    title('Material Cost Comparison', 'FontSize', 12);
    xlabel('Area (m²)', 'FontSize', 10); 
    ylabel('Cost ($)', 'FontSize', 10);
    grid on;
    print('Material_Cost.png', '-dpng', '-r300');
    
    %% Time-of-Use Pricing
    figure;
    hours = 0:23;
    [~, rates] = arrayfun(@(h) getTimeDependentValues(h), hours, 'UniformOutput', false);
    rates = cell2mat(rates);
    stem(hours, rates, 'filled', 'LineWidth', 1.5);
    title('Time-of-Use Electricity Pricing', 'FontSize', 12);
    xlabel('Hour', 'FontSize', 10); 
    ylabel('$/kWh', 'FontSize', 10);
    xlim([-1 24]); 
    grid on;
    print('TOU_Pricing.png', '-dpng', '-r300');
    
    %% NTU vs. Effectiveness Validation
    figure;
    NTU_theoretical = linspace(0, 5, 100);
    Effectiveness_theoretical = (1 - exp(-NTU_theoretical)) ./ (1 - 0.5*exp(-NTU_theoretical)); % Counterflow formula
    NTU_simulated = [0.5, 1.2, 2.0, 3.0, 4.0]; % Replace with your actual data
    Effectiveness_simulated = [0.33, 0.55, 0.78, 0.88, 0.92]; % Replace with your actual data
    plot(NTU_theoretical, Effectiveness_theoretical, 'b-', 'LineWidth', 2);
    hold on;
    plot(NTU_simulated, Effectiveness_simulated, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    legend('Theoretical', 'Simulated', 'Location', 'southeast', 'FontSize', 10);
    xlabel('NTU', 'FontSize', 10);
    ylabel('Effectiveness', 'FontSize', 10);
    title('NTU vs. Effectiveness Validation', 'FontSize', 12);
    grid on;
    print('NTU_Validation.png', '-dpng', '-r300');

    %% Cost-Benefit Comparison
    figure;
    categories = {'Baseline', 'Optimized'};
    capital_cost = [2000, 1200]; 
    energy_cost = [800, 480];    
    bar([capital_cost; energy_cost]', 'stacked', 'BarWidth', 0.6);
    title('Cost Breakdown: Baseline vs. Optimized', 'FontSize', 12);
    xlabel('Scenario', 'FontSize', 10); 
    ylabel('Annual Cost ($)', 'FontSize', 10);
    legend('Capital Cost', 'Energy Cost', 'Location', 'northwest', 'FontSize', 10);
    set(gca, 'XTickLabel', categories, 'FontSize', 10);
    grid on;
    print('Cost_Breakdown.png', '-dpng', '-r300');
end

%% Helper Functions for Temperature Profile Plot
function dTdx = odefun(~, T, U, A, m_dot_h, m_dot_c, cp_h, cp_c)
    Th = T(1);
    Tc = T(2);
    dThdx = -U * A * (Th - Tc) / (m_dot_h * cp_h);
    dTcdx = U * A * (Th - Tc) / (m_dot_c * cp_c);
    dTdx = [dThdx; dTcdx];
end

function res = bcfun(Ta, Tb, Th_in, Tc_in)
    res = [Ta(1) - Th_in; Tb(2) - Tc_in];
end