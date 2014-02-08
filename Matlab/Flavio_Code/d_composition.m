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
       %fprintf('ODD=======I=%d================\n',i);     
       Ra(end-i+1)=signeven*N(end-i+1);
       Rb(end-i+1)=signeven*D(end-i+1);
       signeven=-signeven;
       Ia(end-i+1)=0;
       Ib(end-i+1)=0;
   else %even, imaginary part
       %fprintf('EVEN=======I=%d================\n',i);     
       Ia(end-i+1)=signodd*N(end-i+1);
       Ib(end-i+1)=signodd*D(end-i+1);
       signodd=-signodd;
       Ra(end-i+1)=0;
       Rb(end-i+1)=0;
   end
end

% fprintf('==========Ra Vector=========');
% Ra
% fprintf('==========Rb Vector=========');
% Rb
% fprintf('==========Ia Vector=========');
% Ia
% fprintf('==========Ib Vector=========');
% Ib


%% KP generator function
% fprintf('conv(Ra,Rb)');
% conv(Ra,Rb)
% fprintf('-conv(Ra,Rb)');
% -conv(Ra,Rb)
% fprintf('-conv(Ia,Ib)');
% -conv(Ia,Ib)
% 
% 
% 
% fprintf('-conv(Ra,Rb)-conv(Ia,Ib)');
% -conv(Ra,Rb)-conv(Ia,Ib)

%fprintf('==========F1 Vector=========\n');
f1=([0 -conv(Ra,Rb)-conv(Ia,Ib)]);
%fprintf('==========F2 Vector=========\n');
f2=([0 conv(Ia,Rb)-conv(Ra,Ib)]);
%fprintf('==========Fn Vector=========\n');
fn=[conv(Ra,Ra)+conv(Ia,Ia) 0];