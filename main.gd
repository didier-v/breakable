
extends Node


func _ready():

	#full screen
	var options = get_node("/root/options_manager").read_options()
	if(options.has("full_screen")):
		OS.set_window_fullscreen(options.full_screen)

	#language
	if(options.has("locale")):
		TranslationServer.set_locale(options.locale)
	else:
		#TODO : FIX for locales not working on osx
		#print("locale is "+OS.get_environment("$LANG"))
		if(OS.get_locale()=="fr" || OS.get_locale()=="en"):
			TranslationServer.set_locale(OS.get_locale())
		
	#load first scene
	var global = get_node("/root/global")
	global.load_menu()


