#macro TILESIZE 8
#macro WIDTH 56
#macro HEIGHT 112
#macro TILEWIDTH round(WIDTH/TILESIZE)
#macro TILEHEIGHT round(HEIGHT/TILESIZE)

#macro CENTERX room_width/2
#macro CENTERY room_height/2

#macro XMIN CENTERX - WIDTH/2
#macro XMAX CENTERX + WIDTH/2
#macro YMIN CENTERY - HEIGHT/2
#macro YMAX CENTERY + HEIGHT/2