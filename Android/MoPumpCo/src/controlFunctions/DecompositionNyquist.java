package controlFunctions;

import java.util.ArrayList;
import java.util.List;
/** Class that implements the Nyquist Decomposition
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class DecompositionNyquist{

	private List<Double> De;//Denominator Even
	private List<Double> Do;//Denominator Odd
	private List<Double> Ne;//Numerator Even
	private List<Double> No;//Numerator Odd
	private List<Double> X;
	private List<Double> Y;
	private List<Double> Z;
	private int n = 0;
	private int m = 0;
	
	
	public DecompositionNyquist(List<Double> inputD,List<Double> inputN){
	
//      MATLAB CODE
//		% Find returns the indices for elements diferrents of zero		
//		m=length(N)-min(find(N~=0))
//		n=length(D)-min(find(D~=0))

		System.out.println("INPUT N==========");
		OtherFunctions.showList(inputN);
		System.out.println("INPUT D==========");
		OtherFunctions.showList(inputD);
		
		TransferFuction tf = new TransferFuction(inputN, inputD);
		
		List<Integer> indicesN =  findNonZeroElements(inputN);
		
		int minFinNonZeroN = OtherFunctions.minCalcFromArray(indicesN);
		
		setM(inputN.size()-(minFinNonZeroN+1));// M and N Question about indeces or Counters

		List<Integer> indicesD =  findNonZeroElements(inputD);

		int minFinNonZeroD = OtherFunctions.minCalcFromArray(indicesD);

		setN(inputD.size()-(minFinNonZeroD+1) );// M and N Question about indeces or Counters

		int nD = inputD.size() - 1;

		
		List<Double> evenVector = OtherFunctions.ones(nD);
		List<Double> oddVector = evenVector;
		
	
		int sizeDNArrays = (int)(Math.floor(nD/2)+1);
		
		setDe(OtherFunctions.zeros(sizeDNArrays));
		setDo(OtherFunctions.zeros(sizeDNArrays));
		setNe(OtherFunctions.zeros(sizeDNArrays));
		setNo(OtherFunctions.zeros(sizeDNArrays));
		
		int signEven = 1;
		int signOdd = 1;
			
		for(int i=0;i<nD+1;i++){

			if( ((i+1)%2) == 1){
				
//				System.out.println("ITERATION mod(i,2)==1 WIth i ="+i);
		        
				// Matlab Code
				// De(end-(i-1)/2)=D(end-i+1)*signeven;
				int locationDe = (De.size()-1) - (i/2);				
				int locationD = (inputD.size()) - (i+1); //Was necessary change the fuction because
														 //the difference between the start point 
														 // of Java Arrays 0 and the start point 
													     // of Matlab Arrays 1 )
				De.set(locationDe, (inputD.get(locationD)*signEven));
							
				// Matlab Code
				//Ne(end-(i-1)/2)=N(end-i+1)*signeven;
				int locationNe = (Ne.size()-1) - (i/2);				
				int locationN = (inputN.size()) - (i+1); //Was necessary change the fuction because
													     //the difference between the start point 
														 // of Java Arrays 0 and the start point 
														 // of Matlab Arrays 1 )
				Ne.set(locationNe, (inputN.get(locationN)*signEven));
				
				// Matlab Code
				// signeven=signeven*-1
				signEven = signEven*-1;				
			} else {
				
				// Matlab Code
				// Do(end-i/2+1)=D(end-i+1)*signodd;
				int locationDo = (Do.size()-1) - ((i+1)/2) +1;				
				int locationD = (inputD.size()) - (i+1) ;//Was necessary change the fuction because
														 //the difference between the start point 
														 // of Java Arrays 0 and the start point 
														 // of Matlab Arrays 1 )
				Do.set(locationDo, (inputD.get(locationD)*signOdd));
			
				// Matlab Code
				//No(end-i/2+1)=N(end-i+1)*signodd;
				int locationNo = (No.size()-1)  - ((i+1)/2) +1  ;
				
				int locationN = (inputN.size()) - (i+1) ;//Was necessary change the fuction because
														 //the difference between the start point 
														 // of Java Arrays 0 and the start point 
														 // of Matlab Arrays 1 )
				
				No.set(locationNo, (inputN.get(locationN)*signOdd));
				// Matlab Code
				// signodd=signodd*-1
				signOdd = signOdd*-1;
			}
		}
		
		
		System.out.println("==========De Vector=========");
		OtherFunctions.showList(De);
		System.out.println("==========Do Vector=========");
		OtherFunctions.showList(Do);
		System.out.println("==========Ne Vector=========");
		OtherFunctions.showList(Ne);
		System.out.println("==========No Vector=========");
		OtherFunctions.showList(No);
		
		List<Double> convDoNe = OtherFunctions.convolution(Do, Ne);
		List<Double> convDeNo = OtherFunctions.convolution(De, No);
		List<Double> convDoNo = OtherFunctions.convolution(Do, No);
		List<Double> convDeNe = OtherFunctions.convolution(De, Ne);	
		List<Double> convNeNe = OtherFunctions.convolution(Ne, Ne);
		List<Double> convNoNo = OtherFunctions.convolution(No, No);			
		
		List<Double> XOut = OtherFunctions.SubOfVectors(convDoNe,convDeNo);
		System.out.println("----------X=conv(Do,Ne)-conv(De,No)----------");
		OtherFunctions.showList(XOut);	
//		
		List<Double> Y1 = OtherFunctions.shiftLeftVector(convDoNo,1);		
		List<Double> Y2 = OtherFunctions.shiftRightVector(convDeNe,1);
		List<Double> YOut = OtherFunctions.SumOfVectors(Y1,Y2);
		System.out.println("----------Y=[conv(Do,No), 0]+[0 conv(De,Ne)]----------");
		OtherFunctions.showList(YOut);

		List<Double> Z1 = OtherFunctions.shiftRightVector(convNeNe,1);
		List<Double> Z2 = OtherFunctions.shiftLeftVector(convNoNo,1);
		List<Double> ZOut = OtherFunctions.SumOfVectors(Z1,Z2);
		System.out.println("----------Z=[0 conv(Ne,Ne)]+[conv(No,No) 0]----------");
		OtherFunctions.showList(ZOut);	
		
		System.out.println("==========M Value=========");
		System.out.println("m = "+getM());
		System.out.println("==========N Value=========");
		System.out.println("n = "+getN());

	}	
	
	/**
	 * @param de the de to set
	 */
	private void setDe(List<Double> de) {
		De = de;
	}

	/**
	 * @param do1 the do to set
	 */
	private void setDo(List<Double> do1) {
		Do = do1;
	}

	/**
	 * @param ne the ne to set
	 */
	private void setNe(List<Double> ne) {
		Ne = ne;
	}

	/**
	 * @param no the no to set
	 */
	private void setNo(List<Double> no) {
		No = no;
	}

	/**
	 * @param x the x to set
	 */
	private void setX(List<Double> x) {
		X = x;
	}

	/**
	 * @param y the y to set
	 */
	private void setY(List<Double> y) {
		Y = y;
	}

	/**
	 * @param z the z to set
	 */
	private void setZ(List<Double> z) {
		Z = z;
	}

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
	 * @return the de
	 */
	private List<Double> getDe() {
		return De;
	}

	/**
	 * @return the do
	 */
	private List<Double> getDo() {
		return Do;
	}

	/**
	 * @return the ne
	 */
	private List<Double> getNe() {
		return Ne;
	}

	/**
	 * @return the no
	 */
	private List<Double> getNo() {
		return No;
	}

	/**
	 * @return the x
	 */
	private List<Double> getX() {
		return X;
	}

	/**
	 * @return the y
	 */
	private List<Double> getY() {
		return Y;
	}

	/**
	 * @return the z
	 */
	private List<Double> getZ() {
		return Z;
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
	
}
