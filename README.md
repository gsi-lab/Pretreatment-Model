# Pretreatment Model
## Overview
Different data-driven and knowledge-driven models for the dilute acid pretreatment of wheat straw

### Employment
The repository contains the following folders:

- **design_of_experiments**: folder with the files for calculating the designs of expeirments
- **easyGSA**: empty folder to install the easyGSA toolbox
- **experimenta_data**: folder containing a *.mat* file with the experimental data of the dilute acid pretreatment
- **identifiability_analysis**: folder with the scripts/functions for performing the identifiability analysis (main file: *identifiability_analysis.m*)
- **model_gpr**: folder with the script to fit a GPR model to the experimental data
- **model_mechanistic**: folder with the scripts/functions for the mechanistic model and the validation (main file: *sim_pretreatment.m*, *model_validation.m*)
- **model_rsm**: folder with the script to fit a RSM model to the experimental data
- **MOSKopt**: empty folder to install MOSKopt
- **optimization_gpr**: folder with the script to run the optimization problem with the GPR model
- **optimization_mechanistic**: folder with the scripts/functions to run the optimization problem with the mechanistic model (main file: *opt_mechanistic.m*)
- **optimization_MOSKopt**: folder with the scripts/functions to run the optimization problem with the mechanistic model and the MOSKopt solver (main file: *rs_MOSKopt.m*)
- **parameter_estimation_initial**: folder with the scripts/functions to run the intial parameter estimation before the identifiability analysis (main file: *parameter_estimation_initial.m*)
- **parameter_estimation_main**: folder with the scripts/functions to run the main parameter estimation after the identifiability analysis (main file: *parameter_estimation_main.m*)
- **sensitivity_analysis**: folder with the scripts/functions to run the sensitivity analysis with the easyGSA toolbox (main file: *sensitivity_analysis.m*)
- **uncertainty_analysis**: folder with the script to run the uncertainty analysis

### Prerequisites
- MATLAB 2020b or higher        (https://www.mathworks.com/)
- R 4.0.5 or higher             (https://www.r-project.org/)

The frameworke furthermore utilizes the easyGSA toolbox and the MOSKopt solver developed by Resul Al (resal@kt.dtu.dk). They are available on the GSI-Lab GitHub page:
- easyGSA (https://github.com/gsi-lab/easyGSA)
- MOSKopt (https://github.com/gsi-lab/MOSKopt)

### Developer
Nikolaus Vollmer (nikov@kt.dtu.dk) - PROSYS Research Center, Department of Chemical and Biochemical Engineering, Technical University of Denmark

### Acknowledgements
This work is part of the Fermentation-Based Biomanufacturing Initiative (http://www.fbm.dtu.dk) at the Technical University of Denmark and received funding by the Novo Nordisk Foundation (Grant no. NNF17SA0031362)

Parts of the code stem from:
- Sin et al., 2010, Assessing reliability of cellulose hydrolysis models to support biofuel process design—Identifiability and uncertainty analysis, *Computers & Chemical Engineering*, Vol. 34 (9), pp. 1385-1392. https://doi.org/10.1016/j.compchemeng.2010.02.012
- Sin and Gernaey, 2016, Data Handling and Parameter Estimation, in *Experimental methods in wastewater treatment*, pp. 201-234, ISBN: 9781780404745.
