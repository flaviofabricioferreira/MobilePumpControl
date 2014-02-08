function [polyx,polyy]=intersect_polygones(polyx1,polyy1,polyx2,polyy2)

polyx=[];
polyy=[];

pxi=polyx1;
pyi=polyy1;
pxo=polyx2;
pyo=polyy2;

n_in=inpolygon(polyx1(1),polyy1(1),polyx2,polyy2);
if n_in==0
    n_in=length(find(inpolygon(polyx2,polyy2,polyx1,polyy1)>0));
    if n_in==0
        fprintf(2,'no intersection\n');
        return;
    end
    pxi=polyx2;
    pyi=polyy2;
    pxo=polyx1;
    pyo=polyy1;
end

ind=find(inpolygon(pxi,pyi,pxo,pyo),1,'first');
polyx=[polyx pxi(ind)];
polyy=[polyy pyi(ind)];

i=1;
j=1;
on_inner=1;
if inpolygon(pxi(ind+1),pyi(ind+1),pxo,pyo)
    polyx=[polyx pxi(ind+1)];
    polyy=[polyy pyi(ind+1)];
    i=i+2;
else
    ind=find(inpolygon(pxo,pyo,pxi,pyi),1,'first');
    polyx=[polyx pxo(ind)];
    polyy=[polyy pyo(ind)];
    on_inner=-1;
    j=j+2;
end
stop=0;



while stop==0
   if on_inner==1
       j=1;
       if round(100*pxi(i))==round(100*polyx(1))
           stop=1;
       end
       if inpolygon(pxi(i),pyi(i),pxo,pyo)&&stop==0
           polyx=[polyx pxi(i)];
           polyy=[polyy pyi(i)];
           i=i+1;
       elseif stop==0
           m1=(pyi(i)-pyi(i-1))/(pxi(i)-pxi(i-1));
           b1=pyi(i)-m1*pxi(i);
           % find polypoint on outer polygon

            ustop=0;
            while ustop==0
                m2=(pyo(j+1)-pyo(j))/(pxo(j+1)-pxo(j));
                b2=pyo(j)-m2*pxo(j);
                intx=(b2-b1)/((m1-m2)+eps);
                inty=m2*intx+b2;
                if ((intx>(pxi(i-1)+1e-8)&&intx<(pxi(i)-1e-10))||(intx<(pxi(i-1)-1e-8)&&intx>(pxi(i)+1e-10)))&&(round(100*polyx(end))~=round(100*intx))
                    ustop=1;                    
                end
                j=j+1;
            end
           polyx=[polyx intx];
           polyy=[polyy inty];
           on_inner=-on_inner;
       end
   else
       i=1;
       if round(100*pxo(j))==round(100*polyx(1))
           stop=1;
       end
       if inpolygon(pxo(j),pyo(j),pxi,pyi)&&stop==0
           polyx=[polyx pxo(j)];
           polyy=[polyy pyo(j)];
           j=j+1;
       elseif stop==0
           m1=(pyo(j)-pyo(j-1))/(pxo(j)-pxo(j-1));
           b1=pyo(j)-m1*pxo(j);
           % find polypoint on outer polygon
           ustop=0;
           while ustop==0
                m2=(pyi(i+1)-pyi(i))/(pxi(i+1)-pxi(i));
                b2=pyi(i)-m2*pxi(i);
                intx=(b2-b1)/((m1-m2)+eps);
                inty=m2*intx+b2;
                if ((intx>(pxo(j-1)+1e-8)&&intx<(pxo(j)-1e-10))||(intx<(pxo(j-1)-1e-8)&&intx>(pxo(j)+1e-10)))&&(round(100*polyx(end))~=round(100*intx))
                    ustop=1;                    
                end
                i=i+1;
           end
%            m2=(pyi(i)-pyi(i-1))/(pxi(i)-pxi(i-1));
%            b2=pyi(i)-m2*pxi(i);
%            intx=(b2-b1)/(m1-m2);
%            inty=m2*intx+b2;
           polyx=[polyx intx];
           polyy=[polyy inty];
           on_inner=-on_inner;
       end
   end
end

polyx=[polyx polyx(1)];
polyy=[polyy polyy(1)];
