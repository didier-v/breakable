
extends Node2D

#autoload singletons
# nc
# global

var center #of the viewport

export(float) var paddle_width=0 setget set_paddle_width
export(bool) var sticky setget set_sticky

func _ready():
	
	paddle_width=global.INITIAL_PADDLE_WIDTH
	#paddle initial pos
	var pos = self.get_pos()
	pos.x = get_viewport_rect().size.x/2
	pos.y = self.get_pos().y
	set_pos(pos)

	center = get_viewport_rect().size/2;
	get_viewport().warp_mouse(center)

	sticky=false
	
	set_fixed_process(true)


# mouse movement
func _fixed_process(delta): 
	var mouse_pos = get_viewport().get_mouse_pos()
	var size = get_viewport_rect().size
	var pos=get_pos()
	var new_x = mouse_pos.x
	pos.x=clamp(new_x,0,size.width) #paddle follows the mouse, but does not exit the screen
	set_pos(pos)
	if sticky:
		nc.post_notification("paddle_moved",pos)

#collision
func _on_Area2D_body_enter( body ):
	if(body.get_meta("type")=="ball"):
		var velocity = body.get_linear_velocity()
		velocity.y=-velocity.y # simple bounce

		var body_pos = body.get_pos()
		var paddle_pos = get_pos()
		var relative_pos = Vector2(body_pos.x-paddle_pos.x, -12)
		nc.post_notification( "paddle_hit",relative_pos)
		var coeff = (body_pos.x-paddle_pos.x)/paddle_width # -0,5 .. 0,5 , depending on where the ball hits the paddle
		var angle =  -coeff*PI/2.4
		velocity = velocity.rotated(angle) # relative rotation, keeps speed
		body.set_linear_velocity(velocity)
		body.adjust_angle() #let the ball adjust the angle so the game keeps being playable
		
	elif(body.get_meta("type")=="bonus"):
		nc.post_notification("bonus_hit",body)

func update_paddle():
	var paddle_area=self.get_node("paddle_area")
	if(paddle_area!=null):
		paddle_area.clear_shapes() #remove previous shape
		var r = RectangleShape2D.new()
		r.set_extents(Vector2(paddle_width/2,global.PADDLE_HEIGHT/2)) 
		paddle_area.add_shape(r) #define new rectangle shape
		update()

func set_paddle_width(pw): #size changes with SMALL_PADDLE and BIG_PADDLE
	paddle_width=pw
	var left=get_node("left")
	if(left!=null):
		var pos = left.get_pos()
		pos.x=-paddle_width/2
		left.set_pos(pos)
	var right=get_node("right")
	if(right!=null):
		var pos = right.get_pos()
		pos.x=paddle_width/2-16
		right.set_pos(pos)
	var middle=get_node("middle")
	if(middle!=null):
		middle.set_scale(Vector2(paddle_width/20.0-1.5,1))
	
	update_paddle()
	
func set_sticky(is_sticky):
	sticky=is_sticky
	
	