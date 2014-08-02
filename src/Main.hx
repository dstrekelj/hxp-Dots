import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.net.SharedObject;

class Main extends Engine
{
	/** Stores the menu scene. */
	public static var sceneMenu : Scene;
	/** Stores the game scene. */
	public static var sceneGame : Scene;
	/** Handles data storage. */
	public static var so : SharedObject;
	
	/**
	 * Constructor. Sets game to 640 x 480 resolution, fixed framerate at 60 fps.
	 * @param		width		Width of game
	 * @param		height		Height of game
	 * @param		frameRate	Game framerate, in frames per second
	 * @param		fixed		Use fixed framerate?
	 */
	override public function new (width : Int = 0, height : Int = 0, frameRate : Float = 60, fixed : Bool = false) : Void
	{
		super(640, 480, frameRate, fixed);
	}
	
	/**
	 * Called after Engine has been added to the Flash Stage. Prepares SharedObject
	 * for data storage. Initializes scene variables. Sets menu scene to active scene.
	 */
	override public function init () : Void
	{
#if debug
		HXP.console.enable();
#end
		setupSharedObject();	
	
		sceneMenu = new scenes.MainMenu();		
		sceneGame = new scenes.Game();
		
		HXP.scene = sceneMenu;
	}
	
	/** Main function of project. */
	public static function main () : Void
	{
		new Main();
	}
	
	/**
	 * Prepares SharedObject of "highscore" name for data storage. Catch error if
	 * SharedObject cannot be opened or created (insufficient permissions, free disk
	 * space, ...). Set current session best score to 0. If no previous high score
	 * exists, set high score to 0.
	 */
	private function setupSharedObject () : Void
	{
		try
		{
			so = SharedObject.getLocal("highscore");
		}
		catch (error : Dynamic)
		{
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		so.flush();
		
		if (so.data.score == null)
		{
			so.data.score = 0;
			so.flush();
		}
	}
	
	/** Pause game while not in focus. For HTML5 and Flash targets. */
	override public function focusLost () : Void
	{
		paused = true;
	}
	/** Resume game while not in focus. For HTML5 and Flash targets. */
	override public function focusGained () : Void
	{
		paused = false;
	}
}