function [stable_KP_intervals]=stableKP_NO(N,D,De,Do,X,Y,Z,n,m,show_results)

%% stable KP region (KI,KD=0!) (Munro et al. 1999)
%roots of X(u)
rx=roots(X)';
count_positive=length(find(rx>0));
rxv=zeros(1,count_positive);
j=1;
for i=1:length(rx)
    if rx(i)>0
        rxv(j)=rx(i);
        j=j+1;
    end
end
count_positive=length(find(imag(rxv)==0));
rx=zeros(1,count_positive);
j=1;
for i=1:length(rxv)
    if imag(rxv(i))==0
        rx(j)=rxv(i);
        j=j+1;
    end
end
rx=[rx 0 Inf];
grx=polyval(Y,rx)./polyval([0,conv(De,De)]+[conv(Do,Do),0],rx);
nanind=find(isnan(grx));
if isempty(nanind)==0
    grx(nanind)=0;
end
[sgrx ind]=sort(grx);
rx=rx(ind);
sgrx=[sgrx Inf];
c=-1./sgrx;

if sign(sgrx(1))~=sign(sgrx(end))
    i=1;
    while (i<=length(c))&&(sign(c(i))~=-1)
        i=i+1;
    end
    c=[c(1:i-1),Inf,c(i:end)];
end
signswitch=i;
if signswitch>length(c)
    signswitch=-1;
end
if c(1)~=-Inf
    c=[0 c];
end


etaintervals=zeros(length(c)-2,2);
for i=1:length(c)-2
    if i<=signswitch
        etaintervals(i,1)=c(i);
        etaintervals(i,2)=c(i+1);
    else
        etaintervals(i,1)=c(i+1);
        etaintervals(i,2)=c(i+2);
    end
end

% calculate derivatives of X(u) 
nX=length(X);
dX=zeros(nX,nX);
for i=1:nX
    for j=1:nX-1
        if i==1
            dX(i,j+1)=X(j)*(nX-j);
        else
            dX(i,j+1)=dX(i-1,j)*(nX-j);
        end
    end
end

i=1;
while X(i)==0
    i=i+1;
end
beta1=X(i);
beta0=X(end);
eta=zeros(length(sgrx),1);
eta0=length(find(real(roots(D))>0));
for i=1:length(sgrx)
    sumrj=0;
    for j=1:i-1
        rjadd=0;
        if rx(j)==0
            rjadd=-sign(beta0);
        elseif rx(j)==Inf
            rjadd=sign(beta1);
        else
            l=1;
            while polyval(dX(l,:),rx(j))==0
                l=l+1;
            end
            rjadd=(-1+(-1)^l)*sign(polyval(dX(l,:),rx(j)));
        end
        sumrj=sumrj+rjadd;
    end
    eta(i,1)=eta0+sumrj;
end


%% stable KP region (Soeylemez 2003)
%check if f(u)==const
if sum(Y-Z)==0
    fprintf(2,'f==const!\n');
    return;
end
%define V(u)
dY1=zeros(1,length(Y));
for j=1:length(Y)-1
    dY1(j+1)=Y(j)*(length(Y)-j);
end
dZ1=zeros(1,length(Z));
for j=1:length(Z)-1
    dZ1(j+1)=Z(j)*(length(Z)-j);
end
V=conv(Y,dZ1)-conv(dY1,Z);
% calculate positive real roots zeta of X(u)*V(u)
zetav=roots(conv(X,V));
count_positive=length(find(zetav>0));
zeta=zeros(1,count_positive);
j=1;
for i=1:length(zetav)
    if zetav(i)>0
        zeta(j)=zetav(i);
        j=j+1;
    end
end
zetav=zeta;
count_positive=length(find(imag(zetav)==0));
zeta=zeros(1,count_positive);
j=1;
for i=1:length(zetav)
    if imag(zetav(i))==0
        zeta(j)=zetav(i);
        j=j+1;
    end
end
zeta=sort(zeta);
zeta=[0 zeta 1e99];
%construct squared frequency intervals Ui
Ui=zeros(length(zeta)-1,2);
for i=2:length(zeta)
    Ui(i-1,1)=zeta(i-1);
    Ui(i-1,2)=zeta(i);
end

%calculate dUi
dUi=zeros(1,length(zeta)-1);
dUilowerzero=0;
for i=1:length(dUi)
    dUi(i)=2*sign(polyval(V,(zeta(i)+zeta(i+1))/2))*sign(polyval(X,(zeta(i)+zeta(i+1))/2));
    if dUi(i)<0
        dUilowerzero=dUilowerzero+1;
    end
end

%calculate Ki
Ki=zeros(length(zeta)-1,2);
for i=1:length(zeta)-1
    f1=-polyval(Y,zeta(i))/polyval(Z,zeta(i));
    f2=-polyval(Y,zeta(i+1))/polyval(Z,zeta(i+1));
    Ki(i,1)=min([f1,f2]);
    Ki(i,2)=max([f1,f2]);
end

%calculate mue
%find Ki intervals with dUi<0
Ki_effective=zeros(1,dUilowerzero);
dividezero=0;
j=1;
for i=1:length(dUi)
    if dUi(i)<0
        Ki_effective(1,j)=i;
        if sign(Ki(i,1))~=sign(Ki(i,2))
            dividezero=dividezero+1;
        end
        j=j+1;
    end
