function [stableKPintervals]=calculate_stable_KP_noKIKD(X,Y,D,De,Do)

    %% stable KP region (KI,KD=0!) (Munro et al. 1999)
    %roots of X(u)
    rx=roots(X)';
    count_positive=length(find(rx>0));
    rxv=zeros(1,count_positive);
    j=1;
    for i=1:length(rx)
        if rx(i)>0
            rxv(j)=rx(i);
            j=j+1;
        end
    end
    count_positive=length(find(imag(rxv)==0));
    rx=zeros(1,count_positive);
    j=1;
    for i=1:length(rxv)
        if imag(rxv(i))==0
            rx(j)=rxv(i);
            j=j+1;
        end
    end
    rx=[rx 0 Inf];
    grx=polyval(Y,rx)./polyval([0,conv(De,De)]+[conv(Do,Do),0],rx);
    nanind=find(isnan(grx));
    if isempty(nanind)==0
        grx(nanind)=0;
    end
    [sgrx ind]=sort(grx);
    rx=rx(ind);
    sgrx=[sgrx Inf];
    c=-1./sgrx;

    if sign(sgrx(1))~=sign(sgrx(end))
        i=1;
        while (i<=length(c))&&(sign(c(i))~=-1)
            i=i+1;
        end
        c=[c(1:i-1),Inf,c(i:end)];
    end
    signswitch=i;
    if signswitch>length(c)
        signswitch=-1;
    end
    if c(1)~=-Inf
        c=[0 c];
    end


    etaintervals=zeros(length(c)-2,2);
    for i=1:length(c)-2
        if i<=signswitch
            etaintervals(i,1)=c(i);
            etaintervals(i,2)=c(i+1);
        else
            etaintervals(i,1)=c(i+1);
            etaintervals(i,2)=c(i+2);
        end
    end

    % calculate derivatives of X(u) 
    nX=length(X);
    dX=zeros(nX,nX);
    for i=1:nX
        for j=1:nX-1
            if i==1
                dX(i,j+1)=X(j)*(nX-j);
            else
                dX(i,j+1)=dX(i-1,j)*(nX-j);
            end
        end
    end

    i=1;
    while X(i)==0
        i=i+1;
    end
    beta1=X(i);
    beta0=X(end);
    eta=zeros(length(sgrx),1);
    eta0=length(find(real(roots(D))>0));
    for i=1:length(sgrx)
        sumrj=0;
        for j=1:i-1
            rjadd=0;
            if rx(j)==0
                rjadd=-sign(beta0);
            elseif rx(j)==Inf
                rjadd=sign(beta1);
            else
                l=1;
                while polyval(dX(l,:),rx(j))==0
                    l=l+1;
                end
                rjadd=(-1+(-1)^l)*sign(polyval(dX(l,:),rx(j)));
            end
            sumrj=sumrj+rjadd;
        end
        eta(i,1)=eta0+sumrj;
    end
    
    %extract stable intervals
    stableKPintverals=zeros(size(etaintervals));
    j=1;
    for i=1:length(sgrx)
        if eta(i,1)<=0
            stableKPintervals(j,:)=etaintervals(i,:);
            j=j+1;
        end
    end
    stableKPintervals=stableKPintervals(1:j-1,:);
end