using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobilePumpControl.ControlFunctions;

namespace MobilePumpControl.ControlFunctions
{
    public class TransferFunction
    {
        private List<double> Numerator {get ; set;}        
        private List<double> Denominator {get; set;}
        
        public TransferFunction(List<double> Num,List<double> Den){

            Numerator = Num;
            Denominator = Den;
        }

        public TransferFunction(double gainK, double timeT1, int deadTime, int order)
        {

            double Ks = gainK;


            List<double> numGs = new List<double>();
            numGs.Add(1.0);
            List<double> denGs = new List<double>();
            denGs.Add(timeT1);
            denGs.Add(1.0);
            TransferFunction Gs = new TransferFunction(numGs, denGs);

            //Gs=Gs^3
            //TransferFunction Gs2 = Gs;
            TransferFunction Gs2 = Gs;
            for (int i = 0; i < order - 1; i++)
            {
                //Gs2 = Gs2.multiplyTranferFuctionby(Gs);//^2	
                Gs2 = multiplyTranferFunctions(Gs,Gs);//^2	
            }
            
            //Gs = Gs2;

            //[Ns,Ds]=tfdata(Ks*Gs,'v')
            List<double> numK = new List<double>();
            numK.Add(Ks);
            List<double> denK = new List<double>();
            denK.Add(1.0);
            TransferFunction K = new TransferFunction(numK, denK);

            //		Gs=tf(Ks,[0.1 1])*Gs	
            List<double> numKK = new List<double>();
            numKK.Add(Ks);
            List<double> denKK = new List<double>();
            denKK.Add(0.1); // At matlab example use 0.1
            denKK.Add(1.0);
            TransferFunction KK = new TransferFunction(numKK, denKK);

            //       K*       exp(-Tt*s)*1      
            //   --------- x --------------
            //  (s*T1+1)^n           1

            TransferFunction Gs3 = multiplyTranferFunctions(KK,Gs2);
            Gs3.show();

            Numerator = Gs3.Numerator;
            Denominator = Gs3.Denominator;
        }

        public static TransferFunction multiplyTranferFunctions(TransferFunction tf1, TransferFunction tf2) {


            //Here the parameters are passed by value
            List<Double> outNum = OtherFunctions.multiplyPolys(tf1.Numerator, tf2.Numerator);
            List<Double> outDen = OtherFunctions.multiplyPolys(tf1.Denominator, tf2.Denominator);

            TransferFunction tfOut = new TransferFunction(outNum, outDen);

            return tfOut;

   		
        // This implematation of android was because the parameters are passed by reference
        //List<double> inputNum2 = new List<double>();
        //List<double> inputDen2 = new List<double>();             
        //for(int i=0;i<tf2.Numerator.size();i++){
        //    inputNum2.add(tf2.Numerator.get(i));
        //}
        //for(int j=0;j<tf2.Denominator.size();j++){
        //    inputDen2.add(tf2.Denominator.get(j));
        //}



        

        }

        public void show() { 
            
            String num = "";
    		double numberN = 0;
	    	int expnumN = 0;
		    
            String den = "";
		    double numberD = 0;
		    int expnumD = 0;
		
		
		    for(int i=0;i<this.Numerator.Count;i++){
			    numberN = this.Numerator[i]; 
			    expnumN = (this.Numerator.Count-1-i);
			    if(numberN > 0){
    				num = num + " ";
	    			num = num + "+";
		    		num = num + Convert.ToString(numberN);
			    	if(expnumN != 0){
				    	num = num + "s";
					    if(expnumN != 1){
						    num = num + "^" +(Convert.ToString(expnumN));	
					    }
				    }
				
			    } else if (numberN < 0) {
				    num = num + " ";
				    num = num + "-";
				    num = num + (Convert.ToString(numberN));
				        if(expnumN != 0){
					        num = num + "s";
					        if(expnumN != 1){
						    num = num + "^" +(Convert.ToString(expnumN));	
					        }
				        }
			    } else {
				
			    }
						 
		    }
        		
            Console.WriteLine(num);
		    for(int j=0;j<this.Denominator.Count;j++){
    			numberD = this.Denominator[j]; 
			    expnumD = (this.Denominator.Count-1-j);
    			if(numberD > 0){
	    			den = den + " ";
		    		den = den + "+";
			    	den = den + (Convert.ToString(numberD));
				    if(expnumD != 0){
					    den = den + "s";
					    if(expnumD != 1){
				    	    den = den + "^" +(Convert.ToString(expnumD));	
					    }
				    }				
			    } else if (numberD < 0) {
				    den = den + " ";
				    den = den + "-";
				    den = den + (Convert.ToString(numberD));
				    if(expnumD != 0){
					    den = den + "s";
					    if(expnumD != 1){
						    den = den + "^" +(Convert.ToString(expnumD));	
					    }
				    }
			    } else {
				
		    }
						 
		}

        Console.WriteLine("-------------------------------");
		Console.WriteLine(den);
		Console.WriteLine("===================================================");
		
        }

   

    }
}
