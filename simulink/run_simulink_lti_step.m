
function run_simulink_lti_step()
%RUN_SIMULINK_LTI_STEP  Run the LTI Simulink model step test and plot.
model = 'pfca_lti_model';
if ~bdIsLoaded(model), load_system(model); end
set_param(model,'StopTime','3');
out = sim(model,'SaveOutput','on','SaveFormat','StructureWithTime');
% Extract Scope data automatically is messy; instead, log Plant output to workspace:
% For quick view, just open the Scope:
open_system([model '/Scope']);
disp('Simulation complete. Check the Scope window for step response.');
end
