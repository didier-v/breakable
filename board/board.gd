
extends Node

#autoload
var global
var nc

#resources
var pauseDialogResource
var ballResource
var bonusResource


var current_level
var playing # true if playing, false if about to start
var lifes setget set_lifes # number of balls left
var score setget set_score
var current_speed
var multiplier # every brick hit has its value multiplied by this
var bricks_left
var bricks_since_last_bonus
var balls_in_game


func _ready():
	#autoload
	global = get_node("/root/global")
	nc = get_node("/root/nc")
	
	#resources
	ballResource = preload("res://ball/ball.scn")
	bonusResource = preload("res://bonus/bonus.scn")
	pauseDialogResource = preload("res://PauseDialog/PauseDialog.scn") 

	#notifications
	nc.add_observer(self,"brick_hit","brick_hit")
	nc.add_observer(self,"paddle_hit","paddle_hit")
	nc.add_observer(self,"wall_hit","wall_hit")
	nc.add_observer(self,"bonus_hit","bonus_hit")
		
	#initial state
	score=0
	balls_in_game=0
	set_lifes(3)
	current_speed=0
	bricks_since_last_bonus = 0
	current_level=2
	init_level()
	
	#input
	set_process_input(true)
	
	#mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

#####################
###### EVENTS #######
#####################
func _exit_tree():
	#clean notifictaion center
	nc.remove_observer(self,"brick_hit")
	nc.remove_observer(self,"paddle_hit")
	nc.remove_observer(self,"wall_hit")
	nc.remove_observer(self,"bonus_hit")

func _input(event):

	if event.is_action("ui_cancel") and not event.is_pressed() : # pause on ESC
		get_tree().set_input_as_handled()
		set_process_input(false)
		show_pause_dialog()
	if playing:
		if event.is_action("ui_fire"): # during a game, some bonus can be activated with the mouse button
			get_node("bonus_effect_manager").fire_effect()
	else: #not playing
		if event.is_action("ui_fire"): # start a game
			playing = true
			multiplier=0
			start_ball()


#####################
###### PAUSE DIALOG #
#####################

func show_pause_dialog():
	var pauseDialogNode = pauseDialogResource.instance()
	self.add_child(pauseDialogNode)
	pauseDialogNode.delegate = self 
	pauseDialogNode.popup_centered()
	get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#delegate functions
func close_dialog(dialog,response):
	dialog.queue_free() # close the dialog
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().set_pause(false) # run the game
	set_process_input(true) # can process input again
	if(response.message=="Continue"):
		pass
	else:
		global.load_menu() # abandon


#########################
###### LEVEL MANAGEMENT #
#########################

func init_level():
	get_node("level").load_level(current_level)
	playing = false
	multiplier=0
	current_speed=230
	create_ball(current_speed)
	bricks_left = get_node("level").get_total_bricks()

func create_ball(speed):
	var ball = ballResource.instance()
	add_child(ball)
	balls_in_game+=1
	ball.set_meta("type","ball")
	ball.set_speed(speed)
	get_node("paddle").set_sticky(true) #the ball stays on the paddle until the player fires

func start_ball():
	get_node("paddle").set_sticky(false)
	for child in get_children(): #find balls 
		if(child.get_meta("type")=="ball"):
			child.start()
			return




######################
###### NOTIFICATIONS #
######################

func brick_hit( observer, notificationName,data):
	#this notification sends the brick and the ball
	var brick=data.brick
	var ball=data.ball
	get_node("sound").play("brick")
	multiplier=multiplier+1 #increase score and multiplier
	set_score(score+(10*multiplier))
	current_speed+=4.54 #increase speed
	ball.set_speed(current_speed)
	brick.set_current_hp(brick.current_hp-1) #for bricks that require several hits
	if (brick.current_hp==0):
		generate_bonus(brick.get_pos()) #the brick may drop a bonus
		brick.queue_free()
		bricks_left = bricks_left-1
		if(bricks_left==0): #no more bricks, end level
			for child in get_children(): #remove all balls
				if(child.get_meta("type")=="ball"):
					child.queue_free()
			balls_in_game=0
			current_level+=1
			if(current_level>global.MAX_LEVEL):
				current_level=1
			get_node("board_animation").play("level_transition") #animation between levels
		
	
func paddle_hit(observer, notificationName,notificationData):
	if playing:
		get_node("sound").play("paddle")
		multiplier=0

func wall_hit(observer, notificationName,notificationData):
	if playing:
		get_node("sound").play("wall")

func bonus_hit(observer, notificationName,bonus):
	#this notification sends the bonus hit
	bonus.queue_free()
	if playing:
		get_node("bonus_effect_manager").apply_effect(bonus.effect)


#######################
###### COLLISIONS #####
#######################

#area below the paddle
func _on_area_lost_body_enter(body):
	if body.get_meta("type")=="ball":
		if(balls_in_game==1):
			set_lifes(lifes-1) # remove 1 life
			get_node("bonus_effect_manager").current_effect="" # remove current effet
			for child in get_children(): #remove all bonuses
				if(child.get_meta("type")=="bonus"):
					child.queue_free()
			get_node("paddle").set_paddle_width(global.INITIAL_PADDLE_WIDTH) # restore paddle
			if lifes==0:
				global.load_game_over(score) # game over
			else:
				create_ball(current_speed) #new ball
				playing = false

		body.queue_free() # remove the ball
		balls_in_game-=1
	
	elif body.get_meta("type")=="bonus":
		body.queue_free() # remove the bonus


######################
###### UTILITIES #####
######################

func generate_bonus(pos):
	#the probability increases with each brick hit
	var i=bricks_since_last_bonus*bricks_since_last_bonus/350.0
	var x=randf()
	bricks_since_last_bonus+=1
	if(x<i): #win!
		bricks_since_last_bonus=0
		var bonus = bonusResource.instance()
		bonus.set_pos(pos) #the new bonus appears where the brick was hit
		bonus.set_meta("type","bonus")
		add_child(bonus)
		bonus.start()


func set_lifes(s):
	lifes = s
	#also update ui
	get_node("game_ui").set_lifes(lifes-1) # -1 because one is currently played

func set_score(s):
	score=s
	global.score=s
	get_node("game_ui").set_score(score)
	get_node("game_ui").set_multiplier(multiplier)
#
func clone_ball(current_ball,n): 
	#for the multiple balls bonus
	for i in range(n):
		var ball = ballResource.instance()
		add_child(ball)
		balls_in_game+=1
		ball.set_pos(current_ball.get_pos())
		ball.set_meta("type","ball")
		ball.set_speed(current_speed)
		ball.start()
