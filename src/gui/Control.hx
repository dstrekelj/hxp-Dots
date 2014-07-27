package gui;

import gui.CEvent;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

/**
 * Parent class to all controls. Defines constructor, variables, methods and
 * events. Never create a Control object, instead create an object of the
 * appropriate subclass.
 */

@:enum abstract Alignment(String) {
	var TOP_LEFT = "top_left";
	var TOP = "top";
	var TOP_RIGHT = "top_right";
	var CENTER_LEFT = "center_left";
	var CENTER = "center";
	var CENTER_RIGHT = "center_right";
	var BOTTOM_LEFT = "bottom_left";
	var BOTTOM = "bottom";
	var BOTTOM_RIGHT = "bottom_right";
}

class Control extends Entity implements IEventDispatcher {
	public static inline var MOUSE_OVER	: String = "mouse_over";
	public static inline var MOUSE_DOWN	: String = "mouse_down";
	public static inline var MOUSE_UP	: String = "mouse_up";
	
	/** Control object ID, null if undefined. */	
	@:isVar public var ID (get, set) : String;
	private inline function get_ID () : String { return ID; }
	private inline function set_ID (value : String) : String { return ID = value; }	
	
	/** Control object alignment. */
	@:isVar public var alignment (get, set) : Alignment;
	private inline function get_alignment () : Alignment { return alignment; }
	private inline function set_alignment (value : Alignment) : Alignment {
		setRoot(value);
		return alignment = value;
	}
	
	/**
	 * Constructor used by Control subclasses. Creates new Control object at x,
	 * y position of passed width and height.
	 * @param	x		Control X position on scene.
	 * @param	y		Control Y position on scene.
	 * @param	width	Control width.
	 * @param	height	Control height.
	 */
	public function new (x : Float = 0, y : Float = 0, alignment : Alignment = TOP_LEFT, width : Int = 0, height : Int = 0) : Void {
		super(x, y);
		
		this.width = width;
		this.height = height;
		
		graphic = Image.createRect(10, 10, 0x0000ff, 0);
		
		this.type = "control";
		
		this.ID = null;
		setRoot(alignment);
		
		_eventDispatcher = new EventDispatcher();
	}
	
	override public function added () : Void {
		super.added();
		
		if (HXP.stage != null) {
			HXP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			HXP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
	
	override public function update () : Void {
		super.update();
		
		if (collidePoint(x, y, Input.mouseX + HXP.camera.x, Input.mouseY + HXP.camera.y)) {
			dispatchEvent(new CEvent(MOUSE_OVER, ID));
		}
	}
	
	override public function removed () : Void {
		super.removed();	
		
		if (HXP.stage != null) {
			HXP.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			HXP.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
	
	/**
	 * Sets origin ('root') point to root parameter, aligning the entire
	 * object in a defined way. For example, setRoot(Alignment.CENTER) sets the
	 * origin of the object and its hitbox to the object's center. In the
	 * the illustration, x marks the default object origin.
	 *
	 *		X░░░░										░░░░░
	 *		░░░░░	--->	Alignment.CENTER	--->	░░X░░
	 *		░░░░░										░░░░░
	 */
	public function setRoot (root : Alignment) : Void {
		switch (root) {
		case Alignment.TOP_LEFT:
			graphic.x = 0;
			graphic.y = 0;
			setHitbox(this.width, this.height, 0, 0);
		case Alignment.TOP:
			graphic.x = -this.width / 2;
			graphic.y = 0;
			setHitbox(this.width, this.height, Std.int(this.width / 2), 0);
		case Alignment.TOP_RIGHT:
			graphic.x = -this.width;
			graphic.y = 0;
			setHitbox(this.width, this.height, this.width, 0);
		case Alignment.CENTER_LEFT:
			graphic.x = 0;
			graphic.y = -this.height / 2;
			setHitbox(this.width, this.height, 0, Std.int(this.height / 2));
		case Alignment.CENTER:
			graphic.x = -this.width / 2;
			graphic.y = -this.height / 2;
			setHitbox(this.width, this.height, Std.int(this.width / 2), Std.int(this.height / 2));
		case Alignment.CENTER_RIGHT:
			graphic.x = -this.width;
			graphic.y = -this.height / 2;
			setHitbox(this.width, this.height, this.width, Std.int(this.height / 2));
		case Alignment.BOTTOM_LEFT:
			graphic.x = 0;
			graphic.y = -this.height;
			setHitbox(this.width, this.height, 0, this.height);
		case Alignment.BOTTOM:
			graphic.x = -this.width / 2;
			graphic.y = -this.height;
			setHitbox(this.width, this.height, Std.int(this.width / 2), this.height);
		case Alignment.BOTTOM_RIGHT:
			graphic.x = -this.width;
			graphic.y = -this.height;
			setHitbox(this.width, this.height,this.width, this.height);
		default :
			setHitboxTo(graphic);
		}
	}
	
	/**
	 *	The following methods handle dispatching of specific event types.
	 */
	
	private function onMouseDown (e : MouseEvent = null) : Void {
		if (collidePoint(x, y, Input.mouseX + HXP.camera.x, Input.mouseY + HXP.camera.y)) {
			dispatchEvent(new CEvent(MOUSE_DOWN, ID));
		}
	}
	
	private function onMouseUp (e : MouseEvent = null) : Void {
		if (collidePoint(x, y, Input.mouseX + HXP.camera.x, Input.mouseY + HXP.camera.y)) {
			dispatchEvent(new CEvent(MOUSE_UP, ID));
		}
	}
	
	/**
	 * The following methods are an implementation of IEventDispatcher.
	 */	
	
	public function addEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void {
		_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function dispatchEvent(event : flash.events.Event) : Bool {
		return _eventDispatcher.dispatchEvent(event);
	}
	
	public function hasEventListener(type : String) : Bool {
		return _eventDispatcher.hasEventListener(type);
	}
	
	public function removeEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false) : Void {
		_eventDispatcher.removeEventListener(type, listener, useCapture);
	}
	
	public function willTrigger(type : String) : Bool {
		return _eventDispatcher.willTrigger(type);
	}
	
	private var _eventDispatcher : EventDispatcher;
}