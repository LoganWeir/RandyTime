import Toybox.Lang;
import Toybox.WatchUi;

class RandyTimeDelegate extends WatchUi.BehaviorDelegate {

    private var _view as RandyTimeView;

    function initialize(view as RandyTimeView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onMenu() as Lang.Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RandyTimeMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
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