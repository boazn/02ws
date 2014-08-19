package il.co.jws.app;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.webkit.WebView;
import android.webkit.WebSettings;
import android.webkit.CookieManager;
import android.webkit.WebViewClient;
import android.view.MenuItem;
public class MainActivity extends Activity {
	private WebView webview;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        webview = (WebView) findViewById(R.id.webview);
        WebSettings webSettings = webview.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setLoadWithOverviewMode(true); 
        CookieManager.getInstance().setAcceptCookie(true);
        // Force links and redirects to open in the WebView instead of in a browser
        webview.setWebViewClient(new WebViewClient());
        webview.loadUrl("http://www.02ws.co.il/small.php");
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle presses on the action bar items
        switch (item.getItemId()) {
            case R.id.action_refresh:
                doRefresh();
                return true;
            case R.id.action_hebrew:
            	changeLang(1);
                  return true;
            case R.id.action_english:
            	changeLang(0);
                  return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
    
    protected void doRefresh(){
    	webview = (WebView) findViewById(R.id.webview);
    	webview.loadUrl("http://www.02ws.co.il/small.php");
    }
    
    protected void changeLang(int lang){
    	webview = (WebView) findViewById(R.id.webview);
    	webview.loadUrl("http://www.02ws.co.il/small.php?lang=" + lang);
    }
}
