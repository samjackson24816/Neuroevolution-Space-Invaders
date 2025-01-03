

if global.tick % spd == 0 {
	if tileY >= TILEHEIGHT - 1 {
		//show_debug_message("enemy bullet distroyed");
		instance_destroy();
	} else {
		tileY += 1;
	}
	timer = 0;
}

	
//move
x = get_real_x(tileX);
y = get_real_y(tileY);



	
	
if place_meeting(x, y, oPlayer ) {
	global.playGame = false; 
}


