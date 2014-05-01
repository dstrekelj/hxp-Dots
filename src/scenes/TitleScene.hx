package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

class TitleScene extends Scene {
	private var mousePointer : gui.MousePointer;
	private var optionStart : gui.Option;
	private var optionQuit : gui.Option;
	private var titleText : gui.TextField;
	private var madeBy : gui.TextField;
	
	private var spawnTimer : Float = 0;
	
	public function new () : Void {
		super();
		
		mousePointer = new gui.MousePointer(0, 0);
		titleText = new gui.TextField(HXP.width/2, HXP.height/2-40, "TOCHKA", 64, "top");
		madeBy = new gui.TextField(HXP.width/2, HXP.height/2+16, "BY DOMAGOJ STREKELJ", 16, "top");
		optionStart = new gui.Option(HXP.width-12, HXP.height-12, "START", 48, "bottom-right");
		optionQuit = new gui.Option(HXP.width-12, 12, "QUIT", 48, "top-right");
	}
	
	override public function begin () : Void {
		add(mousePointer);
		
		add(titleText);
		add(madeBy);
		add(optionStart);
		add(optionQuit);
				
		super.begin();
	}
	
	override public function update () : Void {
		handleOptions();
		
		spawn();
		
		super.update();
	}
	
	override public function end () : Void {
		removeAll();
		
		super.end();
	}
	
	private function handleOptions () : Void {
		if (mousePointer.handle(optionStart)) {
			HXP.scene = new scenes.GameScene();
		} else if (mousePointer.handle(optionQuit)) {
			flash.Lib.exit();
		}
	}
	
	private function spawn () : Void {
		spawnTimer += HXP.elapsed;
		if (spawnTimer >= 0.3) {
			add ( new entities.Obstacle ( HXP.width, (HXP.height-40) * HXP.random, HXP.random ) );
			spawnTimer=0;
		}
	}
}