package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import gui.Button;
import gui.CEvent;
import gui.Control;
import gui.Label;

class TitleScene extends Scene
{
	/*	The following private variables relate to the game's GUI.
	 *
	 *	MousePointer class extends Entity and selected options
	 *	are detected through collision with the Option class (also
	 *	extending Entity). This	was done for easier implementation
	 *	of the system on mobile targets.
	 *
	 *	TextField class is the same as the Option class with
	 *	the difference being a lack of collision detection.
	 *//*
	private var mousePointer : gui.MousePointer;
	private var optionStart : gui.Option;
	private var optionQuit : gui.Option;
	private var titleText : gui.TextField;
	private var madeBy : gui.TextField;
	*/
	private var bStart	: Button;
	private var bQuit	: Button;
	private var lTitle	: Label;
	private var lMadeBy	: Label;
	
	/*	A timer for the obstacles spawning in the background.
	 */
	private var spawnTimer : Float = 0;
	
	/*	Constructor for the TitleScene class extending the Scene class.
	 *
	 *	Creates new instances of the GUI classes mentioned earlier,
	 *	with different positions of GUI elements for different targets.
	 *
	 *	Defines keyboard input for non-mobile targets.
	 */
	public function new () : Void
	{
		super();		
#if mobile
		lTitle = new Label("TOCHKA", HXP.width / 2, (HXP.height / 2) - 40, TOP, 64);
		lMadeBy = new Label("BY DOMAGOJ STREKELJ", HXP.width / 2, (HXP.height / 2) + 16, TOP, 16);
		bStart = new Button("START", HXP.width - 12, HXP.height - 12, BOTTOM_RIGHT, 48);
		bQuit = new Button("QUIT", HXP.width - 12, 12, TOP_RIGHT, 48);		
#else
		lTitle = new Label("TOCHKA", HXP.width / 2, (HXP.height / 2) - 32, BOTTOM, 64);
		lMadeBy = new Label("BY DOMAGOJ STREKELJ", HXP.width / 2, (HXP.height / 2) - 24, BOTTOM, 16);
		bStart = new Button("START", HXP.width / 2, (HXP.height / 2) + 24, TOP, 32);
		bQuit = new Button("QUIT", HXP.width / 2, (HXP.height / 2) + 88, TOP, 32);
#end
		bStart.addEventListener(Control.MOUSE_DOWN, sceneHandler);
		bQuit.addEventListener(Control.MOUSE_DOWN, sceneHandler);
		/*
		mousePointer = new gui.MousePointer(0, 0);	
#if mobile
		titleText = new gui.TextField(HXP.width/2, HXP.height/2-40, "TOCHKA", 64, null, "top");
		madeBy = new gui.TextField(HXP.width/2, HXP.height/2+16, "BY DOMAGOJ STREKELJ", 16, null, "top");
		optionQuit = new gui.Option(HXP.width-12, 12, "QUIT", 48, "top-right");	
		optionStart = new gui.Option(HXP.width-12, HXP.height-12, "START", 48, "bottom-right");
#else
		titleText = new gui.TextField(HXP.width/2, HXP.height/2-32, "TOCHKA", 64, null, "bottom");
		madeBy = new gui.TextField(HXP.width/2, HXP.height/2-24, "BY DOMAGOJ STREKELJ", 16, null, "bottom");
		optionStart = new gui.Option(HXP.width/2, HXP.height/2+24, "START", 32, "top");
		optionQuit = new gui.Option(HXP.width/2, HXP.height/2+88, "QUIT", 32, "top");
		Input.define( "start", [Key.ENTER] );
		Input.define( "exit", [Key.ESCAPE, Key.BACKSPACE] );
#end*/
	}
	
	/*	Called when Scene is switched to and set to the currently
	 *	active Scene.
	 *
	 *	Places GUI elements on the scene.
	 */
	override public function begin () : Void
	{
		super.begin();
		
		add(bStart);
		add(bQuit);
		add(lTitle);
		add(lMadeBy);
		/*
		add(mousePointer);
		
		add(titleText);
		add(madeBy);
		add(optionStart);
		add(optionQuit);
		*/		
	}
	
	/*	Updates the game, updating the Scene and its Entities.
	 *
	 *	Calls handleOptions() to check if options were selected.
	 *	Calls spawn() to create the obstacles in the background.
	 */
	override public function update () : Void
	{
		super.update();

		//handleOptions();
		spawn();		
	}
	
	/*	Called when Scene is switched from and is no longer the
	 *	currently active Scene.
	 *
	 *	All Entities and assets are removed on Scene switch.
	 */
	override public function end () : Void
	{
		super.end();
		
		removeAll();
	}
	
	/*	Handles the collision of the MousePointer object with
	 *	the Option objects representing selectable options.
	 *	
	 *	If colliding with "QUIT", exit the game.
	 *	If colliding with "START", switch scene to GameScene.
	 *//*
	private function handleOptions () : Void
	{
		if (mousePointer.handle(optionStart) || Input.pressed("start"))
		{
			HXP.scene = new scenes.GameScene();
		}
		else if (mousePointer.handle(optionQuit) || Input.pressed("exit"))
		{
			flash.Lib.exit();
		}
	}*/
	
	private function sceneHandler (e : CEvent) : Void
	{
		switch(e.senderID)
		{
			case id if (id == bStart.ID):
				HXP.scene = Main.sceneGame;
			case id if (id == bQuit.ID):
#if (flash || html5)
			//flash.Lib.fscommand("quit");
			flash.system.System.exit(0);
#else
			flash.Lib.exit();
#end
		}
	}
	
	/*	Spawns the obstacles in the background at random times
	 *	on random points on the Y-axis by looking at elapsed time.
	 */
	private function spawn () : Void
	{
		spawnTimer += HXP.elapsed;
		if (spawnTimer >= 0.3)
		{
			add ( new entities.Obstacle ( HXP.width, (HXP.height-40) * HXP.random, HXP.random ) );
			spawnTimer=0;
		}
	}
}