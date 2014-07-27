package gui;

import gui.Control;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

import flash.events.MouseEvent;

class Button extends Control {
	/** Button label. Changing the label updates the button visuals.  */
	@:isVar public var label (get, set) : String;
	private inline function get_label () : String { return label; }
	private inline function set_label (value : String) : String {
		graphic.destroy();
		graphic = new Text(value, 0, 0, 0, 0, _textOptions);
		setHitboxTo(graphic);
		setRoot(alignment);
		return label = value;
	}
	
	/**
	 * Constructor. Creates news labeled Button object at x, y position, of
	 * passed width and height.
	 * @param	label		Button label text. Becomes control ID by default.
	 * @param	x			Button X position on scene.
	 * @param	y			Button Y position on scene.
	 * @param	?alignment	Button alignment from 'root' position. For
	 *						example, the default TOP_LEFT alignment sets the
     *						origin ('root') of the graphic and hitbox to the
	 *						top left corner	of the button.
	 * @param	?size		Button label font size, defaults to 16.
	 * @param	?width		Button width, defaults to label text width.
	 * @param	?height		Button height, defaults to label text height.
	 */
	public function new (label : String = "Button", x : Float = 0, y : Float = 0, ?alignment : Alignment = TOP_LEFT, ?newSize : Int = 16, ?width : Int = 0, ?height : Int = 0) : Void {
		super(x, y, width, height);
		
		this.ID = label;
		this.alignment = alignment;
		
		_textOptions = {size : newSize};
		
		graphic = new Text(label, 0, 0, 0, 0, _textOptions);
		setHitboxTo(graphic);

		setRoot(alignment);
	}
	
	override public function added () : Void {
		super.added();
	}
	
	override public function update () : Void {
		super.update();
	}
	
	override public function removed () : Void {
		super.removed();
	}
	
	private var _textOptions : TextOptions;
}