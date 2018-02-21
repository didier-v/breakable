
extends Node

#autoload singletons
# global
# nc

onready var board = get_parent()
onready var current_effect = ""


func apply_effect(effect):
	if(effect!=""):
		fire_effect() #fire previous effect if it can
	current_effect = effect
	var func_name = "apply_"+effect
	if(has_method(func_name)):
		nc.post_notification("show_bonus_message",effect) # let the ui know that an effect has been triggered
		call(func_name)

func fire_effect(): ## some effects (like sticky) have a fire action
	if(current_effect!=""):
		var func_name = "fire_"+current_effect
		if(has_method(func_name)):
			call(func_name)


####################
#SCORE
func apply_score():
	board.set_score(board.score+1000)
	current_effect=""
	
####################
#EXTRA LIFE
func apply_extra_life():
	board.set_lifes(board.lifes+1)
	current_effect=""

####################
#STICKY
func apply_sticky():
	board.sticky = true
	
func fire_sticky():
	var children=board.get_children()
	for child in children:
		if  child.has_meta("type") && child.get_meta("type")=="ball":
			child.set_active(true)
	board.sticky = false
	board.unstick()
	current_effect=""

####################
#SMALL PADDLE
func apply_small_paddle():
	var paddle = board.get_node("paddle")
	if(paddle.paddle_width>global.INITIAL_PADDLE_WIDTH):
		paddle.set_paddle_width(global.INITIAL_PADDLE_WIDTH)
	else:
		paddle.set_paddle_width(global.INITIAL_PADDLE_WIDTH-50)
	current_effect=""
		
####################
#BIG PADDLE
func apply_big_paddle():
	var paddle = board.get_node("paddle")
	if(paddle.paddle_width<global.INITIAL_PADDLE_WIDTH):
		paddle.set_paddle_width(global.INITIAL_PADDLE_WIDTH)
	else:
		paddle.set_paddle_width(global.INITIAL_PADDLE_WIDTH+50)
	current_effect=""

####################
#3 BALLS
func apply_three_balls():
	if(board.balls_in_game<=1):
		var children=board.get_children()
		for child in children:
			if child.has_meta("type") && child.get_meta("type")=="ball":
				board.clone_ball(child,2)
	current_effect=""