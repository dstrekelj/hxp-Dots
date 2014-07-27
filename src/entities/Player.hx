package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{
	/*	This set of variables describes player movement.
	 */
	private var acceleration : Float;
	private var gravity : Float;
	private var velocity : Float;
	
	/*	This set of variables handles sound effects.
	 */
	private var sfxJump : Sfx = new Sfx("audio/jump.wav");
	private var sfxDeath : Sfx = new Sfx("audio/death.wav");	
	private var gfxCircle : Graphic = Image.createCircle(20, 0xE0E0D0, 100); 
	
	/*	This set of variables describes player states.
	 */
	public var isDestroyed : Bool;
	public var isReady : Bool;
	
	/*	Constructor for the Entity class extended by the Player class
	 *	@param	x		X position of Player on scene
	 *	@param	y		Y position of Player on scene
	 *
	 *	Initializes player movement variables as well as
	 *	sound effects variables.
	 *
	 *	The player's graphical representation is a circle with a 20 px
	 *	radius. There's a -20, -20 offset to center the graphic to the
	 *	center of the object's Entity.
	 *	The player's hitbox is set to a 30 x 30 px square, with it's
	 *	origin at 15, 15 (because of the -20, -20 offset). The hitbox
	 *	type is set to "player".
	 *	
	 *	The input corresponding to "jump" is tied to certain keyboard
	 *	keys.
	 *
	 *	The Player entity is set to be rendered on layer 1.
	 */
	public function new ( x : Float, y : Float ) : Void
	{
		super( x, y );
		
		acceleration = 0;
		gravity = 12;
		velocity = 0;
		/*
		sfxJump = new Sfx( "audio/jump.wav" );
		sfxDeath = new Sfx( "audio/death.wav" );
		*/
		isDestroyed = false;
		isReady = false;
		
		graphic = gfxCircle;
		graphic.x = -20;
		graphic.y = -20;
		setHitbox( 30, 30, 15, 15 );
		type = "player";
		
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE] );
		
		layer = 1;
	}
	
	/*	Handles user input
	 */
	private function handleInput () : Void
	{
		if ( Input.pressed( "jump" ) || Input.mousePressed )
		{
			acceleration = -8;
			sfxJump.play( 0.8, 0, false );
			isReady = true;
		}
	}
	
	/*	Moves the Player entity depending on movement variables/properties
	 */
	private function move () : Void
	{
		if ( acceleration < gravity )
		{
			acceleration += 0.5;
		}
		else if ( acceleration >= gravity )
		{
			acceleration = gravity;
		}
		
		velocity = acceleration;
		
		moveBy( 0, velocity );
	}
	
	/*	Function defined in the Engine class, used to update the game
	 *
	 *	Calls handleInput() to decide what to do based on the player's
	 *	input. Makes the necessary checks for the game to proceed
	 *	as designed.
	 */
	override public function update () : Void
	{
		handleInput();
		
		if ( isReady )
		{
			move();
		}
		
		if ( !onCamera )
		{
			destroy();
		}
		
		var e : Entity = collide( "obstacle", x, y );
		if ( e != null )
		{
			var o : Obstacle = cast( e, Obstacle );
			this.destroy();
		}
		
		super.update();
	}
	
	/*	Destroys the Player entity and updates its state variable
	 */
	public function destroy () : Void
	{
		sfxDeath.play( 0.6, 0, false );
		scene.remove( this );
		isDestroyed = true;
	}
}