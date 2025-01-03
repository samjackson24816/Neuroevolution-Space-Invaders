draw_set_font(fMSGothic);

if global.playGame == true {	
	draw_rectangle( XMAX, YMAX, XMIN, YMIN, true );
} else {
	draw_set_halign(fa_center);
	
	
	draw_text(XMIN + WIDTH/2, YMIN + HEIGHT/2, "Press Space\nto Start" );
	//reset text
	draw_set_halign(fa_left);
}

draw_set_halign(fa_center);
	
draw_text(XMIN + WIDTH/2,0,global.tick);
	
//reset text
draw_set_halign(fa_left);
