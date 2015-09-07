
extends Sprite

var position
var radius

func _ready():
	position=Vector2(0,0);
	radius = 5;

func _draw():
	draw_circle(position,radius, Color(1,1,1))



