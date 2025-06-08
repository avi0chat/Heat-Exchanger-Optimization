function [q, Th_out, Tc_out, effectiveness, NTU] = heatExchangerNTU(m_dot_h, m_dot_c, cp_h, cp_c, Th_in, Tc_in, U, A)
    % Counterflow heat exchanger simulation using NTU-effectiveness method
    C_h = m_dot_h * cp_h;
    C_c = m_dot_c * cp_c;
    C_min = min(C_h, C_c);
    C_max = max(C_h, C_c);
    C_r = C_min / C_max;
    
    NTU = (U * A) / C_min;
    
    if abs(C_r - 1) < 1e-10
        effectiveness = NTU / (1 + NTU);
    else
        effectiveness = (1 - exp(-NTU*(1 - C_r))) / (1 - C_r*exp(-NTU*(1 - C_r)));
    end
    
    q = effectiveness * C_min * (Th_in - Tc_in);
    Th_out = Th_in - q / C_h;
    Tc_out = Tc_in + q / C_c;
end