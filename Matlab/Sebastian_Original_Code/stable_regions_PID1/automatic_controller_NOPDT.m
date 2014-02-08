%% automatic controller synthesis NOPDT-system

% system definition
Ks=0.0050295;
Gs=tf(1,[10.05 1]);
Gs=Gs^4
[Ns,Ds]=tfdata(Ks*Gs,'v');
Gs=tf(Ks,[0.1 1])*Gs;
[N,D]=tfdata(Gs,'v')
L=18;

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

% calc singular frequencies for KP=0
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,0,L,D,N,l,0.1,1)


% calc stabilizable KP interval
[KPmin KPmax]=stableKP_NOPDT(omega0,f1,f2,fn,L,l,Ns);
KPmin=0.8*KPmin;
KPmax=0.8*KPmax;

tic
[KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope(f1,f2,fn,KPmin,KPmax,L,D,N,l,0.1);


KP=0.05*KPmax;
%KP=KPAmax;
% calc singular frequencies
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.1,0);
%calculate stable region
[polyx,polyy]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,0);
[polyA,polyCOGx,polyCOGy,incircle_r,KImax]=calc_polygon_surface_COG(polyx,polyy);


toc
figure(1)
plot(polyx,polyy);
hold on
plot(polyCOGx,polyCOGy,'*');
title(sprintf('KP=%g',KP));

%% results
%KP=KPAmax;
KD=polyCOGx;
KI=polyCOGy;

% %slower controller
% x1=(polyx(1)+polyx(2))/2;
% y1=0;
% x2=polyCOGx;
% y2=polyCOGy;
% x=(polyCOGx+x1)/2;
% m=(y2-y1)/(x2-x1);
% b=-m*x1;
% KI=m*x+b;
% KD=x;
% plot(KD,KI,'r*');

%[KD KI]=ginput(1);

G=tf(Ns,Ds,'InputDelay',L);
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
