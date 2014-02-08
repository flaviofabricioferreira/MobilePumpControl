function [polynum,polyx,polyy,polynsp,polylength]=stable_region_NO(N,D,X,Y,Z,ub,lb,KP,n,m,all_regions)

%########################
% This function extracts the stable region for a n-order system
% 
% Limitations:
% -
%########################

%% count unstable poles at origin
P=conv(N,[KP 1e-5])+[D 0];
r=roots(P);
polenum_origin=length(find(real(r)>0));

%% calculate P(u)
P=Y+KP.*Z;

%% calculate positive roots u* of P(u)
r=roots(P);
count_positive=length(find(r>0));
uv=zeros(1,count_positive);
j=1;
for i=1:length(r)
    if r(i)>0
        uv(j)=r(i);
        j=j+1;
    end
end
count_positive=length(find(imag(uv)==0));
u=zeros(1,count_positive);
j=1;
for i=1:length(uv)
    if imag(uv(i))==0
        u(j)=uv(i);
        j=j+1;
    end
end

%% calculate boundary offsets
A=zeros(1,count_positive);
for i=1:count_positive
    A(i)=polyval([X 0],u(i))/polyval(Z,u(i));
end

%% calculate derivatives of P(u) 
nP=length(P);
dP=zeros(nP,nP);
for i=1:nP
    for j=1:nP-1
        if i==1
            dP(i,j+1)=P(j)*(nP-j);
        else
            dP(i,j+1)=dP(i-1,j)*(nP-j);
        end
    end
end

%% calculate numbers of additional stable poles on the origin side
nsp=zeros(1,count_positive);
for i=1:count_positive
    l=1;
    while polyval(dP(l,:),u(i))==0
        l=l+1;
    end
    nsp(i)=((-1)^l-1)*sign(polyval(dP(l,:),u(i)+eps)/polyval(X,u(i)+eps));
end

polynum=1;
polylength(1)=4;
polyx(1,:)=[lb ub ub lb];
polyy(1,:)=[ub ub lb lb];

%add KI>0
KIactive=0;
if N(end)~=0
    KIactive=1;
    KInsp=sign(N(end)/(D(end)+N(end)*KP));
    polyy(1,:)=[ub ub 0 0];
    polyx(2,:)=polyx(1,:);
    polyy(2,:)=[0 0 lb lb];
    polynum=polynum+1;
    polylength(2)=4;
end

%add KD
KDactive=0;
if m==n-1
    KDactive=1;
    KDsec=-1/N(end-m);
    KDnsp=sign(KP*N(end-m)^2+D(end-n+1)*N(end-m)-N(end-m+1));
    polyx(1,:)=[lb KDsec KDsec lb];
    polyx(2,:)=[lb KDsec KDsec lb];
    polyx(3,:)=[KDsec ub ub KDsec];
    polyy(3,:)=polyy(1,:);
    polynum=polynum+1;
    polyx(4,:)=[KDsec ub ub KDsec];
    polyy(4,:)=polyy(2,:);
    polynum=polynum+1;
    polylength(3:4)=4;
end

