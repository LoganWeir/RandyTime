import Toybox.Lang;
import Toybox.WatchUi;

class RandyTimeSettingsDelegate extends WatchUi.BehaviorDelegate {

    private var _view as RandyTimeSettingsView;

    function initialize(view as RandyTimeSettingsView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Lang.Boolean {
        return _view.onSelect();
    }

    function onNextPage() as Lang.Boolean {
        return _view.onNextPage();
    }

    function onPreviousPage() as Lang.Boolean {
        return _view.onPreviousPage();
    }

    function onBack() as Lang.Boolean {
        return _view.onBack();
    }

}