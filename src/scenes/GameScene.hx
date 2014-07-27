package scenes;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;

import gui.Button;
import gui.CEvent;
import gui.Control;
import gui.Label;

import flash.net.SharedObject;

import entities.*;

class GameScene extends Scene
{
	private var bMenu : Button;
	private var bRestart : Button;
	private var lInstructions : Label;
	private var lGameOver : Label;
	private var lHighScores : Label;
	private var lScore : Label;
	
	/**	Player class extends Entity, represents the player. */
	private var player : Player;
	
	/*	spawnTimer is used to time the spawn times of obstacles.
	 *	quitTimer is used to disable the Quit option for a while
	 *	to prevent accidental quitting of the game.
	 */
	private var spawnTimer : Float;
	private var quitTimer : Float;
	
	/**	SharedObject used for storing game progress. */
	private var so : SharedObject;
	
	private var score : Float;
	
	/*	Constructor for the GameScene class extending Scene.
	 *
	 *	Creates player object and initializes spawnTimer and
	 *	quitTimer variables.
	 *
	 *	Creates objects of GUI classes with specific parameters
	 *	depending on whether the target is mobile or not. The
	 *	difference is in the instruction text ("Touch" instead
	 *	of "CLICK") and the on-screen position of the options.
	 */
	public function new () : Void
	{
		super ();
		score = 0;
		player = new Player ( 100, HXP.halfHeight );
		spawnTimer = 0;
		quitTimer = 0;
		/*
		mousePointer = new gui.MousePointer(0, 0);
		txtScore = new gui.GameScore ( HXP.width/2, 24, false );
#if mobile
		txtfieldInstructions = new gui.TextField(HXP.width/2, HXP.height/2, 
												 "AVOID COLLISION" +
												 "\nTOUCH TO JUMP",
												 24, "center", "center", true
												);
		txtfieldGameOver = new gui.TextField(HXP.width/2, HXP.height/2-40, "YOU DIED", 64, "center", "top", false);
		txtfieldScores = new gui.TextField(HXP.width/2, HXP.height/2+16, "SCORE: ", 16, "center", "top", false);
		optionMenu = new gui.Option(HXP.width-12, 12, "MENU", 48, "top-right", false);
		optionRestart = new gui.Option(HXP.width-12, HXP.height-12, "RESTART", 48, "bottom-right", false);
#else
		txtfieldInstructions = new gui.TextField(HXP.width/2, HXP.height/2, 
												 "AVOID COLLISION" +
												 "\nLCLICK/SPACE/W/UP" +
												 "\nTO JUMP",
												 24, "center", "center", true
												);
		txtfieldGameOver = new gui.TextField(HXP.width/2, HXP.height/2-32, "GAME OVER", 64, "center", "bottom", false);
		txtfieldScores = new gui.TextField(HXP.width/2, HXP.height/2-24, "SCORE: ", 16, "center", "bottom", false);	
		optionRestart = new gui.Option(HXP.width/2, HXP.height/2+24, "RESTART", 32, "top", false);	
		optionMenu = new gui.Option(HXP.width/2, HXP.height/2+88, "MENU", 32, "top", false);
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE, Key.ENTER] );
		Input.define( "exit", [Key.ESCAPE, Key.BACKSPACE] );
#end*/
		lScore = new Label("", HXP.width / 2, 24, CENTER);
		lScore.visible = false;
#if mobile
		lInstructions = new Label("AVOID COLLISION\nTOUCH SCREEN TO JUMP", HXP.width / 2, HXP.height / 2, CENTER, 24);
		lGameOver = new Label("GAME OVER", HXP.width / 2, HXP.height / 2, TOP, 64);	
		lHighScores = new Label("SCORE: ", HXP.width / 2, (HXP.height / 2) + 16, TOP);
		bMenu = new Button("MENU", HXP.width - 12, 12, TOP_RIGHT, 48);
		bRestart = new Button("RESTART", HXP.width - 12, HXP.height - 12, BOTTOM_RIGHT, 48);
#else
		lInstructions = new Label("AVOID COLLISION\nLEFT CLICK / SPACE / W / UP\nTO JUMP", HXP.width / 2, HXP.height / 2, CENTER, 24);
		lGameOver = new Label("GAME OVER", HXP.width / 2, (HXP.height / 2) - 32, BOTTOM, 64);
		lHighScores = new Label("SCORE: ", HXP.width / 2, (HXP.height / 2) - 24, BOTTOM, 16);
		bMenu = new Button("MENU", HXP.width / 2, (HXP.height / 2) + 88, TOP, 32);
		bRestart = new Button("RESTART", HXP.width / 2, (HXP.height / 2) + 24, TOP, 32);
#end
		lGameOver.visible = false;
		lHighScores.visible = false;
		bMenu.addEventListener(Control.MOUSE_DOWN, sceneHandler);
		bRestart.addEventListener(Control.MOUSE_DOWN, sceneHandler);
		
	}
	
