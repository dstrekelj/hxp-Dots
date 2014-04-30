package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class TextField extends Entity {
	private var textFieldText : Text;
	
	public function new ( x : Float, y : Float, text : String, ?size : Int, ?visible : Bool = true ) : Void {
		super(x, y);
		
		textFieldText = new Text(text);
		textFieldText.size = size;
		
		this.visible = visible;
		
		graphic = textFieldText;
					
		setHitboxTo(graphic);
		type = "textfield";
	}
	
	public function setText ( newText : String ) : Void {
		textFieldText.text = newText;
	}
}