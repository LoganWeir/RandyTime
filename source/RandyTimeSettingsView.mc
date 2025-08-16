import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class RandyTimeSettingsView extends WatchUi.View {

    private var _minMinutes as Lang.Number;
    private var _maxMinutes as Lang.Number;
    private var _mainView as RandyTimeView;
    private var _selectedField as Lang.Number = 0; // 0 = min, 1 = max

    function initialize(mainView as RandyTimeView) {
        View.initialize();
        _mainView = mainView;
        _minMinutes = mainView.getMinMinutes();
        _maxMinutes = mainView.getMaxMinutes();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Timer Settings", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Min minutes setting
        var minColor = (_selectedField == 0) ? Graphics.COLOR_BLUE : Graphics.COLOR_WHITE;
        dc.setColor(minColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_MEDIUM, "Min: " + _minMinutes.toString() + " min", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Max minutes setting
        var maxColor = (_selectedField == 1) ? Graphics.COLOR_BLUE : Graphics.COLOR_WHITE;
        dc.setColor(maxColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 80, Graphics.FONT_MEDIUM, "Max: " + _maxMinutes.toString() + " min", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 120, Graphics.FONT_TINY, "UP/DOWN to change", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 140, Graphics.FONT_TINY, "SELECT to switch field", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 160, Graphics.FONT_TINY, "BACK to save & exit", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onSelect() as Lang.Boolean {
        _selectedField = (_selectedField + 1) % 2;
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() as Lang.Boolean {
        if (_selectedField == 0) {
            if (_minMinutes < _maxMinutes) {
                _minMinutes++;
            }
        } else {
            _maxMinutes++;
        }
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() as Lang.Boolean {
        if (_selectedField == 0) {
            if (_minMinutes > 1) {
                _minMinutes--;
            }
        } else {
            if (_maxMinutes > _minMinutes) {
                _maxMinutes--;
            }
        }
        WatchUi.requestUpdate();
        return true;
    }

    function onBack() as Lang.Boolean {
        _mainView.setTimerBounds(_minMinutes, _maxMinutes);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

}