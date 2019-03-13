
extends Node


func _ready():

	#full screen
	var options = $"/root/options_manager".read_options()
	if(options.has("full_screen")):
		OS.set_window_fullscreen(options.full_screen)

	#language
	if(options.has("locale")):
		TranslationServer.set_locale(options.locale)
	else:
		if OS.get_locale().begins_with("fr") || OS.get_locale().begins_with("en"):
			TranslationServer.set_locale(OS.get_locale())

	#load first scene
	$"/root/global".load_menu()


