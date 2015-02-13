
/*
* I'll probably use this add physics to objects in the game
* But not right now
*/

import luxe.Component;
import luxe.Vector;
import luxe.Sprite;

import luxe.collision.Collision;
import luxe.collision.CollisionData;
import luxe.collision.shapes.Polygon;
import luxe.collision.shapes.Circle;
import luxe.collision.shapes.Shape;

class Physics extends Component
{
	var shape : Shape;
	var movement_vector : Vector;
	var gravity_vector : Vector;
	var gravity : Bool = false;
	var kinetic : Bool = false;
	var collides : Bool = false;

	public function new( kinetic:Bool, collides:Bool, ?gravity:Vector)
	{
		// I don't know if I'll use this
		super({ name: 'physics' });
		movement_vector = new Vector( 0, 0 );

		if(gravity != null)
		{
			gravity_vector = gravity;
		}
		else
		{
			gravity_vector = new Vector( 0, 0 );
		}

		this.kinetic = kinetic;
		this.collides = collides;

	}

	override function init()
	{
		entity.events.listen('collision', on_collision);
	}

	override function update( dt:Float )
	{
		if(kinetic)
		{
			pos.add( Vector.Multiply( movement_vector, dt )  );
			movement_vector.add( gravity_vector );
			if(shape != null)
			{
				shape.x = pos.x;
				shape.y = pos.y;
			}
		}
	}

	public function on_collision( data:CollisionData )
	{
		trace("Collision!");
		pos.add( data.separation );
		movement_vector.multiplyScalar(0);
	}

	public function set_shape( shape:Shape )
	{
		this.shape = shape;
	}

	public function set_gravity_vector( g:Vector )
	{
		gravity_vector = g;
	}

	public function set_gravity( g:Bool )
	{
		gravity = g;
	}

}