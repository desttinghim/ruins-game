
// Imports go here \/
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite; // Double check this
import luxe.Text;

import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;
import luxe.collision.shapes.Polygon;
import luxe.collision.CollisionData;
import luxe.collision.Collision;

import luxe.collision.ShapeDrawerLuxe;
// Imports go here ^

class Main extends luxe.Game { // Extend luxe.game at some point

	var drawer : ShapeDrawerLuxe;
	var normal_color : Int = 0x999999;
	var collide_color : Int = 0xCC1111;

	var ground:Polygon;
	var wall1:Polygon;
	var wall2:Polygon;
	var player:Polygon;
	var trigger:Polygon;
	var crate:Polygon;
	var door:Polygon;
	var platform:Polygon;
	var platform2:Polygon;

	var textmade:Bool = false;
	var triggered:Bool = false;
	var onground:Bool = false;
	var crate_onground:Bool = false;
	var gravity = 50; // Per second
	var maxspeed = 200; // Per second
	var maxyspeed = 500;
	var jumpspeed = 1000;
	var xspeed = 0;
	var yspeed = 0;
	var crate_xspeed = 0;
	var crate_yspeed = 0;

	//var collision_group<Collide>; 	// Make an array to store all of the Collide components
	//var sprite_group<Sprite>		// Make an array to store all of the Sprites

	// Somewhere in here, make a loop to check collisions and dispatch events to deal with them
	// Make a movement component that either listens for events for the Collide comp or messages for itself from the Collide comp

	override function ready() {
		// Game starts here
		drawer = new ShapeDrawerLuxe();
	
		ground = Polygon.rectangle( Luxe.screen.w / 2, Luxe.screen.h - 16, Luxe.screen.w, 32);
		wall1 = Polygon.rectangle( 16, Luxe.screen.h / 2, 32, Luxe.screen.h);
		wall2 = Polygon.rectangle( Luxe.screen.w - 16, Luxe.screen.h / 2, 32, Luxe.screen.h);
		player = Polygon.rectangle( Luxe.screen.w / 2, Luxe.screen.h / 2, 32, 32);
		trigger = Polygon.rectangle( (Luxe.screen.w / 3) * 2, Luxe.screen.h - 32, 32, 16 );
		door = Polygon.rectangle( (Luxe.screen.w / 2), Luxe.screen.h - 64, 32, 64 );
		platform = Polygon.rectangle( (Luxe.screen.w / 3), Luxe.screen.h - 80, 96, 32 );
		platform2 = Polygon.rectangle( (Luxe.screen.w / 3) - 96, Luxe.screen.h - 48, 32, 32 );
		crate = Polygon.rectangle( (Luxe.screen.w / 3), Luxe.screen.h - 112, 32, 32 );
	}

	override function onkeyup( e:KeyEvent ) {

		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}

	}

	override function update( dt:Float ) {
		// Game loop

		ground_player( ground );
		ground_player( platform );
		ground_player( platform2 );

		ground_crate( ground );
		ground_crate( platform );
		ground_crate( platform2 );

		separate_crate( wall1 );
		separate_crate( wall2 );

		separate_player( wall1 );
		separate_player( wall2 );

		var crate_data = Collision.test( crate, player );
		if(crate_data != null)
		{
			if(player.y < crate.y - 16)
			{
				player.y -= crate_data.separation.y;// crate.y - 32;
				yspeed = 0;
				onground = true;
			}
			else
			{
				crate.x += crate_data.separation.x;
				separate_player( crate );
			}
		}

		var trigger_data = Collision.test( player, trigger );
		if(trigger_data != null)
		{
			triggered = true;
		}
		else
		{
			triggered = false;
		}
		trigger_data = Collision.test( crate, trigger );
		if(trigger_data != null)
		{
			triggered = true;
		}

		if(triggered)
		{
			var door_data = Collision.test(  player, door );
			if( door_data != null )
			{
				if( Luxe.input.keypressed(Key.space) )
				{
					if(!textmade)
					{
						Luxe.draw.text(
						{
							text: "You win!", 
							pos: Luxe.screen.mid,
							align: TextAlign.center,
						});
						textmade = true;
					}
				}
			}
		}


		if(Luxe.input.keydown(Key.key_a)) 
		{
			xspeed = -maxspeed;
		} 
		else if(Luxe.input.keydown(Key.key_d)) 
		{
			xspeed = maxspeed;
		}
		else
		{
			xspeed = 0;
		}

		if(onground) {
			if(Luxe.input.keydown(Key.key_w)) {
				yspeed = -jumpspeed;
				onground = false;
			}
		}

		player.x += xspeed * dt;
		player.y += yspeed * dt;

		crate.x += crate_xspeed * dt;
		crate.y += crate_yspeed * dt;

		drawer.drawPolygon(player, new Color().rgb(normal_color), true );
		drawer.drawPolygon(wall1, new Color().rgb(normal_color), true );
		drawer.drawPolygon(wall2, new Color().rgb(normal_color), true );
		drawer.drawPolygon(ground, new Color().rgb(normal_color), true);
		drawer.drawPolygon(crate, new Color().rgb(normal_color), true);
		drawer.drawPolygon(platform, new Color().rgb(normal_color), true);
		drawer.drawPolygon(platform2, new Color().rgb(normal_color), true);
		if(triggered)
		{
			drawer.drawPolygon(trigger, new Color().rgb(collide_color), true);
			drawer.drawPolygon(door, new Color().rgb(normal_color), true);
		}
		else 
		{
			drawer.drawPolygon(trigger, new Color().rgb(normal_color), true);
		}
	}

	function separate_player( shape:Shape )
	{
		var collision_data = Collision.test( player, shape );
		if(collision_data != null) 
		{
			if(player.y > shape.y + 16)
			{
				player.y = shape.y + 32;
				yspeed = 0;
			}
			player.position.add(collision_data.separation);
		}
		return collision_data;
	}

	function separate_crate( shape:Shape )
	{
		var collision_data = Collision.test( crate, shape );
		if(collision_data != null) 
		{
			crate.position.add(collision_data.separation);
		}
		return collision_data;
	}

	function ground_player( shape:Shape )
	{
		var collision_data = separate_player( shape );
		if(collision_data != null) 
		{
			if(collision_data.separation.y != 0) {
				yspeed = 0;
				if(collision_data.separation.y < 0)
				{
					onground = true;
				}
			}
		} 
		else 
		{
			if(yspeed > gravity) 
			{
				onground = false;
			}
			if(yspeed <= maxyspeed)
			{
				yspeed += gravity;
			}
			else
			{
				yspeed = maxyspeed;
			}
		}
	}

	function ground_crate( shape:Shape )
	{
		var collision_data = separate_crate(shape);
		if(collision_data != null) 
		{
			if(collision_data.separation.y != 0) {
				crate_yspeed = 0;
				if(collision_data.separation.y < 0)
				{
					crate_onground = true;
				}
			}
		} 
		else 
		{
			if(crate_yspeed > gravity) 
			{
				crate_onground = false;
			}
			if(crate_yspeed <= maxyspeed)
			{
				crate_yspeed += gravity;
			}
			else
			{
				crate_yspeed = maxyspeed;
			}
		}
	}


}
