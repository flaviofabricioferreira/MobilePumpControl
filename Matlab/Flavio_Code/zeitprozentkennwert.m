function tau=zeitprozentkennwert(n,m)

%#################################
% Kennwertermittlung fuer das
% Zeitprozentverfahren PTn-Glied
%#################################
% Lutz, Wendt: Taschenbuch der 
% Regelungstechnik, S. 357 ff.
%#################################

%Genauigkeit
maxtol=1e-6;

%Anfangswertabschaetzung
tau=n*(m/100+0.5);
iteration=0;
n1=0;
n2=0;
n2p1=0;
n2p2=0;
n3=0;
n4=0;
npow1=0;
nfac1=0;
while (1)
    summe=0.0;
    iteration;
    %Summenbildung
    for i=0:n-1
        summe;
        npow1=(tau^i);
        nfac1=factorial(i);
        summe=summe+npow1/nfac1;
        %summe=summe+(tau^i)/factorial(i);
    end
    n1=summe;
   % n2p1=(1-m/100)
   % tau
   % n2p2=exp(tau)
   % n2=n2p1*n2p2
    n2=(1-m/100)*exp(tau);
    n3=factorial(n-1);
    n4=(tau)^(n-1);
    delta_tau=(n1-n2)*(n3/n4);
    %delta_tau=(summe-(1-m/100)*exp(tau))*factorial(n-1)/(tau)^(n-1);
    tau=tau+delta_tau;
    if abs(delta_tau)<maxtol
        break;
    end
    iteration=iteration+1;
end