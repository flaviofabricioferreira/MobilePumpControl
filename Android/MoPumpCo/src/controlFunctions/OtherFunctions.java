package controlFunctions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** Class that store many helpful mathematical methods
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
/**
 * @author Flavio
 *
 */
public class OtherFunctions {
	
	
	
	
	/** 
	 * @param numbers
	 * @return
	 */
	public static double minCalcFromArray(double[] numbers) {
		 
		double min = numbers[0];
        
        for(int i=0; i < numbers.length ; i++){
            if(numbers[i]<min)  
            {  
               min=numbers[i];  
            }  
        }

        return min;
	}
	
	public static double minCalcFromArray(List<Double> numbers) {
		 
		double min = numbers.get(0);
        
        for(int i=0; i < numbers.size() ; i++){
            if(numbers.get(i)<min)  
            {  
               min=numbers.get(i);  
            }  
        }

        return min;
	}
	
	public static int minCalcFromArray(List<Integer> numbers) {
		 
		int min = numbers.get(0);
        
        for(int i=0; i < numbers.size() ; i++){
            if(numbers.get(i)<min)  
            {  
               min=numbers.get(i);  
            }  
        }

        return min;
	}
		
	public static double maxCalcFromArray(List<Double> numbers) {
		 
		double max = numbers.get(0);
        
        for(int i=0; i < numbers.size() ; i++){
            if(numbers.get(i)>max)  
            {  
               max=numbers.get(i);  
            }  
        }

        return max;
	}
	
	

	
	/** Fill with Zeros the array with length size
	 * @param size is the lenght of the array
	 * @return list is the array of zeros with length size 
	 */
	public static List<Double> zeros(int size) {
		List<Double> list = new ArrayList<Double>();
		for(int i=0;i<size;i++){
			list.add(0.0);
		}
		return list;
	}
		
	/** Calculate the maximum value of the array
	 * @param numbers is the array thats we will search the maximum value
	 * @return max is the maximum value found at array
	 */
	public static double maxCalcFromArray(double[] numbers) {
		 
		double max = numbers[0];      
        for(int i=0; i < numbers.length ; i++){
            if(numbers[i]>max)  
            {  
               max=numbers[i];  
            }  
        }
        return max;
	}
	
	
	
	// Fill with Ones the array with lenghtxVal size
	public static List<Double> ones(int size) {
		List<Double> list = new ArrayList<Double>();
		for(int i=0;i<size;i++){
			list.add(1.0);
		}
		return list;
	}
	
	
	public static void showList(List<Double> L){
		
		for(int i=0;i<L.size();i++){
			System.out.println("ITEM["+i+"]= "+L.get(i));
		}
		
	}
	public static List<Double> flipLeftRightVector(List<Double> input){
		
//		System.out.println("NOT FLIPPED LIST");
//		showList(input);
//		Collections.reverse(input);
		
		int size = input.size();
		double temp;

		for (int i = 0; i < (size/2); i++)
		  {
//		     temp = array[i];
			 temp = input.get(i);
//		     array[i] = array[SIZE-1 - i];
			 input.set(i, input.get((size -1 - i)));
//		     array[SIZE-1 - i] = temp;
			 input.set((size -1 - i), temp);

		  }				
//		System.out.println("FLIPPED LIST");
//		showList(input);
		return input; 
		
	}
	
	public static List<Double> SumOfVectors(List<Double> N1,List<Double> N2){
		
		int sizeN1= N1.size();
		int sizeN2= N2.size();
		
		if(sizeN1 == sizeN2){
			List<Double> sum = zeros(sizeN1);
			for(int i=0;i<N1.size();i++){
				sum.set(i,(N1.get(i)+N2.get(i)));
			}
			return sum;
		}
		else{
			return null;	
		}
		 
		
	}
	
public static List<Double> SubOfVectors(List<Double> N1,List<Double> N2){
		
		int sizeN1= N1.size();
		int sizeN2= N2.size();
		
		if(sizeN1 == sizeN2){
			List<Double> sum = zeros(sizeN1);
			for(int i=0;i<N1.size();i++){
				sum.set(i,(N1.get(i)-N2.get(i)));
			}
			return sum;
		}
		else{
			return null;	
		}
		 
		
	}

public static List<Double> MultOfVectorByOneNumber(List<Double> N1,double number){
	
	int sizeN1= N1.size();
	List<Double> output = zeros(sizeN1);
	
    for(int i=0; i < sizeN1 ; i++){
        output.set(i, (N1.get(i)*number)) ;
    }

    return output;

}

public static List<Double> shiftRightVector(List<Double> N1,int number){
	
	int sizeN1= N1.size();
//	System.out.println("===================================");
//	System.out.println("INPUT SHIFTRIGHT");
//	showList(N1);
	List<Double> shiftted = zeros((sizeN1+number));
	
	for(int i=number;i<shiftted.size();i++){
	    shiftted.set(i,N1.get((i-number)));
	}
//	System.out.println("OUTPUT SHIFTRIGHT");
//	showList(shiftted);
	return shiftted;	 	
}

public static List<Double> shiftLeftVector(List<Double> N1,int number){
	
	int sizeN1= N1.size();
	
////	System.out.println("===================================");
////	System.out.println("INPUT SHIFTLEFT");
//	showList(N1);
	
	List<Double> shiftted = zeros((sizeN1+number));
	for(int i=0;i<(shiftted.size()-number);i++){
	    shiftted.set(i,N1.get(i));
	}
	
//	System.out.println("OUTPUT SHIFT");
//	showList(shiftted);
	
	return shiftted;	 	
}
	
