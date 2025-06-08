# MATLAB Heat Exchanger Optimization  
**NTU-Effectiveness Modeling with Dynamic Cost Optimization**

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a-orange)](https://www.mathworks.com/products/matlab.html)

---

## 📌 Project Overview

This MATLAB project models and optimizes a counterflow heat exchanger using the NTU-effectiveness method. The goal is to minimize annual operating costs under a 5 kPa pressure drop constraint using dynamic flow control and cost-aware design.

### Key Highlights
- 40% average cost reduction during peak hours  
- 70% savings during off-peak operation  
- <0.1% error against theoretical benchmarks  
- Full NTU validation and sensitivity analysis

---

## 📂 Repository Structure

```
heat-exchanger-optimization/
├── Code/
│   ├── 01_getTimeDependentValues.m
│   ├── 02_heatExchangerNTU.m
│   ├── 03_optimizeHX.m
│   ├── 04_visualizeHX.m
│   └── 05_runALL.m
└── Plots/
    ├── 01_Temperature_Profile.png
    ├── 02_Material_Cost.png
    ├── 03_TOU_Pricing.png
    ├── 04_U_Sensitivity.png
    ├── 05_Cost_Breakdown.png
    └── 06_NTU_Validation.png

---

## How to Run

1. **Clone this repository**:
```bash
git clone https://github.com/<your-username>/heat-exchanger-optimization.git
```

2. **Open in MATLAB**, navigate to the `Code/` folder and run:
```matlab
runALL
```

This will:
- Run baseline and optimization simulations
- Generate and save all output plots in `/Plots`
- Display cost and effectiveness metrics in the console

---

## Sample Console Output

```
=== BASE CASE VALIDATION ===
Heat transferred: 58.38 kW
Hot outlet: 52.07°C
Cold outlet: 43.28°C
Effectiveness: 0.466
NTU: 0.813

=== PROCESS OPTIMIZATION ===
Hour 08:00 - Flow: 0.408 kg/s, Area: 6.00 m², Cost: $10171.17, ΔP: 5.0 kPa
Hour 20:00 - Flow: 0.334 kg/s, Area: 1.98 m², Cost: $2997.24, ΔP: 3.4 kPa
```

---

## Key Figures

> These images will display automatically once uploaded to the `Plots/` folder in the GitHub repo.

| Plot File               | Description                              |
|-------------------------|------------------------------------------|
| `Temperature_Profile.png` | Hot/cold fluid temperature gradients     |
| `Cost_Breakdown.png`     | Capital vs. energy cost analysis         |
| `NTU_Validation.png`     | Model validation against theory          |
| `TOU_Pricing.png`        | Electricity rate vs. time-of-use         |
| `Material_Cost.png`      | Steel vs. polymer vs. carbon trade-offs  |
| `U_Sensitivity.png`      | Heat transfer vs. U-value response       |

---

## Requirements

- MATLAB R2023a or later  
- Optimization Toolbox  
- `bvp4c` solver (built-in MATLAB function)

---

## 👤 Author

**Aviral Chaturvedi**  
B.Tech Chemical Engineering, Delhi Technological University  
📧 aviralchaturvedi_23pe017@dtu.ac.in  
🔗 [LinkedIn](https://www.linkedin.com/in/aviralchaturvedi)