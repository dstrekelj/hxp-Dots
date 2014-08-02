package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import gui.*;

class Game extends Scene
{	
	/** Determines spawn rate of obstacles in background. */
	private static inline var _SPAWN_RATE : Float = 0.3;
	/** Stores player entity. */
	private var _player : entities.Player;
	/** Label for game over text. */
	private var _lGameOver : Label;
	/** Label for high scores. */
	private var _lHighScores : Label;
	/** Label for instructions. */
	private var _lInstructions : Label;
	/** Label for current score. */
	private var _lScore : Label;
	/** 'Return to menu' button. */
	private var _bMenu : Button;
	/** 'Restart game' button. */
	private var _bRestart : Button;
	/** Variable keeping track of current score. */
	private var _score : Float;
	
	/**
	 * Constructor. Initializes player variable. Initializes GUI variables (labels,
	 * buttons) at specific positions for mobile and non-mobile targets.
	 */
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
	
	/**
	 * Called when scene is set to active scene. Populates scene with player entity
	 * and GUI elements. Calls init() to initialize certain parameters.
	 */
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
	
	/**
	 * Calls Player class' init() method. Sets score to 0. Sets visibility of GUI
	 * elements. Removes existing event listeners from buttons.
	 */
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
		if (_bMenu.hasEventListener(Control.MOUSE_CLICK) && _bRestart.hasEventListener(Control.MOUSE_CLICK))
		{
			_bMenu.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
			_bRestart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
		}		
	}
	
	/**
	 * Updates scene state. If player entity is ready and alive, play the game.
	 * If player is not alive, show the scoreboard (current score, session best
	 * and all-time high).
	 */
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
	
	/** Spawn timer. Counts elapsed time till it matches or exceeds _SPAWN_RATE. */
	private var _spawnTimer : Float = 0;
	/** Core game logic. Populate scene with obstacle entities. Track score. */
	private function play () : Void
	{
		_spawnTimer += HXP.elapsed;
		if (_spawnTimer >= _SPAWN_RATE)
		{
			create(entities.Obstacle, true).init();
			_spawnTimer = 0;
		}
			
		_score += HXP.elapsed;
		_lScore.text = "SCORE: " + Std.int(_score);
	}
	
	/**
	 * Calls recordScore() to store score data. Displays current score, session best
	 * and all-time high score. Displays buttons with added event listeners. Handles
	 * keyboard input for navigation. Quitting changes scene to the menu scene.
	 * Restarting calls init() to reset game parameters.
	 */
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
	
	/** Stores current score data in SharedObject. */
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
	
	/** Handles dispatched events from buttons and changes scenes accordingly. */
	private function sceneHandler (e : CEvent) : Void
	{
		switch(e.senderID)
		{
			case id if (id == _bMenu.id): HXP.scene = Main.sceneMenu;
			case id if (id == _bRestart.id): init();
		}
	}
	
	/**
	 * Called when scene is no longer active scene. Removes all entities on scene
	 * and event listeners from buttons.
	 */
	override public function end () : Void
	{
		super.end();
		
		removeAll();
		
		_bMenu.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
		_bRestart.removeEventListener(Control.MOUSE_CLICK, sceneHandler);
	}
}