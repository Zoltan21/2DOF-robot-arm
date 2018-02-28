%the purpose of the ~exist is useful when the clear all command is
%commented and we want to run just a particular part of the script
%%-------------------------------------------------------------------------
%SET FLAG
%this should be set for 1, in order to get the right parameters
global joint56
joint56=1;
%for the discrete-time linear model, you have to set the sampling time
Ts=0.045;
%%-------------------------------------------------------------------------
%to obtain the dynamic model relation in torque
if ~(exist('Qm'))
    %get the dynamic model of the system
    if (joint56==1)
        Qm = CalculateModel5_6Joints( );
    else
        Qm = CalculateModel( );%get the dynamic model of the system
    end
end
%to collect the coefficients for each state
if ~(exist('dynamic_model'))
    dynamic_model = CollectModelCoefficients( Qm );%Collect the coefficients
    % This model does not contain the damping, so we add a linear friction
    % the friction matrix
    syms b1 b2 'real'
    F=[b1 0; 0 b2];
    dynamic_model.F=F;
    dynamic_model.M = simplify(dynamic_model.M);
    dynamic_model.B = simplify(dynamic_model.B);
    dynamic_model.C = simplify(dynamic_model.C);
    dynamic_model.G = simplify(dynamic_model.G);
    clear F
end

%evaluating the model by giving values to the coefficients
if ~(exist('dynamic_evaluated_model'))
    dynamic_evaluated_model = EvaluateModel( dynamic_model );
end

%calculating the general linearized model
%linearizing the Qm
if ~(exist('linearized_model'))
    linearized_model = LinearizeModel(Qm);
    linearized_model.F = dynamic_model.F;
end

if ~(exist('linearized_evaluated_model'))
    linearized_evaluated_model = EvaluateLinearizedModel( linearized_model );
    linearized_evaluated_model.F = dynamic_evaluated_model.F;
end

%get the linear model in the state space form
if ~(exist('linearized_state_space_model'))
    linearized_state_space_model = CalculateStateSpaceModel( linearized_evaluated_model );
end

%this part is not finished yet
if ~(exist('discrete_linearized_state_space_model'))
    linearized_disc_state_space_model=CalculateDiscreteStateSpaceModel(linearized_state_space_model,Ts);
end

%this is used to get the Simulink model
prompt='UPDATE SIMULINK MODEL?(press 1 if yes)= ';
x=input(prompt);
if (x==1)
    prompt='MODEL TYPE: \n 1. WITHOUT GRAVITY WITHOUT FRICTION\n 2. WITH GRAVITY WITHOUT FRICTION\n 3. WITH GRAVITY WITH FRICTION\n 4. WITHOUT GRAVITY WITH FRICTION \n=';
    x=input(prompt);
    CalculateOptimizedBlock(dynamic_evaluated_model,x);
    disp('the results are generated model');
end
%% saving the models into a .mat file
%save data/DYNAMIC_MODELS dynamic_model dynamic_evaluated_model linearized_model linearized_evaluated_model linearized_state_space_model linearized_disc_state_space_model

