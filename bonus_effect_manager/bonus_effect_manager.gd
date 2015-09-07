
extends Node

#autoload
var global
var nc

var board
var current_effect

func _ready():
	global = get_node("/root/global")
	nc = get_node("/root/nc")
	current_effect=""
	board = get_parent()
	
func apply_effect(effect):
	if(effect!=""):
		fire_effect() #fire previous effect if it can
	current_effect = effect
	var func_name = "apply_"+effect
	if(has_method(func_name)):
		nc.post_notification("show_bonus_message",effect)
		call(func_name)

func fire_effect():
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
	var children=board.get_children()
	for child in children:
		if(child.get_meta("type")=="ball"):
			child.set_active(false)
	board.get_node("paddle").set_sticky(true)
	
func fire_sticky():
	var children=board.get_children()
	for child in children:
		if(child.get_meta("type")=="ball"):
			child.set_active(true)
	board.get_node("paddle").set_sticky(false)
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
			if(child.get_meta("type")=="ball"):
				board.clone_ball(child,2)
	current_effect=""