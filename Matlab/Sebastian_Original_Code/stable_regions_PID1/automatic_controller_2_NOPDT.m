%% automatic controller synthesis NOPDT-system
tic
% system 1 definition
Gs1=Gref1;
[Ns1,Ds1]=tfdata(Gs1,'v');
Gs1=tf(1,[1 1])*Gs1;
[N1,D1]=tfdata(Gs1,'v');
L1=get(Gref1,'OutputDelay');

% system 2 definition
Gs2=Gref2;
[Ns2,Ds2]=tfdata(Gs2,'v');
Gs2=tf(1,[1 1])*Gs2;
[N2,D2]=tfdata(Gs2,'v');
L2=get(Gref2,'OutputDelay')+10;

%% stable KP-interval system 1

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D1,N1);

[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,0,L1,D1,N1,l,0.1,1);

% calc stabilizable KP interval
[KPmin KPmax]=stableKP_NOPDT(omega0,f1,f2,fn,L1,l,Ns1);
KPmin1=0.9*KPmin;
KPmax1=0.9*KPmax;

%% stable KP-interval system 2

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D2,N2);

[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,0,L2,D2,N2,l,0.1,1);

% calc stabilizable KP interval
[KPmin KPmax]=stableKP_NOPDT(omega0,f1,f2,fn,L2,l,Ns2);
KPmin2=0.9*KPmin;
KPmax2=0.9*KPmax;

%% overlapping stable KP-interval
KPmin=max([KPmin1 KPmin2]);
if KPmin<0
    KPmin=0;
end
KPmax=min([KPmax1 KPmax2]);

if KPmax2<KPmax1
    [Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D2,N2);
    [KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope(f1,f2,fn,0,KPmax2,L2,D2,N2,l,0.1);
else
    [Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D1,N1);
    [KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope(f1,f2,fn,0,KPmax1,L1,D1,N1,l,0.1);
end

%KP=0.1*KPmax;
KP=KPAmax;

%% stable region system 1
% calc singular frequencies
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D1,N1);
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L1,D1,N1,l,0.1,0);
%calculate stable region
[polyx1,polyy1]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L1,0);

%% stable region system 2
% calc singular frequencies
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D2,N2);
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L2,D2,N2,l,0.1,0);
%calculate stable region
[polyx2,polyy2]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L2,0);

figure(1)
plot(polyx1,polyy1);
hold on
plot(polyx2,polyy2,'r');
[polyx,polyy]=intersect_polygones(polyx1,polyy1,polyx2,polyy2);
plot(polyx,polyy,'g');
toc


[polyA,polyCOGx,polyCOGy,incircle_r,KImax]=calc_polygon_surface_COG(polyx,polyy);


toc
plot(polyCOGx,polyCOGy,'*');
title(sprintf('KP=%g',KPAmax));

%% results
KP=KPAmax;
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

G=tf(N1,D1,'InputDelay',L1);
Gr=tf([KD KP KI],[1 0]);
Go=series(Gr,G);
Gw=feedback(Go,ss(1));
figure(2)
hold on
step(Gw);
G=tf(N2,D2,'InputDelay',L2);
Gr=tf([KD KP KI],[1 0]);
Go=series(Gr,G);
Gw=feedback(Go,ss(1));
step(Gw);
title(sprintf('setpoint tracking, KP=%g',KP));
legend('automatic tuning');
grid on
% Gz=ss(1)/(1+ss(Go));
% figure(3)
% step(Gz);
% title(sprintf('output disturbance rejection, KP=%g',KP));
% legend('automatic tuning');