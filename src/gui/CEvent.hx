package gui;

import flash.events.Event;

class CEvent extends Event {
	/** ID of Control object dispatching Event, null if undefined. */
	public var senderID : String;
		
	/**
	 * Custom Event constructor. Creates new Event of passed type,
	 * attributes it to dispatcher of passed controlID.
	 * @param	type		Event type.
	 * @param	?senderID	ID of Control object dispatching Event.
	 * @param	bubbles
	 * @param	cancelable
	 */
	public function new (type : String, ?senderID : String = null, bubbles : Bool = false, cancelable : Bool = false) : Void {
		this.senderID = senderID;
		super(type, bubbles, cancelable);
	}
}