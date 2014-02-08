%% plot KP generator

%system definition
N=[0 0 1];
D=[1 1 1];

[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);
L=10;


omegavec=0.001:0.01:100;
y=zeros(1,length(omegavec));
for i=1:length(omegavec)
    omega=omegavec(i);
    y(i)=((polyval(f1,omega)/polyval(fn,omega))*sin(L*omega))+(polyval(f2,omega)/polyval(fn,omega))*cos(L*omega);
    %y(i)=omega*sin(omega);%+cos(omega);
end

figure(1)
grid on
hold on
plot(omegavec,y);
plot([omegavec(1) omegavec(end)],[0 0],'--');
%plot([roots(N)],zeros(1,length(roots(N))),'r*');
for k=1:1:50
    plot((k*pi/L-0.5*pi/L),0,'o');
    %plot((k*pi/L),0,'ro');
end