# mtperceptualsegmentation-dataanalysis
-All code was written and tested in Matlab Ver. 2017b
-Copy all Matlab scripts/functions (.m files) and example data (.mat) files to directory/directories of your choice.
-Include directory with scripts/functions in your Matlab path 
(cf. https://www.mathworks.com/matlabcentral/answers/78888-set-path-or-add-path-in-matlab)
-Running any of the scripts will open a prompt to select the directory where data files are saved.
-Installation + run-time are neglible on a standard PC

*All analyses make use of:
i. Statistics and Machine Learning Toolbox
ii. Optimization Toolbox
---------------------------------------
I. Scripts
A. psychometricAnalysis.m
For each experiment,
-calculates and plots psychometric function (fraction coherent choices versus signed texture contrast)
-fits psychometric to cumulative Gaussian to quantify point of subjective equality (PSE – mean), slope (s.d.), and threshold (mean + 1 s.d.)

-Expected output: 2 psychometric functions (1 for each direction of pattern drift) from 1 representative session for each monkey

B. directionTuningAnalysis.m
For each unit,
-calculates and plots direction tuning curves and pattern-component measures from responses to:
i. sine gratings
ii. sine plaids

-Expected output: 2 grating and plaid direction tuning curves along with associated pattern- and component-direction selective predictions for 2 representative units from Monkey S

C. rocAnalysis.m
For each unit,
-regresses firing rate on signed texture contrast to determine a unit’s “preferred” plaid segmentation cue
-calculates area under receiver operating characteristic (ROC) for a pair of spike rate distributions, e.g.:
i. XX% texture contrast coherent cue vs. XX% texture contrast transparent cue ("neuronal sensitivity"), or
ii. XX% texture contrast cue, "coherent" choices vs. "transparent" choices ("choice probability")

-Expected output: 4 grating vs. firing rate scatterplots and 4 neurometric functions (2 (1 for each direction of pattern drift) for each of 2 representative units from Monkey S)

II. Example Data
A. examplePsychometricData
B. exampleDirectionData
C. exampleTexturedPlaidData


