package gui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class MousePointer extends Entity {
	private var image : Image;
	
	public function new ( x : Int, y : Int ) : Void {
		super(x, y);
		
		image = Image.createCircle(5, 0xffffff);
		image.centerOrigin();
		graphic = image;
		
		setHitbox(10, 10, 0, 0);
		centerOrigin();
		type = "pointer";
	}
	
	override public function update () : Void {
		moveTo(Input.mouseX, Input.mouseY);
		
		super.update();
	}
	
	public function handle ( option : Option ) : Bool {
		var e : Entity = collideWith(option, x, y);
		
		if (e != null && Input.mousePressed) {
			return true;
		} else {
			return false;
		}
	}
}
