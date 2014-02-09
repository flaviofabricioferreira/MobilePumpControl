package screen;

import java.awt.font.NumericShaper;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.os.Environment;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.widget.EditText;

import com.jmatio.io.*;
import com.jmatio.types.*;
import com.ruhr.stepresponse.R;
import com.ruhr.stepresponse.R.id;
import com.ruhr.stepresponse.R.layout;
import com.ruhr.stepresponse.R.menu;

import controlFunctions.CalcSingularFrequenciesDelay;
import controlFunctions.CompositionD;
import controlFunctions.DecompositionNyquist;
import controlFunctions.OtherFunctions;
import controlFunctions.ParametersExtractor;
import controlFunctions.TransferFuction;


/** Class that implements the main screen of the application
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class MainActivity extends Activity {

	 private static final String XSTART = "XSTART";
	 private static final String XEND = "XEND";
	 private static final String XDIRECTION = "XDIRECTION";
	 
	 private static final String YSTART = "YSTART";
	 private static final String YEND = "YEND";
	 private static final String YDIRECTION = "YDIRECTION";
	 
	 private static final String GAINK = "GAINK";
	 private static final String TIMET1 = "TIMET1";
	 private static final String INDEXI = "INDEXI";
	 private static final String TIMETT = "TIMETT";
	 
	 private double xStart,xEnd,xDirection;
     private double yStart,yEnd,yDirection;
     private double gainK;
	 private double timeT1;
     private int indexI;
	 private int timeTt;
	


	private double InputSignal[];
	private double OutputSignal[];
	

	

	EditText xStartET,xEndET,xDirectionET; // EditTexts
	EditText yStartET,yEndET,yDirectionET; // EditTexts
	EditText gainKET,timeT1ET; // EditTexts
	EditText timeTtET,indexIET; // EditTexts
	
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

	    importSelectedScopeDatas();
		
		setContentView(R.layout.activity_main);

		// Check if app just started, or if it is being restored
		checkApp(savedInstanceState);		
		
		connectEditTextsObjects();

		extractParametersOfData();

		automaticControllerNOPDT(getGainK(),getTimeT1(),getTimeTt(),getIndexI());
		
		showDataAtScreen();

	}

	private void connectEditTextsObjects() {
//		xStartET = (EditText) findViewById(R.id.editTextXStart);
//		xEndET = (EditText) findViewById(R.id.editTextXEnd);
//		xDirectionET = (EditText) findViewById(R.id.editTextXDirection);
//		yStartET = (EditText) findViewById(R.id.editTextYStart);
//		yEndET = (EditText) findViewById(R.id.editTextYEnd);
//		yDirectionET = (EditText) findViewById(R.id.editTextYDirection);
		gainKET = (EditText) findViewById(R.id.editTextGainkValue);
		timeT1ET = (EditText) findViewById(R.id.editTextTimeT1Value);		
		timeTtET = (EditText) findViewById(R.id.editTextTtValue);
		indexIET = (EditText) findViewById(R.id.editTextIndexIValue);
	}

	private void checkApp(Bundle sIS) {

		if(sIS == null){
		// Just started
		    xStart = 0.0;
		    xEnd = 0.0;
		    xDirection = 0.0;
		    yStart = 0.0;
            yEnd = 0.0;
		    yDirection = 0.0;
		    gainK = 0.0;
		    timeT1 = 0.0;
		    setTimeTt(0);
		    setIndexI(0);
	    
	    } else {
        // App is being restored
            xStart = sIS.getDouble(XSTART);
            xEnd = sIS.getDouble(XEND);
            xDirection = sIS.getDouble(XDIRECTION);
            yStart = sIS.getDouble(YSTART);
            yEnd = sIS.getDouble(YEND);
            yDirection = sIS.getDouble(YDIRECTION);
            gainK = sIS.getDouble(GAINK);
		    timeT1 = sIS.getDouble(TIMET1);            
		    setTimeTt(sIS.getInt(TIMETT));
		    setIndexI(sIS.getInt(INDEXI));
	    }	
		
	}

	private void showDataAtScreen() {
		
	
		gainKET.setText(String.format("%.06f", getGainK()));

		timeT1ET.setText(String.format("%.06f", getTimeT1()));

		indexIET.setText(String.format("%d", getIndexI()));

		timeTtET.setText(String.format("%d", getTimeTt()));
		
	}

	private void extractParametersOfData() {
		ParametersExtractor MP = new ParametersExtractor(getOutputSignal(),getInputSignal());
		
		setxStart(MP.getxStart());
		setxEnd(MP.getxEnd());
		setxDirection(MP.getxDirection());
		setyStart(MP.getyStart());
		setyEnd(MP.getyEnd());
		setyDirection(MP.getyDirection());
		setGainK(MP.getGainK());
		setTimeT1(MP.getTimeT1());
		setIndexI(MP.getnNearTPCV());
		setTimeTt(MP.getDeadTimeTt());
	}

	private void importSelectedScopeDatas() {
		// TODO Auto-generated method stub
		
		int numberInput = 0;
		int numberOutput = 0;
		
	    Bundle extras = getIntent().getExtras();
	    if(extras != null)
        {
			
	    	numberInput = extras.getInt("InputSignalSelectedNumber");
			numberOutput = extras.getInt("OutputSignalSelectedNumber");
	    	System.out.println("INPUT = : "+numberInput);
	    	System.out.println("OUTPUT= : "+numberOutput);
	    	
        }
		
		
		setOutputSignal(importScopeData("signal"+numberOutput+".txt"));
		
		setInputSignal(importScopeData("signal"+numberInput+".txt"));
	}


	private void automaticControllerNOPDT(double gK,double timeT1,int deadTime, int order) {
		
//		List<Double> inputN = new ArrayList<Double>();
//		inputN.add(0.0);
//		inputN.add(0.0);
//		inputN.add(1.0);
//			
//		List<Double> inputD = new ArrayList<Double>();
//		inputD.add(1.0);
//		inputD.add(1.0);
//		inputD.add(1.0);

		double Ks= gK;
		
		List<Double> numGs = new ArrayList<Double>();
		numGs.add(1.0);
		List<Double> denGs = new ArrayList<Double>();
		denGs.add(timeT1);
		denGs.add(1.0);
		TransferFuction Gs = new TransferFuction(numGs, denGs);
		
		//Gs=Gs^3
		TransferFuction Gs2 = Gs;	
		for(int i=0;i<order-1;i++){
			Gs2 = Gs2.multiplyTranferFuctionby(Gs);//^2	
		}			
		Gs = Gs2;	
		
////		[Ns,Ds]=tfdata(Ks*Gs,'v')
//		List<Double> numK = new ArrayList<Double>();
//		numK.add(Ks);
//		List<Double> denK = new ArrayList<Double>();
//		denK.add(1.0);
//		TransferFuction K = new TransferFuction(numK,denK);
		
//		Gs=tf(Ks,[0.1 1])*Gs	
		List<Double> numKK = new ArrayList<Double>();
		numKK.add(Ks);
		List<Double> denKK = new ArrayList<Double>();
		denKK.add(0.1);
		denKK.add(1.0);
		TransferFuction KK = new TransferFuction(numKK,denKK);
		
		Gs = KK.multiplyTranferFuctionby(Gs);//^3
	
		List<Double> numeratorN = Gs.getTfData().get(0);
		
		List<Double> denominatorD = Gs.getTfData().get(1);		

//		perform nyquist-decomposition
		DecompositionNyquist DN = new DecompositionNyquist(denominatorD, numeratorN);
		
//		perform d-composition
		CompositionD D = new CompositionD(denominatorD, numeratorN);		
				
		int L= deadTime;
		
//		calc singular frequencies 
		CalcSingularFrequenciesDelay CSF = new CalcSingularFrequenciesDelay(D.getF1(),D.getF2(),
				                                                            D.getFn(),0, L, 
				                                                            denominatorD, numeratorN,
				                                                            D.getL(), 0.1, true);

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		System.out.println("==========numeratorN=========");
		OtherFunctions.showList(numeratorN);
		
		System.out.println("==========denominatorD=========");
		OtherFunctions.showList(denominatorD);
		
		
		
		System.out.println("==========F1 Vector=========");
		OtherFunctions.showList(D.getF1());
		System.out.println("==========F2 Vector=========");
		OtherFunctions.showList(D.getF2());
		System.out.println("==========FN Vector=========");
		OtherFunctions.showList(D.getFn());	
		
		
		System.out.println("OMEGA0 VECTOR==============================");
		OtherFunctions.showList(CSF.getOmega0());
		System.out.println("OMEGAPlus VECTOR===========================");
		OtherFunctions.showList(CSF.getOmegaPlus());
		System.out.println("OMEGAMinus VECTOR==========================");
		OtherFunctions.showList(CSF.getOmegaMinus());
		
	}

	private double[] importScopeData(String fileName) {

		 int lenghtOfData = 0;
		 String arrayString[];
		 double arrayDouble[] = new double[1]; 

		 
		 arrayString = getStringArrayFromFile(fileName);
		 lenghtOfData = arrayString.length;

		 if(lenghtOfData>1){
			 arrayDouble = new double[lenghtOfData];
			 for(int i=0;i<lenghtOfData;i++){
			     arrayDouble[i] = Double.parseDouble(arrayString[i]);
			     //System.out.println("arrayDouble["+i+"] = " + arrayDouble[i] );
			 }
		 }
		 else {
			 System.out.println("ERRROOOOOR");
			 
		 }
		 
		 return arrayDouble;
	}

	private String[] getStringArrayFromFile(String fileName) {
		
		 String text;
		 InputStream ims;
		 String arrayString[] = new String[1];
		
		try {
			ims = getAssets().open(fileName);
			BufferedReader reader = new BufferedReader(new InputStreamReader(ims));
		    StringBuilder sb = new StringBuilder();
		    String line = null;
		    while ((line = reader.readLine()) != null) {
		      sb.append(line).append("\n");
		    }
		    text = sb.toString();
		    text = text.replace(',','.');
		    arrayString = text.split("\n");
		    return arrayString;
		 } catch (IOException e) {
			// TODO Auto-generated catch block
			Log.e("I/O ERROR","Failed when ...");
			e.printStackTrace();
			return arrayString;
		 }
				
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	 public double getxStart() {
		return xStart;
	}


	public void setxStart(double xStart) {
		this.xStart = xStart;
	}
	public double getxEnd() {
		return xEnd;
	}


	public void setxEnd(double xEnd) {
		this.xEnd = xEnd;
	}


	public double getxDirection() {
		return xDirection;
	}


	public void setxDirection(double xDirection) {
		this.xDirection = xDirection;
	}


	public double getyStart() {
		return yStart;
	}


	public void setyStart(double yStart) {
		this.yStart = yStart;
	}


	public double getyEnd() {
		return yEnd;
	}


	public void setyEnd(double yEnd) {
		this.yEnd = yEnd;
	}


	public double getyDirection() {
		return yDirection;
	}


	public void setyDirection(double yDirection) {
		this.yDirection = yDirection;
	}

    public double getGainK() {
		return gainK;
	}


	public void setGainK(double gainK) {
		this.gainK = gainK;
	}


	public double getTimeT1() {
		return timeT1;
	}


	public void setTimeT1(double timeT1) {
		this.timeT1 = timeT1;
	}
	
	 /**
		 * @return the inputSignal
		 */
		private double[] getInputSignal() {
			return InputSignal;
		}

		/**
		 * @param inputSignal the inputSignal to set
		 */
		private void setInputSignal(double[] inputSignal) {
			InputSignal = inputSignal;
		}

		/**
		 * @return the outputSignal
		 */
		private double[] getOutputSignal() {
			return OutputSignal;
		}

		/**
		 * @param outputSignal the outputSignal to set
		 */
		private void setOutputSignal(double[] outputSignal) {
			OutputSignal = outputSignal;
		}
		/**
		 * @return the indexI
		 */
		private int getIndexI() {
			return indexI;
		}

		/**
		 * @param indexI the indexI to set
		 */
		private void setIndexI(int indexI) {
			this.indexI = indexI;
		}

		/**
		 * @return the timeTt
		 */
		private int getTimeTt() {
			return timeTt;
		}

		/**
		 * @param timeTt the timeTt to set
		 */
		private void setTimeTt(int timeTt) {
			this.timeTt = timeTt;
		}
	
}
