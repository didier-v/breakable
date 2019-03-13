
extends Node2D

#autoload singletons
# nc
# global

var center #of the viewport
var board
export(float) var paddle_width=0 setget set_paddle_width

func _ready():

	paddle_width=global.INITIAL_PADDLE_WIDTH
	#paddle initial pos
	self.position.x = get_viewport_rect().size.x/2

	center = get_viewport_rect().size/2;
	get_viewport().warp_mouse(center)

	set_physics_process(true)


# mouse movement
func _physics_process(delta):

	var mouse_pos = get_viewport().get_mouse_position()
	var size = get_viewport_rect().size
	position.x = clamp(mouse_pos.x,0,size.x)

	if board.sticky || !board.playing:
		nc.post_notification("paddle_moved",position)

# collision
func _on_Area2D_body_enter( body ):
	if body.has_meta("type"):
		if body.get_meta("type")=="ball":
			var velocity = body.get_linear_velocity()
			velocity.y=-velocity.y # simple bounce

			var body_pos = body.position
			var paddle_pos = position
			var relative_pos_x = body_pos.x-paddle_pos.x
			nc.post_notification( "paddle_hit",relative_pos_x)
			var coeff = (body_pos.x-paddle_pos.x)/paddle_width # -0,5 .. 0,5 , depending on where the ball hits the paddle
			var angle =  coeff*PI/2.4
			velocity = velocity.rotated(angle) # relative rotation, keeps speed
			body.set_linear_velocity(velocity)
			body.adjust_angle() #let the ball adjust the angle so the game keeps being playable

		elif body.get_meta("type")=="bonus":
			nc.post_notification("bonus_hit",body)


func update_paddle():
	if has_node("paddle_area"):
		var paddle_area = $paddle_area
		if(paddle_area.get_shape_owners().empty()):
			paddle_area.create_shape_owner(paddle_area)
		var so = paddle_area.get_shape_owners()[0]
		paddle_area.shape_owner_clear_shapes(so)

		var r = RectangleShape2D.new()
		r.set_extents(Vector2(paddle_width/2,global.PADDLE_HEIGHT/2))
		paddle_area.shape_owner_add_shape(so,r)
		update()

func set_paddle_width(pw): #size changes with SMALL_PADDLE and BIG_PADDLE bonus
	if paddle_width!=pw:
		paddle_width=pw
		if has_node("left"):
			$left.position.x = -paddle_width/2
		if(has_node("right")):
	#		$right.set_pos(pos)
			$right.position.x = paddle_width/2-16
		if(has_node("middle")):
			$middle.set_scale(Vector2(paddle_width/20.0-1.5,1))
		update_paddle()



