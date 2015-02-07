
/*
* I'll probably use this add physics to objects in the game
* But not right now
*/

import luxe.Component;
import luxe.Vector;

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

	public function new( gravity : Bool, kinetic : Bool, collides : false)
	{
		// I don't know if I'll use this
		this.gravity = gravity;
		this.kinetic = kinetic;
		this.collides = collides;
	}

	override function init()
	{

	}

	override function update()
	{

	}

	public function setShape( shape : Shape )
	{
		this.shape = shape;
	}

	public function setGravityVector( g : Vector )
	{
		gravity_vector = g;
	}

	public function setGravity( g : Bool )
	{
		gravity = g;
	}

}