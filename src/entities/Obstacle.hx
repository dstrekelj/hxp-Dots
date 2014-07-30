package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Obstacle extends Entity
{
	/** Entity velocity. */
	private static inline var velocity : Float = 7.0;
	/** Random factor used to achieve variations in velocity between existing entities. */
	private var vFactor : Float;
	
	public static var isOnCamera (default, null) : Bool;
	
	/** Constructor. Creates Obstacle object with circle graphic, rendered at layer 1. */
	public function new () : Void
	{
		super();
		
		graphic = Image.createCircle(20, 0x44BBFF, 100);
		setHitbox(30, 30, -5, -5);
		type = "obstacle";
		
		layer = 1;
	}
	
	/** Initialises entities position on screen and velocity factor. */
	public function init () : Void
	{
		this.x = HXP.width;
		this.y = (HXP.height - 40) * HXP.random;
		this.vFactor = HXP.random;
	}
	
	/** Move entity every frame. If entity is off camera, recycle it. */
	override public function update () : Void
	{
		super.update();
		
		moveBy(-(velocity + (velocity * vFactor)), 0);
		
		if (!onCamera)
		{
			isOnCamera = false;
			scene.recycle(this);
		}
		else
		{
			isOnCamera = true;
		}
	}
}