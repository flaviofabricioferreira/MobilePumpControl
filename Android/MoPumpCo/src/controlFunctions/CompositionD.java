package controlFunctions;

import java.util.ArrayList;
import java.util.List;

/** Class that implements the Composition D
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class CompositionD{

	private List<Double> Ra;//Denominator Even
	private List<Double> Ia;//Denominator Odd
	private List<Double> Rb;//Numerator Even
	private List<Double> Ib;//Numerator Odd
	private List<Double> f1;//Numerator Odd
	private List<Double> f2;//Numerator Odd
	private List<Double> fn;//Numerator Odd
	private int n = 0;
	private int m = 0;
	private int l = 0;
	

	public CompositionD(List<Double> inputD,List<Double> inputN){
	
//      MATLAB CODE
//		% Find returns the indices for elements diferrents of zero		
//		m=length(N)-min(find(N~=0))
//		n=length(D)-min(find(D~=0))

		System.out.println("INPUT D==========");
		OtherFunctions.showList(inputD);
		System.out.println("INPUT N==========");
		OtherFunctions.showList(inputN);
		
		
		
		List<Double> inputDShiftedLeft = OtherFunctions.shiftLeftVector(inputD, 1);
		List<Double> inputNShiftedRight = OtherFunctions.shiftRightVector(inputN,1);
		
		System.out.println("INPUT D====SHIFTED RIGHT===");
		OtherFunctions.showList(inputDShiftedLeft);
		System.out.println("INPUT N====SHIFTED LEFT===");
		OtherFunctions.showList(inputNShiftedRight);
				
		
		TransferFuction tf = new TransferFuction(inputNShiftedRight, inputDShiftedLeft);
		
		
		List<Integer> indicesN =  findNonZeroElements(inputNShiftedRight);	
		int minFinNonZeroN = OtherFunctions.minCalcFromArray(indicesN);	
		setM(inputNShiftedRight.size()-(minFinNonZeroN+1));// M and N Question about indeces or Counters
		
		List<Integer> indicesD =  findNonZeroElements(inputDShiftedLeft);
		int minFinNonZeroD = OtherFunctions.minCalcFromArray(indicesD);
		setN(inputDShiftedLeft.size()-(minFinNonZeroD+1) );// M and N Question about indeces or Counters

		setL((getN() - getM()));
		
		int nD = inputDShiftedLeft.size();
				
		setRa(OtherFunctions.zeros(nD));
		setIa(OtherFunctions.zeros(nD));
		setRb(OtherFunctions.zeros(nD));
		setIb(OtherFunctions.zeros(nD));
		
		int signEven = 1;
		int signOdd = 1;
			
		for(int i=0;i<nD;i++){

			int locationN = (inputNShiftedRight.size() - (1+i));				
			int locationRa =(Ra.size() - (1+i));
			int locationD = (inputDShiftedLeft.size() - (1+i));
			int locationRb =(Rb.size() - (1+i));     
			int locationIa =(Ia.size() - (1+i));     
			int locationIb =(Ib.size() - (1+i));     //Was necessary change the fuction because
													 //the difference between the start point 
													 // of Java Arrays 0 and the start point 
												     // of Matlab Arrays 1 )
			if( (i%2) == 0){				
//				System.out.println("ITERATION mod(i,2)==1 WIth i ="+i);		
				Ra.set(locationRa, signEven*inputNShiftedRight.get(locationN));
				Rb.set(locationRb, signEven*inputDShiftedLeft.get(locationD));
				signEven=-signEven;
				Ia.set(locationIa, 0.0);
				Ib.set(locationIb, 0.0);
			} else {
				Ia.set(locationIa, (signOdd*inputNShiftedRight.get(locationN)));
				Ib.set(locationIb, (signOdd*inputDShiftedLeft.get(locationD)));
				signOdd=-signOdd;
				Ra.set(locationIa, 0.0);
				Rb.set(locationIb, 0.0);
			}
		}
				
//		KP generator function
		List<Double> convRaRb = OtherFunctions.convolution(Ra,Rb);
		List<Double> convIaIb = OtherFunctions.convolution(Ia,Ib);
		List<Double> convIaRb = OtherFunctions.convolution(Ia,Rb);
		List<Double> convRaIb = OtherFunctions.convolution(Ra,Ib);
		List<Double> convRaRa = OtherFunctions.convolution(Ra,Ra);
		List<Double> convIaIa = OtherFunctions.convolution(Ia,Ia);
		
		List<Double> SumConvRaRbConvIaIb = OtherFunctions.SumOfVectors(convRaRb,convIaIb);
		SumConvRaRbConvIaIb = OtherFunctions.MultOfVectorByOneNumber(SumConvRaRbConvIaIb,-1);
		setF1(OtherFunctions.shiftRightVector(SumConvRaRbConvIaIb, 1));
		
		List<Double> SubConvIaRbConvRaIb = OtherFunctions.SubOfVectors(convIaRb,convRaIb);
		setF2(OtherFunctions.shiftRightVector(SubConvIaRbConvRaIb, 1));
				
		List<Double> SumConvRaRaConvIaIa = OtherFunctions.SumOfVectors(convRaRa,convIaIa);		
		setFn(OtherFunctions.shiftLeftVector(SumConvRaRaConvIaIa, 1));

		

		
//		List<Double> convDoNe = OtherFunctions.convolution(Do, Ne);
//		List<Double> convDeNo = OtherFunctions.convolution(De, No);
//		
//		
//		List<Double> XOut = OtherFunctions.SubOfVectors(convDoNe,convDeNo);
//		System.out.println("----------X=conv(Do,Ne)-conv(De,No)----------");
//		OtherFunctions.showList(XOut);	
////		
//		List<Double> Y1 = OtherFunctions.shiftLeftVector(convDoNo,1);		
//		List<Double> Y2 = OtherFunctions.shiftRightVector(convDeNe,1);
//		List<Double> YOut = OtherFunctions.SumOfVectors(Y1,Y2);
//		System.out.println("----------Y=[conv(Do,No), 0]+[0 conv(De,Ne)]----------");
//		OtherFunctions.showList(YOut);
//
//		List<Double> Z1 = OtherFunctions.shiftRightVector(convNeNe,1);
//		List<Double> Z2 = OtherFunctions.shiftLeftVector(convNoNo,1);
//		List<Double> ZOut = OtherFunctions.SumOfVectors(Z1,Z2);
//		System.out.println("----------Z=[0 conv(Ne,Ne)]+[conv(No,No) 0]----------");
//		OtherFunctions.showList(ZOut);	
//		
//		System.out.println("==========M Value=========");
//		System.out.println("m = "+getM());
//		System.out.println("==========N Value=========");
//		System.out.println("n = "+getN());

	}	
	
	/**
	 * @return the f1
	 */
	public List<Double> getF1() {
		return f1;
	}

	/**
	 * @return the f2
	 */
	public List<Double> getF2() {
		return f2;
	}

	/**
	 * @return the fn
	 */
	public List<Double> getFn() {
		return fn;
	}

	/**
	 * @param f1 the f1 to set
	 */
	private void setF1(List<Double> f1) {
		this.f1 = f1;
	}

	/**
	 * @param f2 the f2 to set
	 */
	private void setF2(List<Double> f2) {
		this.f2 = f2;
	}

	/**
	 * @param fn the fn to set
	 */
	private void setFn(List<Double> fn) {
		this.fn = fn;
	}

	/**
	 * @return the n
	 */
	public int getN() {
		return n;
	}

	/**
	 * @return the m
	 */
	public int getM() {
		return m;
	}

	/**
	 * @return the ra
	 */
	public List<Double> getRa() {
		return Ra;
	}

	/**
	 * @return the ia
	 */
	public List<Double> getIa() {
		return Ia;
	}

	/**
	 * @return the rb
	 */
	public List<Double> getRb() {
		return Rb;
	}

	/**
	 * @return the ib
	 */
	public List<Double> getIb() {
		return Ib;
	}

	/**
	 * @param ra the ra to set
	 */
	private void setRa(List<Double> ra) {
		Ra = ra;
	}

	/**
	 * @param ia the ia to set
	 */
	private void setIa(List<Double> ia) {
		Ia = ia;
	}

	/**
	 * @param rb the rb to set
	 */
	private void setRb(List<Double> rb) {
		Rb = rb;
	}

	/**
	 * @param ib the ib to set
	 */
	private void setIb(List<Double> ib) {
		Ib = ib;
	}

	/**
	 * @param de the de to set
	 */
	

	private List<Integer> findNonZeroElements(List<Double> inputN) {

		List<Integer> ind = new ArrayList<Integer>();

		int c=0;
//		System.out.println("SIze of INPUTNARRAY IS = "+inputN.size());
		for(int i=0;i<inputN.size();i++){
			if(inputN.get(i)!= 0){
				ind.add(i);
				c++;
			}
		}
		
		if(c>0){
			return ind;			
		} else {
			return null;
		}
		
	}

	/**
	 * @param n the n to set
	 */
	private void setN(int n) {
		this.n = n;
	}

	/**
	 * @param m the m to set
	 */
	private void setM(int m) {
		this.m = m;
	}
		
	/**
	 * @param l the l to set
	 */
	private void setL(int l) {
		this.l = l;
	}

	/**
	 * @return the l
	 */
	public int getL() {
		return l;
	}
}
