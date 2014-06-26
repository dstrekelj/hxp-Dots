package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class MousePointer extends Entity
{
	public function new ( x : Float, y : Float ) : Void
	{
		super( x, y );
			
		setHitbox( 10, 10, 0, 0 );
		centerOrigin();
		type = "pointer";
	}
	
	override public function update () : Void
	{
#if mobile
		if ( Input.mousePressed )
		{
			moveTo( Input.mouseX, Input.mouseY );
		}
		else
		{
			moveTo( -1, -1 );
		}
#else
		moveTo( Input.mouseX, Input.mouseY );
#end
		
		super.update();
	}
	
	public function handle ( option : Option ) : Bool
	{
		var e : Entity = collideWith( option, x, y );
#if mobile
		if (e != null)
		{
			return true;
		}
#else
		if (e != null && Input.mousePressed)
		{
			return true;
		}
#end
		else
		{
			return false;
		}
	}
}
