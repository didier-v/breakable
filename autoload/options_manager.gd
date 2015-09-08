extends Node


func read_options():
	var options = {}
	var f = File.new()
	if(f.file_exists("user://options.data")):
		var err = f.open("user://options.data",File.READ)
		options = f.get_var()
		f.close()
	return options
	
func write_options(options):
	var f = File.new()
	var err = f.open("user://options.data",File.WRITE) #will create or replace the file
	f.store_var(options)
	f.close()


