extends Node

var score_names #array of the names of the best players
var score_values #array of their scores
var HI_SCORE_SIZE = 10
func _ready():
	score_names = []
	score_values = []
	read_scores() #load file of hi scores
	
func get_lowest_hi_score():
#this function is useful to know if the last player deserves to be in hte hi score list
	if score_values.size()<HI_SCORE_SIZE : # some room left in the list
		return 0
	else:
		return score_values[score_values.size()-1]
	
func add_hi_score(name,score):
	if score_values.size()==0: #first score ever, just add it to the arrays
		score_values.append(score)
		score_names.append(name)
	else:
		var i=0
		while i<score_values.size(): 
			if(score>score_values[i]): #insert the score, keep the array sorted by value
				score_values.insert(i,score)
				score_names.insert(i,name)
				i=score_values.size()
			elif i==(score_values.size()-1): #some room left, put this low score at the end of the array
				score_values.append(score)
				score_names.append(name)
				i=score_values.size()
			i+=1

	if score_values.size()>HI_SCORE_SIZE: #delete the lowest scores by resizing the arrays
		score_values.resize(HI_SCORE_SIZE)
		score_names.resize(HI_SCORE_SIZE)

	write_scores() #save to file



func read_scores():
	var f = File.new()
	if(f.file_exists("user://hiscores.data")):
		var err = f.open_encrypted_with_pass("user://hiscores.data",File.READ,"foo")
		score_names = f.get_var()
		score_values = f.get_var()
		f.close()
	

func write_scores():
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://hiscores.data",File.WRITE,"foo") #will create or replace the file
	f.store_var(score_names)
	f.store_var(score_values)
	f.close()
