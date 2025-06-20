//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Application.Storage;
using Toybox.System;
using Toybox.Lang;

class JwsGlanceDelegate extends WatchUi.GlanceViewDelegate {
    var notify;

    // Handle menu button press
    function onMenu() {
        doNextPage();
    }

    function doNextPage(){
        makeRequest();
        page = (page == 2) ? 1 : page + 1;
        switchView(page);
        WatchUi.requestUpdate();
        return true;
    }
    function switchView(pageNum) {

        var newView = null;
        var inputDelegate = new JwsDelegate(notify);
        var lang = Application.getApp().getProperty("lang");
        if(page == 1) {
            newView = new JwsView(lang);
        }   
        else if(page == 2) {
            newView = new DetailsView(lang);
        } 
        else
        {
            newView = new JwsView(lang);
        }
       System.println("page=" + page);
        switchToView(newView, inputDelegate, WatchUi.SLIDE_IMMEDIATE);
    }

    function onSelect() {
        doNextPage();
    }

    function makeRequest() {
         notify.invoke("Loading...");
        try{
                var url = "https://www.02ws.co.il/02wsjsonshort.json";
                var params = {   };
                var options = {                                             // set the options
                    :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
                    :headers => {                                           // set headers
                            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                                                                            // set response type
                    :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_URL_ENCODED
                };                                            // set the parameters
               
                var responseCallback = method(:onReceive);                  // set responseCallback to
                                                                            // onReceive() method
                Communications.makeWebRequest(url, params, options, responseCallback);
           
            return true;
        }
        catch(exception){
            System.println(exception);
            return false;
        }
       
    }

    // Set up the callback to the view
    function initialize(handler) {
        WatchUi.GlanceViewDelegate.initialize();
        notify = handler;
        notify.invoke("press button");
        makeRequest();
    }

    function dump_device_information() {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings has :monkeyVersion) {
            System.println(Lang.format("MonkeyC Version: $1$.$2$.$3$", deviceSettings.monkeyVersion));
        }
        else {
            System.println("MonkeyC Version: < 1.2.0");
        }

        if (deviceSettings has :partNumber) {
            System.println(Lang.format("Device Part Num: $1$", [ deviceSettings.partNumber ]));
        }
    }

    // Receive the data from the web request
    function onReceive(responseCode as $.Toybox.Lang.Number, data as Null or $.Toybox.Lang.Dictionary or $.Toybox.Lang.String or $.Toybox.PersistedContent.Iterator) as Void {
        if (responseCode == 200) {
            if (Toybox.Application has :Storage){
                Storage.setValue("02wsjson", data);
            }
            else {
                Application.getApp().setProperty("02wsjson", data);
            }
            
            notify.invoke(data);
          } else {
            //notify.invoke("Failed to load\nError: " + responseCode.toString());
            dump_device_information();
            System.println("ResoponseCode:" + responseCode.toString());
            if (Toybox.Application has :Storage){
                notify.invoke(Storage.getValue("02wsjson"));
            }
            else{
                notify.invoke(Application.getApp().getProperty("02wsjson"));
            }
            
        }
    }
}