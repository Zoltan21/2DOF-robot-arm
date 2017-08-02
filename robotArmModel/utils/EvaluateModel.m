function dynamic_evaluated_model = EvaluateModel( dynamic_model )

%running the dataSet to upload the data
syms q1 q2 dq1 dq2 ddq1 ddq2 'real'
%run('dataSet_NONLINEAR_2joints.m');
run('dataSet_NONLINEAR_2joints.m');
dynamic_evaluated_model.M=eval(dynamic_model.M);
dynamic_evaluated_model.C=eval(dynamic_model.C);
dynamic_evaluated_model.B=eval(dynamic_model.B);
dynamic_evaluated_model.G=eval(dynamic_model.G);
dynamic_evaluated_model.F=eval(dynamic_model.F);
end


