extends Node
# Preload StillCard node for instancing cards of that type
var StillCard=preload("res://scenes/StillCard.tscn")
###########################################
# Global settings
#################################
var first_card=0100 #Determins the first card
var time_to_gameover = globalvars.time_to_gameover # Has to be bigger than 12
###########################################
# Big Scopre Vars just for scripting
#################################
# masterdeck
var masterdeck = globalvars.masterdeck
# other general vars that represent stats
#var global_cards_of_the_run = playervars.cards_of_the_run
var cards_of_the_run = playervars.cards_of_the_run
var fastest_cards_index = playervars.fastest_cards_index 
var slowest_cards_index = playervars.slowest_cards_index
var card_index_and_card_seconds = playervars.card_index_and_card_seconds
var card_flags = []
var game_unlocks = []
var card_count = 1
# characteristics of each card
var	dialog1
var	dialog2 
var	textA
var	textB
var	nextA 
var	nextB 
var nextBflagged
var nextBunlocked
var specialItem = []
var flagOrUnlock = []
var	BGImage 
var	cardtype 
var	trait 
var	deathjoke 
# other scripting vars
var d10
var extra_wait_time = 0
# involved in random swipe making
var swap_swipe = false
var swap_text_buffer
var swap_code_buffer
var current_card
var GameTimer
var CardTimer
var game_seconds = 0
var card_seconds = 0
var EarthIconRect = [Rect2(0,0,18,18),Rect2(18,0,18,18),Rect2(36,0,18,18),Rect2(54,0,18,18),Rect2(72,0,18,18),Rect2(90,0,18,18),Rect2(0,18,18,18),Rect2(18,18,18,18),Rect2(36,18,18,18),Rect2(54,18,18,18),Rect2(72,18,18,18),Rect2(90,18,18,18)]

func _ready():
	#
	# Reset Player Vars
	#
	playervars.cards_of_the_run.clear()
	#var history_of_the_run = {}
	playervars.fastest_cards_index.clear()
	playervars.slowest_cards_index.clear()
	playervars.card_index_and_card_seconds.clear()	
	####################################
	#
	#	Set Up the Card System
	#
	######################################
	# Start with card set in first_card
	_load_next_card(first_card)


	##########################################
	#
	#  Create a GameTimer that measure seconds
	#
	#######################################
	GameTimer = Timer.new()
	GameTimer.connect("timeout", self, "_on_second_tick")
	add_child(GameTimer)
	GameTimer.wait_time = 1
	GameTimer.start()
	# Show the Timer in the progress bar
	$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/TimeLeft.value = time_to_gameover
	$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/TimeLeft.min_value = 0
	$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/TimeLeft.max_value = time_to_gameover
	##########################################
	#
	#  Create a CardTimer that measure seconds
	#
	#######################################
	CardTimer = Timer.new()
	CardTimer.connect("timeout", self, "_on_card_tick")
	add_child(CardTimer)
	CardTimer.wait_time = 0.1
	CardTimer.start()
	
	################################################
	## Initialize Pause/Play Buttons
	###################################################
	var PauseButton = $OverTheCard/GUI/VBoxContainer/HBoxTopContainer/PauseButton
	var PlayButton = $OverTheCard/PauseScreen/PlayButton
	PauseButton.connect("pressed", self, "_on_pause")
	PlayButton.connect("pressed", self, "_on_play")
	
	pass

func _process(delta):
#	$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/EarthIcon.Earth_Icon_Frame = Rect2(Vector2(90,18),Vector2(18,18))
#	print(game_seconds)
#	var current_card=get_child(0)
	#$Stillcard.queue_free()
	# Set up a timer with clock here
	pass
	
#########################################
#
#	On signal "direction swipe" pick the following card and load it 
#
#####################################
func _on_swipe(swipe):
#	print ("swipe is", swipe)
	var following_card = _pick_following_card(swipe)
	_load_next_card(following_card)
	
