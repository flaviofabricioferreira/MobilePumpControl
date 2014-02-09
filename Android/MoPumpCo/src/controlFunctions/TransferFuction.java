package controlFunctions;

import java.util.ArrayList;
import java.util.List;


/** Class that implements the Transfer Function 
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class TransferFuction {

	private List<Double> Numerator;
	private List<Double> Denominator;
	
	
	
	public TransferFuction(List<Double> Num,List<Double> Den){		
		
//		List<Double> poly1 = new ArrayList<Double>();
//		poly1.add(1.0);
//		poly1.add(2.0);
//		poly1.add(3.0);
//			
//		List<Double> poly2 = new ArrayList<Double>();
//		poly2.add(4.0);
//		poly2.add(5.0);
//
//		multiplyPolys(poly1, poly2);
		
		setNumerator(Num);
		setDenominator(Den);		
	}
	
	/** This method returns the numerator and denominator of the transfer tunction
	 * 
	 * 
	 * @return Two double Lists with numerator and denominator 
	 */
	public ArrayList<List<Double>> getTfData(){
		
		
		ArrayList<List<Double>> listND = new ArrayList<List<Double>>();
		List<Double> N = new ArrayList<Double>();
		List<Double> D = new ArrayList<Double>();
		
		int numberOfShifts = 0;
		int sizeNum = this.Numerator.size();
		int sizeDen = this.Denominator.size();
		
		
		for(int i=0;i<sizeNum;i++){
			N.add(this.Numerator.get(i));
		}
		for(int j=0;j<sizeDen;j++){
			D.add(this.Denominator.get(j));
		}
						
		
		if(sizeNum > sizeDen){
			numberOfShifts = sizeNum - sizeDen;
			D = OtherFunctions.shiftRightVector(D,numberOfShifts);
		} else if (sizeNum < sizeDen){
			numberOfShifts = sizeDen - sizeNum;			
			N = OtherFunctions.shiftRightVector(N,numberOfShifts);			
		} else {
			numberOfShifts = 0;
		}
		
		listND.add(N);
		listND.add(D);
		
		return listND;
	}
	
	
	
	
	
	/** Get Method of the parameter Numerator
	 * @return
	 */
	public List<Double> getNumerator() {
		return Numerator;
	}

	/** Get Method of the parameter Denominator
	 * @return the denominator
	 */
	public List<Double> getDenominator() {
		return Denominator;
	}

	/** Set Method of the parameter Numerator
	 * @param numerator 
	 */
	private void setNumerator(List<Double> numerator) {
		Numerator = numerator;
	}

	/**Set Method of the parameter Denominator
	 * @param denominator 
	 */
	private void setDenominator(List<Double> denominator) {
		Denominator = denominator;
	}

	/** Method that permit multiply the transfer function by another transfer function
	 * 
	 * @param tf2 is the transfer function that will be multiplied by this transfer function.
	 * @return out is the result of the multiplication. 
	 */
	public TransferFuction multiplyTranferFuctionby(TransferFuction tf2){
		
		//This implematation of android was because the parameters are passed by reference		
		
		List<Double> inputNum2 = new ArrayList<Double>();
		List<Double> inputDen2 = new ArrayList<Double>();
		
		for(int i=0;i<tf2.Numerator.size();i++){
			inputNum2.add(tf2.Numerator.get(i));
		}
		for(int j=0;j<tf2.Denominator.size();j++){
			inputDen2.add(tf2.Denominator.get(j));
		}
		
		List<Double> outNum = multiplyPolys(this.Numerator,inputNum2);
		List<Double> outDen = multiplyPolys(this.Denominator,inputDen2);
	
		TransferFuction out = new TransferFuction(outNum, outDen);
		
		return  out;
	}
	
	/** Method that permit multiply one polynomial by another 
	 * 
	 * @param Poly1 is the first polynomial of the multiplication.
	 * @param Poly2 is the second polynomial of the multiplication.
	 * @return multiResult is the result of the multiplication. 
	 */
	private List<Double> multiplyPolys(List<Double> Poly1,List<Double> Poly2){
		
		List<Double> multiResult = OtherFunctions.zeros(Poly1.size()+Poly2.size()-1);
		
		for(int i = 0; i < Poly1.size(); ++i)
		{
			for(int j = 0; j < Poly2.size(); ++j)
			{
				multiResult.set((i + j), (multiResult.get(i + j)+(Poly1.get(i)*Poly2.get(j))));
			}
		}

		return multiResult;
	}
	
	/** Method that shows the transfer function of the same way of the Matlab  
	 * 
	 */
	public void show(){
			
		String num = "";
		double numberN = 0;
		int expnumN = 0;
		String den = "";
		double numberD = 0;
		int expnumD = 0;
		
		
		for(int i=0;i<this.Numerator.size();i++){
			numberN = this.Numerator.get(i); 
			expnumN = (this.Numerator.size()-1-i);
			if(numberN > 0){
				num = num + " ";
				num = num + "+";
				num = num + String.valueOf(numberN);
				if(expnumN != 0){
					num = num + "s";
					if(expnumN != 1){
						num = num + "^" +(String.valueOf(expnumN));	
					}
				}
				
			} else if (numberN < 0) {
				num = num + " ";
				num = num + "-";
				num = num + (String.valueOf(numberN));
				if(expnumN != 0){
					num = num + "s";
					if(expnumN != 1){
						num = num + "^" +(String.valueOf(expnumN));	
					}
				}
			} else {
				
			}
						 
		}
		System.out.println(num);
		for(int j=0;j<this.Denominator.size();j++){
			numberD = this.Denominator.get(j); 
			expnumD = (this.Denominator.size()-1-j);
			if(numberD > 0){
				den = den + " ";
				den = den + "+";
				den = den + (String.valueOf(numberD));
				if(expnumD != 0){
					den = den + "s";
					if(expnumD != 1){
						den = den + "^" +(String.valueOf(expnumD));	
					}
				}
				
			} else if (numberD < 0) {
				den = den + " ";
				den = den + "-";
				den = den + (String.valueOf(numberD));
				if(expnumD != 0){
					den = den + "s";
					if(expnumD != 1){
						den = den + "^" +(String.valueOf(expnumD));	
					}
				}
			} else {
				
			}
						 
		}
		System.out.println("-------------------------------");
		System.out.println(den);
		System.out.println("===================================================");
		
		
		
		
	}
	
}
