tool
extends StaticBody2D

# a generic wall that can be made horizontal or vertical in the editor
# it adjusts its collision shape accordingly

export (String, "horizontal","vertical") var orientation setget set_orientation
export (Color, RGBA) var color setget set_color
export (float) var width=10 setget set_width
export (float) var length=512 setget set_length
var shape_owner

func _ready():
	if orientation==null:
		orientation="horizontal"
	update_wall()



func update_wall():
	if !get_shape_owners().empty(): # the function can be called before the shape owner is created
		var so = get_shape_owners()[0]
		self.shape_owner_clear_shapes(so)
		var r = RectangleShape2D.new()
		if(orientation=="horizontal"):
			r.set_extents(Vector2(length/2,width/2))
		else:
			r.set_extents(Vector2(width/2,length/2))
		self.shape_owner_add_shape(so,r)
		update()


func _draw():
	var r
	if(orientation=="horizontal"):
		r = Rect2(-length/2,-width/2,length,width)
	else:
		r = Rect2(-width/2,-length/2,width,length)
	draw_rect(r,color)


func set_orientation(o):
	orientation=o
	update_wall()

func set_color(c):
	color=c
	update()

func set_width(w):
	width=w
	update_wall()

func set_length(l):
	length=l
	update_wall()
