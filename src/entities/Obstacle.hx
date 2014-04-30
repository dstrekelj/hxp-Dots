package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Obstacle extends Entity {
	private var acceleration : Float;
	private var velocity : Float;
	
	public function new ( x : Float, y : Float, acceleration : Float ) {
		super( x, y );
		
		graphic = Image.createCircle( 20, 0x44BBFF, 100 );
		setHitbox(30, 30, -5, -5);
		type = "obstacle";
		
		this.acceleration = acceleration;
		velocity = 7;
		layer = 1;
	}
	
	private function move () : Void {
		var speed : Float = 0;
		
		speed = -1 * (velocity + (velocity * acceleration));
		
		moveBy(speed, 0);
	}
	
	override public function update () {
		move();
		if ( !onCamera ) {
			destroy();
		}
		super.update();
	}
	
	public function destroy () : Void {
		scene.remove( this );
	}
}