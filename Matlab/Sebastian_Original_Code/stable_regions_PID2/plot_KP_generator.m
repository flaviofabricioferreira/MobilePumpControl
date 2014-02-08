%% plot KP generator

%system definition
D=[1 1 1];
N=[0 0 1];

L=5;
KP=-0.4;

%calculate d composition
[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);

omegavec=0.001:0.1:20;
y=zeros(1,length(omegavec));
for i=1:length(omegavec)
    omega=omegavec(i);
    y(i)=(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
end

figure(1)
grid on
hold on
plot(omegavec,y);
plot([omegavec(1) omegavec(end)],[KP KP],'r');