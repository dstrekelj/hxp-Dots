package scenes;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;

import flash.net.SharedObject;

import entities.*;
import gui.*;

class GameScene extends Scene {
	//Entities:
	private var player : Player;
	public var textScore : GameScore;
	private var textInstructions : Instructions;
	//Variables:
	public var restart : Bool;
	private var spawnTimer : Float;
	private var quitTimer : Float;
	
	private var mousePointer : gui.MousePointer;
	private var optionMenu : gui.Option;
	private var optionTryAgain : gui.Option;
	private var txtfieldGameOver : gui.TextField;
	//private var txtfieldScore : gui.TextField;
	private var txtfieldScores : gui.TextField;
	
	private var so : SharedObject;
	
	public function new () {
		super ();
			
		//Declaring the entities
		player = new Player ( 150, HXP.halfHeight );
		textScore = new GameScore ( HXP.width-140, 10, false );
#if android
		textInstructions = new Instructions ( 10, 10, "DODGE OBSTACLES." +
											 "\nSTAY INSIDE THE SCREEN." +
											 "\nTOUCH TO JUMP." +
											 "\nTOUCH TO CONTINUE.", true );
#else
		textInstructions = new Instructions ( 10, 10, "DODGE OBSTACLES." +
											 "\nSTAY INSIDE THE SCREEN." +
											 "\nJUMP: LCLICK, SPACE, W, UP." +
											 "\nJUMP TO CONTINUE.", true );
#end
		//Declaring the variables
		restart = false;
		spawnTimer = 0;
		quitTimer = 0;
		
		mousePointer = new gui.MousePointer(0, 0);
		optionMenu = new gui.Option(HXP.width-12, 12, "MENU", 48, "top-right", false);
		optionTryAgain = new gui.Option(HXP.width-12, HXP.height-12, "AGAIN", 48, "bottom-right", false);
		txtfieldGameOver = new gui.TextField(HXP.width/2, HXP.height/2-40, "YOU DIED", 64, "top", false);
		//txtfieldScore = new gui.TextField(HXP.width/2, 12, "SCORE: ", 48, "top", true);
		txtfieldScores = new gui.TextField(HXP.width/2, HXP.height/2+16, "SCORE: ", 16, "top", false);
		
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE] );
	}
	
	override public function begin () {
		//Setting up the background colour
#if flash
        HXP.screen.color = 0x222222;
#else
        var base = Image.createRect(HXP.width, HXP.height, 0x222222, 1);
        base.color = 0x222222;
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = 100;
#end
		//Adding the entities to the scene
		add ( mousePointer );
		add ( optionMenu );
		add ( optionTryAgain );
		add ( txtfieldGameOver );
		//add ( txtfieldScore );
		add ( txtfieldScores );
		
		add ( textScore );
		add ( textInstructions );
		add ( player );
		
		super.begin();
	}
	
	override public function update () {
		setup();
		
		showScoreboard();
						
		super.update();
	}
	
	override public function end () {
		removeAll();
		
		try {
			so = SharedObject.getLocal( "highscore" );
		} catch ( error : Dynamic ) {
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		
		super.end();
	}
	
	private function setup () : Void {
		if (player.isReady) {
			textScore.visible = true;
			textInstructions.visible = false;
			spawn();
			if ( !player.isDestroyed ) {
				textScore.addScore();
			}
		}
	}
	
	private function spawn () : Void {
		spawnTimer += HXP.elapsed;
		if (spawnTimer >= 0.3) {
			add ( new Obstacle ( HXP.width, (HXP.height-40) * HXP.random, HXP.random ) );
			spawnTimer=0;
		}
	}
	
	private function recordScore () : Void {
		try {
			so = SharedObject.getLocal( "highscore" );
		} catch ( error : Dynamic ) {
			trace("SharedObject error: " + error);
		}
			
		if ( textScore.getScore() > Std.int(so.data.sessionbest) ) {
			so.data.sessionbest = textScore.getScore();
			so.flush();
		}
			
		if ( textScore.getScore() > Std.int(so.data.score) ) {
			so.data.score = textScore.getScore();
			so.flush();
		}
	}
	
	private function showScoreboard () : Void {
		if (player.isDestroyed){
			quitTimer += HXP.elapsed;
			
			recordScore();
			
			textScore.visible = false;
			
			optionMenu.visible = true;
			optionTryAgain.visible = true;
			txtfieldGameOver.visible = true;
					
			txtfieldScores.setText("SCORE: " + textScore.getScore() +
								   " (BEST: " + so.data.sessionbest +
								   ", ALL-TIME: " + so.data.score + ")");
			txtfieldScores.visible = true;
			
			if (mousePointer.handle(optionMenu)) {
				HXP.scene = new scenes.TitleScene();
			} else if (mousePointer.handle(optionTryAgain) && quitTimer >= 0.5) {
				HXP.scene = new scenes.GameScene();
			}
		}
	}
}