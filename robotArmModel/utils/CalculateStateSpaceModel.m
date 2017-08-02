function linearized_state_space_model=CalculateStateSpaceModel(linearized_evaluated_model)

M=linearized_evaluated_model.M;
B=linearized_evaluated_model.B;
D=linearized_evaluated_model.D;
F=linearized_evaluated_model.F;
%state feedback for 2 joint model


%calculate linear model
%we also have Qm
linearized_state_space_model.A=[zeros(2) eye(2)
    -M\D     -M\B-M\F ];

linearized_state_space_model.B=[zeros(2)
    inv(M)];

end