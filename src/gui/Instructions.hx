package gui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;

class Instructions extends Entity {
	private var textInstructions : Text;
		
	public function new ( x : Int, y : Int, text : String , visible : Bool ) {
		super( x, y );
				
		layer = 0;
		this.visible = visible;
		
		textInstructions = new Text(text);
		textInstructions.size = 24;
		
		graphic = textInstructions;
	}
	
	public function setText ( text : String ) : Void {
		textInstructions.text = text;
	}
}