
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
	var rh = RectangleShape2D.new()
	rh.set_extents(Vector2(bw/2.2,bh/2.2))
	var shape_owner_id = $brick_body.create_shape_owner($brick_body)
	$brick_body.shape_owner_clear_shapes(shape_owner_id)
	$brick_body.shape_owner_add_shape(shape_owner_id,rh)


func set_hp(new_hp):
	hp = new_hp
	set_current_hp(hp)

func set_current_hp(new_hp):
	current_hp=new_hp
	if(current_hp>0):
		$Sprite.set_texture(global.brick_texture[current_hp]) #change texture according to current hp
	
	