###############################################################
#
#  LOAD CARD SCRIPT
# This script loads a card (and in the future adds extra perks)
# It creates dynamically an instance of the next card
#
#############################################################
func _load_next_card(next_card_code):
	if next_card_code == 9000:
		_load_epitaph()
	# PreLoad new card
	var instanced_card = StillCard.instance()
	instanced_card.set_name("Card" + str(next_card_code))
	########################################################
	# Pass dynamic parameters to new card
	# update vars, putting values of the next_card_code into the current values
	#######################################################
	# get all the vars from masterdeck for the next card
	_update_current_card_vars(next_card_code)
	# connect with the swipe signal
	instanced_card.connect("_swiped", self, "_on_swipe")
	var bg_image = instanced_card.get_child(1).get_child(0)
	# If the card has an image, update it
	if BGImage == "." :
#		print("BGImage = 0")
		var card_texture_name = str("C" + _card_code_to_str(next_card_code))
		var card_bg=load("res://sprites/" + card_texture_name + ".png")
		bg_image.set_texture(card_bg)
		#passes the once/still/repeat command to the bg Image script in the card
		instanced_card.get_child(1).get_child(0).bg_repeat = cardtype 
	#in case there no image, use the dummy_texture. Could be a black screen
	if BGImage != "." :
		var other_card_bg=load("res://sprites/" + str(BGImage) + ".png")
#		print (other_card_bg)
		bg_image.set_texture(other_card_bg)
	##################################
	#
	#	RANDOMIZE SWIPE DIRECTION
	#	(should make into a separate function, it's confusing here)
	#
	# Randomize Swipe Side:
	d10 = randi()%11+1
	# only swap in 30% of cases
	if d10 < 4:
		swap_swipe = true
	else:
		swap_swipe = false
	if swap_swipe == true:
		# We are just swapping text labels here
		swap_text_buffer = textA
		textA = textB
		textB = swap_text_buffer
		#here we are swapping the card codes as well
		swap_code_buffer = nextA
		nextA = nextB
		nextB = swap_code_buffer
	else:
		pass
	# center the 2 dialogs and put them in the card
	var text_array = [str("[center]" + dialog1 + "[/center]"), str("[center]" + dialog2 + "[/center]")]
	instanced_card.dialog_text=text_array
	# place the left and right options in place
	var left_text = instanced_card.get_child(2).get_child(0).get_child(2).get_child(0).get_child(0)
	left_text.set_bbcode(str(textA))
	var right_text = instanced_card.get_child(2).get_child(0).get_child(2).get_child(2).get_child(0)
	right_text.set_bbcode(str("[right]" + textB + "[/right]"))
	# update card count after first card
	if next_card_code != first_card:
		_update_card_count(current_card)
	# reset the card timer
	card_seconds = 0
	# Finally add the card
	$CardContainer.add_child(instanced_card)
	current_card = next_card_code
	# add the record to the global var
#	playervars.cards_of_the_run.append(next_card_code)
#	print (cards_of_the_run)
	pass
	
	
	
	####################################
	#
	#	Update current card variables and flags
	#
	######################################
func _update_current_card_vars(next_card_code):
	# Convert the code into a string (it's usually a number)
	var next_card_code_str = _card_code_to_str(next_card_code)
	# Update each value to the respective ones, and format them according to int or str
	dialog1 = masterdeck[next_card_code_str].dialog1
	dialog2 = masterdeck[next_card_code_str].dialog2
	textA = masterdeck[next_card_code_str].textA
	textB = masterdeck[next_card_code_str].textB
	nextA = int(masterdeck[next_card_code_str].nextA)
	nextB = int(masterdeck[next_card_code_str].nextB)
	nextBflagged = int(masterdeck[next_card_code_str].nextBflagged)
	nextBunlocked = int(masterdeck[next_card_code_str].nextBunlocked)
	# parse the specialItem string into an array
	specialItem = masterdeck[next_card_code_str].specialItem.split(",")
	flagOrUnlock = masterdeck[next_card_code_str].flagOrUnlock
	BGImage = masterdeck[next_card_code_str].BGImage
	cardtype = masterdeck[next_card_code_str].cardtype
	trait = masterdeck[next_card_code_str].trait
	deathjoke = masterdeck[next_card_code_str].deathjoke
	update_card_flags(specialItem)
#	print ("this is the output of parsing:", masterdeck[next_card_code_str].dialog1)
	pass
	
