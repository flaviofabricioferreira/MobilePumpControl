%% system definition
%D=[1 8 32 46 46 17];
%N=[0 0 1 -4 1 2];
%N=[0 0.109693 0.0728112 0.7354 0.318 1];
%D=[1.41834 3.39206 7.62744 5.9986 3.33 1];

%N=[0 0 0 -0.5 -7 -2 1];
%D=[1 11 46 95 109 74 24];

D=[1 1 1];
N=[0 0 1];

%G=tf(1,[1 1]);
%G=G^8;

%G=tf(1,[1 1])*tf(1,[1 2])*tf(1,[1 3])*tf(1,[1 4])*tf(1,[1 1 1]);
%[N,D]=tfdata(G,'v');
%N=[0 0 -1 -7 0 -2 1];

%D=[D 0];
%N=[0 N];

KP=0.1;
L=5;

clc
tic

%% calculate even and odd parts of the nominator and denominator
m=length(N)-min(find(N~=0));
n=length(D)-min(find(D~=0))+1;
l=n-m;
nD=length(D)-1;
evenvec=ones(1,nD);
oddvec=evenvec;
De=zeros(1,floor(nD/2)+1);
Do=zeros(1,floor(nD/2)+1);
Ne=zeros(1,floor(nD/2)+1);
No=zeros(1,floor(nD/2)+1);
signeven=1;
signodd=1;
for i=1:1:nD+1
    if mod(i,2)==1
        De(end-(i-1)/2)=D(end-i+1)*signeven;
        Ne(end-(i-1)/2)=N(end-i+1)*signeven;
        signeven=signeven*-1;
    else
        Do(end-i/2+1)=D(end-i+1)*signodd;
        No(end-i/2+1)=N(end-i+1)*signodd;
        signodd=signodd*-1;
    end
end


%% calculate X(u), Y(u) and Z(u)
X=conv(Do,Ne)-conv(De,No);
Y=[conv(Do,No), 0]+[0 conv(De,Ne)];
Z=[0 conv(Ne,Ne)]+[conv(No,No) 0];


%% calculate P(u)
P=Y+KP.*Z;

%% count unstable poles at origin
polenum_origin=length(find((real(roots(KP.*N+D)))>0));

%% calculate singular frequencies
f1=([0 -conv(Ra,Rb)-conv(Ia,Ib)]);
f2=([0 conv(Ia,Rb)-conv(Ra,Ib)]);
fn=[conv(Ra,Ra)+conv(Ia,Ia) 0];
[omega0,omegaplus,omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l);

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
A=g;

x=[-10^1:1:10^1];
figure(1)
hold on
xlim([-6 6]);
ylim([-2 2]);
for i=1:count_positive
    patch([x fliplr(x-0.2) x(1)],[x.*u(i)^2+g(i) fliplr((x).*u(i)^2+g(i)) x(1)*u(1)^2+g(1)],[0.7 0.7 0.7],'LineStyle','none');
    plot(x,x.*u(i)^2+g(i));
end

%% negative crossing singular frequencies
u=omegaminus;
count_positive=length(u);

% calculate boundary offsets g(omega)
g=zeros(1,count_positive);
for i=1:count_positive
    g(i)=u(i)*((polyval(-f2,u(i))/polyval(fn,u(i)))*sin(u(i)*L)+(polyval(f1,u(i))/polyval(fn,u(i))*cos(u(i)*L)));
end
A=[0 A g(1:end-1)];

x=[-10^1:1:10^1];
u=[0 u];
g=[0 g];
for i=1:count_positive+1
    patch([x fliplr(x+0.2)],[x.*u(i)^2+g(i) fliplr(x).*u(i)^2+g(i)-0.1],[0.7 0.7 0.7],'LineStyle','none');
    plot(x,x.*u(i)^2+g(i));
end

%% determine stable section in KI axis (valid for NOPDT-Systems from here
%% on)
u=[0 omegaplus omegaminus(1:end-1)];
intx=zeros(1,length(u)-1);
for i=2:length(u)
    intx(i-1)=-A(i)/u(i)^2;
end
[sintx ind]=sort(intx);
i=1;
while sintx(i)<=0
    i=i+1;
end
stablepolyx=[sintx(i-1) sintx(i)];
stablepolyy=[0 0];
stablepoly=[ind(i-1)+1 ind(i)+1];
stop=0;
ydirection=-1;
while stop==0
    intx=zeros(1,length(u));
    inty=zeros(1,length(u));
    for i=1:length(u)
        intx(i)=(A(i)-A(stablepoly(end)))/((u(stablepoly(end))^2-u(i)^2)+eps);
        inty(i)=u(i)^2*intx(i)+A(i);
    end
    if ydirection==1
        [sinty,ind]=sort(inty,'descend');
    else
        [sinty,ind]=sort(inty);
    end
    j=1;
    if ydirection==1
        while sinty(j)>=stablepolyy(end)-1e-8
            j=j+1;
        end
    else
        while sinty(j)<=stablepolyy(end)+1e-8
            j=j+1;
        end
    end
    stablepolyx=[stablepolyx intx(ind(j))];
    stablepolyy=[stablepolyy sinty(j)];
    stablepoly=[stablepoly ind(j)];
    plot(stablepolyx(end),stablepolyy(end),'r*');
    if (u(ind(j)+1)>0)&&(A(ind(j)+1)>0)
        ydirection=1;
    end
    if round(100*stablepolyx(end))/100==round(100*stablepolyx(1))/100
        stop=1;
    end
end    

toc

[KD KI]=ginput(1);
G=tf(N,D,'InputDelay',L);
Gr=tf([KD KP KI],[1 0]);
Go=series(Gr,G);
Gw=feedback(Go,ss(1));
figure(2)
step(Gw);
Gz=ss(1)/(1+ss(Go));
figure(3)
step(Gz);


