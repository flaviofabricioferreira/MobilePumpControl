package screen;

import com.ruhr.stepresponse.R;
import com.ruhr.stepresponse.R.layout;


import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.Window;
import android.view.WindowManager;

/** Class that implements the splashScreen of the application
 * 
 * @author Flavio Fabricio Ventura de Melo Ferreira
 * @version – 20/11/2013
 * 
 * 
 */
public class SplashScreen extends Activity {

    private static String TAG = SplashScreen.class.getName();
    private static long SLEEP_TIME = 5;    // Sleep for some time

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
	    this.requestWindowFeature(Window.FEATURE_NO_TITLE);    // Removes title bar
	    this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);    // Removes notification bar
		setContentView(R.layout.activity_splash_screen);
		
        // Start timer and launch main activity
        IntentLauncher launcher = new IntentLauncher();
	    launcher.start();
	
	}

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.splash_screen, menu);
//		return true;
//	}

	 private class IntentLauncher extends Thread {
	      @Override
	      /**
	       * Sleep for some time and than start new activity.
	       */
	      
	      
	      
	      public void run() {
	    	 System.out.println("THREAD 1");
	         try {
	            // Sleeping
	            Thread.sleep(SLEEP_TIME*1000);
	         } catch (Exception e) {
	            Log.e(TAG, e.getMessage());
	         }
	 
	         System.out.println("THREAD 2");
	         // Start main activity
//	         Intent intent = new Intent(SplashScreen.this, MainActivity.class);
	         Intent intent = new Intent(SplashScreen.this, InputSelection.class);
	         System.out.println("THREAD 3");
	         SplashScreen.this.startActivity(intent);
	         System.out.println("THREAD 4");
	         SplashScreen.this.finish();
	         System.out.println("THREAD 5");
	      }
	   }
	
	
}
