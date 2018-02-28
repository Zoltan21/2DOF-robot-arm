# README #

This repository contains packages related to a 2 degrees of freedom (2DOF) arm experiment.
 We have 3 main packages:

 	- Robot Arm Model

 	- Robot Arm Control

 	- optimal PID parameters

The purpose of packages is to run the experiments separately, and to get a well organised structure.

RUN startup.m first

More details on the 2DOF robot arm can be found in detailed_desciption_2DOF_RobotArm.pdf file. Read this first!

Robot Arm Model package

This package contains the mathematical model of this robot arm. Based on the Newton-Euler iteration the corresponding mathematical model was found. This method contains three steps: 

		1. Geometric model

		2. Kinematic model

		3. Dynamic model

If you want to read in details about these models, follow the link: http://www6.in.tum.de/burschka/courses/robotics/aufgaben/solution04.pdf, This .pdf is similar to the book from where I obtained the model. I will also put here my pdf related to this topic.
The important files are always the one which contains "main". In order to obtain the dynamical model you have to run the main.m file from This package. We used our best knowledge to calculate and estimate the parameters. The measured and estimated parameters are available in dataSet_NONLINEAR_2joints.m file. Also in this file you can set the linearization points, because there is a linearized model available also.

So if you run the main script you get the dynamic model of the system. There are several representation available for this in structure form:

	- dynamic_model: structure containing M, B, C, G, F matrices The form of the model is Qm = M(q)*ddq + (B(q,dq)+F)*dq + C(q)*dq^2 + G(q), where ddq - angular acceleration vector, dq - angular velocity vector

	- dynamic_evaluated_model: the same thing but evaluated using the parameters described in dataSet_NONLINEAR_2joints.m - q, dq - unknown

	- linearized_model - linearized version M, B, D, G, F: structure: Qm = M(q)*ddq + (B(q,dq)+F)*dq + G(q), ATTENTION: the B here is not the same as the B in the previous structure

	- linearized_evaluated_model: - 

	- linearized_state_space_model: A, B: dx=Ax+Bu, the model was reformulated to get in the classical form x=[q' dq']', u=Qm--the torque

	- linearized_disc_state_space_model: same but in discrete-time: ATTENTION - You also have to set the sampling time for this case. SET FLAG: Ts

Also if you want to simulate this system there are some available Simulink models for this. To do this go to the Simulink folder. The last part of the main script asks you if you want to update the Simulink model, make sure that the corresponding Simulink model is opened for this.

Robot Arm Control package

In this package the main file is modular_funct.m. This is a scelet for simple read and write operation.

Optimal PID package

This package contains an optimization algorithm to find the optimal PID parameters based on the model.
