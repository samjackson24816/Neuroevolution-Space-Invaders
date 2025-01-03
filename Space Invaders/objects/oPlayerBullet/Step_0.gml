
if global.tick % spd == 0 {
	if tileY <= 0 {
		//show_debug_message("bullet distroyed");
		instance_destroy();
	} else {
		tileY -= 1;
	}
	
	//move
	x = get_real_x(tileX);
	y = get_real_y(tileY);
	
	var _inst = instance_place( x, y, oEnemy )
	if _inst != noone {
		//kill the enemy
		with _inst {
			instance_destroy();
		}
	}
	timer = 0;
}
