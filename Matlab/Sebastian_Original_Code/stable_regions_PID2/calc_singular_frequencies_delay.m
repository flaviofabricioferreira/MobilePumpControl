function [omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,tolerance)

stepsize=0.01;

omega=stepsize;
omega0=[];
i_break=0;
i=1;
y1=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
y2=0;
omegasign=-1;
i=1;
am=0;
while N(i)==0
    i=i+1;
end
am=N(i);
i=1;
bn=0;
while D(i)==0
    i=i+1;
end
bn=D(i);

%% limit function factor
limfac=0;
lf=l;
if mod(l,2)~=0
    lf=l-1;
end
if mod(lf/2,2)==0
    limfac=1;
else
    limfac=-1;
end  
while i_break==0
    y2=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
    if sign(y1)==-sign(y2)
        if isempty(omega0)
            if y2>y1
                omegasign=1;
            end
        end
        omega0=[omega0 (omega-stepsize+omega)/2];
        y1=y2;
        f=(polyval(f1,omega0(end))*sin(omega0(end)*L)+polyval(f2,omega0(end))*cos(omega0(end)*L))/polyval(fn,omega0(end));
        if mod(l,2)==0
            delta=abs(f/(-(bn/am)*limfac*omega0(end)^(l-1)*sin(omega0(end)*L)));
        else
            delta=abs(f/(-(bn/am)*limfac*omega0(end)^(l-1)*cos(omega0(end)*L)));
        end
        if delta<(1+1*tolerance)&&delta>(1-1*tolerance)&&i_break==0
            i_break=1;
        end
    end
    omega=omega+stepsize;
end
jp=1;
jm=1;
omegaplus=zeros(1,ceil(length(omega0)/2));
omegaminus=zeros(1,ceil(length(omega0)/2));
for i=1:length(omega0)
    if omegasign==1
        omegaplus(jp)=omega0(i);
        omegasign=-omegasign;
        jp=jp+1;
    else
        omegaminus(jm)=omega0(i);
        omegasign=-omegasign;
        jm=jm+1;
    end
end
omegaplus=omegaplus(1:jp-1);
omegaminus=omegaminus(1:jm-1);