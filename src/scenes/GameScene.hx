package scenes;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;

import flash.net.SharedObject;

import entities.*;

class GameScene extends Scene
{
	/*	The following private variables relate to the game's GUI.
	 *
	 *	MousePointer class extends Entity and selected options
	 *	are detected through collision with the Option class (also
	 *	extending Entity). This	was done for easier implementation
	 *	of the system on mobile targets.
	 *
	 *	TextField class is the same as the Option class with
	 *	the difference being a lack of collision detection.
	 *
	 *	GameScore class is a modified TextField class which updates
	 *	and displays the players current score. The score value is
	 *	returned via a getter method and stored in the SharedObject.
	 */
	private var mousePointer : gui.MousePointer;
	private var optionMenu : gui.Option;
	private var optionRestart : gui.Option;
	private var txtfieldInstructions : gui.TextField;
	private var txtfieldGameOver : gui.TextField;
	private var txtfieldScores : gui.TextField;
	private var txtScore : gui.GameScore;
	
	/*	Player class extends Entity, represents the player.
	 */
	private var player : Player;
	
	/*	spawnTimer is used to time the spawn times of obstacles.
	 *	quitTimer is used to disable the Quit option for a while
	 *	to prevent accidental quitting of the game.
	 */
	private var spawnTimer : Float;
	private var quitTimer : Float;
	
	/*	SharedObject used for storing game progress.
	 */
	private var so : SharedObject;
	
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
			
		player = new Player ( 100, HXP.halfHeight );
		spawnTimer = 0;
		quitTimer = 0;
		
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
		txtfieldGameOver = new gui.TextField(HXP.width/2, HXP.height/2-32, "YOU DIED", 64, "center", "bottom", false);
		txtfieldScores = new gui.TextField(HXP.width/2, HXP.height/2-24, "SCORE: ", 16, "center", "bottom", false);	
		optionRestart = new gui.Option(HXP.width/2, HXP.height/2+24, "RESTART", 32, "top", false);	
		optionMenu = new gui.Option(HXP.width/2, HXP.height/2+88, "MENU", 32, "top", false);
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE, Key.ENTER] );
		Input.define( "exit", [Key.ESCAPE, Key.BACKSPACE] );
#end
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
		add ( mousePointer );
		add ( optionMenu );
		add ( optionRestart );
		add ( txtfieldInstructions );
		add ( txtfieldGameOver );
		add ( txtfieldScores );	
		add ( txtScore );
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
			txtScore.visible = true;
						
			txtfieldInstructions.visible = false;
						
			spawn();
			
			if ( !player.isDestroyed )
			{
				txtScore.addScore();
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
			
		if ( txtScore.getScore() > Std.int(so.data.sessionbest) )
		{
			so.data.sessionbest = txtScore.getScore();
			so.flush();
		}
			
		if ( txtScore.getScore() > Std.int(so.data.score) )
		{
			so.data.score = txtScore.getScore();
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
			
			txtScore.visible = false;
			
			optionMenu.visible = true;
			optionRestart.visible = true;
			txtfieldGameOver.visible = true;
					
			txtfieldScores.setText("SCORE: " + txtScore.getScore() +
								   " (BEST: " + so.data.sessionbest +
								   " / ALL-TIME: " + so.data.score + ") ");
			txtfieldScores.visible = true;

			if (mousePointer.handle(optionMenu) || Input.pressed("exit"))
			{
				HXP.scene = new scenes.TitleScene();
			} else if ((mousePointer.handle(optionRestart) || Input.pressed("jump")) && quitTimer >= 0.5)
			{
				HXP.scene = new scenes.GameScene();
			}
		}
	}
}