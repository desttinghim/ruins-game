
/*
*	Actual game file - this will be used to build base systems
*	once the minimum viable prototype is complete.
*/
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.collision.data.ShapeCollision;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;
import luxe.collision.shapes.Polygon;

class Ruins extends luxe.Game {

	var player : Sprite;
	var playerCol : PhysicsComponent;

	var ground : Sprite;
	var groundCol : PhysicsComponent;

	override function ready() {

		Reg.physicsGroup = new Array<Shape>();

		player = new Sprite({
			name: 'player',
			pos: Luxe.screen.mid,
			color: new Color().rgb(0xf94b04),
			size: new Vector(128, 128)
		});

		playerCol = new PhysicsComponent(
			true,
			true,
			Polygon.rectangle(player.pos.x, player.pos.y, player.size.x, player.size.y, true),
			new Vector(0, 200)
		);
		player.add(playerCol);
		Reg.physicsGroup.push(playerCol.shape);

		ground = new Sprite({
			name: 'ground',
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.h),
			color: new Color().rgb(0xf94b04),
			size: new Vector(Luxe.screen.w, 128)
		});

		groundCol = new PhysicsComponent(
			false,
			true,
			Polygon.rectangle(ground.pos.x, ground.pos.y, ground.size.x, ground.size.y, true)
		);
		ground.add(groundCol);
		Reg.physicsGroup.push(groundCol.shape);

	} //ready

	override function update( dt:Float ) {

		// var shapeCollision = Collision.shapeWithShape(playerCol.shape, groundCol.shape);
		// if(shapeCollision != null) {
		// 	playerCol.on_collision(shapeCollision);
		// }

	} //update

	override function onkeyup( e:KeyEvent ) {

		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}
	} //onkeyup

}
