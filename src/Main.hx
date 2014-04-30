import com.haxepunk.Engine;
import com.haxepunk.HXP;

import flash.net.SharedObject;

class Main extends Engine
{
	private var so : SharedObject;
	
	override public function new ( width : Int = 0, height : Int = 0, frameRate : Float = 60, fixed : Bool = false ) {
		super( 640, 480, frameRate, fixed );
	}
		
	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		
		setupSharedObject();
				
		//HXP.scene = new MainScene();			//Screen is empty because MainScene.hx is empty
		HXP.scene = new scenes.TitleScene();		//Loads GameScene.hx code
	}
		
	override public function focusLost () {
		paused = true;
	}
	
	override public function focusGained () {
		paused = false;
	}
	
	public static function main() {
		new Main();
	}
	
	private function setupSharedObject () : Void {
		try {
			so = SharedObject.getLocal( "highscore" );
		} catch ( error : Dynamic ) {
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		so.flush();
			
		if ( so.data.score == null ) {
			so.data.score = 0;
			so.flush();
		}
	}
}