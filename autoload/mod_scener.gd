extends Node
 
# Description:
# A powerfull scene switcher / loader with preloading, progressbar usage and blackscreener (background)
# Includes also a lightweight switcher (fastload) for just load another scene without any features
 
# Usage:
# sload("res://new_scene.scn", "progressbar_node", "yieldcount", "background_node", "time_max", "debug_output")
 
# Author (s)
# Kermer (GodotEngine.org), Marco Heizmann
 
# Version:
# V1.0
 
# Link:
# http://godotengine.de/en/script_modules/mod_scener

# Special Thanks to Kermer, who did almost the whole work and was very patient with me

######## Test mode should always be present.
func  modtest():
	print("Module -mod_scener- loaded")
	return true
########


var loader = [null,0,0]		# Resource(Loader), current stage, stage_count
var wait_frames				# wait a moment to display the progressbar
var time_max = 4			# how much time we block this thread

# some more vars used
var current_scene
var last_tick = null
var path = null

var progressbar_node = null
var background_node = null
var debug_print = false


# preload a scene
func sload(path, bar=null, yields=1, bg=null, tmax = 4, debuger = false):

	# no path given / no yields counted (every yield results in an stage update, so count them)
	if !path:
		return false

	# wrong path format
	if !( path.begins_with('res://') or path.begins_with('user://') ):
		return false

	# if yields is set
	if yields < 1:
		yields = 4

	# if progressbar is given
	if bar:
		progressbar_node = bar

	# if background is given
	if bg:
		background_node = bg

	# set max time to wait
	if tmax > 0:
		time_max = tmax

	# debuger activated?
	if debuger:
		debug_print = true

	loader[0] = ResourceLoader.load_interactive(path)		# append ressource to the loader
	loader[2] = loader[0].get_stage_count() + yields + 1	# steps for that script

	# now load the scene
	if loader[0] == null:
		return	# something went wrong

	set_process(true)
	last_tick = OS.get_ticks_msec()		# for loading time display
	
	wait_frames = 1		# wait a moment to display the progressbar


# process until everything is loaded
func _process(delta):

	# finished loading
	if loader[0] == null:
		set_process(false) 			# no need to process anymore
		return
	
	# wait / pause
	if wait_frames > 0: 
		wait_frames -= 1			# wait for frames to let the "loading" animation to show up
		return

	var t = OS.get_ticks_msec()		# get time
	while OS.get_ticks_msec() < t + time_max: 	# use "time_max" to control how much time we block this thread

		# poll your loader
		var err = loader[0].poll()

		if err == ERR_FILE_EOF:		# load finished
			var resource = loader[0].get_resource()
			yielder()				# yield handling
			set_new_scene(resource)
			loader[0] = null
			break

		elif err == OK:
			yielder()				# yield handling

		else: 						# error during loading
			loader[0] = null
			break

	if debug_print:
		print("  Loading time: ",float(OS.get_ticks_msec() - last_tick)/1000)
	last_tick = OS.get_ticks_msec()


# yield handling
func yielder():

	loader[1] += 1 				# set current stage

	# current stage is below yield count
	if loader[1] > loader[2]:	
		if debug_print:
			print(" Stage out of range!")
		return 0

	var stage = loader[1]
	var progress = float(stage) / loader[2]

	if debug_print:
		print("  ",round(progress*100),"%")

	# if background node is set, show
	if background_node:
		var bckgrnd = get_node("/root").get_node( background_node )
		if !bckgrnd.is_visible():
			bckgrnd.show()
			#bckgrnd.set_layer(10000000000)

	# if progressbar node is set, display progress
	if progressbar_node:
		#if hidden, show
		var prgrsbr = get_node("/root").get_node( progressbar_node )
		if !prgrsbr.is_visible():
			prgrsbr.show()
			#prgrsbr.set_layer(10000000001)

		#set progress in bar
		prgrsbr.set_value( round(progress*100) )

	# everything loaded, now free the parent scene
	if loader[0] == null and loader[1] == loader[2]:

		if debug_print:
			print(" Everything loaded, now free the parent scene ")

		var root = get_node("/root")
		current_scene = root.get_child( root.get_child_count() -2 )
		current_scene.free()


# finaly set the new scene active
func set_new_scene(scene_resource):

	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)


#####


# for scene switching without any features
func fastload(path):

	var root = get_node("/root")
	current_scene = root.get_child( root.get_child_count() -1 )
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):

	# Immediately free the current scene,
	# there is no risk here.    
	current_scene.free()
	
	# Load new scene
	var s = ResourceLoader.load(path)
	
	# Instance the new scene
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)