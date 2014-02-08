function [polyA,polyCOGx,polyCOGy]=calc_polygon_surface_COG(polyx,polyy)

%% calculate surface area and center of gravity of convex polygones defined
%% by their vertices
n=length(polyx)-1;
summeA=0;
summeBx=0;
summeBy=0;
for i=1:n
    ip1=i+1;
    if ip1>n
        ip1=mod(ip1,n);
    end
    summeA=summeA+polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i);
    summeBx=summeBx+(polyx(i)+polyx(ip1))*(polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i));
    summeBy=summeBy+(polyy(i)+polyy(ip1))*(polyx(i)*polyy(ip1)-polyx(ip1)*polyy(i));
end
polyA=0.5*summeA;
polyCOGx=1/(6*polyA)*summeBx;
polyCOGy=1/(6*polyA)*summeBy;  