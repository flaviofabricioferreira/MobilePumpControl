/**
 * MATLAB_PARSE
 * RUHR-UNIVERSITY BOCHUM
 * AUTOMATIC CONTROL AND SYSTEMS THEORY
 *
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version 1.0 October-2013
 */
package controlFunctions;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Array;
import java.util.Arrays;
import android.content.Loader.ForceLoadContentObserver;
import android.os.Environment;
import java.lang.Math;

import com.jmatio.io.*;
import com.jmatio.types.*;


/** Class that extract the parameters of the system from two signals (input and output signals of the system) to create a transfer function.
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class ParametersExtractor {

	private double xVal[];
	private int xValLenght=0;
	private double yVal[];
	private int yValLenght=0;
	private double xStart=0,yStart=0,xEnd=0,yEnd=0;
	private int timeVector[];
	private int xDirection = 0;
	private int yDirection = 0;
	private int stepTime = 0;
	private int deadTimeTt = 0;
	private int TimeT10P = 0;
	private int TimeT50P = 0;
	private int TimeT90P = 0;
	


	private double gainK = 0;
	private double timeT1 = 0;
	private int nNearTPCV = 0; // nearest zeitprozentkennwert -> nearest time percentage characteristic value
	
	
	
	public int getnNearTPCV() {
		return nNearTPCV;
	}




	private void setnNearTPCV(int nNearTPCV) {
		this.nNearTPCV = nNearTPCV;
	}




	/**
     * Constructor of ParametersExtractor read data sets
     *
     * 
     *
     * @param signal1[] Signal stored
     * @param signal2[] Signal stored
     */
	//public ParametersExtractor(double signal1[],double signal2[]) {
	public ParametersExtractor(double signal1[],double signal2[]) {
        
		/*Copies elements from original into a new array,
		 *from indexes start (inclusive) to end (EXclusive)
		 */
		setxVal(Arrays.copyOfRange(signal2, 120-1, 300-1 +1 ));
		setxValLenght(xVal.length);
		
//		for(int i =0;i<xVal.length;i++){
//			//System.out.println("XVAL["+i+"]="+ xVal[i]);
//		}
		
		
		/*Copies elements from original into a new array,
		 *from indexes start (inclusive) to end (EXclusive)
		 */
		setyVal(Arrays.copyOfRange(signal1, 120-1, 300-1 +1 ));
		setyValLenght(yVal.length);
		
//		for(int j =0;j<yVal.length;j++){
//			//System.out.println("YVAL["+j+"]="+ yVal[j]);
//		}
		
		setTimeVector(initializeTimeVector(getyValLenght() - 1));
		
		setxDirection(determineXDirection(this.xVal[this.xValLenght-1],this.xVal[0]));
		//System.out.println("XDIRECTION IS = "+getxDirection());
		
		setStepTime(determineStepTime(getxValLenght(), getxDirection()));
		//System.out.println("STEPTIME IS = "+getStepTime() + "+1s");
		
		calculateStarAndEndTime();
//		System.out.println("XSTART IS = "+ getxStart());
//		System.out.println("XEND IS = "+ getxEnd());
//		System.out.println("YSTART IS = "+ getyStart());
//		System.out.println("YEND IS = "+ getyEnd());

		setyDirection(determineYDirection(this.yVal[this.yValLenght-1],this.yVal[0]));
		//System.out.println("YDIRECTION IS = "+getyDirection());
		
		setDeadTimeTt(determineDeadTime(getyValLenght(),getyDirection(),getStepTime()));
		//System.out.println("DEADTIME TT IS = "+ getDeadTimeTt());
		
		flipYValIfNecessary(getyDirection(),getyStart(),getyEnd(),getyValLenght());
		
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
	


	private double calculateGainK() {
		double k = 0;
		
		double mult = getxDirection()*getyDirection();	
		double sub = (getyEnd()-getyStart());
		double abs = Math.abs(getxEnd()-getxStart());
		
		k = (sub/abs)*(mult);
//		k = (getyEnd()-getyStart())/Math.abs(getxEnd()-getxStart())*getxDirection()*getyDirection();
		return k;
	}




	private double calculateTimeT1() {
		
		double t=0;
		int n = getnNearTPCV();
		double t10P=getTimeT10P();
		double t50P=getTimeT50P();
		double t90P=getTimeT90P();
		
		double zPKn10=zeitprozentkennwert(n,10);
		double zPKn50=zeitprozentkennwert(n,50);
		double zPKn90=zeitprozentkennwert(n,90);
		
		double div1 = t10P/zPKn10;
		double div2 = t50P/zPKn50;
		double div3 = t90P/zPKn90;
					
		t=((double)1/3)*(div1+div2+div3);// Division of Int/Int types its not possible
        //t=(1/3)*(t10P/zPKn10+t50P/zPKn50+t90P/zPKn90);
		//t=(1/3)*(t10P/zeitprozentkennwert(n,10)+t90P/zeitprozentkennwert(n,50)+t90P/zeitprozentkennwert(n,90));
		//		System.out.println("OUTPUT T1 = "+ t);
		
		return t;
	}




	private double zeitprozentkennwert(int n,int m) {
		
		double maxTol=0.000001; //Genauigkeit -> Accuracy		
		double tau = n*((double)m/100 + 0.5); //Anfangswert Abschätzung -> Initial value estimation
		                                      // Division of Int/Int types its not possible
		double deltaTau = 0;
		double sum = 0;		
		double n1,n2,n3,n4 = 0;
		double npow1=0;
		double nfac1=0;
		
		boolean flag=true;
		while(flag){
			sum = 0;
			for(int i=0;i<n;i++){
				npow1=Math.pow(tau,i);
				nfac1=factorial(i);
				sum = sum + npow1/nfac1;
				//sum = sum+(Math.pow(tau,i))/factorial(i);
			}
			
			n1=sum;
			n2=(1-((double)m/100))*Math.exp(tau);// Division of Int/Int types its not possible
			n3=factorial(n-1);
			n4=Math.pow(tau,(n-1));
			deltaTau =(n1-n2)*n3/n4;					
			//deltaTau =(sum-(1-m/100)*Math.exp(tau))*factorial(n-1)/Math.pow(tau,(n-1));
			tau = tau + deltaTau;
			if(Math.abs(deltaTau)<maxTol){
				flag = false;
			}			
		}
		
		return tau;
	}
	


	private int findNearestZeitprozentkennwert() {
		
		int n= 0;
		double mueN=0;
		double mueNM1=0;
		double t10 = getTimeT10P(); 
		double t90 = getTimeT90P();
		
		//System.out.println("================findNearestZeitprozentkennwert()==========="+ n);
		//System.out.println("T10 = "+ t10);
		//System.out.println("T90 = "+ t90);
		//System.out.println("T10/T90 = "+ (t10/t90));
		
		while((t10/t90 > mueN)&&(n<25)){
			
			
			mueNM1 = mueN;
			n = n+1;
			//System.out.println("MUE_N  BEFORE= "+ mueN);
			mueN = zeitprozentkennwert(n,10)/zeitprozentkennwert(n,90);	
			//System.out.println("MUE_N  AFTER= "+ mueN);
			//System.out.println("N= "+ n);
		}
		
		if((Math.abs(t10/t90 - mueNM1)<Math.abs(t10/t90 - mueN))){
			//System.out.println("n = "+ n);
			n=n-1;
		}
		
		
//		System.out.println("NUMBERN = "+ n);
		
		return n;
		
	}


	private int calculateTimeX(double percentage) {
		
		int stepT = getStepTime();
		int tT= getDeadTimeTt();
		int tX= stepT + tT;
		
		while((this.yVal[tX]-getyStart())<=((getyEnd()-getyStart())*(percentage/100))){
			
//			//System.out.println("-----------------Tx IS on START = "+ tX);
//			//System.out.println("yval(t10)-ystart = " + (this.yVal[tX]-getyStart()));
//			//System.out.println("0.1*(yend-ystart) = " + ((getyEnd()-getyStart())*(percentage/100)));
			
			tX= tX+1;
			}
		
		tX= tX - stepT - tT;
		return tX;
		
	}


	private void flipYValIfNecessary(int yDir, double yStart, double yEnd, int ylenght) {
		
		double yend2=0;
				
		if (yDir == -1){
			
			//System.out.println("YDIRECTION == -	1  IS NECESSARY TO FLIP YVAL ");
			//System.out.println("BEFORE YSTART ="+yStart+" and YEND = "+yEnd);
			
			for(int i=0;i<ylenght;i++){
				this.yVal[i] = (yStart+yEnd)-this.yVal[i];	
		
			}
			
			//yend2=ystart;
			//yStart = yEnd;
			//yEnd = yend2;
			yend2 = this.yVal[0];
			setyStart(this.yVal[ylenght]);
			setyEnd(yend2);	
			
			//System.out.println("AFTER YSTART ="+getyStart()+" and YEND = "+getyEnd());
			
			
		}
		
		//System.out.println("YDIRECTION == /+ 1 NOT IS NECESSARY TO FLIP YVAL ");
		
		
	}


	private int determineDeadTime(int lenghtYVal,int yDir, int tstep) {
		
		
		double maxDyDt = 0;
		int maxDyDtX = 0;
		int Tt =0;
		double dYdtNoise = 0;
		
		
		double dydt[]= new double[lenghtYVal];
		for(int i=0;i<lenghtYVal;i++){
			dydt[i]=0;
		}
		
		// Calculus of the maximum Delta
		for(int z=1;z<lenghtYVal-1;z++){ // %% from the second until the penultimate
			dydt[z] = yDir*((this.yVal[z+1]-this.yVal[z-1])/2);
			if (dydt[z] > maxDyDt) {
				maxDyDt = dydt[z]; // Value with double type
				maxDyDtX = z;	   // Time with int type 
			}
		}
		
		Tt = tstep;
		/*Copies elements from original into a new array,
		 *from indexes start (inclusive) to end (EXclusive)*/
		double arrayN[] = Arrays.copyOfRange(dydt, tstep-20, tstep+1);
		double n1 = maxCalcFromArray(arrayN);
		double n2 = minCalcFromArray(arrayN);	
//		for(int i =0;i<arrayN.length;i++){
//		//System.out.println("ARRAYN["+i+"]="+ arrayN[i]);
//     	}		
		
		dYdtNoise = n1- n2;
//		//System.out.println("N1 = " + n1);
//		//System.out.println("N2 = " + n2);
		//System.out.println("dYdtNoise = " + dYdtNoise);
		while (dydt[Tt+1] <= (meanCalcFromArray(Arrays.copyOfRange(dydt, tstep-10, tstep+1))+dYdtNoise )){
			Tt=Tt+1;
		}
		
		Tt=Tt-tstep-1;
		setDeadTimeTt(Tt);		
		return Tt;
	}

	private void calculateStarAndEndTime() {
		
		
		setxStart(xVal[this.stepTime-1 ]);//(The -1 is necessary because the
		setxEnd(xVal[this.xValLenght -1]);// difference between the start point 
										  // of Java Arrays 0 and the start point 
										  // of Matlab Arrays 1 )
		
		
		/*Copies elements from original into a new array,
		 *from indexes start (inclusive) to end (EXclusive)*/
		setyStart(meanCalcFromArray(Arrays.copyOfRange(this.yVal, 0, stepTime+1)));
		setyEnd(meanCalcFromArray(Arrays.copyOfRange(this.yVal, this.yValLenght-11, this.yValLenght)));
		
	}
	

	private double meanCalcFromArray(double[] numbers) {
		 
		 double sum = 0;
         
         for(int i=0; i < numbers.length ; i++)
                 sum = sum + numbers[i];
        

        double average = sum / numbers.length;
		return average;
	}
	
	private double maxCalcFromArray(double[] numbers) {
		 
		double max = numbers[0];
        
        for(int i=0; i < numbers.length ; i++){
            if(numbers[i]>max)  
            {  
               max=numbers[i];  
            }  
        }

        return max;
	}
	
	private double minCalcFromArray(double[] numbers) {
		 
		double min = numbers[0];
        
        for(int i=0; i < numbers.length ; i++){
            if(numbers[i]<min)  
            {  
               min=numbers[i];  
            }  
        }

        return min;
	}
	
	

	/**
    *Determine the Step Time
    *
    * 
    *
    * @param lenghtxVal lenght Size of xVal[] array
    * @param dirX Direction from x
    */
	private int determineStepTime(int lenghtxVal, int dirX) {
		
		double maxDxDt = 0; // Value
		int maxDxDtX = 0; // Time
		int tStep = 0;
		
		// Fill with Zeros the array with lenghtxVal size 
		double dxdt[]= new double[lenghtxVal];
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
    *Determine the Y Direction
    *
    * @param yEnd Value of the last component from yVal array
    * @param yStart Value of the second component from yVal array
    */ 
	private int determineYDirection(double yEnd, double yStart) {
		
		int direction = 0;
		
		if(yEnd>yStart){
			direction =  1; 
		} else {
			direction = -1;
		}

		return direction;
	}
    /**
    *Determine the X Direction
    *
    * @param xEnd Value of the last component from xVal array
    * @param x1 Value of the second component from xVal array
    */
	private int determineXDirection(double xEnd, double x1) {
		
		int direction = 0;
		
		if(xEnd>x1){
			direction =  1; 
		} else {
			direction = -1;
		}

		return direction;
	}
	/**
    *Initialize the Time Vector
    * @param lenght Size of yVal[] array
    */
	private int[] initializeTimeVector(int lenght) {
		
		
		int timVec[] = new int[lenght];
		for(int i=0;i<lenght;i++){
			timVec[i]=i;
		}
		return timVec;
		
	}
	
	private int factorial ( int input )
	{
	  int x, fact = 1;
	  for ( x = input; x > 1; x--)
	     fact *= x;

	  return fact;

	}
	
	
	 private void setxVal(double[] xVal) {
			this.xVal = xVal;
		}


		private void setxValLenght(int xValLenght) {
			this.xValLenght = xValLenght;
		}


		private void setyVal(double[] yVal) {
			this.yVal = yVal;
		}


		private void setyValLenght(int yValLenght) {
			this.yValLenght = yValLenght;
		}


		private void setxStart(double xStart) {
			this.xStart = xStart;
		}


		private void setyStart(double yStart) {
			this.yStart = yStart;
		}


		private void setxEnd(double xEnd) {
			this.xEnd = xEnd;
		}


		private void setyEnd(double yEnd) {
			this.yEnd = yEnd;
		}


		private void setTimeVector(int[] timeVector) {
			this.timeVector = timeVector;
		}


		private void setxDirection(int xDirection) {
			this.xDirection = xDirection;
		}


		private void setyDirection(int yDirection) {
			this.yDirection = yDirection;
		}


		private void setStepTime(int stepTime) {
			this.stepTime = stepTime;
		}


		public double[] getxVal() {
			return xVal;
		}


		public int getxValLenght() {
			return xValLenght;
		}


		public double[] getyVal() {
			return yVal;
		}


		public int getyValLenght() {
			return yValLenght;
		}


		public double getxStart() {
			return xStart;
		}


		public double getyStart() {
			return yStart;
		}


		public double getxEnd() {
			return xEnd;
		}


		public double getyEnd() {
			return yEnd;
		}


		public int[] getTimeVector() {
			return timeVector;
		}


		public int getxDirection() {
			return xDirection;
		}


		public int getyDirection() {
			return yDirection;
		}


		public int getStepTime() {
			return stepTime;
		}
		private void setGainK(double gainK) {
			this.gainK = gainK;
		}


		private void setTimeT1(double timeT1) {
			this.timeT1 = timeT1;
		}


		public double getGainK() {
			return gainK;
		}


		public double getTimeT1() {
			return timeT1;
		}
		



	


	
















		public int getDeadTimeTt() {
			return deadTimeTt;
		}


		private void setDeadTimeTt(int deadTimeTt) {
			this.deadTimeTt = deadTimeTt;
		}

		private void setTimeT10P(int timeT10P) {
			TimeT10P = timeT10P;
		}




		private void setTimeT50P(int timeT50P) {
			TimeT50P = timeT50P;
		}




		private void setTimeT90P(int timeT90P) {
			TimeT90P = timeT90P;
		}




		public int getTimeT10P() {
			return TimeT10P;
		}




		public int getTimeT50P() {
			return TimeT50P;
		}


		public int getTimeT90P() {
			return TimeT90P;
		}
		
}
