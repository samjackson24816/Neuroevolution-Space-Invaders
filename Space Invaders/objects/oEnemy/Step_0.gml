

//movement
if global.tick % spd == 0 {
	if tileY >= TILEHEIGHT - 1 {
		//show_debug_message("enemy distroyed");
		global.tick = max(global.tick - 40, 0);
		
		instance_destroy();
	} else {
		tileY += 1;
	}
	timer = 0;
}
//if global.tick % wiggleRate == 0 {
//	//move randomly to one side
//	tileX = clamp( tileX + choose(1, -1), 0, TILEWIDTH -1 );
//}

//move
x = get_real_x(tileX);
y = get_real_y(tileY);


if global.tick % shootRate == 0 {
	var _inst = instance_create_depth( x, y, 0, oEnemyBullet );
	_inst.tileX = tileX;
	_inst.tileY = tileY;
	_inst.spd = bulletSpd;
}


if place_meeting(x, y, oPlayer) {
	//game over
	global.playGame = false; 
}