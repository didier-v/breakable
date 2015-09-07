
extends Node

var global
var languages = ["en","fr"]

func _ready():
	global = get_node("/root/global")

	var languageOption = get_node("GridContainer/LanguageOption")
	var currentLang = TranslationServer.get_locale()
	for i in range(languages.size()):
		languageOption.add_item(languages[i],i)
		if(languages[i]==currentLang):
			languageOption.select(i)
	
	if(OS.is_window_fullscreen()):
		get_node("GridContainer/screenOption").set_pressed(true)
		

func _on_main_menu_pressed():
	global.load_menu()

func _on_LanguageOption_item_selected( ID ):
	TranslationServer.set_locale(languages[ID])
	global.load_options() #reload the scene when language changes


func _on_screenOption_toggled( pressed ):
	OS.set_window_fullscreen( pressed )