	/*	Called when Scene is switched to and set to the currently
	 *	active Scene.
	 *
	 *	Sets background colour of Scene.
	 *
	 *	Places player object and GUI elements on the Scene.
	 */
	override public function begin () : Void
	{
#if flash
        HXP.screen.color = 0x222222;
#else
        var base = Image.createRect(HXP.width, HXP.height, 0x222222, 1);
        base.color = 0x222222;
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = 100;
#end	
		add(lScore);
		add(lInstructions);
		add(lGameOver);
		add(lHighScores);
		
		add ( player );
		
		super.begin();
	}
	
	/*	Updates the game, updating the Scene and its Entities.
	 *
	 *	Calls setup() to set the game up, player and obstacles.
	 *	Calls showScoreboard() to check for the event that the
	 *	scoreboard needs to be displayed.
	 */
	override public function update () : Void
	{
		setup();
		
		showScoreboard();
						
		super.update();
	}
	
	/*	Called when Scene is switched from and is no longer the
	 *	currently active Scene.
	 *
	 *	Removes all entities and assets on Scene switch and sets
	 *	the high score of the current session to 0.
	 */
	override public function end () : Void
	{
		removeAll();
		
		try
		{
			so = SharedObject.getLocal( "highscore" );
		}
		catch ( error : Dynamic )
		{
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		
		super.end();
	}
	
	/*	Sets up the game by checking whether player is ready
	 *	to play. If he is, displays the necessary GUI elements
	 *	and calls spawn() to create obstacles. Increments current
	 *	score while player is still alive.
	 */
	private function setup () : Void {
		if (player.isReady)
		{
			lScore.visible = true;
			lInstructions.visible = false;
						
			spawn();
			
			if ( !player.isDestroyed )
			{
				score += HXP.elapsed;
				lScore.text = "SCORE: " + Std.int(score);
			}
		}
	}
	
	/*	Creates the obstacles by counting the time elapsed since
	 *	the last frame. Obstacles are created at max game width,
	 *	but random game height position.
	 */
	private function spawn () : Void {
		spawnTimer += HXP.elapsed;
		if (spawnTimer >= 0.3)
		{
			add ( new Obstacle ( HXP.width, (HXP.height-40) * HXP.random, HXP.random ) );
			spawnTimer=0;
		}
	}
	
	/*	Records session best and overall highscore with the use
	 *	of SharedObject.
	 */
	private function recordScore () : Void
	{
		try
		{
			so = SharedObject.getLocal( "highscore" );
		}
		catch ( error : Dynamic )
		{
			trace("SharedObject error: " + error);
		}
			
		if ( Std.int(score) > Std.int(so.data.sessionbest) )
		{
			so.data.sessionbest = Std.int(score);
			so.flush();
		}
			
		if ( Std.int(score) > Std.int(so.data.score) )
		{
			so.data.score = Std.int(score);
			so.flush();
		}
	}
	
	/*	Displays the scoreboard after the player dies. Offers
	 *	options to retry the game or exit to the TitleScene.
	 */
	private function showScoreboard () : Void
	{
		if (player.isDestroyed)
		{
			quitTimer += HXP.elapsed;
			
			recordScore();
			
			lScore.visible = false;
			
			add(bMenu);
			add(bRestart);
			
			lGameOver.visible = true;
					
			lHighScores.text = "SCORE: " + Std.int(score) + " (BEST: " + so.data.sessionbest + " / ALL-TIME: " + so.data.score + ") ";
			lHighScores.visible = true;
			/*
			if (mousePointer.handle(optionMenu) || Input.pressed("exit"))
			{
				HXP.scene = new scenes.TitleScene();
			} else if ((mousePointer.handle(optionRestart) || Input.pressed("jump")) && quitTimer >= 0.5)
			{
				HXP.scene = new scenes.GameScene();
			}
			*/
		}
	}
	
	private function sceneHandler (e : CEvent)
	{
		switch(e.senderID)
		{
			case id if (id == bMenu.ID):
				HXP.scene = Main.sceneTitle;
			case id if (id == bRestart.ID):
				HXP.scene = new scenes.GameScene();
		}
	}
}