#
# This function figures out the next card based on the current card and the direction swiped (in the future extra perks). 
# It returns the code of the next card. A code is a 4 digit number in a sort of order towards the end.
# Ideally the best run is 60 cards swiped like so: 100, 200, 300, .... 5900, 6000.
func _pick_following_card(direction_swiped):
	# As a dummy:
	var next_card_code
	if direction_swiped == "right":
		next_card_code = nextB
	if direction_swiped == "left":
		next_card_code = nextA
	return next_card_code


####################################
#
#	Conver card code to str
#
######################################
func _card_code_to_str(card_code):
	# just add enough zero to make it a 4 char string
	var card_str = str(card_code).pad_zeros(4)
	return card_str
	
####################################
#
#	Update card_flags with the card flag/commands
#
######################################
func update_card_flags(flagsarray):
	# just add enough zero to make it a 4 char string
	for i in range(0,flagsarray.size()):
		# if a flag starts with add_, add it
		if "add_" in flagsarray[i]:
			card_flags.append(flagsarray[i].substr(4, len(flagsarray[i])-4))
		# if a flag strts with remove_, remove it
		if "rm_" in flagsarray[i]:
			card_flags.erase(flagsarray[i].substr(3, len(flagsarray[i])-3))
		# stop_time stops the time		
		if "stop_time" in flagsarray[i]:
				GameTimer.stop()
	pass

##########################################
#
#  Control What Happens Every Second
#
#######################################
func _on_second_tick():
	game_seconds +=1
#	print ("seconds:", game_seconds)
	$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/TimeLeft.value = time_to_gameover - game_seconds
	var every_12th_time = floor(game_seconds/max(1,floor(time_to_gameover/12)))
#	print ("every", every_12th_time)
	if every_12th_time < 12:
		$OverTheCard/GUI/VBoxContainer/HBoxTopContainer/EarthIcon.Earth_Icon_Frame = EarthIconRect[every_12th_time]
	# When timer is up, load EndScreen
	if game_seconds >= time_to_gameover:
		
		var EndBg = $OverTheCard/EndScreen/BlackOut
		var TweenEnd = $OverTheCard/EndScreen/TweenBlackOut
		TweenEnd.interpolate_property(EndBg, "modulate:a", EndBg.get("modulate:a"), 1, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		TweenEnd.start()
		$OverTheCard/EndScreen.show()
		$OverTheCard/EndScreen/Margins.hide()
		extra_wait_time += 1
	if extra_wait_time >= 2:
		var QuitText = $OverTheCard/EndScreen/Margins/CenterContainer/VBoxContainer/QuitBtnContainer
		var TweenAgain = $OverTheCard/EndScreen/TweenBlackOut
		TweenAgain.interpolate_property(QuitText, "modulate:a", QuitText.get("modulate:a"), 1, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		TweenAgain.start()
		$OverTheCard/EndScreen/Margins.show()
		var TextTimer = $OverTheCard/EndScreen/Margins/CenterContainer/VBoxContainer/WipedCont/WipedAwayText/TextTimer
		TextTimer.start()

#################		
#	Updates card timer in seconds
func _on_card_tick():
	card_seconds +=0.1
#	print ("seconds:", card_seconds)

######################
#	Updates Card cound and passes data to playersvars
func _update_card_count(current_card):
	cards_of_the_run[card_count] = {"card": current_card,
            "card_secs": card_seconds,
			"game_secs": game_seconds}
	#initialize card count
	var card_i_and_s = [card_count,card_seconds]
	card_index_and_card_seconds.append(card_i_and_s)
	card_index_and_card_seconds.sort_custom(self, "compare_index_and_secs")
#	print ( card_index_and_card_seconds)
	card_count += 1

func compare_index_and_secs(a,b):
	return a[1] < b[1]


#####################################
#	Pauses the Cards and Shows Pause Screen
func _on_pause():
	get_tree().set_pause(true)
	var PauseScreen = $OverTheCard/PauseScreen
	PauseScreen.show()

##################################
#   Resumes the Game
func _on_play():
	get_tree().set_pause(false)
	var PauseScreen = $OverTheCard/PauseScreen
	PauseScreen.hide()

####################################
# Game Over function - this function should go on a global autoload singleton
func _end_game():
	get_tree().change_scene("res://scenes/EndGame.tscn") # change to whatever
	pass
####################################
# Game Over function - this function should go on a global autoload singleton
func _load_epitaph():
	get_tree().change_scene("res://scenes/Epitaph.tscn") # change to whatever
	pass