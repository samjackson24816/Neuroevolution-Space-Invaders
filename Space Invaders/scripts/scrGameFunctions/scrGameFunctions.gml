

/// @function                get_real_x( _tileX )
/// @description             returns the x room coordinate that corrisponds to the inputted game tile coordinate
/// @param {int}			 _tileX the x coordinate
/// @returns {int}			 the room coordinate
function get_real_x( _tileX ) {
	if _tileX >= 0 && _tileX < TILEWIDTH {
		return XMIN + _tileX*TILESIZE;
	} else {
		return undefined;
	}
	
}

/// @function                get_real_y( _tileY )
/// @description             returns the y room coordinate that corrisponds to the inputted game tile coordinate
/// @param {int}			 _tileY the y coordinate
/// @returns {int}			 the room coordinate
function get_real_y( _tileY ) {
	if _tileY >= 0 && _tileY < TILEHEIGHT {
		return YMIN + _tileY*TILESIZE;
	} else {
		return undefined;
	}
	
}

/// @function                get_array_index( _x, _y )
/// @description             returns the index of the 1d array given by the coordinates
/// @param {int}			 _x	the x coordinate
/// @param {int}			 _y the y coordinate
/// @returns {int}			 the index
function get_array_index( _x, _y ) {
	return _y * TILEWIDTH + _x;
}


/// @function                get_game_grid()
/// @description             returns a grid containing all the information of the game's current state, with binary encoded values for each type of entity
/// @returns {array}		 the compressed 1d grid array containing all the game's information	 
function get_game_grid() {
	
	//make a 2d array for the grid
	var _binaryEncodeLength = 4; //this corrisponds to the number of unique objects that need to be saved
	
	var _grid = array_create(TILEHEIGHT*TILEWIDTH*4, 0);

	//binary encode each value so the neural network can read them clearer: player is 1000, player bullet is 0100, enemy is 0010, enemyBullet is 0001
	
	with(oPlayer) {
		_grid[get_array_index(tileX, tileY)*_binaryEncodeLength] = 1;
	}
	with(oPlayerBullet) {
		_grid[get_array_index(tileX, tileY)*_binaryEncodeLength + 1] = 1;
	}
	with(oEnemy) {
		_grid[get_array_index(tileX, tileY)*_binaryEncodeLength + 2] = 1;
	}
	with(oEnemyBullet) {
		_grid[get_array_index(tileX, tileY)*_binaryEncodeLength + 3] = 1;
	}
	
	return _grid;
}
		
		
/// @function                draw_game_grid(_grid)
/// @description             draws a saved game grid to the screen (used for debugging)
/// @param {array}			 _grid    the game grid, binary encoded and compressed into a 1d array
function draw_game_grid(_grid) {
	for( var i = 0; i < array_length(_grid); i += 4 ) {
		//get binary
		var _binaryValue = array_create(4, 0);
		for( var j = 0; j < 4; j++ ) {
			_binaryValue[j] = _grid[i+j];
		}
		//create instances
		if _binaryValue[0] = 1 {
			draw_sprite(sPlayer, 0, get_real_x((i/4) % TILEWIDTH), get_real_y(floor((i/4)/TILEWIDTH)) );
		}
		if _binaryValue[1] = 1 {
			draw_sprite(sPlayerBullet, 0,  get_real_x((i/4) % TILEWIDTH), get_real_y(floor((i/4)/TILEWIDTH)) );
		}
		if _binaryValue[2] = 1 {
			draw_sprite(sEnemy, 0,  get_real_x((i/4) % TILEWIDTH), get_real_y(floor((i/4)/TILEWIDTH)) );
		}
		if _binaryValue[3] = 1 {
			draw_sprite(sEnemyBullet, 0,  get_real_x((i/4) % TILEWIDTH), get_real_y(floor((i/4)/TILEWIDTH)) );
		}
		show_debug_message(_binaryValue);
	}
}
		
	
		