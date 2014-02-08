%% automatic controller synthesis NOPDT-system

% system definition
D=[1 1 1];
N=[0 0 1];

L=3;

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

% calc singular frequencies for KP=0
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,0,L,D,N,l,0.1);

% calc stabilizable KP interval
[KPmin KPmax]=stableKP_NOPDT(omega0,f1,f2,fn,L,l);

tic
[KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope(f1,f2,fn,KPmin,KPmax,L,D,N,l,0.1);
toc
figure(1)
plot(polyx,polyy);
hold on
plot(polyCOGx,polyCOGy,'*');
title(sprintf('KP=%g',KPAmax));

%% results
KP=KPAmax;
KD=polyCOGx;
KI=polyCOGy;
G=tf(N,D,'InputDelay',L);
Gr=tf([KD KP KI],[1 0]);
Go=series(Gr,G);
Gw=feedback(Go,ss(1));
figure(2)
step(Gw);
title(sprintf('setpoint tracking, KP=%g',KP));
legend('automatic tuning');
grid on
Gz=ss(1)/(1+ss(Go));
figure(3)
step(Gz);
title(sprintf('output disturbance rejection, KP=%g',KP));
legend('automatic tuning');
