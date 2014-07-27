import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.net.SharedObject;

class Main extends Engine
{
	public static var sceneGame : Scene;
	public static var sceneTitle : Scene;	
	
	/*	Necessary for the creation of the SharedObject object used to save
	 *	high scores and other progress. Used in setupSharedObject() function.
	 */
	private var so : SharedObject;

	/*	Constructor for the Main class extending the Engine class.
	 *	@param	width		The width of the game
	 *	@param	height		The height of the game
	 *	@param	frameRate	The game framerate, in frames per second
	 *	@param	fixed		If a fixed framerate should be used
	 */
	override public function new ( width : Int = 0,
								  height : Int = 0,
								  frameRate : Float = 60,
								  fixed : Bool = false
								 ) : Void
	{
		super( 640, 480, frameRate, fixed );
	}

	/*	Main game class, manages the game loop.
	 */
	public static function main () : Void
	{
		new Main();
	}
	
	/*	Called after the Engine object has been created in main().
	 *
	 *	Makes sure to enable the console, if building with -debug flag.
	 *	Sets up the SharedObject for further use.
	 *	Creates and calls the TitleScene (the game's main menu).
	 */
	override public function init () : Void
	{
#if debug
		HXP.console.enable();
#end
		setupSharedObject();		
				
		sceneGame = new scenes.GameScene();
		sceneTitle = new scenes.TitleScene();
		
		HXP.scene = sceneTitle;
	}
	
	/*	Sets up a Flash SharedObject for storing game progress
	 *	(high scores) locally. Available on all targets.
	 *
	 *	Tries creating a local SharedObject. Catches error thrown by
	 *	constructor if creation of a local SharedObject isn't possible.
	 *
	 *	Initializes sessionbest variable and score (overall) variable,
	 *	if the score variable isn't present already (if the game was
	 *	never played before).
	 */
	private function setupSharedObject () : Void
	{		
		try
		{
			so = SharedObject.getLocal( "highscore" );
		}
		catch ( error : Dynamic )
		{
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		so.flush();
			
		if ( so.data.score == null )
		{
			so.data.score = 0;
			so.flush();
		}
	}
	
	/*	focusLost() and focusGained() make sure the game state is paused when
	 *	the game window is not in focus. Works on Android and Flash targets.
	 */
	override public function focusLost () : Void
	{
		paused = true;
	}
	
	override public function focusGained () : Void
	{
		paused = false;
	}
}