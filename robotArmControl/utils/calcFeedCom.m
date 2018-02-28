function u = calcFeedCom(stateV,ddq_ref,u_state_feed)
%calculates the feedback linearization command
q1 = stateV(1);
q2 = stateV(2);
dq1 = stateV(3);
dq2 = stateV(4);

%  The mass matrix
D = [ (8105038177386135*cos(q2))/2305843009213693952+(43241646890010094987*cos(q2)^2)/46116860184273879040000+7574202732379655/288230376151711744,                                   0
                                                                                                                                                    0, 6796184039281211/288230376151711744];
% the  
V = [-dq1*((dq2*((43241646890010094987*sin(2*q2))/11529215046068469760000+(703*sin(q2))/50000))/4-6/25)-(981*sin(q1)*((37*cos(q2))/1000+3173/40000))/200
     ((43241646890010094987*sin(2*q2))/92233720368547758080000+(703*sin(q2))/400000)*dq1^2+(4*dq2)/25-(36297*cos(q1)*sin(q2))/200000];

u = D*(ddq_ref - u_state_feed)+ V;

end