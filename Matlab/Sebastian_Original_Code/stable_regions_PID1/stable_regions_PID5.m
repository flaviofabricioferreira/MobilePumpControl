clear polyx polyy
%% system definition
%D=[1 8 32 46 46 17];
%N=[0 0 1 -4 1 2];
N=[0 0.109693 0.0728112 0.7354 0.318 1];
D=[1.41834 3.39206 7.62744 5.9986 3.33 1];

%N=[0 0 0 -0.5 -7 -2 1];
%D=[1 11 46 95 109 74 24];

%N=[0 1 3 0 9];auto
%D=[1 2 3 7 14];

%G=tf(1,[1 1]);
%G=G^1;

%G=tf(1,[1 1])*tf(1,[1 2])*tf(1,[1 3])*tf(1,[1 4])*tf(1,[1 1 1]);
%[N,D]=tfdata(G,'v');
%N=[0 0 -1 -7 0 -2 1];

%G=tf(1,[0.646569 1]);
%G=G^9;
%G=0.005029*G;


%G1=tf(4,[0.1 1]);
%G2=tf(1,[0.1 1]);
%G3=tf(1,[0.3 1]);
%G4=tf([-0.1 1],[0.1^2 2*0.1*0.1 1]);
%G=G1*G2*G3*G4;
%[N D]=tfdata(G,'v');

Gs=minreal(Model_pe);
[Ns,Ds]=tfdata(Gs,'v');
Gs=tf(1,[1 1])*Gs;
[N,D]=tfdata(Gs,'v');
for i=1:length(N)
    if abs(N(i))<1e-8
        N(i)=0;
    end
end

%D=[1 1 1];
%N=[0 0 1];

%D=[D 0];
%N=[0 N];

KP=1;

clc
%tic

% set parameter space boundaries
lb=-5000;
ub=5000;

% perform nyquist-decomposition
[De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N);

% calculate stable KP intervals
[stable_KP_intervals]=stableKP_NO(N,D,De,Do,X,Y,Z,n,m,0);
KPmin=min(stable_KP_intervals);
KPmax=max(stable_KP_intervals);
KPmin=0;

%[KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope_NO(KPmin,KPmax,D,N,X,Y,Z,ub,lb,n,m);

% % let user choose KP
% KP=input('\nchoose KP:');
KP=0.5*KPmax;
%KP=1;

% calculate all polygones and unstable poles count for specified KP
[polynum,polyx,polyy,polynsp,polylength]=stable_region_NO(N,D,X,Y,Z,ub,lb,KP,n,m,1);

%% plot polytopes
figure(6)
hold on
xlabel('KD');
ylabel('KI');
title(sprintf('stable PID parameter regions for KP=%g',KP));
plot(0,0,'o');
limx=[0 0];
limy=[0 0];
optimalpolyx=0;
optimalpolyy=0;
optimalpolyA=0;
for z=1:polynum
    %figure(z)
    %hold on
    if polynsp(z)<=0
        if limx(1)>min(polyx(z,:))
            limx(1)=min(polyx(z,:));
        end
        if limx(2)<max(polyx(z,:))
            limx(2)=max(polyx(z,:));
        end
        if limy(1)>min(polyy(z,:))
            limy(1)=min(polyy(z,:));
        end
        if limy(2)<max(polyy(z,:))
            limy(2)=max(polyy(z,:));
        end
    end
    plotx=[polyx(z,1:polylength(z)) polyx(z,1)];
    ploty=[polyy(z,1:polylength(z)) polyy(z,1)];  
    if polynsp(z)<=0
        patch(plotx,ploty,[1 1 1],'LineStyle','none');
    end
    plot(plotx,ploty,'b-');
    
    [polyA,COGx,COGy,incircle_r,KImax]=calc_polygon_surface_COG(polyx(z,1:polylength(z)),polyy(z,1:polylength(z)));
    
    if abs(polyA)>optimalpolyA&&polynsp(z)<=0
        optimalpolyA=abs(polyA);
        optimalpolyCOGx=COGx;
        optimalpolyCOGy=COGy;
        optimalpolyx=plotx;
        optimalpolyy=ploty;
    end
    text(COGx,COGy,sprintf('%i',polynsp(z)));
end
set(gca,'Color',[0.7 0.7 0.7]);
%plot(intx,inty,'*');

xlabel('KD');
ylabel('KI');
xlim([limx(1)-0.1*(limx(2)-limx(1)),limx(2)+0.1*(limx(2)-limx(1))]);
ylim([limy(1)-0.1*(limy(2)-limy(1)),limy(2)+0.1*(limy(2)-limy(1))]);

plot(optimalpolyCOGx,optimalpolyCOGy,'o');

%[KD KI]=ginput(1);

KD=optimalpolyCOGx;
KI=optimalpolyCOGy;

% %slower controller
% x1=(optimalpolyx(2)+optimalpolyx(3))/2;
% y1=0;
% x2=optimalpolyCOGx;
% y2=optimalpolyCOGy;
% x=(optimalpolyCOGx+x1)/2;
% m=(y2-y1)/(x2-x1);
% b=-m*x1;
% KI=m*x+b;
% KD=x;
% 
% KI=0.2*KI;
% KD=0.2*KD;

plot(KD,KI,'r*');


%toc
Gr=tf([KD KP KI],[1 0]);
G=tf(N,D);
Go=Gr*G;
Gw=minreal(Go/(1+Go));
%Gw=(Go/(1+Go));
figure(2)
step(Gw);



% calculate all polygones and unstable poles count for specified KP
[polynum,polyx,polyy,polynsp,polylength]=stable_region_NO(N,D,X,Y,Z,ub,lb,KP,n,m,0);
figure(10)
plot([polyx(1:polylength) polyx(1)],[polyy(1:polylength) polyy(1)]);
hold on
xlabel('KD');
ylabel('KI');