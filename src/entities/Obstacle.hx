package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Obstacle extends Entity {
	private var velocity : Float;
	private var velocityFactor : Float;
	
	public function new ( x : Float, y : Float, velocityFactor : Float ) {
		super( x, y );
		
		graphic = Image.createCircle( 20, 0x44BBFF, 100 );
		setHitbox(30, 30, -5, -5);
		type = "obstacle";
		
		this.velocityFactor = velocityFactor;
		velocity = 7;
		layer = 1;
	}
	
	private function move () : Void {
		var speed : Float = 0;
		
		speed = -1 * (velocity + (velocity * velocityFactor));
		
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
		graphic.destroy();
		scene.remove( this );
	}
}