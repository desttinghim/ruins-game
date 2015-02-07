
/*
*	Actual game file - this will be used to build base systems
*	once the minimum viable prototype is complete. 
*/
import luxe.Input;

class Ruins extends luxe.Game
{
	
	override function init()
	{

	}	

	override function update( dt:Float )
	{

	}

	override function onkeyup( e:KeyEvent )
	{

		if(e.keycode == Key.escape)
		{
			Luxe.shutdown();
		}
	}

}