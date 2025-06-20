//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates how to make web requests through GCM.
class WebRequestApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    (:glance)
    function getGlanceView() {
        var view = new $.WidgetGlanceView();
        var delegate = new $.WebRequestDelegate(view.method(:onReceive));
        return [ view ];
    }

    //! Return the initial view for the app
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new $.WebRequestView();
        var delegate = new $.WebRequestDelegate(view.method(:onReceive));
        return [view, delegate];
    }
}