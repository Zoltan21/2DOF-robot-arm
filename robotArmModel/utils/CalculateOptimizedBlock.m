function res=CalculateOptimizedBlock(dynamic_evaluated_model, opt)
%generating the simulink block
MSS = dynamic_evaluated_model.M;
BSS = dynamic_evaluated_model.B;
CSS = dynamic_evaluated_model.C;
GSS = dynamic_evaluated_model.G;
FSS = dynamic_evaluated_model.F;

syms q1 q2 dq1 dq2 tau1 tau2 'real'
q=[q1 q2]';
dq=[dq1 dq2]';
tau=[tau1 tau2]';

switch opt
    case 1
        %WITHOUT GRAVITY WITHOUT FRICTION
        ddq = - inv(MSS)*CSS*dq.^2 - MSS\BSS*dq + MSS\tau; 
    case 2
        %WITH GRAVITY WITHOUT FRICTION
        ddq = - MSS\CSS*dq.^2 - MSS\BSS*dq - MSS\GSS' + MSS\tau; 
    case 3       
        %WITH GRAVITY WITH FRICTION
        ddq= - inv(MSS)*CSS*dq.^2 - (MSS\BSS +MSS\FSS )*dq -MSS\GSS' + MSS\tau;
    case 4
        %WITHOUT GRAVITY WITH FRICTION
        ddq= - inv(MSS)*CSS*dq.^2 - (MSS\BSS +MSS\FSS )*dq + MSS\tau;
    otherwise disp('ERROR');
end

%matlabFunctionBlock('NonlinearModelLQROptimed_real_Z_tmp/NonLinearSystem/GeneratedOptim',ddq);
%matlabFunctionBlock('NonlinearModelLQROptimed/NonlinearSystem/GeneratedOptim',ddq);
matlabFunctionBlock('GeneratedModelTest/GeneratedModel',ddq);
%matlabFunctionBlock('DescriptorUnkownObserver/GeneratedModel',ddq);
%matlabFunctionBlock('GeneratedModelTest/GeneratedModel',ddq);
%matlabFunctionBlock('NonlinearModelLQROptimed/NonlinearSystem/GeneratedOptim',ddq);
%matlabFunctionBlock('NonlinearModelLQRReferenceFollowingOptimed/NonlinearSystem/GeneratedOptim',ddq);
%matlabFunctionBlock('NonLinearModelPDCControllerSimulink/NonLinearSystem/GeneratedModel',ddq);

%matlabFunctionBlock('NonlinearModelLQROptimed_real_Z_tmp/NonLinearSystem/GeneratedOptim',ddq);
%matlabFunctionBlock('NonLinearModelPDCControllerSimple/NonlinearModel/GeneratedModel',ddq);

end