
extends Node2D

#autoload singletons
# global

var bw
var bh
var hp setget set_hp #bricks have hit points
var current_hp setget set_current_hp

func _ready():
	bw=global.BRICK_WIDTH
	bh=global.BRICK_HEIGHT
	var body = get_node("brick_body")
	body.clear_shapes()
	var rh = RectangleShape2D.new()
	rh.set_extents(Vector2(bw/2,bh/2))
	body.add_shape(rh)
	

func set_hp(new_hp):
	hp = new_hp
	set_current_hp(hp)

func set_current_hp(new_hp):
	current_hp=new_hp
	if(current_hp>0):
		get_node("Sprite").set_texture(global.brick_texture[current_hp]) #change texture according to current hp
	
	