end
Ki_intervals=zeros(dUilowerzero+dividezero,2);
Ki_dUi=zeros(dUilowerzero+dividezero,1);

j=1;
for i=1:dUilowerzero
    if sign(Ki(Ki_effective(i),1))~=sign(Ki(Ki_effective(i),2))
        Ki_intervals(i+j-1,:)=[Ki(Ki_effective(i-j+1),1) 0];
        Ki_intervals(i+j,:)=[0 Ki(Ki_effective(i-j+1),2)];
        Ki_dUi(i+j-1)=dUi(Ki_effective(i-j+1));
        j=j+1;
    else
        Ki_intervals(i+j-1,:)=Ki(Ki_effective(i),:);
        Ki_dUi(i+j-1)=dUi(Ki_effective(i));
    end
end

%sortiere KI intervalle
Ki1=Ki_intervals(:,1);
[Ki1 ind]=sort(Ki1);
Ki_intervals(:,1)=Ki_intervals(ind,1);
Ki_intervals(:,2)=Ki_intervals(ind,2);
Ki_dUi=Ki_dUi(ind);
        
Kp_intervals=zeros((length(c)-2)+2*(dUilowerzero+dividezero),2);
mue=ones((length(c)-2)+2*(dUilowerzero+dividezero),1);
j=1;
z=1;
Ki_effective=[Ki_effective 0];
if Ki_effective(1)>0
    for k=1:length(c)-2
        i=k;
        if signswitch~=-1
            if k+signswitch<=length(c)-2
                i=k+signswitch;
            else
                i=k-(length(c)-2-signswitch);
            end
        end
        if j>dUilowerzero+dividezero
            j=dUilowerzero+dividezero;
        end

        a=round(1000*etaintervals(i,1))/1000;
        b=round(1000*etaintervals(i,2))/1000;
        a1=round(1000*Ki_intervals(j,1))/1000;
        b1=round(1000*Ki_intervals(j,2))/1000;
        if (a1>a&&a1<b)&&(b1==b||(b1>b))
            Kp_intervals(z,1)=etaintervals(i,1);
            Kp_intervals(z,2)=Ki_intervals(j,1);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho;
            mue(z)=0.5*(alpha+abs(alpha));
            z=z+1;
            Kp_intervals(z,1)=Ki_intervals(j,1);
            Kp_intervals(z,2)=etaintervals(i,2);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho+Ki_dUi(j);
            mue(z)=0.5*(alpha+abs(alpha));
            if b==b1
                j=j+1;
            end
        elseif (b1>a&&b1<b)&&(a1==a||(a1<a))
            Kp_intervals(z,1)=etaintervals(i,1);
            Kp_intervals(z,2)=Ki_intervals(j,2);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho+Ki_dUi(j);
            mue(z)=0.5*(alpha+abs(alpha));
            z=z+1;
            Kp_intervals(z,1)=Ki_intervals(j,2);
            Kp_intervals(z,2)=etaintervals(i,2);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho;
            mue(z)=0.5*(alpha+abs(alpha));
            if a==a1
                j=j+1;
            end
        elseif (a1>a)&&(b1<b)
            Kp_intervals(z,1)=etaintervals(i,1);
            Kp_intervals(z,2)=Ki_intervals(j,1);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            mue(z)=eta(i)+rho;
            z=z+1;
            Kp_intervals(z,1)=Ki_intervals(j,1);
            Kp_intervals(z,2)=Ki_intervals(j,2);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho+Ki_dUi(j);
            mue(z)=0.5*(alpha+abs(alpha));        
            z=z+1;
            Kp_intervals(z,1)=Ki_intervals(j,2);
            Kp_intervals(z,2)=etaintervals(i,2);        
            mue(z)=eta(i);        
            j=j+1;
        elseif (a>=a1)&&(b<=b1)
            Kp_intervals(z,1)=etaintervals(i,1);
            Kp_intervals(z,2)=etaintervals(i,2);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho+Ki_dUi(j);
            mue(z)=0.5*(alpha+abs(alpha));        
            z=z+1;      
            j=j+1;
        else
            Kp_intervals(z,:)=etaintervals(i,:);       
            %mue(z)=eta(i);
            rho=0;
            if (m==n-1)&&(mean([Kp_intervals(z,1),Kp_intervals(z,2)])<(N(end-m+1)-D(end-n+1)*N(end-m)/(N(end-m)^2)))
                rho=-1;
            end
            alpha=eta(i)+rho;
            mue(z)=0.5*(alpha+abs(alpha)); 
        end
        z=z+1;
    end

    Kp_intervals=Kp_intervals(1:z-1,:);
    mue=mue(1:z-1);
else
    Kp_intervals=etaintervals;
    mue=eta;
end

% extract stable Kp intervals
stableKpint=[];
if show_results
    fprintf('stable Kp intervals:\n');
end
for i=1:length(mue)
    if mue(i)==0
        stableKpint=[stableKpint Kp_intervals(i,1) Kp_intervals(i,2)];
        if show_results
            fprintf('[%.3f, %.3f]\n',Kp_intervals(i,1),Kp_intervals(i,2));
        end
    end
end

stable_KP_intervals=stableKpint;