
function build_pfca_lti_simulink_model()
%BUILD_PFCA_LTI_SIMULINK_MODEL  Create an LTI Simulink model using a State-Space block.
p = pfca_params();
[A,B,C,D] = linearize_pfca_numerical(p, [], []);

model = 'pfca_lti_model';
if bdIsLoaded(model), close_system(model,0); end
new_system(model); open_system(model);

% Add blocks
add_block('simulink/Sources/Step',[model '/Step'],'Time','0.1','Before','0','After','0.05');
add_block('simulink/Continuous/State-Space',[model '/Plant'],'A','A','B','B','C','C','D','D');
add_block('simulink/Math Operations/Sum',[model '/Sum'],'Inputs','+-');
add_block('simulink/Commonly Used Blocks/Gain',[model '/Kp'],'Gain','60');   % PD ~ Kp + Kd*s
add_block('simulink/Continuous/Derivative',[model '/d/dt']);
add_block('simulink/Commonly Used Blocks/Gain',[model '/Kd'],'Gain','10');
add_block('simulink/Sinks/Scope',[model '/Scope']);

% Lines (r -> Sum, Sum -> Kp -> Plant -> Scope), and PD parallel path
set_param([model '/Step'],'Position',[30 50 60 70]);
set_param([model '/Sum'],'Position',[100 45 120 75]);
set_param([model '/Kp'],'Position',[160 30 210 80]);
set_param([model '/Plant'],'Position',[260 30 350 80]);
set_param([model '/Scope'],'Position',[400 30 450 80]);
set_param([model '/d/dt'],'Position',[160 100 210 140]);
set_param([model '/Kd'],'Position',[230 100 280 140]);

add_line(model,'Step/1','Sum/1');
add_line(model,'Sum/1','Kp/1');
add_line(model,'Kp/1','Plant/1');
add_line(model,'Plant/1','Scope/1');

% Feedback (y -> Sum - input)
add_line(model,'Plant/1','Sum/2','autorouting','on');

% Derivative branch for PD: y_err -> d/dt -> Kd -> Sum (positive into Kp path)
add_line(model,'Sum/1','d/dt/1','autorouting','on');
add_line(model,'d/dt/1','Kd/1','autorouting','on');
add_line(model,'Kd/1','Plant/1','autorouting','on'); % (acts like series; simple structure)

% Save model
save_system(model);
disp('Created pfca_lti_model.slx');
end
