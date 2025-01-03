event_inherited();


tileX = floor(TILEWIDTH/2);
tileY = TILEHEIGHT -1;
x = get_real_x(tileX);
y = get_real_y(tileY);


leftKey = false;
rightKey = false;
shootKey = false;

bulletSpd = playerBulletSpd;
bulletCooldown = playerBulletCooldown;

shootTick = 0;

