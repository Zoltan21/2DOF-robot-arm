%benchmark PID control based on linear continuos-time state space model

cfg.ss.A = [ 0 0 1 0
            0 0 0 1
            18.5668 0 -7.8097 0
            0 7.6969 0 -6.7857];
cfg.ss.B = [
         0         0
         0         0
   32.5405         0
         0   42.4106];
%first lets see the first angle
cfg.ss.C1 = [1 0 0 0];
cfg.ss.C2 = [0 1 0 0];
cfg.ss.D = [0 0];

%%manually calculating the TF function, we have
cfg.tf.joint1 = tf(32.54,[1 7.8 -18.56]);
cfg.tf.joint2 = tf(42.41,[1 6.78 -7.69]);
%calculating the control