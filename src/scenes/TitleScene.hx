package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

class TitleScene extends Scene {
	private var mousePointer : gui.MousePointer;
	private var optionStart : gui.Option;
	private var optionQuit : gui.Option;
	private var titleText : gui.TextField;
	private var madeBy : gui.TextField;
	
	public function new () : Void {
		super();
		
		mousePointer = new gui.MousePointer(0, 0);
		titleText = new gui.TextField(10, 10, "DOT DODGE", 48);
		madeBy = new gui.TextField(268, 34, "BY DOMAGOJ STREKELJ", 16);
		optionStart = new gui.Option(10, 82, "START", 32);
		optionQuit = new gui.Option(10, 138, "QUIT", 32);		
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
}