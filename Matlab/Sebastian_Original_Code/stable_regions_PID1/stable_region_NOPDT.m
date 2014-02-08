function [polyx,polyy]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,show_results)

%########################
% This function extracts the stable region for a n-order system with time
% delay.
% Limitations:
% - degree of numerator >= degree of denominator + 1
% - origin in KD-KI-plane has to be stable
% - only polytopes around the origins are found
%########################

%% positive crossing singular frequencies
u=omegaplus;
count_positive=length(u);

%% calculate boundary offsets g(omega)
g=zeros(1,count_positive);
i_break=0;
for i=1:count_positive
    g(i)=u(i)*((polyval(-f2,u(i))/polyval(fn,u(i)))*sin(u(i)*L)+(polyval(f1,u(i))/polyval(fn,u(i))*cos(u(i)*L)));
    f=(polyval(f1,u(i))*sin(u(i)*L)+polyval(f2,u(i))*cos(u(i)*L))/polyval(fn,u(i));
    delta=abs(f/(u(i)^2*cos(u(i)*L)));
    if delta<1.1&&delta>0.9&&i_break==0
        i_break=i;
    end
end
Aplus=g;

%% plot results
if show_results
    x=[-20^1:1:20^1];
    figure(1)
    hold on
    xlim([-6 6]);
    ylim([-2 2]);
    for i=1:count_positive
        patch([x fliplr(x-0.2) x(1)],[x.*u(i)^2+g(i) fliplr((x).*u(i)^2+g(i)) x(1)*u(1)^2+g(1)],[0.7 0.7 0.7],'LineStyle','none');
        plot(x,x.*u(i)^2+g(i),'-');
    end
end

%% negative crossing singular frequencies
u=omegaminus;
count_positive=length(u);

% calculate boundary offsets g(omega)
g=zeros(1,count_positive);
for i=1:count_positive
    g(i)=u(i)*((polyval(-f2,u(i))/(polyval(fn,u(i))+eps))*sin(u(i)*L)+(polyval(f1,u(i))/(polyval(fn,u(i))+eps)*cos(u(i)*L)));
end
Aminus=g;
A=[0 Aplus Aminus];

if show_results
    x=[-10^1:1:10^1];
    u=[0 u];
    g=[0 g];
    for i=1:count_positive+1
        patch([x fliplr(x+0.2)],[x.*u(i)^2+g(i) fliplr(x).*u(i)^2+g(i)-0.1],[0.7 0.7 0.7],'LineStyle','none');
        plot(x,x.*u(i)^2+g(i),'-');
    end
end

%% determine stable section in KI axis (valid for NOPDT-Systems from here
%% on)
%u=[0 omegaplus omegaminus];
% intx=zeros(1,length(u)-1);
% for i=2:length(u)
%     intx(i-1)=-A(i)/u(i)^2;
% end
% [sintx ind]=sort(intx);
% i=1;
% while sintx(i)<=0
%     i=i+1;
% end
% stablepolyx=[sintx(i-1) sintx(i)];
% stablepolyy=[0 0];
% stablepoly=[ind(i-1)+1 ind(i)+1];
u=omegaplus;
intx=zeros(1,length(u));
for i=1:length(u)
    intx(i)=-Aplus(i)/u(i)^2;
end
[sintx ind]=sort(intx);
i=1;
for z=2:length(u)
    if sintx(z)>sintx(i)
        i=z;
    end
end
stablepolyx=[sintx(i)];
stablepolyy=[0];
stablepoly=[ind(i)+1 1];
u=omegaminus;
intx=zeros(1,length(u));
for i=1:length(u)
    intx(i)=-Aminus(i)/(u(i)^2+eps);
end
[sintx ind]=sort(intx,'descend');
i=1;
for z=2:length(u)
    if sintx(z)<sintx(i)
        i=z;
    end
end
stablepolyx=[stablepolyx sintx(i)];
stablepolyy=[stablepolyy 0];
stablepoly=[stablepoly ind(i)+1+length(omegaplus)];
u=[0 omegaplus omegaminus];
stop=0;
ydirection=-1;
while stop==0
    intx=zeros(1,length(u));
    inty=zeros(1,length(u));
    for i=1:length(u)-1
        if i~=stablepoly(end)
            intx(i)=(A(i)-A(stablepoly(end)))/((u(stablepoly(end))^2-u(i)^2)+0);
            inty(i)=u(i)^2*intx(i)+A(i);
        end
    end
    if ydirection==1
        [sinty,ind]=sort(inty,'descend');
    else
        [sinty,ind]=sort(inty);
    end
    j=1;
    if ydirection==1
        while sinty(j)>=stablepolyy(end)-sqrt(eps)
            j=j+1;
        end
    else
        while sinty(j)<=stablepolyy(end)+sqrt(eps)
            j=j+1;
        end
    end
    %if ind(j)~=stablepoly(end)
        stablepolyx=[stablepolyx intx(ind(j))];
        stablepolyy=[stablepolyy sinty(j)];
        stablepoly=[stablepoly ind(j)];
    %end

    if (u(ind(j))>0)&&(A(ind(j))>0)
        ydirection=1;
    else
        ydirection=-1;
    end
%     if round(10000*stablepolyx(end))==round(10000*stablepolyx(1))&&round(10000*stablepolyy(end))==round(10000*stablepolyy(1))
%         stop=1;
%     end
    if stablepoly(end)==stablepoly(1)
        stop=1;
    end
end

polyx=[stablepolyx stablepolyx(1)];
polyy=[stablepolyy stablepolyy(1)];
