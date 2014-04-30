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
		graphic.x = -textFieldText.textWidth/2;
		//graphic.y = -textFieldText.textHeight/2;
		
		setHitbox(textFieldText.textWidth, textFieldText.textHeight, Std.int(textFieldText.textWidth/2), 0);
		//centerOrigin();
		type = "textfield";
	}
	
	public function setText ( newText : String ) : Void {
		textFieldText.text = newText;
	}
}