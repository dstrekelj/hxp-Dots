package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class Option extends Entity {
	private var optionText : Text;
	
	public function new ( x : Float, y : Float, text : String, ?size : Int, ?visible : Bool = true ) : Void {
		super(x, y);
		
		optionText = new Text(text);
		optionText.size = size;
		
		this.visible = visible;
		
		graphic = optionText;
							
		setHitboxTo(graphic);
		type = "option";
	}
	
	public function setText ( newText : String ) : Void {
		optionText.text = newText;
	}
}
