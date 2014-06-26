package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

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
	 */
	private var mousePointer : gui.MousePointer;
	private var optionStart : gui.Option;
	private var optionQuit : gui.Option;
	private var titleText : gui.TextField;
	private var madeBy : gui.TextField;
	
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
#end
	}
	
	/*	Called when Scene is switched to and set to the currently
	 *	active Scene.
	 *
	 *	Places GUI elements on the scene.
	 */
	override public function begin () : Void
	{
		add(mousePointer);
		
		add(titleText);
		add(madeBy);
		add(optionStart);
		add(optionQuit);
				
		super.begin();
	}
	
	/*	Updates the game, updating the Scene and its Entities.
	 *
	 *	Calls handleOptions() to check if options were selected.
	 *	Calls spawn() to create the obstacles in the background.
	 */
	override public function update () : Void
	{
		handleOptions();
		
		spawn();
		
		super.update();
	}
	
	/*	Called when Scene is switched from and is no longer the
	 *	currently active Scene.
	 *
	 *	All Entities and assets are removed on Scene switch.
	 */
	override public function end () : Void
	{
		removeAll();
		
		super.end();
	}
	
	/*	Handles the collision of the MousePointer object with
	 *	the Option objects representing selectable options.
	 *	
	 *	If colliding with "QUIT", exit the game.
	 *	If colliding with "START", switch scene to GameScene.
	 */
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