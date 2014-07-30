package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import gui.*;

class Game extends Scene
{	
	private static inline var _SPAWN_RATE : Float = 0.3;
	
	private var _player : entities.Player;
	
	private var _lGameOver : Label;
	private var _lHighScores : Label;
	private var _lInstructions : Label;
	private var _lScore : Label;
	
	private var _bMenu : Button;
	private var _bRestart : Button;
	
	private var _score : Float;
	
	public function new () : Void
	{
		super();
		
		_player = new entities.Player();
#if mobile
		_lGameOver = new Label("GAME OVER", HXP.halfWidth, HXP.halfHeight - 40, TOP, 64);
		_lHighScores = new Label("SCORE : ? (BEST: ? / ALL-TIME: ?)", HXP.halfWidth, HXP.halfHeight + 16, TOP);
		_lInstructions = new Label("AVOID COLLISION\nTOUCH SCREEN TO JUMP\n\nTOUCH TO PLAY", HXP.halfWidth, HXP.halfHeight, CENTER, 24);
		_bMenu = new Button("MENU", HXP.width - 12, 12, TOP_RIGHT, 48);
		_bRestart = new Button("RESTART", HXP.width - 12, HXP.height - 12, BOTTOM_RIGHT, 48);
#else
		_lGameOver = new Label("GAME OVER", HXP.halfWidth, HXP.halfHeight - 32, BOTTOM, 64);
		_lHighScores = new Label("SCORE : ? (BEST: ? / ALL-TIME: ?)", HXP.halfWidth, HXP.halfHeight - 24, BOTTOM);
		_lInstructions = new Label("AVOID COLLISION\nLEFT CLICK / SPACE / W / UP\nTO JUMP\n\nJUMP TO PLAY", HXP.halfWidth, HXP.halfHeight, CENTER, "center", 24);
		_bMenu = new Button("MENU", HXP.halfWidth, HXP.halfHeight + 88, TOP, 32);
		_bRestart = new Button("RESTART", HXP.halfWidth, HXP.halfHeight + 24, TOP, 32);
#end
		_lScore = new Label("SCORE: ", HXP.halfWidth, 48, CENTER);
	}
	
	override public function begin () : Void
	{
		super.begin();
		
		add(_player);
		
		add(_lGameOver);
		add(_lHighScores);
		add(_lInstructions);
		add(_lScore);		
		
		add(_bMenu);
		add(_bRestart);
		
		init();
	}
			
	private function init () : Void
	{
		_player.init();
		
		_score = 0;
		_lScore.visible = false;
		_lGameOver.visible = false;
		_lHighScores.visible = false;
		_lInstructions.visible = true;
		
		_bMenu.visible = false;
		_bRestart.visible = false;
		_bMenu.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
		_bRestart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
	}
	
	override public function update () : Void
	{
		super.update();
		
		if (_player.isReady && _player.isAlive)
		{
			_lInstructions.visible = false;
			_lScore.visible = true;
			
			play();
		}
		else if (!_player.isAlive)
		{
			_lScore.visible = false;
			
			showScoreboard();
		}
	}
	
	private var _spawnTimer : Float = 0;
	private function play () : Void
	{
		_spawnTimer += HXP.elapsed;
		if (_spawnTimer >= _SPAWN_RATE)
		{
			create(entities.Obstacle, true).init();
			_spawnTimer = 0;
			//trace(HXP.round(flash.system.System.totalMemory / 1024 / 1024, 2));
		}
			
		_score += HXP.elapsed;
		_lScore.text = "SCORE: " + Std.int(_score);
	}
	
	private function showScoreboard () : Void
	{
		recordScore();
		
		_lHighScores.text = "SCORE: " + Std.int(_score) + " (BEST: " + Main.so.data.sessionbest + " / ALL-TIME: " + Main.so.data.score + ") ";
		
		_lGameOver.visible = true;
		_lHighScores.visible = true;
		
		_bMenu.visible = true;
		_bRestart.visible = true;
		
		
		if (!(_bMenu.hasEventListener(Control.MOUSE_CLICK) && _bRestart.hasEventListener(Control.MOUSE_CLICK)) )
		{
			if(!entities.Obstacle.isOnCamera)
			{
				_bRestart.addEventListener(Control.MOUSE_CLICK, sceneHandler);
			}
				
			_bMenu.addEventListener(Control.MOUSE_CLICK, sceneHandler);
		}
		
		if(!entities.Obstacle.isOnCamera)
		{
			if (Input.pressed("start"))
			{
				init();
			}
		}
		
		if (Input.pressed("exit"))
		{
			HXP.scene = Main.sceneMenu;
		}
	}
	
	private function recordScore () : Void
	{
		try
		{
			Main.so = flash.net.SharedObject.getLocal("highscore");
		}
		catch(error : Dynamic)
		{
			trace("SharedObject error: " + error);
		}
			
		if (Std.int(_score) > Std.int(Main.so.data.sessionbest))
		{
			Main.so.data.sessionbest = Std.int(_score);
			Main.so.flush();
		}
		
		if (Std.int(_score) > Std.int(Main.so.data.score))
		{
			Main.so.data.score = Std.int(_score);
			Main.so.flush();
		}
	}
	
	private function sceneHandler (e : CEvent) : Void
	{
		switch(e.senderID)
		{
			case id if (id == _bMenu.id): HXP.scene = Main.sceneMenu;
			case id if (id == _bRestart.id): init();
		}
	}
	
	override public function end () : Void
	{
		super.end();
		
		removeAll();
		
		_bMenu.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
		_bRestart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
	}
}