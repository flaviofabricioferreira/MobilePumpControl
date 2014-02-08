%clear
%% system definition
%D=[1 8 32 46 46 17];
%N=[0 0 1 -4 1 2];
%N=[0 0.109693 0.0728112 0.7354 0.318 1];
%D=[1.41834 3.39206 7.62744 5.9986 3.33 1];

%N=[0 0 0 -0.5 -7 -2 1];
%D=[1 11 46 95 109 74 24];

%N=[0 1 3 0 9];
%D=[1 2 3 7 14];

%G=tf(1,[1 1]);
%G=G^1;

%G=tf(1,[1 1])*tf(1,[1 2])*tf(1,[1 3])*tf(1,[1 4])*tf(1,[1 1 1]);
%[N,D]=tfdata(G,'v');
%N=[0 0 -1 -7 0 -2 1];

%G=tf(1,[0.646569 1]);
%G=G^9;
%G=0.005029*G;


%G1=tf(4,[0.1 1]);
%G2=tf(1,[0.1 1]);
%G3=tf(1,[0.3 1]);
%G4=tf([-0.1 1],[0.1^2 2*0.1*0.1 1]);
%G=G1*G2*G3*G4;
%[N D]=tfdata(G,'v');

D=[1 1 1 0];
N=[0 0 0 1];

%D=[D 0];
%N=[0 N];

KP=0;

clc
%tic

%% set parameter space boundaries
lb=-5000;
ub=5000;

%% calculate even and odd parts of the nominator and denominator
m=length(N)-min(find(N~=0));
n=length(D)-min(find(D~=0));
nD=length(D);
evenvec=ones(1,nD);
oddvec=evenvec;
Ra=zeros(1,nD);
Ia=zeros(1,nD);
Rb=zeros(1,nD);
Ib=zeros(1,nD);
signeven=1;
signodd=1;
for i=1:nD
   if mod(i,2)~=0 %uneven, real part
       Ra(end-i+1)=signeven*N(end-i+1);
       Rb(end-i+1)=signeven*D(end-i+1);
       signeven=-signeven;
       Ia(end-i+1)=0;
       Ib(end-i+1)=0;
   else
       Ia(end-i+1)=signodd*N(end-i+1);
       Ib(end-i+1)=signodd*D(end-i+1);
       signodd=-signodd;
       Ra(end-i+1)=0;
       Rb(end-i+1)=0;
   end
end




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

