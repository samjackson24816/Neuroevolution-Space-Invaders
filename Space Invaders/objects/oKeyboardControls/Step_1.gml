	
if global.playGame == true {
	
	global.leftKey = keyboard_check( vk_left );
	global.rightKey = keyboard_check( vk_right );
	global.shootKey = keyboard_check( vk_space );
} else {
	
	//check if the game should be started
	global.playGame = keyboard_check( vk_space );
}