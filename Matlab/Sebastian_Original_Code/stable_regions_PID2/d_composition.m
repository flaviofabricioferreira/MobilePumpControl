function [Ra,Rb,Ia,Ib,f1,f2,fn,n,m,l]=d_composition(D,N)

%##################################
% This function calculates the d-composition of a quasipolynomial transfer
% function as found in HOHENBICHLER2003
% Remarks:
% - D denotes the plant denominator without integral part from controller
%##################################

D=[D 0];
N=[0 N];
m=length(N)-min(find(N~=0));
n=length(D)-min(find(D~=0));
l=n-m;
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
   else %even, imaginary part
       Ia(end-i+1)=signodd*N(end-i+1);
       Ib(end-i+1)=signodd*D(end-i+1);
       signodd=-signodd;
       Ra(end-i+1)=0;
       Rb(end-i+1)=0;
   end
end

%% KP generator function
f1=([0 -conv(Ra,Rb)-conv(Ia,Ib)]);
f2=([0 conv(Ia,Rb)-conv(Ra,Ib)]);
fn=[conv(Ra,Ra)+conv(Ia,Ia) 0];