

leftKey = global.leftKey;
rightKey = global.rightKey;
shootKey = global.shootKey;


if tileX > 0 { tileX -= leftKey; }
if tileX < TILEWIDTH - 1 { tileX += rightKey; }

x = get_real_x(tileX);
y = get_real_y(tileY);

if shootKey && global.tick > shootTick + bulletCooldown {
	var _inst = instance_create_depth( x, y, 0, oPlayerBullet );
	_inst.tileX = tileX;
	_inst.tileY = tileY;
	_inst.spd = bulletSpd;
	shootTick = global.tick;
}

