package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Obstacle extends Entity
{
	/*	velocity sets the speed at which the obstacle moves.
	 *	velocityFactor is a random factor by which the velocity is
	 *	multiplied in order to achieve varying speed per obstacle.
	 */
	private var velocity : Float;
	private var velocityFactor : Float;
	
	/*	The constructor for the Obstacle class, extending Entity.
	 *	@param	x				Horizontal position of obstacle on screen
	 *	@param	y				Vertical position of obstacle on screen
	 *	@param	velocityFactor	The factor the object's velocity is multiplied by
	 *
	 *	The obstacle's graphic is a circle with a 20 px radius.
	 *	The obstacle's hitbox is a 30 x 30 px square, with its origin at -5, -5.
	 *	The hitbox type is set to "obstacle".
	 *	The obstacle is rendered on layer 1.
	 */
	public function new ( x : Float, y : Float, velocityFactor : Float )
	{
		super( x, y );
		
		graphic = Image.createCircle( 20, 0x44BBFF, 100 );
		setHitbox( 30, 30, -5, -5 );
		type = "obstacle";
		
		this.velocityFactor = velocityFactor;
		velocity = 7;
		layer = 1;
	}
	
	/*	This function moves the obstacle according to the velocity
	 *	and velocityFactor variables.
	 */
	private function move () : Void
	{
		var speed : Float = 0;
		speed = -1 * ( velocity + ( velocity * velocityFactor ) );
		moveBy( speed, 0 );
	}
	
	/*	Updates the obstacle when on Scene. Makes sure to destroy
	 *	instances of the Obstacle class when they move off screen
	 *	to free used up memory space by calling destroy().
	 */
	override public function update () : Void
	{
		move();
		if ( !onCamera ) {
			destroy();
		}
		super.update();
	}
	
	/*	Destroys the object of the Obstacle class, including its graphic
	 *	and removes it from the Scene it is in.
	 */
	public function destroy () : Void
	{
		graphic.destroy();
		scene.remove( this );
	}
}