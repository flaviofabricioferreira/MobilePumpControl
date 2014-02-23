/**
 * BACHELOR THESIS
 * UFCG - FEDERAL UNIVERSITY OF CAMPINA GRANDE
 * CAMPINA GRANDE - PARAIBA - BRAZIL
 *
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @email flaviofabricio@gmail.com
 * @version 1.0 February-2013
 */



using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobilePumpControl.ControlFunctions
{
    class ParametersExtractor
    {
    
    private List<double> xVal {get ; set;}
    private List<double> yVal { get; set; }
    
    private double xStart {get ; set;}
    private double yStart {get ; set;}    
    private double xEnd {get ; set;}
    private double yEnd {get ; set;}

    private List<int> timeVector { get; set; }
	
    private int xDirection {get ; set;}
	private int yDirection {get ; set;}
	
    private int stepTime {get ; set;}
	public int deadTimeTt {get ; set;}
	
    private int TimeT10P {get ; set;}
	private int TimeT50P {get ; set;}
	private int TimeT90P {get ; set;}

    public double gainK { get; set; }
    public double timeT1 { get; set; }
    public int nNearTPCV { get; set; }
    // nearest zeitprozentkennwert -> nearest time percentage characteristic value

        public ParametersExtractor(List<double> signalInput, List<double> signalOutput) {

            initializeParameters();

            xVal = signalInput.GetRange((120 - 1), 181);

            yVal = signalOutput.GetRange((120 - 1), 181);

            timeVector = initializeTimeVector((yVal.Count - 1));


            xDirection = determineXDirection(xVal[xVal.Count - 1], xVal[0]);


            stepTime = determineStepTime(xVal.Count, xDirection);

            calculateStarAndEndTime();
 
            yDirection = determineYDirection(yVal[yVal.Count - 1], yVal[0]);

            deadTimeTt = determineDeadTime(yVal.Count, yDirection, stepTime);


            flipYValIfNecessary(yDirection, yStart, yEnd, yVal.Count);

            TimeT10P = calculateTimeX(10);

            TimeT50P = calculateTimeX(50);

            TimeT90P = calculateTimeX(90);

            nNearTPCV = findNearestZeitprozentkennwert(TimeT10P,TimeT90P);//find nearest time percentage characteristic value

            timeT1 = calculateTimeT1(nNearTPCV,TimeT10P,TimeT50P,TimeT90P);
    
            gainK =  calculateGainK();
 		
        }



        private void flipYValIfNecessary(int yDir, double ySt, double yE, int ylenght)
        {
            double yend2 = 0;

            if (yDir == -1)
            {

                //System.out.println("YDIRECTION == -	1  IS NECESSARY TO FLIP YVAL ");
                //System.out.println("BEFORE YSTART ="+yStart+" and YEND = "+yEnd);

                for (int i = 0; i < ylenght; i++)
                {
                    this.yVal[i] = (ySt + yE) - this.yVal[i];

                }

                //yend2=ystart;
                //yStart = yEnd;
                //yEnd = yend2;
                yend2 = this.yVal[0];
                yStart = yVal[ylenght];
                yEnd = yend2;
                
                //setyStart(this.yVal[ylenght]);
                //setyEnd(yend2);
                //System.out.println("AFTER YSTART ="+getyStart()+" and YEND = "+getyEnd());


            }

            //System.out.println("YDIRECTION == /+ 1 NOT IS NECESSARY TO FLIP YVAL ");
        }

         private void initializeParameters() { 

          xStart = 0;
          yStart = 0;    
          xEnd = 0;
          yEnd = 0;
    
          xDirection = 0;
	      yDirection = 0;
	
          stepTime = 0;
	      deadTimeTt = 0;
	
          TimeT10P = 0;
	      TimeT50P = 0;
	      TimeT90P = 0;

          gainK = 0;
          timeT1 = 0;
          nNearTPCV = 0;
          
          xVal = new List<double>();
          yVal = new List<double>();
          timeVector = new List<int>();

                

        }

        /**
        *Initialize the Time Vector
        * @param lenght Size of yVal[] array
        */
        private List<int> initializeTimeVector(int lenght) {

            //int[] timVec = new int[lenght];
            List<int> timVec = new List<int>();
		    
            for(int i=0; i<lenght; i++){
    			timVec.Add(i);
		    }

            return timVec;
	    }

        /**
        *Determine the X Direction
        *
        * @param xEnd Value of the last component from xVal array
        * @param x1 Value of the second component from xVal array
        */
        private int determineXDirection(double xEnd, double x1)
        {

            int direction = 0;

            if (xEnd > x1)
            {
                direction = 1;
            } else
            {
                direction = -1;
            }

            return direction;
        }

        /**
        *Determine the Step Time
        * @param lenghtxVal lenght Size of xVal[] array
        * @param dirX Direction from x
        */
        private int determineStepTime(int lenghtxVal, int dirX) {
		
		    double maxDxDt = 0; // Value
		    int maxDxDtX = 0; // Time
		    int tStep = 0;
		
		    // Fill with Zeros the array with lenghtxVal size 
            double[] dxdt = new double[lenghtxVal];
		    for(int i=0;i<lenghtxVal;i++){
    			dxdt[i]=0;
		    }
		
		    // Calculus of the maximum Delta
		    for(int z=1;z<lenghtxVal-1;z++){ // %% from the second unit the penultimate
			    dxdt[z] = dirX*(this.xVal[z]-this.xVal[z-1]);
			    if (dxdt[z] > maxDxDt) {
				    maxDxDt = dxdt[z]; // Value with double type
				    maxDxDtX = z;	   // Time with int type 
				                       //(The +1 is necessary because the
						    		   // difference between the start point 
							    	   // of Java Arrays 0 and the start point 
                    			    	// of Matlab Arrays 1 )
			    }
		    }
		
		    /* Find the tStep to the left side until to found a tStep 
		    with the same value of dxdt*/
		    tStep=maxDxDtX;
		    while(dxdt[tStep-1]<0.999*dxdt[tStep]){
			    tStep=tStep-1;
		    }
		
		    return tStep;
		
	    }

        /**
        *Determine the Start and End times to use
        */
        private void calculateStarAndEndTime()
        {

            xStart = xVal[stepTime - 1];
            //setxStart(xVal[this.stepTime - 1]);//(The -1 is necessary because the

            xEnd = xVal[xVal.Count - 1];
            //setxEnd(xVal[this.xValLenght - 1]);// difference between the start point 
            // of Java Arrays 0 and the start point 
            // of Matlab Arrays 1 )
            /*Copies elements from original into a new array,
             *from indexes start (inclusive) to end (EXclusive)*/


            yStart = OtherFunctions.meanCalcFromArray(yVal.GetRange(0, (stepTime + 1)));
            //setyStart(meanCalcFromArray(Arrays.copyOfRange(this.yVal, 0, stepTime + 1)));
    
                       
           // List<double> testtt = yVal.GetRange((yVal.Count - 11), 11);
           // for (int i = 0; i < testtt.Count; i++){
           //     Console.WriteLine("Yval["+i+"] = " + testtt[i]);
            //}
            
            yEnd = OtherFunctions.meanCalcFromArray(yVal.GetRange((yVal.Count - 11), 11));
            //setyEnd(meanCalcFromArray(Arrays.copyOfRange(this.yVal, this.yValLenght - 11, this.yValLenght)));

        }

        /**
        *Determine the Y Direction
        *
        * @param yEnd Value of the last component from yVal array
        * @param yStart Value of the second component from yVal array
        */
        private int determineYDirection(double yEnd, double yStart)
        {

            int direction = 0;

            if (yEnd > yStart)
            {
                direction = 1;
            }
            else
            {
                direction = -1;
            }

            return direction;
        }

        private int determineDeadTime(int lenghtYVal,int yDir, int tstep) {
		
		
		    double maxDyDt = 0;
		    int maxDyDtX = 0;
		    int Tt =0;
		    double dYdtNoise = 0;
		
		
		    //double dydt[]= new double[lenghtYVal];
            List<double> dydt = new List<double>(lenghtYVal);

            

    		for(int i=0;i<lenghtYVal;i++){
		    	dydt.Add(0.0d);
	    	}

            
            
		    // Calculus of the maximum Delta
		    for(int z=1; z<lenghtYVal-1; z++){ // %% from the second until the penultimate
			    dydt[z] = yDir*((yVal[z+1]-yVal[z-1])/2);
                Console.WriteLine("---------------Z= " + z+" -------------");
                Console.WriteLine("dydt[z=" + z + "]="+dydt[z]);
                Console.WriteLine("yVal[z+1=" + (z + 1) + "]="+ yVal[z + 1]);
                Console.WriteLine("yval[z-1=" + (z - 1) + "]="+ yVal[z - 1]);
                Console.WriteLine("yval[(yVal[z+1]-yVal[z-1])/2]=" + ((yVal[z + 1] - yVal[z - 1])/2));
                Console.WriteLine("dydt[z=" + z + "]=" + dydt[z]);
			    if (dydt[z] > maxDyDt) {
				    maxDyDt = dydt[z]; // Value with double type
				    maxDyDtX = z;	   // Time with int type 
			    }
		    }
		
		    Tt = tstep;
		    /*Copies elements from original into a new array,
		    *from indexes start (inclusive) to end (EXclusive)*/
		    //double arrayN[] = Arrays.copyOfRange(dydt, tstep-20, tstep+1);

            // ARRAY N NAO ESTA COM VALORES E SIM COM 0s
            List<double> arrayN = dydt.GetRange((tstep-10),11);
            Console.WriteLine("ARRAY N");
            OtherFunctions.showVectorDouble(arrayN);
            // N1 DEVERIA SER 0.8
            double n1 = OtherFunctions.maxCalcFromArray(arrayN);
            Console.WriteLine("N1 = " + n1);
            // N2 DEVERIA SER -3
            double n2 = OtherFunctions.minCalcFromArray(arrayN);
            Console.WriteLine("N2 = " + n2);

//		for(int i =0;i<arrayN.length;i++){
//		//System.out.println("ARRAYN["+i+"]="+ arrayN[i]);
//     	}		
		
		    dYdtNoise = n1- n2;
            Console.WriteLine("dYdtNoise = " + dYdtNoise);
//		//System.out.println("N1 = " + n1);
//		//System.out.println("N2 = " + n2);
		//System.out.println("dYdtNoise = " + dYdtNoise);
            //while (dydt[Tt + 1] <= (OtherFunctions.meanCalcFromArray(Arrays.copyOfRange(dydt, tstep - 10, tstep + 1)) + dYdtNoise))
 
            while ( dydt[Tt + 1] <= ( OtherFunctions.meanCalcFromArray(dydt.GetRange((tstep - 11),11)) + dYdtNoise) )
            {
                //Console.WriteLine("DEU PAUUU em Tt= "+Tt);
    			Tt=Tt+1;
	    	}
		
		    Tt=Tt-tstep-1;
		    //setDeadTimeTt(Tt);		
            deadTimeTt = Tt;
		    return Tt;
	    }

        private int calculateTimeX(double percentage)
        {

            int stepT = stepTime;
            int tT = deadTimeTt;
            int tX = stepT + tT;

            while ((this.yVal[tX] - yStart) <= ((yEnd - yStart) * (percentage / 100)))
            {

                //			//System.out.println("-----------------Tx IS on START = "+ tX);
                //			//System.out.println("yval(t10)-ystart = " + (this.yVal[tX]-getyStart()));
                //			//System.out.println("0.1*(yend-ystart) = " + ((getyEnd()-getyStart())*(percentage/100)));

                tX = tX + 1;
            }

            tX = tX - stepT - tT;
            return tX;

        }

        private int findNearestZeitprozentkennwert(double t10,double t90)
        {

            int n = 0;
            double mueN = 0;
            double mueNM1 = 0;
            //double t10 = TimeT10P;
            //double t90 = TimeT90P;

            //System.out.println("================findNearestZeitprozentkennwert()==========="+ n);
            //System.out.println("T10 = "+ t10);
            //System.out.println("T90 = "+ t90);
            //System.out.println("T10/T90 = "+ (t10/t90));

            while ((t10 / t90 > mueN) && (n < 25))
            {


                mueNM1 = mueN;
                n = n + 1;
                //System.out.println("MUE_N  BEFORE= "+ mueN);
                mueN = zeitprozentkennwert(n, 10) / zeitprozentkennwert(n, 90);
                //System.out.println("MUE_N  AFTER= "+ mueN);
                //System.out.println("N= "+ n);
            }

            if ((Math.Abs(t10 / t90 - mueNM1) < Math.Abs(t10 / t90 - mueN)))
            {
                //System.out.println("n = "+ n);
                n = n - 1;
            }


            //		System.out.println("NUMBERN = "+ n);

            return n;

        }

        private double zeitprozentkennwert(int n, int m)
        {

            double maxTol = 0.000001; //Genauigkeit -> Accuracy		
            double tau = n * ((double)m / 100 + 0.5); //Anfangswert Abschätzung -> Initial value estimation
            // Division of Int/Int types its not possible
            double deltaTau = 0;
            double sum = 0;
            double n1, n2, n3, n4 = 0;
            double npow1 = 0;
            double nfac1 = 0;

            Boolean flag = true;
            while (flag)
            {
                sum = 0;
                for (int i = 0; i < n; i++)
                {
                    
                    npow1 = Math.Pow(tau, i);
                    
                    nfac1 = factorial(i);
                    sum = sum + npow1 / nfac1;
                    //sum = sum+(Math.pow(tau,i))/factorial(i);
                }
                
                
                n1 = sum;
                n2 = (1 - ((double)m / 100)) * Math.Exp(tau);// Division of Int/Int types its not possible
                n3 = factorial(n - 1);
                n4 = Math.Pow(tau, (n - 1));
                deltaTau = (n1 - n2) * n3 / n4;
                //deltaTau =(sum-(1-m/100)*Math.exp(tau))*factorial(n-1)/Math.pow(tau,(n-1));
                tau = tau + deltaTau;
                if (Math.Abs(deltaTau) < maxTol)
                {
                    flag = false;
                }
            }

            return tau;
        }

        private int factorial(int input)
        {
            int x, fact = 1;
            for (x = input; x > 1; x--)
                fact *= x;

            return fact;

        }

        private double calculateTimeT1(int n, double t10P, double t50P,double t90P)
        {

            double t = 0;
            //int n = getnNearTPCV();
            //double t10P = getTimeT10P();
            //double t50P = getTimeT50P();
            //double t90P = getTimeT90P();

            double zPKn10 = zeitprozentkennwert(n, 10);
            double zPKn50 = zeitprozentkennwert(n, 50);
            double zPKn90 = zeitprozentkennwert(n, 90);

            double div1 = t10P / zPKn10;
            double div2 = t50P / zPKn50;
            double div3 = t90P / zPKn90;

            t = ((double)1 / 3) * (div1 + div2 + div3);// Division of Int/Int types its not possible
            //t=(1/3)*(t10P/zPKn10+t50P/zPKn50+t90P/zPKn90);
            //t=(1/3)*(t10P/zeitprozentkennwert(n,10)+t90P/zeitprozentkennwert(n,50)+t90P/zeitprozentkennwert(n,90));
            //		System.out.println("OUTPUT T1 = "+ t);

            return t;
        }

        private double calculateGainK()
        {
            double k = 0;

            double mult = xDirection * yDirection;
            double sub = (yEnd - yStart);
            double abs = Math.Abs(xEnd - xStart);

            k = (sub / abs) * (mult);
            //		k = (getyEnd()-getyStart())/Math.abs(getxEnd()-getxStart())*getxDirection()*getyDirection();
            return k;
        }


    }
}
