extends "res://level/generic_level.gd"

#autoload singletons
# global

func init_level(levelNode):
	var brick_array = {
		0:[0,1,2,1,2,1,2,1,2,1,0],
		1:[1,1,1,1,1,1,1,1,1,1,1],
		2:[2,1,1,1,1,1,1,1,1,1,2],
		3:[1,1,1,2,1,1,1,2,1,1,1],
		4:[1,1,1,2,1,1,1,2,1,1,1],
		5:[2,1,1,1,1,1,1,1,1,1,2],
		6:[1,1,1,1,1,1,1,1,1,1,1],
		7:[0,1,2,1,2,1,2,1,2,1,0],
	}


	var bricks_in_row = floor(1024/(global.BRICK_WIDTH+separation))
	var margin = (1024-(global.BRICK_WIDTH+separation)*bricks_in_row)/2
	var top = 100
	var total_bricks=0
	for i in range(8):
		var brick_line = brick_array[i]
		for j in range(bricks_in_row):
			if(brick_line[j]>0):
				var b = brique.instance()
				b.set_name("brick_"+str(i)+"_"+str(j))
				b.set_meta("type","brick")
				b.set_pos(Vector2(j*(global.BRICK_WIDTH+separation)+margin+global.BRICK_WIDTH/2,top+i*(global.BRICK_HEIGHT+separation)))
				levelNode.add_child(b)
				b.set_hp(brick_line[j])
				total_bricks += 1

	return total_bricks
