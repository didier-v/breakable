
extends Node

#autoload singletons
# global

onready var options = $"/root/options_manager".read_options()
onready var languages = ["en","fr"]

func _ready():
	var currentLang = TranslationServer.get_locale()
	for i in range(languages.size()):
		$GridContainer/LanguageOption.add_item(languages[i],i)
		if(languages[i]==currentLang):
			$GridContainer/LanguageOption.select(i)
	
	if(OS.is_window_fullscreen()):
		$GridContainer/ScreenOption.pressed = true
		

func _on_MainMenu_pressed():
	global.load_menu()

func _on_LanguageOption_item_selected( id ):
	TranslationServer.set_locale(languages[id])
	options["locale"]=languages[id]
	$"/root/options_manager".write_options(options)
	global.load_options() #reload the scene when language changes


func _on_ScreenOption_toggled( pressed ):
	OS.set_window_fullscreen( pressed )
	options["full_screen"]=pressed
	$"/root/options_manager".write_options(options)

