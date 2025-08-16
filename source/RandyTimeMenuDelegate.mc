import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class RandyTimeMenuDelegate extends WatchUi.MenuInputDelegate {

    private var _view as RandyTimeView;

    function initialize(view as RandyTimeView) {
        MenuInputDelegate.initialize();
        _view = view;
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            // Settings
            var settingsView = new RandyTimeSettingsView(_view);
            WatchUi.pushView(settingsView, new RandyTimeSettingsDelegate(settingsView), WatchUi.SLIDE_UP);
        } else if (item == :item_2) {
            // About - could show app info
            System.println("About RandyTime");
        }
    }

}