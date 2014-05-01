package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class Option extends Entity {
	private var optionText : Text;
	
	public function new ( x : Float, 
						  y : Float, 
						  text : String,
						 ?size : Int = 16,
						 ?align : String = "top-left",
						 ?visible : Bool = true
						) : Void {
		super(x, y);
		
		optionText = new Text(text);
		optionText.size = size;
		
		graphic = optionText;
		
		setAlignment(align);
		type = "option";
		
		this.visible = visible;
	}
	
	public function setText ( newText : String ) : Void {
		optionText.text = newText;
	}
	
	public function setAlignment ( newAlignment : String ) : Void {
		switch (newAlignment) {
		case "top-left":
			graphic.x = 0;
			graphic.y = 0;
			setHitbox(optionText.textWidth, optionText.textHeight, 0, 0);
		case "top":
			graphic.x = -optionText.textWidth/2;
			graphic.y = 0;
			setHitbox(optionText.textWidth, optionText.textHeight, Std.int(optionText.textWidth/2), 0);
		case "top-right":
			graphic.x = -optionText.textWidth;
			graphic.y = 0;
			setHitbox(optionText.textWidth, optionText.textHeight, optionText.textWidth, 0);
		case "center-left":
			graphic.x = 0;
			graphic.y = -optionText.textHeight/2;
			setHitbox(optionText.textWidth, optionText.textHeight, 0, Std.int(optionText.textHeight/2));
		case "center":
			graphic.x = -optionText.textWidth/2;
			graphic.y = -optionText.textHeight/2;
			setHitbox(optionText.textWidth, optionText.textHeight, Std.int(optionText.textWidth/2), Std.int(optionText.textHeight/2));
		case "center-right":
			graphic.x = -optionText.textWidth;
			graphic.y = -optionText.textHeight/2;
			setHitbox(optionText.textWidth, optionText.textHeight, optionText.textWidth, Std.int(optionText.textHeight/2));
		case "bottom-left":
			graphic.x = 0;
			graphic.y = -optionText.textHeight;
			setHitbox(optionText.textWidth, optionText.textHeight, 0, optionText.textHeight);
		case "bottom":
			graphic.x = -optionText.textWidth/2;
			graphic.y = -optionText.textHeight;
			setHitbox(optionText.textWidth, optionText.textHeight, Std.int(optionText.textWidth/2), optionText.textHeight);
		case "bottom-right":
			graphic.x = -optionText.textWidth;
			graphic.y = -optionText.textHeight;
			setHitbox(optionText.textWidth, optionText.textHeight, optionText.textWidth, optionText.textHeight);
		default :
			setHitboxTo(graphic);
		}
	}
}
