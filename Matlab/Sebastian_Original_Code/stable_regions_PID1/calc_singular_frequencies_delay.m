function [omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,tolerance,calcKPint)

%% solver settings
stepsize=0.001;
stepfine=0.0001;
minstep=1e-5;
stepsize_orig=stepsize;

omega=minstep;
omega0=[];
omega0type=[];
i_break=0;
i=1;
y1=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
dy1dt=(-KP+(polyval(f1,omega+minstep)*sin((omega+minstep)*L)+polyval(f2,omega+minstep)*cos((omega+minstep)*L))/polyval(fn,omega+minstep))-y1;
y2=0;
omegasign=-1;

%% initialize limit function
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


%% find singular freqs
max_i=20;
if calcKPint
    max_i=30;
end
while i_break<max_i
    %calc next y(omega+delta) and its gradient
    y2=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
    dy2dt=(-KP+(polyval(f1,omega+minstep)*sin((omega+minstep)*L)+polyval(f2,omega+minstep)*cos((omega+minstep)*L))/polyval(fn,omega+minstep))-y2;
    
    %detect change in sign,
    %if sign changed refine stepsize and search in opposite direction until
    %sign changes again
    if sign(y1)==-sign(y2)
        if isempty(omega0)
            if y2>y1
                omegasign=1;
            end
        end
        omegafine=omega-stepsize;
        
        %detect change of sign in opposite direction
        while sign(-KP+(polyval(f1,omegafine)*sin(omegafine*L)+polyval(f2,omegafine)*cos(omegafine*L))/polyval(fn,omegafine))~=sign(y2)
            omegafine=omegafine+stepfine;
        end
        
        %add omega to omega0 vector
        omega0=[omega0 (omegafine-stepfine+omegafine)/2];
        
        %add type to omega0type vector (1==rising, -1==falling)
        if dy2dt>0
            omega0type=[omega0type 1];
        else
            omega0type=[omega0type -1];
        end
        
        %replace y1 by y2 (incl. gradients)
        y1=y2;
        dy1dt=dy2dt;
        
        %check if tolerance is reached
        f=(polyval(f1,omega0(end))*sin(omega0(end)*L)+polyval(f2,omega0(end))*cos(omega0(end)*L))/polyval(fn,omega0(end));
        if mod(l,2)==0
            delta=abs(f-(-(bn/am)*limfac*omega0(end)^(l-1)*sin(omega0(end)*L)));
        else
            delta=abs(f-(-(bn/am)*limfac*omega0(end)^(l-1)*cos(omega0(end)*L)));
        end
        if (delta/f>=1-tolerance)||i_break>0
            i_break=i_break+1;
        end
        %plot(omega0(end),0,'ro');
        stepsize=stepsize_orig;
        
    %check if initial stepsize is too large and refine stepsize if
    %necessary
    elseif (sign(dy1dt)==-1&&sign(dy2dt)==1)&&(y1>0&&y2>0)||(sign(dy1dt)==1&&sign(dy2dt)==-1)&&(y1<0&&y2<0)&&stepsize>minstep
        omega=omega-(2*stepsize);
        stepsize=stepsize/10;
    
    %between two zero crossings - proceed with increased omega after
    %calculating gradient of y1
    else                       
        dy1dt=(-KP+(polyval(f1,omega+minstep)*sin((omega+minstep)*L)+polyval(f2,omega+minstep)*cos((omega+minstep)*L))/polyval(fn,omega+minstep))-y2;
        omega=omega+stepsize; 
    end
end

%separate omega0 vector into omega+ and omega- vectors
jp=1;
jm=1;

omegaplus=zeros(1,ceil(length(omega0)/2))
omegaminus=zeros(1,ceil(length(omega0)/2))
omega0
for i=1:length(omega0)
    fprintf('\n=====ITERATION %d =====\n',i)
    if omega0type(i)==1
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


% %% plot results
% omegavec=omega0(1):0.0001:10;
% y=zeros(1,length(omegavec));
% for i=1:length(omegavec)
%     omega=omegavec(i);
%     y(i)=-KP+(polyval(f1,omega)*sin(omega*L)+polyval(f2,omega)*cos(omega*L))/polyval(fn,omega);
% end
% 
% figure(1)
% grid on
% hold on
% plot(omegavec,y);
% plot([omegavec(1) omegavec(end)],[0 0],'r');
% plot(omegaplus,zeros(length(omegaplus),1),'go');
% plot(omegaminus,zeros(length(omegaminus),1),'ro');
