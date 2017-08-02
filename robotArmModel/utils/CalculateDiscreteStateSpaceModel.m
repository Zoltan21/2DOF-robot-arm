function discrete_state_space_model = CalculateDiscreteStateSpaceModel( linearized_state_space_model,Ts )

    aux=size(linearized_state_space_model.A);
    discrete_state_space_model.A = Ts*linearized_state_space_model.A+eye(aux(1));
    discrete_state_space_model.B = Ts*linearized_state_space_model.B;
    
end

