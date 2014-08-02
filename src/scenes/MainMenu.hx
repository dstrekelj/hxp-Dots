package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import gui.*;

class MainMenu extends Scene
{
	/** Determines spawn rate of obstacles in background. */
	private static inline var _SPAWN_RATE : Float = 0.3;
	
	/** Label for game title. */
	private var lTitle	: Label;
	/** Label for subtitle. */
	private var lMadeBy	: Label;
	/** Start button. */
	private var bStart	: Button;
	/** Quit button.  */
	private var bQuit	: Button;	
	
	/**
	 * Constructor. Initializes GUI variables (labels, buttons) at specific positions
	 * for mobile and non-mobile targets. Defines sets of keyboard inputs for navigation.
	 */
	public function new () : Void
	{
		super();
#if mobile
		lTitle = new Label("TOCHKA", HXP.halfWidth, HXP.halfHeight - 40, TOP, 64);
		lMadeBy = new Label("BY DOMAGOJ STREKELJ", HXP.halfWidth, HXP.halfHeight + 16, TOP, 16);
		bStart = new Button("START", HXP.width - 12, HXP.height - 12, BOTTOM_RIGHT, 48);
		bQuit = new Button("QUIT", HXP.width - 12, 12, TOP_RIGHT, 48);
#else
		lTitle = new Label("TOCHKA", HXP.halfWidth, HXP.halfHeight - 32, BOTTOM, 64);
		lMadeBy = new Label("BY DOMAGOJ STREKELJ", HXP.halfWidth, HXP.halfHeight - 24, BOTTOM, 16);
		bStart = new Button("START", HXP.halfWidth, HXP.halfHeight + 24, TOP, 32);
		bQuit = new Button("QUIT", HXP.halfWidth, HXP.halfHeight + 88, TOP, 32);
#end
		Input.define("start", [Key.ENTER]);
		Input.define("exit", [Key.ESCAPE, Key.BACKSPACE]);
	}
	
	/**
	 * Called when scene is set to active scene. Adds GUI elements to scene and event
	 * listeners for buttons. Omits "Quit" button from Flash and HTML5 targets.
	 */
	override public function begin () : Void
	{
		super.begin();
		
		add(lTitle);
		add(lMadeBy);
		add(bStart);
		bStart.addEventListener(Control.MOUSE_CLICK, sceneHandler);
#if !(flash || html5)
		add(bQuit);
		bQuit.addEventListener(Control.MOUSE_CLICK, sceneHandler);
#end
	}
	
	/** Spawn timer. Counts elapsed time till it matches or exceeds _SPAWN_RATE. */
	private var _spawnTimer : Float = 0;
	/**
	 * Updates scene state. Checks if defined inputs were pressed and acts on them if
	 * they were. Populates background by spawning obstacle entities.
	 */
	override public function update () : Void
	{
		super.update();
		
		if (Input.pressed("start"))
		{
			HXP.scene = Main.sceneGame;
		}
#if !(flash || html5)
		else if (Input.pressed("exit"))
		{
			flash.Lib.exit();
		}
#end
		
		_spawnTimer += HXP.elapsed;
		if (_spawnTimer >= _SPAWN_RATE)
		{
			create(entities.Obstacle, true).init();
			_spawnTimer = 0;
		}
	}
	
	/**
	 * Called when scene is no longer active scene. Removes all entities on scene
	 * and event listeners from buttons.
	 */
	override public function end () : Void
	{
		super.end();
		
		removeAll();
		
		bStart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
#if !(flash || html5)
		bQuit.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
#end
	}
	
	/** Handles dispatched events from buttons and changes scenes accordingly. */
	private function sceneHandler (e : CEvent) : Void
	{
		switch(e.senderID)
		{
			case id if (id == bStart.id):
				HXP.scene = Main.sceneGame;
#if !(flash || html5)
			case id if (id == bQuit.id):
				flash.Lib.exit();
#end
		}
	}
}
