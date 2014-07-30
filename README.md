# hxp-Dots v0.9.0

## About
Leap across incoming dots to survive and attain the high score. Written in Haxe 3.1.1 using HaxePunk 2.5.2.

To play the game on Linux or Mac, compile the sources. Library versions are as follows:
* haxelib_client: 3.1.0-rc.4
* HaxePunk: 2.5.2
* hxcpp: 3.1.30
* hxlibc: 1.1.4
* lime-tools: 1.3.0
* lime: 0.9.6
* openfl-bitfive: 1.0.5
* openfl-html5-dom: 1.2.1
* openfl-native: 1.3.0
* openfl-ouya: 1.0.2
* openfl-samples: 1.2.1
* openfl-tools: 1.0.10
* openfl: 1.3.0

## How to play

### Controls

**Desktop:** ENTER and ESC/BACKSPACE to navigate menus. UP/W/SPACE/ENTER/LEFT-CLICK to jump.
**Android:** Touch the options to use them. Touch the screen to jump.

### Rules

* The player "dies" if he leaves the screen or collides with an obstacle.
* The score is equal to the amount of time spent "alive", expressed in seconds.

## Version information

**Version 0.9.0**
* Code refactored
* New version of hxp-GUI implemented
* Fixed memory leak on Windows platform
* Flash and HTML5 support introduced

---

**Version 0.8.0**
* Positioning of UI significantly improved
* Keyboard controls now more intuitive

**Version 0.7.2**
* Prettied up the title screen

**Version 0.7.1**
* "TRY AGAIN" is now an Option class object

**Version 0.7.0**
* First commit with working prototype
* Added a title screen
* Added a "BACK TO TITLE SCREEN" option on death
