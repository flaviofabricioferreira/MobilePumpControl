package screen;



import com.ruhr.stepresponse.R;
import com.ruhr.stepresponse.R.id;
import com.ruhr.stepresponse.R.layout;
import com.ruhr.stepresponse.R.menu;

import android.R.integer;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.widget.RadioGroup;

/** Class that implements the screen of output signal selection. 
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class ResponseSelecionActivity extends Activity {

	int inputSignalNumber = 0;
	int outputSignalNumber = 0;
	
	
	
	




	public final static String OUTPUT_SIGNAL_SELECTED = "controlFunctions.OUTSELECTED";
	public final static String INPUT_SIGNAL_SELECTED = "controlFunctions.INPSELECTED";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_response_selecion);

		
		
		Bundle extras = getIntent().getExtras();
	    if(extras != null)
        {
	    	setInputSignalNumber(extras.getInt("signal1Selected"));
        }	    	    
	    
	    
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.response_selecion, menu);
		return true;
	}

	public void responseSelectionNext(View view) 
	{
		System.out.println("responseSelectionNext  entrou");
	    Intent intent = new Intent(ResponseSelecionActivity.this, MainActivity.class);

	    setOutputSignalNumber();
	    
	    intent.putExtra("InputSignalSelectedNumber", getInputSignalNumber());
	    intent.putExtra("OutputSignalSelectedNumber", getOutputSignalNumber());
	    
	    startActivity(intent);
	    
	    System.out.println("responseSelectionNext  SAIU");
	}
	
	public void responseSelectionBack(View view) 
	{
	    Intent intent = new Intent(ResponseSelecionActivity.this, InputSelection.class);
//	    
//	    System.out.println("INPUT4");	        
//	    int input = 0;
//	    Bundle bundle = getIntent().getExtras();
//	    
//	    System.out.println("INPUT5");
//	    if(bundle.getString("INPUT_SIGNAL_SELECTED")!= null)
//        {
//	    	System.out.println("INPUT6");
//	    	input =  Integer.parseInt(bundle.getString("INPUT_SIGNAL_SELECTED"));
//	    	System.out.println("THE SIGNAL SELECTED ON THE INPUT WAS:"+input);
//	    	System.out.println("INPUT7");
////	    	System.out.println("DADOS RECEBIDOS  = " + bundle.getString("INPUT_SIGNAL_SELECTED"));
////	    	
//        }
//	    intent.putExtra(INPUT_SIGNAL_SELECTED, input);
//	    System.out.println("INPUT8");
//	    
//	    
//	    int j = 1;
//	    System.out.println("INPUT9");
//	    intent.putExtra(OUTPUT_SIGNAL_SELECTED, j);
//	    System.out.println("INPUT10");
	    
	    
	    startActivity(intent);
	}
	
	/**
	 * @return the inputSignalNumber
	 */
	private int getInputSignalNumber() {
		return inputSignalNumber;
	}

	/**
	 * @param inputSignalNumber the inputSignalNumber to set
	 */
	private void setInputSignalNumber(int inputSignalNumber) {
		this.inputSignalNumber = inputSignalNumber;
	}
	/**
	 * @return the outputSignalNumber
	 */
	private int getOutputSignalNumber() {
		return outputSignalNumber;
	}

	/**
	 * @param outputSignalNumber the outputSignalNumber to set
	 */
	private void setOutputSignalNumber() {
				
		RadioGroup radioGroup = (RadioGroup) findViewById(R.id.radiogroup);
		int checkedRadioButton = radioGroup.getCheckedRadioButtonId();
		int number = 1;
			
			switch (checkedRadioButton) {
			  case R.id.radioButtonInputSignal1: 
				  number = 1;
			      break;
			  case R.id.radioButtonInputSignal4: 
				  number = 4;
			      break;

			}
					
		this.outputSignalNumber = number;
	}
}
