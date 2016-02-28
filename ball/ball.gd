
extends RigidBody2D

#autoload singletons 
#nc # notification center


var speed setget set_speed, get_speed # ball speed
var active setget set_active #boolean true is ball is active (playing)
var relative_pos  # vector2: ball position relative to the paddle, used to calculate the bounce angle

func _ready():

	set_active(false)
	nc.add_observer(self,"paddle_hit","paddle_hit") #What the ball should do when it hits the paddle
	nc.add_observer(self,"paddle_moved","follow_paddle") #when game starts (or sticky bonus), the ball follows the paddle

func body_enter(body):
	if(body.get_name()=="brick_body"):
		var brick = body.get_parent()
		nc.post_notification( "brick_hit",{"brick":brick,"ball":self}) #let the world know that the ball touched a brick
	elif(body.get_name().find("wall")>0):
		nc.post_notification( "wall_hit","")  #let the world know that the ball hit a wall


	
func _exit_tree():
	#always clean notifications
	nc.remove_observer(self,"paddle_moved") 
	nc.remove_observer(self,"paddle_hit")

func _on_ball_body_exit( body ):
	var lv=get_linear_velocity().normalized()*speed
	set_linear_velocity(lv)
	if(body.get_name()=="brick_body"):
		adjust_angle()


func adjust_angle():
	#here we cheat with the angle to make the game more enjoyable
	var min_angle = 20 #below 20, it's too horizontal
	var lv=get_linear_velocity().normalized()*speed  #current velocity
	var angle = rad2deg(lv.angle_to(Vector2(1,0))) #current angle

	#bounce
	if (angle>0 and angle<min_angle):
		angle=angle-min_angle #<0
	elif (angle<0 and angle>-min_angle):
		angle=angle+min_angle #>0
	elif (angle>180-min_angle and angle<180):
		angle=angle-180+min_angle #>0
	elif (angle<-180+min_angle and angle>-180):
		angle=angle+180-min_angle #<0
	else:
		angle=0
	if angle!=0:
		lv= lv.rotated(deg2rad(angle)) # we change the angle, but keep the speed
		set_linear_velocity(lv) 


func start():
	set_active(true)
	var lv=Vector2(rand_range(-200,200),-200).normalized()*speed #starting velocity, with random angle
	set_linear_velocity(lv)

func paddle_hit(object,action,data):
	if active:
		nc.remove_observer(self,"paddle_moved") #when the ball is active, it doesn't stick to the paddle anymore
	else:
		relative_pos = data #this happens when the sticky bonus has been caught
		nc.add_observer(self,"paddle_moved","follow_paddle")

func follow_paddle(object,action,data):
	var pos = data
	if(get_pos()==Vector2(0,0)): #if new ball, just put it on the top of the paddle
		pos.y=pos.y-12
	else:
		pos=pos+relative_pos #sticky bonus again. we want ball to stick to the hit point of the paddle
	set_pos(pos)

func set_active(is_active):
	active=is_active
		
func set_speed(new_speed):
	speed=new_speed
	
func get_speed():
	return speed
	
	
