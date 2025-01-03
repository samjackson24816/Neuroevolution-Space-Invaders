
if global.playGame == false {
	instance_destroy(oGameObjParent);
	pastTick = false;
} else {
	if pastTick == false {
		//the first frame of the game
				
		//create all the instances to run the game
		instance_create_depth( 0, 0, 0, oPlayer );
		instance_create_depth( 0, 0, 0, oEnemyControl );
		pastTick = true;
		global.tick = 0;
	}
	
	
	//run the game tick
	global.tick++;
}
