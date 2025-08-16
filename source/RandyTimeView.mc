import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application;
import Toybox.Math;
import Toybox.Attention;
import Toybox.Lang;

class RandyTimeView extends WatchUi.View {

    private var _timer as Timer.Timer?;
    private var _remainingSeconds as Lang.Number = 0;
    private var _isRunning as Lang.Boolean = false;
    private var _minMinutes as Lang.Number = 1;
    private var _maxMinutes as Lang.Number = 5;
    private var _statusLabel as Text?;
    private var _timerLabel as Text?;
    private var _boundsLabel as Text?;
    private var _instructionLabel as Text?;
    private var _southArrow as Drawable?;
    private var _selectedOption as Lang.Number = 0; // 0 = start, 1 = set min, 2 = set max
    private var _optionTexts as Array<String> = ["start", "set min", "set max"];
    private var _inSettingMode as Lang.Boolean = false;

    function initialize() {
        View.initialize();
        loadSettings();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        _statusLabel = findDrawableById("status") as Text;
        _timerLabel = findDrawableById("timer_display") as Text;
        _boundsLabel = findDrawableById("bounds_display") as Text;
        _instructionLabel = findDrawableById("instruction") as Text;
        _southArrow = findDrawableById("south_arrow");
        updateBoundsDisplay();
        updateInstructionText();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function loadSettings() as Void {
        var storage = Application.Storage;
        _minMinutes = storage.getValue("minMinutes");
        if (_minMinutes == null) {
            _minMinutes = 1;
        }
        _maxMinutes = storage.getValue("maxMinutes");
        if (_maxMinutes == null) {
            _maxMinutes = 5;
        }
    }

    function saveSettings() as Void {
        var storage = Application.Storage;
        storage.setValue("minMinutes", _minMinutes);
        storage.setValue("maxMinutes", _maxMinutes);
    }

    function updateBoundsDisplay() as Void {
        if (_boundsLabel != null) {
            _boundsLabel.setText(_minMinutes.toString() + "-" + _maxMinutes.toString() + " min");
        }
    }

    function updateInstructionText() as Void {
        if (_instructionLabel != null) {
            if (_isRunning || _remainingSeconds > 0) {
                _instructionLabel.setText("");
                if (_southArrow != null) {
                    _southArrow.setVisible(false);
                }
            } else {
                _instructionLabel.setText(_optionTexts[_selectedOption]);
                if (_southArrow != null) {
                    _southArrow.setVisible(true);
                }
            }
        }
    }

    function startTimer() as Void {
        if (_isRunning) {
            return;
        }

        // Generate random time between min and max minutes
        var range = _maxMinutes - _minMinutes;
        var randomMinutes = _minMinutes + Math.rand() % (range + 1);
        _remainingSeconds = randomMinutes * 60;
        
        _isRunning = true;
        if (_statusLabel != null) {
            _statusLabel.setText(Rez.Strings.running);
        }
        updateInstructionText();
        
        _timer = new Timer.Timer();
        _timer.start(method(:onTimerTick), 1000, true);
        
        updateTimerDisplay();
        WatchUi.requestUpdate();
    }

    function stopTimer() as Void {
        if (!_isRunning) {
            return;
        }
        
        _isRunning = false;
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
        
        if (_statusLabel != null) {
            _statusLabel.setText(Rez.Strings.ready);
        }
        updateInstructionText();
        
        WatchUi.requestUpdate();
    }

    function onTimerTick() as Void {
        if (!_isRunning) {
            return;
        }
        
        _remainingSeconds--;
        
        if (_remainingSeconds <= 0) {
            // Timer finished
            _isRunning = false;
            if (_timer != null) {
                _timer.stop();
                _timer = null;
            }
            
            if (_statusLabel != null) {
                _statusLabel.setText(Rez.Strings.finished);
            }
            if (_timerLabel != null) {
                _timerLabel.setText("?");
            }
            updateInstructionText();
            
            // Vibrate to notify user
            if (Attention has :vibrate) {
                var vibeData = [
                    new Attention.VibeProfile(50, 1000), // 1 second vibration
                    new Attention.VibeProfile(0, 500),   // 0.5 second pause
                    new Attention.VibeProfile(50, 1000), // 1 second vibration
                ];
                Attention.vibrate(vibeData);
            }
        } else {
            updateTimerDisplay();
        }
        
        WatchUi.requestUpdate();
    }

    function updateTimerDisplay() as Void {
        if (_timerLabel != null) {
            var minutes = _remainingSeconds / 60;
            var seconds = _remainingSeconds % 60;
            var timeString = minutes.format("%02d") + ":" + seconds.format("%02d");
            _timerLabel.setText(timeString);
        }
    }

    function onSelect() as Lang.Boolean {
        if (_inSettingMode) {
            // Setting mode - save and exit
            _inSettingMode = false;
            _selectedOption = 0; // Return to 'start' option
            saveSettings();
            if (_statusLabel != null) {
                _statusLabel.setText(Rez.Strings.ready);
            }
            if (_timerLabel != null) {
                _timerLabel.setText("?");
            }
            updateInstructionText();
            WatchUi.requestUpdate();
        } else if (_isRunning) {
            // Running state - stop timer
            stopTimer();
        } else if (_remainingSeconds > 0) {
            // Stopped state - resume timer
            _isRunning = true;
            if (_statusLabel != null) {
                _statusLabel.setText(Rez.Strings.running);
            }
            _timer = new Timer.Timer();
            _timer.start(method(:onTimerTick), 1000, true);
            updateInstructionText();
            WatchUi.requestUpdate();
        } else {
            // Ready state - handle selected option
            if (_selectedOption == 0) {
                // Start timer
                startTimer();
            } else if (_selectedOption == 1) {
                // Enter min setting mode
                _inSettingMode = true;
                if (_timerLabel != null) {
                    _timerLabel.setText(_minMinutes.toString());
                }
                if (_statusLabel != null) {
                    _statusLabel.setText("Setting Min");
                }
                WatchUi.requestUpdate();
            } else if (_selectedOption == 2) {
                // Enter max setting mode
                _inSettingMode = true;
                if (_timerLabel != null) {
                    _timerLabel.setText(_maxMinutes.toString());
                }
                if (_statusLabel != null) {
                    _statusLabel.setText("Setting Max");
                }
                WatchUi.requestUpdate();
            }
        }
        return true;
    }

    function onBack() as Lang.Boolean {
        if (_inSettingMode) {
            // Exit setting mode back to main screen
            _inSettingMode = false;
            _selectedOption = 0; // Return to 'start' option
            saveSettings();
            if (_statusLabel != null) {
                _statusLabel.setText(Rez.Strings.ready);
            }
            if (_timerLabel != null) {
                _timerLabel.setText("?");
            }
            updateInstructionText();
            WatchUi.requestUpdate();
            return true;
        } else if (_remainingSeconds > 0 || _isRunning) {
            // Reset timer (running or stopped)
            if (_timer != null) {
                _timer.stop();
                _timer = null;
            }
            _isRunning = false;
            _remainingSeconds = 0;
            if (_statusLabel != null) {
                _statusLabel.setText(Rez.Strings.ready);
            }
            if (_timerLabel != null) {
                _timerLabel.setText("?");
            }
            updateInstructionText();
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function onNextPage() as Lang.Boolean {
        if (_inSettingMode) {
            // DOWN = decrease the setting value
            if (_selectedOption == 1) {
                // Setting min - decrease but keep above 0
                if (_minMinutes > 1) {
                    _minMinutes--;
                    if (_timerLabel != null) {
                        _timerLabel.setText(_minMinutes.toString());
                    }
                    WatchUi.requestUpdate();
                }
            } else if (_selectedOption == 2) {
                // Setting max - decrease but keep above min
                if (_maxMinutes > _minMinutes) {
                    _maxMinutes--;
                    if (_timerLabel != null) {
                        _timerLabel.setText(_maxMinutes.toString());
                    }
                    WatchUi.requestUpdate();
                }
            }
        } else if (!_isRunning && _remainingSeconds == 0) {
            // DOWN = cycle up through options: 0 -> 1 -> 2 -> 0
            _selectedOption = (_selectedOption + 1) % 3;
            updateInstructionText();
            WatchUi.requestUpdate();
        }
        return true;
    }

    function onPreviousPage() as Lang.Boolean {
        if (_inSettingMode) {
            // UP = increase the setting value
            if (_selectedOption == 1) {
                // Setting min - increase but keep below max
                if (_minMinutes < _maxMinutes) {
                    _minMinutes++;
                    if (_timerLabel != null) {
                        _timerLabel.setText(_minMinutes.toString());
                    }
                    WatchUi.requestUpdate();
                }
            } else if (_selectedOption == 2) {
                // Setting max - increase
                _maxMinutes++;
                if (_timerLabel != null) {
                    _timerLabel.setText(_maxMinutes.toString());
                }
                WatchUi.requestUpdate();
            }
        } else if (!_isRunning && _remainingSeconds == 0) {
            // UP = cycle down through options: 0 -> 2 -> 1 -> 0
            _selectedOption = (_selectedOption + 2) % 3;
            updateInstructionText();
            WatchUi.requestUpdate();
        }
        return true;
    }

    function getMinMinutes() as Lang.Number {
        return _minMinutes;
    }

    function getMaxMinutes() as Lang.Number {
        return _maxMinutes;
    }

    function setTimerBounds(minMinutes as Lang.Number, maxMinutes as Lang.Number) as Void {
        _minMinutes = minMinutes;
        _maxMinutes = maxMinutes;
        saveSettings();
        updateBoundsDisplay();
        WatchUi.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
