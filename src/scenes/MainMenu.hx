package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import gui.*;

class MainMenu extends Scene
{
	private static inline var _SPAWN_RATE : Float = 0.3;
	
	private var lTitle	: Label;
	private var lMadeBy	: Label;
	private var bStart	: Button;
	private var bQuit	: Button;	
	
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
	
	private var _spawnTimer : Float = 0;
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
			//trace(HXP.round(flash.system.System.totalMemory / 1024 / 1024, 2));
		}
	}
	
	override public function end () : Void
	{
		super.end();
		
		removeAll();
		
		bStart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
#if !(flash || html5)
		bQuit.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
#end
	}
	
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
