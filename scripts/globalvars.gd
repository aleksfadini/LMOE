extends Node
var masterdeck
var tooltips
var time_to_gameover = 60
func _ready():
	####################################
	#
	#	Parse the JSON masterdeck file
	#
	######################################
	# Makes our "new file"
	var data_file = File.new()
	#	#	tells Godo to just read the file and check for errors
	if data_file.open("res://data/masterdeck.json", File.READ) != OK:
		return
	#	# Get as a dictionnary
	var data_text = data_file.get_as_text()
	#	# Close file
	data_file.close()
	# Parse the file
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	#save the parse file in the masterdeck array
	masterdeck = data_parse.result
	####################################
	#
	#	Parse the JSON tooltip file
	#
	######################################
		# Makes our "new file"
	var tt_data_file = File.new()
	#	#	tells Godo to just read the file and check for errors
	if tt_data_file.open("res://data/tooltips.json", File.READ) != OK:
		return
	#	# Get as a dictionnary
	var tt_data_text = tt_data_file.get_as_text()
	#	# Close file
	tt_data_file.close()
	# Parse the file
	var tt_data_parse = JSON.parse(tt_data_text)
	if tt_data_parse.error != OK:
		return
	#save the parse file in the masterdeck array
	tooltips = tt_data_parse.result

	print("tt",tooltips)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

####################################
#
#	Conver card code to str
#
######################################
func _card_code_to_str(card_code):
	# just add enough zero to make it a 4 char string
	var card_str = str(card_code).pad_zeros(4)
	return card_str