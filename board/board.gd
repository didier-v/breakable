
extends Node

#autoload singletons:
# - global
# - nc

#resources
onready var pause_dialog_desource = preload("res://pause_dialog/pause_dialog.tscn")
onready var ball_resource = preload("res://ball/ball.tscn")
onready var bonus_resource = preload("res://bonus/bonus.tscn")

var current_level
var playing # true if playing, false if about to start
var lifes setget set_lifes # number of balls left
var score setget set_score
var current_speed
var multiplier # every brick hit has its value multiplied by this
var bricks_left
var bricks_since_last_bonus
var balls_in_game # usually 1 but can be more with the "three balls" bonus
var sticky = false # for the sticky bonus


func _ready():

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
	current_level=1
	init_level()
	$paddle.board = self

	#input
	set_process_input(true)

	#mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


#####################
###### EVENTS #######
#####################
func _exit_tree():
	#clean notification center
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
			$bonus_effect_manager.fire_effect()
	else: #not playing
		if event.is_action("ui_fire"): # start a game
			playing = true
			multiplier=0
			start_ball()


#####################
###### PAUSE DIALOG #
#####################
func show_pause_dialog():
	var pause_dialog_node = pause_dialog_desource.instance()
	self.add_child(pause_dialog_node)
	pause_dialog_node.delegate = self #delegate will be called with close_dialog function
	pause_dialog_node.popup_centered()
	get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#delegate functions
func close_dialog(dialog,response):
	dialog.queue_free() # close the dialog
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().set_pause(false) # run the game
	set_process_input(true) # can process input again
	if(response.message=="Continue"):
		pass #keep playing
	else:
		global.load_menu() # abandon


#########################
###### LEVEL MANAGEMENT #
#########################
func init_level():
	$level.load_level(current_level)
	playing = false
	multiplier=0
	current_speed=230
	create_ball(current_speed)
	bricks_left = $level.get_total_bricks()

func create_ball(speed):
	var ball = ball_resource.instance()
	add_child(ball)
	balls_in_game+=1
	ball.board = self
	ball.set_meta("type","ball")
	ball.set_speed(speed)
	return ball

func start_ball():
	for child in get_children(): #find balls
		if child.has_meta("type") && child.get_meta("type")=="ball":
			child.start()
			return



######################
###### NOTIFICATIONS #
######################
func brick_hit( observer, notificationName,data):
	#this notification sends the brick and the ball
	var brick=data.brick
	var ball=data.ball
	$brick_sound.play(0)
	multiplier=multiplier+1 #increase score and multiplier when you hit multiple bricks before hitting the paddle
	set_score(score+(10*multiplier))
	current_speed+=4.54 #increase speed
	ball.set_speed(current_speed)
	brick.set_current_hp(brick.current_hp-1) #for bricks that require several hits
	if (brick.current_hp==0):
		generate_bonus(brick.position) #the brick may drop a bonus
		brick.queue_free()
		bricks_left = bricks_left-1
		if(bricks_left==0): #no more bricks, end level
			for child in get_children(): #remove all balls
				if child.has_meta("type") && child.get_meta("type")=="ball":
					child.queue_free()
			balls_in_game=0
			current_level+=1
			if(current_level>global.MAX_LEVEL):
				current_level=1
			$board_animation.play("level_transition") #animation between levels

func paddle_hit(observer, notificationName,notificationData):
	if playing:
		$pad_sound.play(0) # paddle
		multiplier=0

func wall_hit(observer, notificationName,notificationData):
	if playing:
		$wall_sound.play(0) # wall

func bonus_hit(observer, notificationName,bonus):
	#this notification sends the bonus hit
	bonus.queue_free()
	if playing:
		$bonus_effect_manager.apply_effect(bonus.effect)


#######################
###### COLLISIONS #####
#######################
func _on_area_lost_body_entered( body ): #area below the paddle
	if body.has_meta("type"):
		if body.get_meta("type")=="ball":
			if(balls_in_game==1):
				set_lifes(lifes-1) # remove 1 life
				$bonus_effect_manager.current_effect="" # remove current effet
				for child in get_children(): #remove all bonuses
					if child.has_meta("type") && child.get_meta("type")=="bonus":
						child.queue_free()
				$paddle.set_paddle_width(global.INITIAL_PADDLE_WIDTH) # restore paddle
				if lifes==0:
					global.load_game_over(score) # game over
				else:
					playing = false
					create_ball(current_speed) #new ball

			body.queue_free() # remove the ball
			balls_in_game-=1
		elif body.get_meta("type")=="bonus":
			body.queue_free() # remove the bonus


######################
###### UTILITIES #####
######################

func generate_bonus(pos):
	if !sticky: ## no bonus while sticky is active
		#the probability increases with each brick hit
		var i=bricks_since_last_bonus*bricks_since_last_bonus/320.0
		var x=randf()
		bricks_since_last_bonus+=1
		if(x<i): #win!
			bricks_since_last_bonus=0
			var bonus = bonus_resource.instance()
			bonus.position = pos #the new bonus appears where the brick was hit
			bonus.set_meta("type","bonus")
			add_child(bonus)
			bonus.start()


func set_lifes(s):
	lifes = s
	#also update ui
	$game_ui.set_lifes(lifes-1) # -1 because one is currently played

func set_score(s):
	score=s
	global.score=s
	$game_ui.set_score(score)
	$game_ui.set_multiplier(multiplier)


func clone_ball(current_ball,n):
	#for the multiple balls bonus
	for i in range(n):
		var ball=create_ball(current_speed) #new ball
		ball.position = current_ball.position
		ball.start(false)


func unstick():
	#for the sticky bonus
	sticky=false
	$game_ui/message.text=""
