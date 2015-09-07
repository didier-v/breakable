extends Node


#Collision layers
#ball 1 , no mask 
#bonus 2  , no mask 
#brick 3, mask 1
#paddle 1,2, mask 1,2
#TODO

# bonus aleatoires
#		fog
#		"ghost":5,
#		"ninja":5
# textures des bonus aleatoires
# types de briques
## briques à 3 hits
## briques mobiles
## briques indestructibles
# animation sur balle perdue
# transition entre niveaux
# hi score
# bonus temps sur un niveau



#autoload
var mod_scener #autoload script to manage scenes
var score # score of the current game
var brick_texture #array of brick textures 
var bonus_texture #dictionary of bonus textures
var bonus_effect #dictionary of bonus effects
var bonus_message #dictionary of bonus messages

#constants
const BRICK_WIDTH = 86
const BRICK_HEIGHT = 37
const INITIAL_PADDLE_WIDTH = 100
const MAX_LEVEL = 2

func _ready():

	score=0
	
	bonus_texture =  {
		"score":preload("res://textures/bonus_score.png"),
		"sticky":preload("res://textures/bonus_sticky.png"),
		"three_balls":preload("res://textures/bonus_three_balls.png"),
		"extra_life":preload("res://textures/bonus_extra_life.png"),
		"small_paddle":preload("res://textures/bonus_small_paddle.png"),
		"big_paddle":preload("res://textures/bonus_big_paddle.png")
		}

	bonus_effect = {
		"score":15,
		"sticky":15,
		"three_balls":10,
		"extra_life":5,
		"small_paddle":15,
		"big_paddle":15,
#		"ninja_stars":10,
#		"ghost":5,
#		"fog":10
	}
	
	bonus_message = {
		"score":"1000 points de plus",
		"sticky":"GLU",
		"three_balls":"3 BALLES",
		"extra_life":"1 VIE DE PLUS" ,
		"small_paddle":"Petite raquette",
		"big_paddle":"Grande raquette",
#		"ninja_stars":10,
#		"ghost":5,
#		"fog":10
	}

		
	brick_texture=[null,
		preload("res://textures/brick01.png"), #1 hit
		preload("res://textures/brick11.png")  #2 hits
	]

	#TODO : FIX for locales not working on osx
	TranslationServer.set_locale("fr")
	#print("locale is "+OS.get_environment("$LANG"))
	randomize()
	mod_scener = get_node("/root/mod_scener")
#	OS.set_window_fullscreen( true )

	
#SCENE MANAGEMENT
func new_game():
	mod_scener.fastload("res://board/board.scn")

func load_menu():
	mod_scener.fastload("res://menu/menu.scn")
	
func load_hi_scores():
	mod_scener.fastload("res://hi_scores/hi_scores.scn")

func load_options():
	mod_scener.fastload("res://options/options.scn")

func load_game_over(score):
	mod_scener.fastload("res://game_over/game_over.scn")
	
func quit():
	get_tree().quit()