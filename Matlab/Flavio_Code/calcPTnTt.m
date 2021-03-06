%###############################################
% calculate PTn-Tt from measured step response
% SCHWARZE
%###############################################

load Scope1

%% read data sets
xval=ScopeData.signals(1,2).values(120:300);
yval=ScopeData.signals(1,1).values(120:300);

timevec=0:1:length(yval)-1;%0-180

%% determine x direction
dirx=0;
if xval(end)>xval(1)
    dirx=1;% This direction   ---->
else
    dirx=-1;% This direction <----
end

%% determine steptime
dxdt=zeros(1,length(xval)); % is an 1-by-180 matrix of zeros.
maxdxdt=0;
maxdxdtx=0;

for z=2:length(xval)-1      % Calculus of the maximum Delta
    dxdt(z)=dirx*(xval(z)-xval(z-1));
    if dxdt(z)>maxdxdt
        maxdxdt=dxdt(z);
        maxdxdtx=z;
    end
end

tstep=maxdxdtx;
while dxdt(tstep-1)<0.999*dxdt(tstep)
    tstep=tstep-1;
end

%% calculate start and end value
xstart=xval(tstep-1);
xend=xval(end);
ystart=mean(yval(1:tstep))
yend=mean(yval(end-10:end))
ABCD = yval(end-10:end)


%% determine y direction
diry=0;
if yend>ystart
    diry=1;
else
    diry=-1;
end

%% determine deadtime Tt
dydt=zeros(1,length(yval));
maxdydt=0;
maxdydtx=0;
for z=2:length(yval)-1
    dydt(z)=diry*(yval(z+1)-yval(z-1))/2;
    if dydt(z)>maxdydt
        maxdydt=dydt(z);
        maxdydtx=z;
    end
end 
Tt=tstep;
n1 = max(dydt(tstep-10:tstep))
n2 = min(dydt(tstep-10:tstep))
dydtnoise=n1-n2;
%%dydtnoise=(max(dydt(tstep-10:tstep))-min(dydt(tstep-10:tstep)));
while dydt(Tt+1)<=mean(dydt(tstep-10:tstep))+dydtnoise;
    Tt=Tt+1;
end
Tt=Tt-tstep-1

%% flip yval if necessary
if diry==-1
    yval=(ystart+yend)-yval;
    yend2=ystart;
    ystart=yend;
    yend=yend2;
end

%% calculate t10
t10=tstep+Tt;
yval(t10);
ystart;
yend;
yend-ystart;

while yval(t10)-ystart<=0.1*(yend-ystart)
    t10=t10+1;
end
t10=t10-tstep-Tt;

%% calculate t70
t50=tstep+Tt;
while yval(t50)-ystart<=0.5*(yend-ystart)
    t50=t50+1;
end
t50=t50-tstep-Tt;

%% calculate t90
t90=tstep+Tt;
while yval(t90)-ystart<=0.9*(yend-ystart)
    t90=t90+1;
end
t90=t90-tstep-Tt;

%% find nearest zeitprozentkennwert 
%% find nearest time percentage characteristic value
n=0;
mue_n=0;
mue_n_m1=0;
while (t10/t90 > mue_n)&&n<25
    mue_n_m1=mue_n;
    n=n+1;
    mue_n=zeitprozentkennwert(n,10)/zeitprozentkennwert(n,90);
end
if abs(t10/t90-mue_n_m1)<abs(t10/t90-mue_n)
    n=n-1;
end
%% calculate T

% t10
% zpkn10 = zeitprozentkennwert(n,10)
% div1 = t10/zpkn10
% t50
% zpkn50 = zeitprozentkennwert(n,50)
% div2 = t50/zpkn50
% t90
% zpkn90 = zeitprozentkennwert(n,90)
% div3 = t90/zpkn90
% T1=1/3*(t10/zpkn10+t50/zpkn50+t90/zpkn90)

T1=1/3*(t10/zeitprozentkennwert(n,10)+t50/zeitprozentkennwert(n,50)+t90/zeitprozentkennwert(n,90))

%% calculate K
K=(yend-ystart)/abs(xend-xstart)*dirx*diry
order=n

%% plot results
fprintf('---------------------------------------------------------------------------')
Gref=tf(K,1,'InputDelay',Tt)%InputDelay is a numeric vector specifying a time delay for each input channel
%%Gref=tf(K,1)%InputDelay is a numeric vector specifying a time delay for each input channel
fprintf('---------------------------------------------------------------------------')
%Gref= K*exp(-Tt*s)
for i=1:n
    Gref=Gref*tf(1,[T1 1]);%K*exp(-Tt*s)*   1      
                                         %  (s*T1+1)^n
end
figure(1)
uvec=0.*timevec;
uvec(tstep:end)=xend-xstart;
yref=lsim(Gref,uvec,timevec).*diry+ystart;
plot(timevec,yval,'.');
hold on
plot(yref,'r');
legend('measured data','reference system');
systext=sprintf('$\\frac{%g}{(%.2f\\cdot s+1)^%i}\\cdot e^{-%.1f\\cdot s}$',K,T1,n,Tt);
text(0.5*length(yval),yend*0.5,systext,'interpreter','Latex','FontSize',24,'BackgroundColor',[1 1 1],'EdgeColor',[0 0 0]);
grid on

% figure(1)
% subplot(2,1,1);
% uvec=0.*timevec;
% uvec(tstep:end)=xend-xstart;
% yref=lsim(Gref,uvec,timevec+450).*diry+ystart;
% plot(ScopeData.time,ScopeData.signals(1,1).values,'.');
% hold on
% plot(timevec+450,yref,'r');
% legend('measured data','reference system');
% %systext=sprintf('$\\frac{%g}{(%.2f\\cdot s+1)^%i}\\cdot e^{-%.1f\\cdot s}$',K,T1,n,Tt);
% %text(0.5*length(yval),yend*0.5,systext,'interpreter','Latex','FontSize',14,'BackgroundColor',[1 1 1],'EdgeColor',[0 0 0]);
% grid on
% subplot(2,1,2);
% plot(ScopeData.time,ScopeData.signals(1,2).values(:,2),'.');
% hold on
% plot(ScopeData.time,ScopeData.signals(1,1).values,'-');
% legend('q_{mes}','q_{est}');


%% create workspace variables
Tt=Tt;
T1=T1;
Gref=tf(K,1,'InputDelay',Tt);
for i=1:n
    Gref=Gref*tf(1,[T1 1]);
end
[z,n]=tfdata(Gref,'v');