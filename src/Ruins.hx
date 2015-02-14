
/*
*	Actual game file - this will be used to build base systems
*	once the minimum viable prototype is complete. 
*/
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.collision.CollisionData;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;
import luxe.collision.shapes.Polygon;

class Ruins extends luxe.Game
{
	var collideables:Array<Sprite>; // Collection of sprites with physics
	
	override function ready()
	{
		// TODO(louis): Set up collision system
		collideables = new Array<Sprite>();

		var playerSprite = new Sprite({
			name: 'player',
			pos: Luxe.screen.mid,
			size: new Vector( 32, 32 ),
			color: new Color().rgb(0xccddff)
			});
		var playerCol = new Physics( true, true, new Vector( 0, 50 ) );
			playerCol.set_shape(Polygon.rectangle( 0, 0, 32, 32 ));
		
		playerSprite.add(playerCol);
		playerSprite.add(new PlayerInput());

		collideables.push( playerSprite );

		var groundSprite = new Sprite({
			name: 'ground',
			size: new Vector( Luxe.screen.w, 32 ),
			pos: new Vector( Luxe.screen.w / 2, Luxe.screen.h - 16 ),
			color: new Color().rgb(0xffddee)
			});

		groundSprite.add(new Physics(false, true, 
			Polygon.rectangle( groundSprite.pos.x, groundSprite.pos.y, 
				groundSprite.size.x, groundSprite.size.y ) ));

		collideables.push( groundSprite );
	}	

	override function update( dt:Float )
	{
		for(isprite in collideables)
		{
			var iphysic = isprite.get('physics').shape;
			for(asprite in collideables)
			{
				var aphysic = asprite.get('physics').shape;
				var collisionTest = Collision.test( iphysic, aphysic ); 
				if(collisionTest != null)
				{
					isprite.events.fire('collision', collisionTest);
				}
			}
		}
	}

	override function onkeyup( e:KeyEvent )
	{

		if(e.keycode == Key.escape)
		{
			Luxe.shutdown();
		}
	}

}