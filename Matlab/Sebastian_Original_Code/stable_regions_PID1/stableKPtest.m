% test stable KP interval delay

D=[1 1 1];
N=[0 0 1];
L=3;
KP=0;


[Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N);
[omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,0.2);

mr=0;
mi=0;
mid=0;
m0=0;

kappa=1;

stop=0;
while stop==0&&kappa<50    

    R=((2*kappa)+mod(l,2)-1)/(2*L)*pi;

    z_min=kappa+mr+(mi+mid)/2+ceil(l/2)+ceil(m0/2)-1;
    omega_in_R=find(omega0<=R);
    if length(omega_in_R)>=z_min
        stop=1;
    else
        kappa=kappa+1;
    end
end
if kappa==50
    fprintf(2,'fail - no stable regions\n');
    return
end


omegavec=0.001:0.01:ceil(R);
y=zeros(1,length(omegavec));
for i=1:length(omegavec)
    omega=omegavec(i);
    y(i)=(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
end

omega0=omega0(omega_in_R);
minKPvec=zeros(1,length(omega0));
maxKPvec=zeros(1,length(omega0));
gradient=sign(y(2)-y(1));

j=1;
z=1;
x1=1;
x2=1;
% works only with rising initial gradient for now
ismin=1;
for i=1:length(omega0)
    while omegavec(x2)<omega0(i)
        x2=x2+1;
    end
    if ismin==1
        minKPvec(j)=min(y(x1:x2));
        ismin=-ismin;
        j=j+1;
    else
        maxKPvec(z)=max(y(x1:x2));
        ismin=-ismin;
        z=z+1;
    end
    x1=x2;
end
minKPvec=minKPvec(1:j-1);
maxKPvec=maxKPvec(1:z-1);

KPmin=max(minKPvec);
KPmax=min(maxKPvec);
        
    
figure(1)
grid on
hold on
plot(omegavec,y);
plot(omega0,0,'r*');
plot([omegavec(1) omegavec(end)],[KPmax KPmax],'r');
plot([omegavec(1) omegavec(end)],[KPmin KPmin],'r');
xlabel('\omega');
ylabel('KP(\omega)');
title(sprintf('KP_{min}=%g, KP_{max}=%g',KPmin,KPmax));