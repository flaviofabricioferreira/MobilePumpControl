%% plot KP generator

%system definition
D=[1 1 1];
N=[0 0 1];

L=2;
KP=0.5;

G1=tf([-4 1],[1 1]);
G2=tf([-7 1],[5 1]);
G3=tf([-7 1],[9 1]);
G4=tf([9 2*0.3*(-3) 1],[100 2*10*0.4 1]);
G=G1*G2*G3*G4;
G=G*tf(1,[0.1 1]);
[N,D]=tfdata(G,'v');

KP=-0.6;
L=40;

%calculate d composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

omegavec=0.001:0.001:10;
y=zeros(1,length(omegavec));
for i=1:length(omegavec)
    omega=omegavec(i);
    y(i)=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
end

figure(1)
grid on
hold on
plot(omegavec,y);
plot([omegavec(1) omegavec(end)],[0 0],'r');

[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.3,0);
plot(omega0,0.*ones(1,length(omega0)),'o');