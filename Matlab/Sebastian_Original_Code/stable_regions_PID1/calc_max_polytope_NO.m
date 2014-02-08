function [KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope_NO(KPmin,KPmax,D,N,X,Y,Z,ub,lb,n,m)

KPmin=0.9*ceil(100*KPmin)/100;
KPmax=0.9*floor(100*KPmax)/100;
KPvec=[KPmin:(KPmax-KPmin)/5:KPmax];

figure(5);
hold on
grid on
xlabel('KD');
ylabel('KI');
zlabel('KP');

KPAmax=0;
KPAmaxi=0;
Amax=0;
polyxmax=0;
polyymax=0;
polyCOGxmax=0;
polyCOGymax=0;

for j=1:4
    for i=1:length(KPvec)

        KP=KPvec(i);

        % calculate all polygones and unstable poles count for specified KP
        [polynum,polyx,polyy,polynsp,polylength]=stable_region_NO(N,D,X,Y,Z,ub,lb,KP,n,m,0);
        
        for z=1:polynum
            plotx=[polyx(z,1:polylength(z)) polyx(z,1)];
            ploty=[polyy(z,1:polylength(z)) polyy(z,1)];
            plotz=KP.*ones(1,length(plotx));
            patch(plotx,ploty,plotz,[0.6 0.6 0.6],'LineStyle','-');
        end
        
        %calculate polygon surface
        [polyA,polyCOGx,polyCOGy,inr,KImax]=calc_polygon_surface_COG(polyx(1,1:polylength(1)),polyy(1,1:polylength(1)));
        if polyA>Amax
            KPAmax=KP;
            KPAmaxi=i;
            Amax=polyA;
            polyxmax=plotx;
            polyymax=ploty;
            polyCOGxmax=polyCOGx;
            polyCOGymax=polyCOGy;
        end
                
    end
    
    KPmin=KPvec(KPAmaxi-1);
    KPmax=KPvec(KPAmaxi+1);
    KPvec=[KPmin:(KPmax-KPmin)/5:KPmax];   
end

plotz=KPAmax.*ones(1,length(polyxmax));
patch(polyxmax,polyymax,plotz,[0 1 0],'LineStyle','-');

polyx=polyxmax;
polyy=polyymax;
polyCOGx=polyCOGxmax;
polyCOGy=polyCOGymax;