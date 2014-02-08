function [De,Do,Ne,No,X,Y,Z,n,m]=nyquist_decomposition(D,N)

%##################################
% This function calculates the nyquist-decomposition of a polynomial transfer
% function as found in SOEYLEMEZ2003
% Remarks:
% - D denotes the plant denominator without integral part from controller
%##################################

%% calculate even and odd parts of the nominator and denominator
m=length(N)-min(find(N~=0));
n=length(D)-min(find(D~=0));
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