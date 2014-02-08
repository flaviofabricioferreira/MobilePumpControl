function [polyA,polyCOGx,polyCOGy,incircle_r,KImax]=calc_polygon_surface_COG(polyx,polyy)

%% calculate surface area, center of gravity and radius of inner circle of convex polygones defined
%% by their vertices
n=length(polyx)-0;
summeA=0;
summeBx=0;
summeBy=0;
summeU=0;
KImax=0;
for i=1:n
    ip1=i+1;
    if ip1>n
        ip1=mod(ip1,n);
    end
    summeA=summeA+polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i);
    summeBx=summeBx+(polyx(i)+polyx(ip1))*(polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i));
    summeBy=summeBy+(polyy(i)+polyy(ip1))*(polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i));
    summeU=summeU+sqrt((polyx(ip1)-polyx(i))^2+(polyy(ip1)-polyy(i))^2);
    if sign(polyx(i))~=sign(polyx(ip1))&&polyy(i)
        x1=polyx(i);
        x2=polyx(ip1);
        y1=polyy(i);
        y2=polyy(ip1);
        m=(y2-y1)/(x2-x1);
        b=y1-m*x1;
        if b>KImax
            KImax=b;
        end
    end
end
polyA=0.5*summeA;
polyCOGx=1/(6*polyA)*summeBx;
polyCOGy=1/(6*polyA)*summeBy;  
incircle_r=2*polyA/summeU;
polyA=abs(polyA);