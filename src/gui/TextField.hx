package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class TextField extends Entity {
	private var textFieldText : Text;
	
	public function new ( x : Float, 
						  y : Float, 
						  text : String,
						 ?size : Int = 16,
						 ?align : String = "top-left",
						 ?visible : Bool = true
						) : Void {
		super(x, y);
		
		textFieldText = new Text(text);
		textFieldText.size = size;
		
		graphic = textFieldText;
		
		setAlignment(align);
		type = "textfield";
		
		this.visible = visible;
	}
	
	public function setText ( newText : String ) : Void {
		textFieldText.text = newText;
	}
	
	public function setAlignment ( newAlignment : String ) : Void {
		switch (newAlignment) {
		case "top-left":
			graphic.x = 0;
			graphic.y = 0;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, 0, 0);
		case "top":
			graphic.x = -textFieldText.textWidth/2;
			graphic.y = 0;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, Std.int(textFieldText.textWidth/2), 0);
		case "top-right":
			graphic.x = -textFieldText.textWidth;
			graphic.y = 0;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, textFieldText.textWidth, 0);
		case "center-left":
			graphic.x = 0;
			graphic.y = -textFieldText.textHeight/2;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, 0, Std.int(textFieldText.textHeight/2));
		case "center":
			graphic.x = -textFieldText.textWidth/2;
			graphic.y = -textFieldText.textHeight/2;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, Std.int(textFieldText.textWidth/2), Std.int(textFieldText.textHeight/2));
		case "center-right":
			graphic.x = -textFieldText.textWidth;
			graphic.y = -textFieldText.textHeight/2;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, textFieldText.textWidth, Std.int(textFieldText.textHeight/2));
		case "bottom-left":
			graphic.x = 0;
			graphic.y = -textFieldText.textHeight;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, 0, textFieldText.textHeight);
		case "bottom":
			graphic.x = -textFieldText.textWidth/2;
			graphic.y = -textFieldText.textHeight;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, Std.int(textFieldText.textWidth/2), textFieldText.textHeight);
		case "bottom-right":
			graphic.x = -textFieldText.textWidth;
			graphic.y = -textFieldText.textHeight;
			setHitbox(textFieldText.textWidth, textFieldText.textHeight, textFieldText.textWidth, textFieldText.textHeight);
		default :
			setHitboxTo(graphic);
		}
	}
}