	public static int sign(double number){
		
		int i=0;
		if(number >= 0){
			i=1;
		} else {
			i = -1;
		}
		
		return i;
		
	}


	public static double polyVal(List<Double> poly,double x){
		double value = 0;
		int size = poly.size();
		
		for(int i=0;i<size;i++){
			value += poly.get(i)*Math.pow(x,(size-1-i));			
		}
		
//		System.out.println("POLYVAL COM x=" + x +"e igual a"+value);
		
		return value;
	}
	
	public static List<Double> convolution(List<Double> inputX,List<Double> inputH) {
		
		//OBJECTS ARE PASSED BY REFERENCE AND PRIMITIVE VALUES BY VALUE
		// Then in this case when i to flip the inputH or the InputX ,
        // i am flipping the input values and not a copy. 
		// The solution is to transform  the two inputs in a copy of the input
	
		List<Double> inputXConv = zeros(inputX.size());
		for(int iX=0;iX<inputXConv.size();iX++){			 
			inputXConv.set(iX, inputX.get(iX));			
		}
		
		List<Double> inputHConv = zeros(inputH.size());
		for(int iH=0;iH<inputHConv.size();iH++){			 
			inputHConv.set(iH, inputH.get(iH));			
		}	
		
		int lenghtL1X = inputX.size();
		int lenghtL2H = inputH.size();
		int lenghtL3SUM = lenghtL1X + lenghtL2H -1;
		int lenghtL4SUB = lenghtL2H -1;
		int lenghtL5 = 0,p1=0;
		double c2 = 0,sum = 0;
		
		List<Double> inputHFliped = flipLeftRightVector(inputHConv); 
		List<Double> convolutionOutput = zeros(lenghtL3SUM);
		List<Double> c1;
		
		for(int i =0;i<lenghtL3SUM;i++){
			p1 = i + lenghtL4SUB;
			List<Double> h2 = zeros(lenghtL3SUM);
//			MATLABCODE =>  h2([p:p1])=f
			int c=0;			
			for(int k=i;k<=p1;k++){
				if(k>=h2.size()){
					h2.add(0.0); // At matlab code this is did automatically
				}
				h2.set(k, inputHFliped.get(c));// siye of H2 is 5(0,4)
				c++;
			}
//			MATLABCODE =>
//			l5=length(h2); 
//			h1=zeros(1,l5); 
//			h1([l2:l3])=x ;
			lenghtL5 = h2.size();
			List<Double> h1 = zeros(lenghtL5);
			int d=0;	
			for(int j=(lenghtL2H-1);j<lenghtL3SUM;j++){			
				h1.set(j, inputXConv.get(d));
				d++;
			}		
			
//			MATLABCODE =>
//			l5=length(h2); 
//			c1= h1.*h2;
//			X.*Y denotes element-by-element multiplication.  X and Y
//		    must have the same dimensions unless one is a scalar.
		
			c1 = zeros(lenghtL5);
			
			if(lenghtL1X==lenghtL2H){
				for(int u=0;u < h1.size();u++){
					double a = h1.get(u);
					double b = h2.get(u);
					double ab = a*b;
					c1.set(u, ab);				
				}
			}
			//			MATLABCODE =>			
//			for i=1:1:l3   
//			c2=c2+c1([i]) To add the same number for all numbers of the array l3 times
//			end 
			c2 = 0;
			for(int v=0;v<lenghtL3SUM;v++){				
				c2 = c2 + c1.get(v);
			}			
			sum = c2;
			convolutionOutput.set(i,sum);
		}
		
		
        return convolutionOutput;
    } 

	
	
}
