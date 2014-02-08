package controlFunctions;

import java.awt.font.NumericShaper;
import java.util.ArrayList;
import java.util.List;

/** Class that calculate the singular frequencies delay
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class CalcSingularFrequenciesDelay {

	private List<Double> omega0 = new ArrayList<Double>();
	private List<Double> omega0Type = new ArrayList<Double>();
	private List<Double> omegaPlus = new ArrayList<Double>();
	private List<Double> omegaMinus = new ArrayList<Double>();
	
	
	public CalcSingularFrequenciesDelay(List<Double> ListF1,List<Double> ListF2,List<Double> ListFn,
			                            int NumberKP,int NumberL,List<Double> DenInp,List<Double> NumInp,
			                            int littleL,double tolerance, boolean calcKPint){
		
		
		//solver settings
		double stepSize = 0.001;
		double stepFine = 0.0001;
		double minStep =  0.00001;
		double stepSizeOrig = stepSize;
		double omega = minStep;
		double omegaFine = 0;
		int omegasign = -1;
		double am = 0;
		double bn = 0;
		double lf = 0;
		double limfac = 0;
		double f = 0;
		double delta = 0; 
		
		int cOp1 =0;
		int cOp2 =0;
		int cOp3 =0;
		
		int ibreak = 0;
		int i = 1;
		int k=0;
		double y1 = 0;
		double dy1Dt = 0;
		double y2 = 0;
		double dy2Dt = 0;
	
		
		y1 = -NumberKP + 
		     (OtherFunctions.polyVal(ListF1,omega)*Math.sin(omega*NumberL)+
		      OtherFunctions.polyVal(ListF2,omega)*Math.cos(omega*NumberL) )/OtherFunctions.polyVal(ListFn,omega);
		
		dy1Dt = (-NumberKP + (OtherFunctions.polyVal(ListF1,omega+minStep)*Math.sin((omega+minStep)*NumberL)+
		                      OtherFunctions.polyVal(ListF2,omega+minStep)*Math.cos((omega+minStep)*NumberL)
		                     )/OtherFunctions.polyVal(ListFn, (omega+minStep))) - y1 ;
				 

		
		
		
		//initialize limit function
		// Why not FindNonZero Elements ??? 
		while(NumInp.get(k)==0){
			k = k+1;
		}
		am = NumInp.get(k);
		
		k = 0;
		while(DenInp.get(k)==0){
			k = k+1;
		}
		bn = DenInp.get(k);
		
        //limit function factor		
		lf = littleL;
		
		if( (littleL%2) != 0){
			lf = littleL-1;
		} 
		
		if( ((lf/2)%2)==0){
			limfac =  1;
		} else {
			limfac = -1;
		}
		
		//find singular freqs
		int maxI= 20;
		
		if(calcKPint){
			maxI = 30;
		}

		while((ibreak<maxI)){
//		while(ibreak<maxI){
//			System.out.println("==========IBREAK========="+ibreak);
			//%calc next y(omega+delta) and its gradient
			y2 = -NumberKP + 
			     (OtherFunctions.polyVal(ListF1,omega)*Math.sin(omega*NumberL)+
				  OtherFunctions.polyVal(ListF2,omega)*Math.cos(omega*NumberL) )/OtherFunctions.polyVal(ListFn,omega);
			
			dy2Dt = (-NumberKP + (OtherFunctions.polyVal(ListF1,omega+minStep)*Math.sin((omega+minStep)*NumberL)+
                    OtherFunctions.polyVal(ListF2,omega+minStep)*Math.cos((omega+minStep)*NumberL)
                   )/OtherFunctions.polyVal(ListFn, (omega+minStep))) - y2 ;
			
			//%detect change in sign,
			//%if sign changed refine stepsize and search in opposite direction until
			//%sign changes again
			if (OtherFunctions.sign(y1)==-OtherFunctions.sign(y2)){
				cOp1 = cOp1 +1;
//				System.out.println("=========OPTION1 number="+cOp1);
//				System.out.println("OPTION2 number="+cOp2);
//				System.out.println("OPTION3 number="+cOp3);
				if (omega0.size() == 0){
//					System.out.println("==========WHILE3 IF2=========");
					if(y2>y1){
//						System.out.println("==========WHILE3 IF3=========");
						omegasign = 1;
					}
				}
				omegaFine = omega - stepSize;
//				%detect change of sign in opposite direction
				
//				System.out.println("IBREAK = "+ibreak+"===============================================");
				double nn1 = -NumberKP ;
			    double nn2 = OtherFunctions.polyVal(ListF1, omegaFine);
			    double nn3 = Math.sin(omegaFine*NumberL);
			    double nn4 = OtherFunctions.polyVal(ListF2, omegaFine);
			    double nn5 = Math.cos(omegaFine*NumberL);
			    double nn6 = OtherFunctions.polyVal(ListFn, omegaFine);
				double nn7 = OtherFunctions.sign(y2);
			    
//				System.out.println("LIST F1");
//				OtherFunctions.showList(ListF1);
//				System.out.println("LIST F2");
//				OtherFunctions.showList(ListF2);
//				System.out.println("LIST Fn");
//				OtherFunctions.showList(ListFn);
//				System.out.println("OMEGA = "+omega);
//				System.out.println("STEPSIZE = "+stepSize);
//				System.out.println("OMEGAFINE = "+omegaFine);
				
//				
//				System.out.println("N1 = "+nn1);
//			    System.out.println("N2 = "+nn2);
//			    System.out.println("N3 = "+nn3);
//			    System.out.println("N4 = "+nn4);
//			    System.out.println("N5 = "+nn5);
//			    System.out.println("N6 = "+nn6);
//			    System.out.println("N7 = "+nn7);
			    
//				System.out.println("SIGN1 != SIGN2");
//				System.out.println(sii1+"!="+sii2);
				while(OtherFunctions.sign(-NumberKP + 
						                  ((OtherFunctions.polyVal(ListF1, omegaFine)*Math.sin(omegaFine*NumberL)+
						                   OtherFunctions.polyVal(ListF2, omegaFine)*Math.cos(omegaFine*NumberL))
						                   /OtherFunctions.polyVal(ListFn, omegaFine)))
						                  !=OtherFunctions.sign(y2)){
					
//					System.out.println("==========WHILE4=========");
					omegaFine = omegaFine+stepFine;
//					System.out.println("omegaFine = omegaFine+stepFine");
//					System.out.println(omegaFine +" = "+omegaFine+"+"+stepFine);
					
				}
				
//				System.out.println("OMEGAFINE after while= "+omegaFine);
//				%add omega to omega0 vector
				List<Double> omegaX = OtherFunctions.shiftLeftVector(omega0,1);
				omegaX.set(omegaX.size()-1, (omegaFine-stepFine+omegaFine)/2);
				omega0 = omegaX;							
				
//				System.out.println("OMEGA0 = ");
//				OtherFunctions.showList(omega0);

				
				// until this point is ok 
				
//				%add type to omega0type vector (1==rising, -1==falling)
				
				if(dy2Dt>0){
//					System.out.println("========== IF4=========");
					List<Double> omega0TypeX = OtherFunctions.shiftLeftVector(omega0Type,1);
					omega0TypeX.set(omega0TypeX.size()-1, 1.0);
					omega0Type = omega0TypeX;
				} else {
//					System.out.println("========== IF5=========");
					List<Double> omega0TypeX = OtherFunctions.shiftLeftVector(omega0Type,1);
					omega0TypeX.set(omega0TypeX.size()-1, -1.0);
					omega0Type = omega0TypeX;
				}
				
//				%replace y1 by y2 (incl. gradients)				
				y1=y2;
				dy1Dt=dy2Dt;
				
//				%check if tolerance is reached
				double omega0end = omega0.get(omega0.size()-1);
				f = (OtherFunctions.polyVal(ListF1,omega0end)*Math.sin(omega0end*NumberL)+
				     OtherFunctions.polyVal(ListF2,omega0end)*Math.cos(omega0end*NumberL))
					 /OtherFunctions.polyVal(ListFn, omega0end);
				
				double n1= (-(bn/am)*limfac)*(Math.pow(omega0end,(littleL-1)));
				double n2 = 0;
				double n3=0;
//				System.out.println("-----------------------------------------");
				
				
				if( (littleL%2)==0){
//					System.out.println("========== IF7=========");
					n2= n1*Math.sin(omega0end*NumberL);
					delta = Math.abs(f- n2);								
//					System.out.println("Delta if"+delta);
				} else {
//					System.out.println("========== IF8=========");
					n2= n1*Math.cos(omega0end*NumberL);
					delta = Math.abs(f- n2);
//					System.out.println("Delta else"+delta);
				}			
				
//				System.out.println("n1 ="+n1);
//				System.out.println("n2 ="+n2);
//				System.out.println("n3 ="+n3);
//				System.out.println("Delta ="+delta);
//				System.out.println("f ="+f);
//				System.out.println("Delta/f ="+(delta/f));
//				System.out.println("Tolerance ="+tolerance);
//				System.out.println("1-Tolerance ="+(1-tolerance));
				
				if(((delta/f)>=(1-tolerance))||ibreak>0){
//					System.out.println("========== IF9=========");					
					ibreak = ibreak+1;
				}
//				%plot(omega0(end),0,'ro');
//				System.out.println("IBREAK PLUS ="+ibreak);
				
				stepSize = stepSizeOrig;
				
			} else if ( ( (OtherFunctions.sign(dy1Dt)==-1) && (OtherFunctions.sign(dy2Dt)==1) ) &&
			            ( (y1>0) && (y2>0) ) ||
			            ( (OtherFunctions.sign(dy1Dt)==1) && (OtherFunctions.sign(dy2Dt)==-1) ) &&
			            ( (y1<0) && (y2<0) ) &&
			            ( stepSize > minStep) ) { 
				cOp2 = cOp2 +1;
				
//				System.out.println("===========OPTION2 number="+cOp2);
//				System.out.println("OPTION1 number="+cOp1);
//				System.out.println("OPTION3 number="+cOp3);
				
				
				omega = omega - (2*stepSize);
				stepSize = stepSize/10;

//			    %between two zero crossings - proceed with increased omega after
//			    %calculating gradient of y1
			} else {
				cOp3 = cOp3 +1;
				
//				System.out.println("============OPTION3 number="+cOp3);
//				System.out.println("OPTION2 number="+cOp2);
//				System.out.println("OPTION1 number="+cOp1);			
				
				
				dy1Dt = (-NumberKP + (OtherFunctions.polyVal(ListF1,omega+minStep)*Math.sin((omega+minStep)*NumberL)+
	                    OtherFunctions.polyVal(ListF2,omega+minStep)*Math.cos((omega+minStep)*NumberL)
	                    )/OtherFunctions.polyVal(ListFn, (omega+minStep))) - y2 ;
				
				omega = omega+stepSize;
				
			}
								
		}
		
		

//		%separate omega0 vector into omega+ and omega- vectors
		int  jp=0;
		int  jm=0;
		
		int sizeOmega0 = omega0.size();
		
		
		omegaPlus = OtherFunctions.zeros((int)Math.ceil(sizeOmega0/2)+1);// +1 because ceil of matlab is for +infinite and here is -inifinite		
		omegaMinus = OtherFunctions.zeros((int)Math.ceil(sizeOmega0/2)+1);
		
		for(int j=0;j<sizeOmega0;j++){
			if(omega0Type.get(j)==1){
				omegaPlus.set(jp,omega0.get(j));
				omegasign=-omegasign;
				jp=jp+1;
			} else {
				omegaMinus.set(jm,omega0.get(j));
				omegasign=-omegasign;
				jm=jm+1;
			}
		}
		
		System.out.println("JP  ="+jp);
		System.out.println("JM  ="+jm);
		
		List<Double> omegaPlusX = omegaPlus.subList(0, jp);
		List<Double> omegaMinusX = omegaMinus.subList(0, jm);						
				
		this.setOmegaPlus(omegaPlusX);
		this.setOmegaMinus(omegaMinusX);
		
	}


	/**
	 * @param omega0 the omega0 to set
	 */
	private void setOmega0(List<Double> omega0) {
		this.omega0 = omega0;
	}


	/**
	 * @param omega0Type the omega0Type to set
	 */
	private void setOmega0Type(List<Double> omega0Type) {
		this.omega0Type = omega0Type;
	}


	/**
	 * @param omegaPlus the omegaPlus to set
	 */
	private void setOmegaPlus(List<Double> omegaPlus) {
		this.omegaPlus = omegaPlus;
	}


	/**
	 * @param omegaMinus the omegaMinus to set
	 */
	private void setOmegaMinus(List<Double> omegaMinus) {
		this.omegaMinus = omegaMinus;
	}


	/**
	 * @return the omega0
	 */
	public List<Double> getOmega0() {
		return omega0;
	}


	/**
	 * @return the omega0Type
	 */
	public List<Double> getOmega0Type() {
		return omega0Type;
	}


	/**
	 * @return the omegaPlus
	 */
	public List<Double> getOmegaPlus() {
		return omegaPlus;
	}


	/**
	 * @return the omegaMinus
	 */
	public List<Double> getOmegaMinus() {
		return omegaMinus;
	}
}
