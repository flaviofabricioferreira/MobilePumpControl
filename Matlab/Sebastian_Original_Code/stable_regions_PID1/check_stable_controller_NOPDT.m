%% check if controller is stable for NOPDT-system

% system 1 definition
Gs=Gref;
[Ns,Ds]=tfdata(Gs,'v');
Gs=tf(1,[1 1])*Gs;
[N,D]=tfdata(Gs,'v');
L=get(Gref,'OutputDelay');

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

%calc singular frequencies
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.1,0);
%calculate stable region
[polyx1,polyy1]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,0);



% system 2 definition
Gs=1*Gref;
[Ns,Ds]=tfdata(Gs,'v');
Gs=tf(1,[10 1])*Gs;
[N,D]=tfdata(Gs,'v');
L=get(Gref,'OutputDelay');

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% perform d-composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

%calc singular frequencies
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.1,0);
%calculate stable region
[polyx2,polyy2]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,0);

[polyx,polyy]=intersect_polygones(polyx1,polyy1,polyx2,polyy2);

figure(1)
hold on
plot(polyx1,polyy1,'Color',[0.8 0.8 0.8]);
plot(polyx2,polyy2,'Color',[0.8 0.8 0.8]);
plot(polyx,polyy);
plot(KD,KI,'*');
title(sprintf('KP=%g',KP));
xlabel('KD');
ylabel('KI');
