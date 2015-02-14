
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
	var max_speed : Vector;
	var movement_vector : Vector;
	var gravity_vector : Vector;
	var friction_vector : Vector;
	var gravity : Bool = false;
	var kinetic : Bool = false;
	var collides : Bool = false;

	public function new( kinetic:Bool, collides:Bool, ?newShape:Shape, ?gravity:Vector)
	{
		super({ name: 'physics' });

		max_speed = new Vector( 500, 1000 );
		movement_vector = new Vector( 0, 0 );
		friction_vector = new Vector( .1, 1 );

		if(gravity != null)
		{
			gravity_vector = gravity;
		}
		else
		{
			gravity_vector = new Vector( 0, 0 );
		}
		if(newShape != null)
		{
			shape = newShape;
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
			movement_vector.multiply( friction_vector );
			if(shape != null)
			{
				shape.x = pos.x;
				shape.y = pos.y;
			}
		}
	}

	public function on_collision( data:CollisionData )
	{
		if(kinetic && movement_vector.y > 0)
		{
			pos.add( data.separation );
			movement_vector.y = 0;
		}
	}

	public function set_shape( shape:Shape )
	{
		this.shape = shape;
	}

	public function set_gravity_vector( g:Vector )
	{
		gravity_vector = g;
	}

	public function set_friction_vector( f:Vector )
	{
		friction_vector = f;
	}

	public function set_gravity( g:Bool )
	{
		gravity = g;
	}

	public function move( x:Float, y:Float )
	{
		if(Math.abs(x) <= 1) 
		{
			movement_vector.x = max_speed.x * x; 
		}
		if(Math.abs(y) <= 1)
		{
			movement_vector.y = max_speed.y * y;
		}
	}

}