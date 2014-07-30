package gui;

import gui.Control;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

import flash.text.TextFormatAlign;

class Label extends Control {
	/** Label text. Changing it updates the Label object accordingly. */
	@:isVar public var text (get, set) : String;
	public function get_text () : String { return text; }
	public function set_text (value : String) : String {
		graphic.destroy();
		graphic = new Text(value, 0, 0, 0, 0, _textOptions);
		setHitboxTo(graphic);
		setRoot(alignment);
		return text = value;
	}
	
	public function new (text : String, x : Float, y : Float, ?alignment : Alignment = CENTER_LEFT, ?textAlign : String = "left", ?newSize : Int = 16, ?width : Int = 0, ?height : Int = 0) : Void {
		super(x, y, alignment, width, height);
		
		this.alignment = alignment;
#if (flash || html5)
		var tta : TextFormatAlign;
		switch(textAlign) {
			case ta if (ta == "left"):		tta = TextFormatAlign.LEFT;
			case ta if (ta == "right"):		tta = TextFormatAlign.RIGHT;
			case ta if (ta == "center"):	tta = TextFormatAlign.CENTER;
			case ta if (ta == "justify"):	tta = TextFormatAlign.JUSTIFY;
			default:						tta = TextFormatAlign.LEFT;
		}
		_textOptions = {align : tta, size : newSize};
#else
		_textOptions = {align : textAlign, size : newSize};
#end		
		graphic = new Text(text, 0, 0, 0, 0, _textOptions);
		setHitboxTo(graphic);
		
		setRoot(alignment);
	}
	
	private var _textOptions : TextOptions;
}