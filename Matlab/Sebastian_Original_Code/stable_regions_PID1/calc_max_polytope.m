function [KPAmax,polyx,polyy,polyCOGx,polyCOGy]=calc_max_polytope(f1,f2,fn,KPmin,KPmax,L,D,N,l,tolerance)

KPmin=ceil(100*KPmin+1)/100;
KPmax=floor(100*KPmax-1)/100;
KPvec=[KPmin:(KPmax-KPmin)/20:KPmax];

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

for j=1:1
    for i=1:length(KPvec)

        KP=KPvec(i);

        % calc singular frequencies
        [omega0 omegaplus omegaminus]=calc_singular_frequencies_delay(f1,f2,fn,KP,L,D,N,l,tolerance,0);

        %calculate stable region
        [polyx,polyy]=stable_region_NOPDT(omegaplus,omegaminus,f1,f2,fn,L,0);
        %plot(polyx,polyy,'g');
        
        plotx=polyx;
        ploty=polyy;
        plotz=KP.*ones(1,length(plotx));
        patch(plotx,ploty,plotz,[0.6 0.6 0.6],'LineStyle','-');
        
        %calculate polygon surface
        [polyA,polyCOGx,polyCOGy,inr,KImax]=calc_polygon_surface_COG(polyx,polyy);
        if polyA>Amax
            KPAmax=KP;
            KPAmaxi=i;
            Amax=polyA;
            polyxmax=polyx;
            polyymax=polyy;
            polyCOGxmax=polyCOGx;
            polyCOGymax=polyCOGy;
        end
                
    end
    
    KPmin=KPvec(KPAmaxi-1);
    KPmax=KPvec(KPAmaxi+1);
    KPvec=[KPmin:(KPmax-KPmin)/5:KPmax];   
end

plotz=KPAmax.*ones(1,length(polyxmax));
%patch(polyxmax,polyymax,plotz,[0 1 0],'LineStyle','-');

polyx=polyxmax;
polyy=polyymax;
polyCOGx=polyCOGxmax;
polyCOGy=polyCOGymax;