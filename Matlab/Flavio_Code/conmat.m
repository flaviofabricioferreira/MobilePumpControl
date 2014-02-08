function conmaty = conmat(x,h)
%the program is developed my Mohendra Roy 
%Bioelectronics division, Department of ECE, Tezpur Central University, INDIA, 
% a=input('Please Give The RANGE : '); 
% k=-a:+1:+a; 
%x=input('The input the x: ') 
%h=input('The input the h: ') 
%x=[1 .5 .25] 
%h=[1 .5 .25] 
f=fliplr(h);
l1=length(x); 
l2=length(h); 
l3=l1+l2-1;
l4=l2-1; 
conmaty=zeros(1,l3); 
for p=1:1:l3
p;    
p1=p+l4; 
h2=zeros(1,l3); % CREATE H WITH THE SIZE OF LX+LH-1
h2([p:p1])=f; % ALLOCATE TO H2 from p until P1 with the inputh flipped
l5=length(h2); 
fprintf('\n=====H1 before =====\n')
h1=zeros(1,l5) %CREATE H1 WITH THE SIZE OF H2
fprintf('\n=====X INTERVAL ====from %d until %d \n',l2,l3)
x
h1([l2:l3])=x ;% ALLOCATE TO H1 from L1 until L§ with the inputX
fprintf('\n=====H1 after =====\n')
h1
fprintf('\n=====H2 before the Multiplication =====\n')
h2
c1=h1.*h2 
c2=0; 
fprintf('\n=============P ITERATION ========%d========\n', p)
for i=1:1:l3 
c2=c2+c1([i]); 
fprintf('I=%d and C2 is $%.2f\n', i, c2)
end 
sum=c2;
conmaty([p])=sum;
end 
% temp1=length(x); 
% temp2=length(h); 
%conmaty;
t=length(conmaty); 
t2=(t-1)/2; 
v=-t2:1:t2; 
% subplot(3,1,1),stem(k,x,'*'); 
% subplot(3,1,2),stem(k,h,'g*'); 
% subplot(3,1,3),stem(v,y,'r*'); 
% n=input('The lower limit of X axis is: ') 
% m=input('The Upper limit of X axis is: ') 
% o=input('The lower limit of Y axis is: ') 
% p=input('The Upper limit of Y axis is: ') 
% subplot(3,1,1),stem(k,x,'*');axis([n m o p]);grid on 
% subplot(3,1,2),stem(k,h,'g*');axis([n m o p]);grid on 
% subplot(3,1,3),stem(v,y,'r*');axis([n m o p]);grid on 
% subplot(3,1,1);stem(x); 
% subplot(3,1,2);stem(h); 
% subplot(3,1,3);stem(y);