import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.net.SharedObject;

class Main extends Engine
{
	public static var sceneMenu : Scene;
	public static var sceneGame : Scene;
	
	public static var so : SharedObject;
	
	override public function new (width : Int = 0, height : Int = 0, frameRate : Float = 60, fixed : Bool = false) : Void
	{
		super(640, 480, frameRate, fixed);
	}
	
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

	public static function main () : Void
	{
		new Main();
	}
	
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
	
	override public function focusLost () : Void
	{
		paused = true;
	}
	
	override public function focusGained () : Void
	{
		paused = false;
	}
}