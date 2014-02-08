package screen;



import com.ruhr.stepresponse.R;
import com.ruhr.stepresponse.R.id;
import com.ruhr.stepresponse.R.layout;
import com.ruhr.stepresponse.R.menu;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.widget.RadioGroup;

/** Class that implements the screen of input signal selection. 
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class InputSelection extends Activity {
	
	public final static String INPUT_SIGNAL_SELECTED = "controlFunctions.INPSELECTED";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_input_selection);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.input_selection, menu);
		
		return true;
	}

	/**
     * Method invoked when Next Button is clicked
     *
     * @param view Signal View Actual
     */
	public void inputSelectionNext(View view) 
	{
		
		System.out.println("inputSelectionNext  entrou");
		
		int inputSign = getTheNumberofSignalSelected();	
						
	    Intent intent = new Intent(InputSelection.this, ResponseSelecionActivity.class);	    
	    	    
	    intent.putExtra("signal1Selected", inputSign);
	    	    
	    
	    startActivity(intent);
	    System.out.println("inputSelectionNext  SAIU");
	}

	private int getTheNumberofSignalSelected() {
		
		RadioGroup radioGroup = (RadioGroup) findViewById(R.id.radiogroup);
		int checkedRadioButton = radioGroup.getCheckedRadioButtonId();
		int number = 2;
		
		switch (checkedRadioButton) {
		  case R.id.radioButtonInputSignal2: 
			  number = 2;
		      break;
//		  case R.id.radioButtonInputSignal5 :
//			  number = 5;
//		      break;		  
		}
		
		return number;
		
	}
	

	
}
