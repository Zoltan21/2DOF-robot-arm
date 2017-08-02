function linearized_evaluated_model = EvaluateLinearizedModel( linearized_model )

%running the dataSet to upload the data
syms q1 q2 dq1 dq2 ddq1 ddq2 'real'
%run('dataSet_NONLINEAR_2joints.m');
run('dataSet_NONLINEAR_2joints.m');
linearized_evaluated_model.M=eval(linearized_model.M);
linearized_evaluated_model.B=eval(linearized_model.B);
linearized_evaluated_model.D=eval(linearized_model.D);
linearized_evaluated_model.G=eval(linearized_model.G);
end


