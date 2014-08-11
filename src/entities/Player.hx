package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{	
	/** X position. */
	private var _setX : Float = 100;
	/** Y position. */
	private var _setY : Float = HXP.halfHeight;
	/** Maximum velocity of player entity (in free fall). */
	private var _gravity : Float = 12;
	/** Takeoff velocity of player entity (from jumping). */
	private var _takeoff : Float = 8;
	/** Velocity of player entity. */
	private var _velocity : Float = 0;
	/** Jump sound effect. */
	private var sfxJump : Sfx = new Sfx("audio/jump.wav");
	/** Collision ('death') sound effect. */
	private var sfxDeath : Sfx = new Sfx("audio/death.wav");
	/** Is the player ready to play? */
	public var isReady (default, null) : Bool;
	/** Is the player alive? */
	public var isAlive (default, null) : Bool;
	
	/** Constructor. Creates Player entity with circle graphic, rendered at layer 1. */
	public function new () : Void
	{
		super();
		
		graphic = Image.createCircle(20, 0xE0E0D0, 100);
		graphic.x = -20;
		graphic.y = -20;
		setHitbox(30, 30, 15, 15);
		type = "player";
		
		layer = 1;
	}
	
	/**
	 * Called when Player entity is added to scene. Defines input keys for jumping.
	 * Calls init() to initialize parameters.
	 */
	override public function added () : Void
	{
		super.added();
		
		Input.define("player_jump", [Key.UP, Key.W, Key.SPACE]);
		
		init();
	}
	
	/**
	 * If player is ready to play and alive, move player entity. If colliding
	 * with Obstacle entity, call destroy(). If outside of screen, call destroy().
	 * Handle movement and play sound effect accordingly.
	 */
	override public function update () : Void
	{
		super.update();
		
		if (isReady && isAlive)
		{
			collidable = true;
			
			(_velocity < _gravity) ? _velocity += 0.5 : _velocity = _gravity;
			moveBy(0, _velocity);
			
			if (!onCamera)
			{
				destroy();
			}
			
			var e : Entity = collide("obstacle", x+32, bottom);
			if (e != null)
			{
				var o : Obstacle = cast(e, Obstacle);
				destroy();
			}
		}
		else
		{
			collidable = false;
		}
		
		if (Input.pressed("player_jump") || Input.mousePressed)
		{
			_velocity = -_takeoff;
			if (isAlive)
			{
				sfxJump.play( 0.8, 0, false );
			}
			if (!isReady)
			{
				isReady = true;
			}
		}
	}
	
	/** Called when Player entity is destroyed. Sets parameters, plays death sound. */
	public function destroy () : Void
	{		
		visible = false;
		isAlive = false;
		isReady = false;		
		
		sfxDeath.play(0.6, 0, false);
	}
	
	/** Initializes Player entity parameters. */
	public function init () : Void
	{
		x = _setX;
		y = _setY;
		
		isReady = false;
		isAlive = true;
		
		visible = true;
	}
}