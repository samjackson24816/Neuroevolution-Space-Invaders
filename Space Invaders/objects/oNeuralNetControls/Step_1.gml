var _output = ne.getOutput( get_game_grid() );
if(_output != undefined) {
	global.leftKey = (_output.get(0, 0) > 0.5);
	global.rightKey = (_output.get(1, 0) > 0.5);
	global.shootKey = (_output.get(2, 0) > 0.5);
}



var _continueTest = global.playGame;
var _fitness = global.tick;
//if(global.playGame == false) {
//	fitnessSum += global.tick;
//	_fitness = fitnessSum/numGames;
//	counter++;
//	if(counter >= numGames) {
//		_continueTest = false;
//		counter = 0;
//		fitnessSum = 0;
//	}
//}


ne.step( _fitness, _continueTest);

if(global.tick > targetScore) {
	ne.stopCurrentIsBest();
}

	
global.playGame = true;	


//} else {
//	if (global.playGame = false) {
//	//check if the game should be started
//	global.playGame = keyboard_check( vk_space );
//	}
//}

