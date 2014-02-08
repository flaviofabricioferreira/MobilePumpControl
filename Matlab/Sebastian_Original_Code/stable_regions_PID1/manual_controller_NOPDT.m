%% manual controller synthesis NOPDT-system

% system definition
D=[1 1 1];
N=[0 0 1];

Ks2=2*3.897;
Gs2=tf(1,[6.428 1]);
Gs2=Gs2^3*tf(1,[1]);
[Ns,Ds]=tfdata(Ks2*Gs2,'v');
Gs2=tf(Ks2,[10 1])*Gs2;
[N,D]=tfdata(Gs2,'v');
L=11;

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

% calc singular frequencies
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,0,L,D,N,l,0.1,1);

%stable KP
[KPmin KPmax]=stableKP_NOPDT(omega0,f1,f2,fn,L,l,Ns);

KP=input(sprintf('\nstable KP [%g , %g]:',KPmin,KPmax));

% calc singular frequencies
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.1,0);

%calculate stable region
[polyx,polyy]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,1);
plot(polyx,polyy,'g');

%manual vs automatic controller placement
xlabel('KD');
ylabel('KI');
title(sprintf('place controller manually, KP=%g',KP));
grid on
%[KD KI]=ginput(1);
[polyA,KDa,KIa]=calc_polygon_surface_COG(polyx,polyy);

KD=KDa;
KI=KIa;

%fast=input('fast/slow controller? (1 or 0):');
fast=1;

G=tf(Ns,Ds,'InputDelay',L);
Gr=tf([KD KP KI],[10 1 0]);
Go=series(Gr,G);
Gw=minreal(feedback(Go,ss(1)));
figure(2)
%step(Gw);
hold on
Gz=ss(1)/(1+ss(Go));
figure(3)
%step(Gz);
hold on
if fast<1
    KDa=0;
    KIa=0.5*KIa;
end
Gr=tf([KDa KP KIa],[10 1 0]);
Go=series(Gr,G);
Gw=feedback(Go,ss(1));
figure(2)
step(Gw);
title(sprintf('setpoint tracking, KP=%g',KP));
legend('manual synthesis','automatic synthesis');
grid on
figure(3)
Gz=ss(1)/(1+ss(Go));
step(Gz);
title(sprintf('output disturbance rejection, KP=%g',KP));
legend('manual synthesis','automatic synthesis');
grid on
figure(1)
hold on
plot(KDa,KIa,'r*');
plot(KD,KI,'o');
