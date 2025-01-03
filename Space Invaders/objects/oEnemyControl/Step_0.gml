
if global.tick % spawnRate == 1 {
	//spawn a new enemy
	
	var _y = get_real_y(0);
	
	////make sure the object isn't being spawned over an existing one
	
	//var _possibleX = array_create(TILEWIDTH, 0);
	//for( var i = 0; i < TILEWIDTH; i++ ) {
	//	_possibleX[i] = i;
	//}
	//array_shuffle_ext(_possibleX);
	
	
	
	//var _bestVal = 100; //set to a overly large value to garentee it will be larger than the number of enemies in the column
	//var _bestIndex = 0;
	//var _dsList = ds_list_create();
	//for (var i = 0; i < TILEWIDTH; i++) {
	//	collision_line_list( get_real_x(_possibleX[i]), _y, get_real_x(_possibleX[i]), _y + vertSpacing * TILESIZE, oEnemy, false, false, _dsList, true);
	//	if  ds_list_size(_dsList) < _bestVal {
	//		_bestVal = ds_list_size(_dsList);
	//		_bestIndex = i;

	//	}
	//	ds_list_clear(_dsList);
	//}
	//ds_list_destroy(_dsList);
	
	//var _x = get_real_x(_possibleX[_bestIndex]);
	
	//var _tileX = clamp(oPlayer.tileX + (spawnSide*2), 0, TILEWIDTH-1);
	//if( spawnSide < 1) {
	//	spawnSide++;
	//} else {
	//	spawnSide = -1;
	//}
	var _tileX = irandom_range(0, TILEWIDTH-1);
	var _x = get_real_x(_tileX);

	
	var _inst = instance_create_depth( _x, _y, 0, oEnemy );
	_inst.tileX = _tileX;
	_inst.tileY = 0;
	_inst.spd = spd;
	_inst.shootRate = shootRate;
	_inst.bulletSpd = bulletSpd;
	_inst.wiggleRate = wiggleRate;
}

