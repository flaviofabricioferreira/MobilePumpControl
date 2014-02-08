n=length(omega0);

om=[0 omega0];
omdist=zeros(1,n);
for i=1:n
    omdist(i)=om(i+1)-om(i);
end
bar(omdist);