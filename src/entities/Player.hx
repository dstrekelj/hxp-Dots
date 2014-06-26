package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity {
	// These affect movement
	private var acceleration : Float;
	private var gravity : Float;
	private var velocity : Float;
	// This handles the "jump" sound effect
	private var sfxJump : Sfx;
	private var sfxDeath : Sfx;
	// These describe the state of the Player entity
	public var isDestroyed : Bool;
	public var isReady : Bool;
	
	/**
	 *	Constructor for the Entity class extended by the Player class
	 *	@param	x		X position of Player on scene
	 *	@param	y		Y position of Player on scene
	 */
	public function new ( x : Float, y : Float ) : Void {
		super( x, y );
		// Movement properties
		acceleration = 0;
		gravity = 12;
		velocity = 0;
		// Set up Player entity graphic, hitbox, collision type
		graphic = Image.createCircle(20, 0xE0E0D0, 100);
		graphic.x = -20;
		graphic.y = -20;
		setHitbox(30, 30, 15, 15);
		type = "player";
		// Set up sound effects
		sfxJump = new Sfx( "audio/jump.wav" );
		//sfxDeath = new Sfx( "audio/death.wav" );
		// Define input
		Input.define( "jump", [Key.UP, Key.W, Key.SPACE] );
		// State of Player entity when created
		isDestroyed = false;
		isReady = false;
		// Render Player entity on layer 1
		layer = 1;
	}
	
	/**
	 *	Handles user input and acts accordingly
	 */
	private function handleInput () : Void {
		if ( Input.pressed( "jump" ) || Input.mousePressed ) {
			acceleration = -8;
			sfxJump.play( 0.8, 0, false );
			isReady = true;
		}
	}
	
	/**
	 *	Moves the Player entity depending on movement variables/properties
	 */
	private function move () : Void {
		if ( acceleration < gravity ) {
			acceleration += 0.5;
		} else if ( acceleration >= gravity ) {
			acceleration = gravity;
		}
		
		velocity = acceleration;
		
		moveBy(0, velocity);
	}
	
	/**
	 *	Function defined in the Engine class, used to update the game
	 */
	override public function update () : Void {
		handleInput();
		
		if (isReady) {
			move();
		}
		
		if ( !onCamera ) {
			destroy();
		}
		
		var e : Entity = collide( "obstacle", x, y );
		if ( e != null ) {
			var o : Obstacle = cast( e, Obstacle );
			this.destroy();
		}
		
		super.update();
	}
	
	/**
	 *	Destroys the Player entity and updates the state variable
	 */
	public function destroy () : Void {
		//sfxDeath.play( 0.8, 0, false );
		scene.remove(this);
		isDestroyed = true;
	}
}