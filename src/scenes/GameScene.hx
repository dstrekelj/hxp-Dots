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
	private var optionRestart : gui.Option;
	//private var txtfieldScore : gui.TextField;
	private var txtfieldInstructions : gui.TextField;
	private var txtfieldGameOver : gui.TextField;
	private var txtfieldScores : gui.TextField;
	
	private var so : SharedObject;
	
	public function new () {
		super ();
			
		//Declaring the entities
		player = new Player ( 100, HXP.halfHeight );
		textScore = new GameScore ( HXP.width/2, 24, false );/*
#if mobile
		textInstructions = new Instructions ( 10, 10, "DODGE OBSTACLES." +
											 "\nSTAY INSIDE THE SCREEN." +
											 "\nTOUCH TO JUMP." +
											 "\nTOUCH TO CONTINUE.", true );
#else
		textInstructions = new Instructions ( 10, 10, "DODGE OBSTACLES." +
											 "\nSTAY INSIDE THE SCREEN." +
											 "\nJUMP: LCLICK, SPACE, W, UP." +
											 "\nJUMP TO CONTINUE.", true );
#end*/
		//Declaring the variables
		restart = false;
		spawnTimer = 0;
		quitTimer = 0;
		
		mousePointer = new gui.MousePointer(0, 0);

		//txtfieldScore = new gui.TextField(HXP.width/2, 24, "SCORE: ", 24, "top", false);
		
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
#end	
		
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE, Key.ENTER] );
		Input.define( "exit", [Key.ESCAPE, Key.BACKSPACE] );
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
		add ( optionRestart );
		add ( txtfieldInstructions );
		add ( txtfieldGameOver );
		//add ( txtfieldScore );
		add ( txtfieldScores );
		
		add ( textScore );
		//add ( textInstructions );
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
			//textInstructions.visible = false;
			
			txtfieldInstructions.visible = false;
			//txtfieldScore.visible = true;
			
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
			optionRestart.visible = true;
			txtfieldGameOver.visible = true;
					
			txtfieldScores.setText("SCORE: " + textScore.getScore() +
								   " (BEST: " + so.data.sessionbest +
								   " / ALL-TIME: " + so.data.score + ") ");
			txtfieldScores.visible = true;
#if mobile
			if (mousePointer.handle(optionMenu)) {
				HXP.scene = new scenes.TitleScene();
			} else if (mousePointer.handle(optionRestart) && quitTimer >= 0.5) {
				HXP.scene = new scenes.GameScene();
			}
#else
			if (mousePointer.handle(optionMenu) || Input.pressed("exit")) {
				HXP.scene = new scenes.TitleScene();
			} else if ((mousePointer.handle(optionRestart) || Input.pressed("jump")) && quitTimer >= 0.5) {
				HXP.scene = new scenes.GameScene();
			}
#end
		}
	}
}