package gui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;

class GameScore extends Entity {
	private var textScore : Text;
	private var score : Float;
	
	public function new ( x : Float, y : Float, visible : Bool ) : Void {
		super( x, y );
		
		textScore = new Text("SCORE: 0");
#if (html5 || flash)
		textScore.align = flash.text.TextFormatAlign.CENTER;
#else
		textScore.align = "center";
#end
		textScore.size = 24;
		
		graphic = textScore;
		graphic.x = -textScore.textWidth/2;
		graphic.y = 0;
		layer = 0;
		score = 0;
		
		this.visible = visible;
	}
	
	public function addScore () : Void {
		score += HXP.elapsed;
		textScore.text = "SCORE: " + Std.int(score);
	}
	
	public function getScore () : Int {
		return Std.int(score);
	}
	
	/*
	public function GameScore () {
		graphic = new Text("Score: 0");
		_score = 0;
	}
	
	public function addScore ( points : Int ) : Void {
		_score += points;
		
		//Text(graphic).text = "Score: " + _score.toString();
	}
	
	public function destroy () : Void {
		graphic = null;
	}*/
}