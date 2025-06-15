import Toybox.Graphics;
import Toybox.WatchUi;
var page = 1;
class JwsView extends WatchUi.View {
    hidden var mMessage = "02WS\nPress menu or\nselect button";
    hidden var mDate = "";
    hidden var mSigWeather = "";
    hidden var mTempTitle = "";
    hidden var mWindHumTitle = "";
    hidden var mRain = "";
    hidden var mModel;
    var mLogo;
    var mlang;
    var mwriter;
    hidden var jTextArea;

    function initialize(lang) {
        WatchUi.View.initialize();
        mlang = lang;
        
            
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
         System.println("JwsView onShow:");         
        
        
    }

     function onLoad() {
          System.println("JwsView onLoad:");
    }

    // Update the view
    function onUpdate(dc) {
        
        var DateLabel = View.findDrawableById("DateLabel") as Toybox.WatchUi.Text;
        var TempLabel = View.findDrawableById("TempLabel") as Toybox.WatchUi.Text;
        var WindHumLabel = View.findDrawableById("WindHumLabel") as Toybox.WatchUi.Text;
        var sigweatherText = View.findDrawableById("sigweatherText") as Toybox.WatchUi.Text;
        var RainText = View.findDrawableById("RainLabel") as Toybox.WatchUi.Text;
        DateLabel.setText(mDate);
        TempLabel.setText(mTempTitle);
        WindHumLabel.setText(mWindHumTitle);
        sigweatherText.setText(mSigWeather);
        RainText.setText(mRain);
        if (mlang == 0){
            changeBitmap(dc);
        }
        System.println("JwsView OnUpdate:" + mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
        View.onUpdate( dc );
        //jTextArea.draw(dc);
         
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function onReceive(args) {
        //System.println("JwsView onReceive:"+args);
        if (args instanceof Dictionary) {
              
            mDate = getDisplayString(args["current"]["daytime" + mlang]) + "";
            if (args["current"]["islight"].equals("1")){
                mTempTitle = getDisplayString(args["current"]["temp"]) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " - " + getDisplayString(args["current"]["temp2"] + StringUtil.utf8ArrayToString([0xC2,0xB0]));
            }
            else{
                mTempTitle = getDisplayString(args["current"]["temp"]) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " - " + getDisplayString(args["current"]["temp3"] + StringUtil.utf8ArrayToString([0xC2,0xB0]));
            }
                
            mSigWeather = getSigWeatherDisplayString(args["sigRunWalkweather"], mlang);
            if (!args["current"]["rainchance"].equals("0")){
              mRain = args["current"]["rainchance"] + "% " + loadResource(Rez.Strings.rain);
            }
            
        }
        else if (args instanceof Array){
            mMessage = "is Array";
        }
        else if (args instanceof Lang.String) {
             mDate = args;
        }
        System.println("JwsView onReceive:"+ mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
        WatchUi.requestUpdate();
    }

      //Get a displayable string for the current object
    function getDisplayString(item) {
        var displayString = "";
        if(item instanceof Toybox.Lang.Array) {
            displayString = getArrayDisplayString(item);
        } else if(item instanceof Toybox.Lang.Dictionary) {
            displayString = getDictionaryDisplayString(item);
        } else {
            //displayString = "Simple Value\n";
            displayString = item.toString();
        }

        return displayString;
    }
  

    function changeBitmap(dc) {
        var bitmap = findDrawableById("logoc") as Toybox.WatchUi.Bitmap;
        bitmap.setBitmap(Rez.Drawables.logoc_eng);
         View.onUpdate( dc );
    }

    //Get a display string for an array
    function getSigWeatherDisplayString(array, lang) {
        var displayString = "";
        for(var index = 1; index < array.size(); index++) {
            if (index == 1){
                mWindHumTitle = getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            else {
                displayString += " \n" + getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            if(index < (array.size()-1)) {
                displayString += "";
            }
           displayString += "";
        }
        return displayString;
    }

    //Get a display string for an array
    function getArrayDisplayString(array) {
         var displayString = "";
        displayString += "[\n";
        for(var index = 0; index < array.size(); index++) {

            displayString += array[index].toString();

            if(index < (array.size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "]\n";

        return displayString;
    }

    //Get a display string for a dictionary
    function getSigWeatherDictionaryDisplayString(dictionary, lang) {
        var displayString = "";
        displayString += dictionary["sigtitle"+lang] + " \n" +  dictionary["sigext"+lang];
     
        return displayString;
    }

    //Get a display string for a dictionary
    function getDictionaryDisplayString(dictionary) {
        var displayString = "\n";
        displayString += "{";
        for(var index = 0; index < dictionary.keys().size(); index++) {
            var key = dictionary.keys()[index];
            var value = dictionary[key];

            displayString += key + "=>" + value.toString();

            if(index < (dictionary.keys().size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "}";

        return displayString;
    }
}