%%add nonsingular stability boundaries
for q=1:length(u)
    polynum1=polynum;
    for i=1:polynum1
        z=1;
        intx=[0,0,0,0];
        inty=[0,0,0,0];
        dy=polyy(i,1)>u(q)*polyx(i,1)+A(q);
        for j=1:polylength(i)+1
            if j>polylength(i)
                j=1;
            end
            if polyy(i,j)>u(q)*polyx(i,j)+A(q)~=dy
                jm1=j-1;
                if jm1<1
                    jm1=polylength(i);
                end
                if (polyx(i,j)-polyx(i,jm1))==0
                    intx(z)=polyx(i,j);
                    intx(z+2)=j;
                    inty(z)=u(q)*intx(z)+A(q);
                    inty(z+2)=j;
                    z=z+1;
                else
                    m=(polyy(i,j)-polyy(i,jm1))/(polyx(i,j)-polyx(i,jm1));
                    a=polyy(i,j)-m*polyx(i,j);
                    intx(z)=(a-A(q))/(u(q)-m);
                    intx(z+2)=j;
                    inty(z)=u(q)*intx(z)+A(q);
                    inty(z+2)=j;
                    z=z+1;
                end
                dy=1-dy;
            end        
        end
        if intx(3)>0&&intx(4)>0
            if intx(4)-1<1
                px=[intx(1) polyx(i,intx(3):polylength(i)) intx(2)];
                polyx(polynum+1,1:length(px))=px;
                polyy(polynum+1,1:length(px))=[inty(1) polyy(i,inty(3):polylength(i)) inty(2)];
            else
                px=[intx(1) polyx(i,intx(3):intx(4)-1) intx(2)];
                polyx(polynum+1,1:length(px))=px;
                polyy(polynum+1,1:length(px))=[inty(1) polyy(i,inty(3):inty(4)-1) inty(2)];
            end
            polylength(polynum+1)=length(px);
            polynum=polynum+1;
            if intx(3)-1<1
                px=[polyx(i,[polylength(i)-1:polylength(i)]),intx(1),intx(2),polyx(i,[intx(4):polylength(i)])];
                polyx(i,1:length(px))=px;
                polyy(i,1:length(px))=[polyy(i,[polylength(i)-1:polylength(i)]),inty(1),inty(2),polyy(i,[inty(4):polylength(i)])];
            else
                if intx(4)==1
                    px=[polyx(i,[1:intx(3)-1]),intx(1),intx(2)];
                    polyx(i,1:length(px))=px;
                    polyy(i,1:length(px))=[polyy(i,[1:inty(3)-1]),inty(1),inty(2)];
                else
                    px=[polyx(i,[1:intx(3)-1]),intx(1),intx(2),polyx(i,[intx(4):polylength(i)])];
                    polyx(i,1:length(px))=px;
                    polyy(i,1:length(px))=[polyy(i,[1:inty(3)-1]),inty(1),inty(2),polyy(i,[inty(4):polylength(i)])];
                end
            end
            polylength(i)=length(px);   
        end
    end
end

%% generate unstable pole count
polynsp=zeros(1,polynum);
for i=1:length(u)
    for j=1:polynum
        z=1;
        while round(polyy(j,z)*1000)==round((u(i)*polyx(j,z)+A(i))*1000)
            z=z+1;
        end
        if A(i)>0&&(round(polyy(j,z)*1000)>round((u(i)*polyx(j,z)+A(i))*1000))
            polynsp(j)=polynsp(j)+nsp(i);
        elseif A(i)<0&&(round(polyy(j,z)*1000)<round((u(i)*polyx(j,z)+A(i))*1000))
            polynsp(j)=polynsp(j)+nsp(i);
        end
    end
end
% add KI and KD
for j=1:polynum
    z=1;
    if KIactive
        while round(polyy(j,z)*1000)==0
            z=z+1;
        end
        if polyy(j,z)<0
            polynsp(j)=polynsp(j)+KInsp;
        end
    end
    z=1;
    if KDactive
        while round(polyx(j,z)*1000)==KDsec
            z=z+1;
        end
        if polyx(j,z)<KDsec
            polynsp(j)=polynsp(j)+KDnsp;
        end
    end
end
polynsp=polynsp+polenum_origin;

if all_regions==0
    z=1;
    for i=1:length(polynsp);
        if polynsp(i)<=0
            polyx(z,:)=polyx(i,:);
            polyy(z,:)=polyy(i,:);
            polynsp(z)=0;
            polylength(z)=polylength(i);
            z=z+1;
        end
    end
    polyx=polyx(1:z-1,:);
    polyy=polyy(1:z-1,:);
    polynsp=polynsp(1:z-1);
    polylength=polylength(1:z-1);
    polynum=z-1;
end