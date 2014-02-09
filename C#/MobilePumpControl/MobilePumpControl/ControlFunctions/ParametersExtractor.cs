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
    
    private List<double> xVal {get ; private set;}
    private List<double> yVal { get; private set; }
    
    private double xStart {get ; private set;}
    private double yStart {get ; private set;}    
    private double xEnd {get ; private set;}
    private double yEnd {get ; private set;}

    private List<int> timeVector { get; private set; }
	
    private int xDirection {get ; private set;}
	private int yDirection {get ; private set;}
	
    private int stepTime {get ; private set;}
	private int deadTimeTt {get ; private set;}
	
    private int TimeT10P {get ; private set;}
	private int TimeT50P {get ; private set;}
	private int TimeT90P {get ; private set;}

    private double gainK { get; private set; }
    private double timeT1 { get; private set; }
    private int nNearTPCV { get; private set; }
    // nearest zeitprozentkennwert -> nearest time percentage characteristic value

        public ParametersExtractor(List<double> signalInput, List<double> signalOutput) {

            initializeParameters();

            xVal = signalInput.GetRange((120 - 1), 181);

            //Array.Copy(signalInput, (120 - 1), xVal, 0, 181);
            
            
            /*Copies elements from original into a new array,
         *from indexes start (inclusive) to end (EXclusive)
         */
            //setxVal(Arrays.copyOfRange(signalInput, 120 - 1, 300 - 1 + 1));
            //setxValLenght(xVal.length);

            //		for(int i =0;i<xVal.length;i++){
            //			//System.out.println("XVAL["+i+"]="+ xVal[i]);
            //		}

            yVal = signalInput.GetRange((120 - 1), 181);

            //Array.Copy(signalOutput, (120 - 1), yVal, 0, 181);

            /*Copies elements from original into a new array,
             *from indexes start (inclusive) to end (EXclusive)
             */
            //setyVal(Arrays.copyOfRange(signalOutput, 120 - 1, 300 - 1 + 1));
            //setyValLenght(yVal.length);

            //		for(int j =0;j<yVal.length;j++){
            //			//System.out.println("YVAL["+j+"]="+ yVal[j]);
            //		}


            timeVector = initializeTimeVector((yVal.Count - 1));
            //setTimeVector(initializeTimeVector(getyValLenght() - 1));

            xDirection = determineXDirection(xVal[xVal.Count - 1], xVal[0]);
            //setxDirection(determineXDirection(this.xVal[this.xValLenght - 1], this.xVal[0]));
            //System.out.println("XDIRECTION IS = "+getxDirection());

            stepTime = determineStepTime(xVal.Count, xDirection);
            //setStepTime(determineStepTime(getxValLenght(), getxDirection()));
            //System.out.println("STEPTIME IS = "+getStepTime() + "+1s");

            calculateStarAndEndTime();
            //		System.out.println("XSTART IS = "+ getxStart());
            //		System.out.println("XEND IS = "+ getxEnd());
            //		System.out.println("YSTART IS = "+ getyStart());
            //		System.out.println("YEND IS = "+ getyEnd());

            yDirection = determineYDirection(yVal[yVal.Count - 1], yVal[0]);
            //setyDirection(determineYDirection(this.yVal[this.yValLenght - 1], this.yVal[0]));
            //System.out.println("YDIRECTION IS = "+getyDirection());

            deadTimeTt = determineDeadTime(yVal.Count, yDirection, stepTime);
            //System.out.println("DEADTIME TT IS = "+ getDeadTimeTt());

            flipYValIfNecessary(getyDirection(), getyStart(), getyEnd(), getyValLenght());

            setTimeT10P(calculateTimeX(10));
            //		System.out.println("TIME T10P IS = "+ getTimeT10P());
            setTimeT50P(calculateTimeX(50));
            //		System.out.println("TIME T50P IS = "+ getTimeT50P());
            setTimeT90P(calculateTimeX(90));
            //		System.out.println("TIME T90P IS = "+ getTimeT90P());

            setnNearTPCV(findNearestZeitprozentkennwert());//find nearest time percentage characteristic value

            setTimeT1(calculateTimeT1());
            //		System.out.println("TIME T1 IS = "+ getTimeT1());
            setGainK(calculateGainK());
            //      System.out.println("GAIN K IS = "+ getGainK());
		
		

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
    			timVec[i]=i;
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

            yStart = meanCalcFromArray(yVal.GetRange(0,(stepTime+1)));
            //setyStart(meanCalcFromArray(Arrays.copyOfRange(this.yVal, 0, stepTime + 1)));

            yEnd = meanCalcFromArray(yVal.GetRange((yVal.Count -11), yVal.Count));
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
            List<double> dydt= new List<double>(lenghtYVal);

    		for(int i=0;i<lenghtYVal;i++){
		    	dydt[i]=0;
	    	}
		
		    // Calculus of the maximum Delta
		    for(int z=1; z<lenghtYVal-1; z++){ // %% from the second until the penultimate
			    dydt[z] = yDir*((yVal[z+1]-yVal[z-1])/2);
			    if (dydt[z] > maxDyDt) {
				    maxDyDt = dydt[z]; // Value with double type
				    maxDyDtX = z;	   // Time with int type 
			    }
		    }
		
		    Tt = tstep;
		    /*Copies elements from original into a new array,
		    *from indexes start (inclusive) to end (EXclusive)*/
		    //double arrayN[] = Arrays.copyOfRange(dydt, tstep-20, tstep+1);
            List<double> arrayN = dydt.GetRange((tstep-20),(tstep+1));
		    
            double n1 = OtherFunctions.maxCalcFromArray(arrayN);
            double n2 = OtherFunctions.minCalcFromArray(arrayN);	
//		for(int i =0;i<arrayN.length;i++){
//		//System.out.println("ARRAYN["+i+"]="+ arrayN[i]);
//     	}		
		
		    dYdtNoise = n1- n2;
//		//System.out.println("N1 = " + n1);
//		//System.out.println("N2 = " + n2);
		//System.out.println("dYdtNoise = " + dYdtNoise);
            //while (dydt[Tt + 1] <= (OtherFunctions.meanCalcFromArray(Arrays.copyOfRange(dydt, tstep - 10, tstep + 1)) + dYdtNoise))
            while (dydt[Tt + 1] <= (OtherFunctions.meanCalcFromArray(dydt.GetRange(( tstep - 10),( tstep + 1))) + dYdtNoise))
            {
    			Tt=Tt+1;
	    	}
		
		    Tt=Tt-tstep-1;
		    //setDeadTimeTt(Tt);		
            deadTimeTt = Tt;
		    return Tt;
	    }

    }
}
