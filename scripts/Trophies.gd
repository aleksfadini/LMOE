extends Node
# maybe modify as a global variable, they can be set so they start with _
var game_size = Vector2(180,320)
var card_slide_from_top = 20 # amount of slide from the top
var card_slide_speed = 45 #slide speed from top
var card_acceleration = 1 # acceleration from top
var card_min_speed = 3
var center_position = Vector2(game_size.x/2, game_size.y/2)
var card_slide_from_side = 60 # how many pixels you can slide the card before it stops
#Vars used for code later
var chars_in_last_line = 0
var already_started = false
# Sets vars to be exported
var death_text = ["Congratulations!","You have unlocked", "the following trophies:"]
var more_tr_text = ["Swipe slowly to see choices,","swipe all the way to confirm.", "", ""]
var less_tr_text = ["Hint:","", "", ""]
var page = 0
var start_more_tr_text = 0
var start_less_tr_text = 0
var next_text = 0
var show_death_text = 1
var show_more_tr_text = 0
var show_less_tr_text = 0
var timer_already_started = false
var card_index = playervars.card_index_and_card_seconds
var slowest_card_codes = []
var fastest_card_codes = []
var skip_text_effct = false
var already_skipped_text = false
func _ready():
	less_tr_text[1] = _pick_random_tt()

	#
	#	Set up the Quit Button
	#
	var QuitButton = $MarginContainer/VBoxContainer/QuitMenu/Button
	var QuitLabel = $MarginContainer/VBoxContainer/QuitMenu.get_child(1)
	#	Set the text on the Quit Button
	QuitLabel.set_bbcode("[center]back to menu[/center]")
	#	Connect the Quit Button
	QuitButton.connect("pressed", self, "_on_QuitButton_pressed")
	#
	#	Background Setup
	#
	#Sets the background image centered
	$BGContainer/BGImage.position = center_position
	#
	#	Dialog Boxes Set up
	#
	# 	Sets dialog boxes content
	$MarginContainer/VBoxContainer/DeathJoke/DialogText.set_bbcode(str("[center]"+death_text[page]))
	$MarginContainer/VBoxContainer/MoreTraits/DialogText.set_bbcode(str("[center]"+more_tr_text[page]))
	$MarginContainer/VBoxContainer/LessTraits/DialogText.set_bbcode(str("[center]"+less_tr_text[page]))
	# Initializes text animations
	$MarginContainer/VBoxContainer/DeathJoke/DialogText.set_visible_characters(0)
	$MarginContainer/VBoxContainer/MoreTraits/DialogText.set_visible_characters(0)
	$MarginContainer/VBoxContainer/LessTraits/DialogText.set_visible_characters(0)
#	chars_in_last_line = $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_total_character_count()
	#	print (chars_in_last_line)
	#Enables processing
	set_process(true)
#	set_process_input(true)
#	$MarginContainer/VBoxContainer/HBoxContainer/ChoiceRight/TweenNode.interpolate_property(self, "modulate:a", 0, 255, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	pass

func _process(delta):
#	chars_in_last_line = $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_total_character_count()
#	if $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() == chars_in_last_line:
##		print("equal chars")
#		show_death_text = 0
#		if timer_already_started == false:
##		print("triggered")
#			$MarginContainer/VBoxContainer/DeathJoke/SecondSentenceDelay.start()
#			timer_already_started = true
#	if $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() <= chars_in_last_line:
#		show_death_text = 1
#	print (chars_in_last_line)
	#############################
	#
	#Top Sliding Card Animation
	#
	##############################
	if($BGContainer/BGImage.position.y < center_position.y+card_slide_from_top):
		$BGContainer/BGImage.translate(Vector2(0,card_slide_speed*delta))
		card_slide_speed -= card_acceleration
#		card_slide_speed = abs(card_slide_speed)-card_acceleration
		card_slide_speed = abs(card_slide_speed)
		card_slide_speed = max(card_slide_speed,card_min_speed)
#	if($BGContainer/BGImage.position.y >= center_position.y+card_slide_from_top):
	pass

####################################
# timers for Dialg boxes
func _on_SecondSentenceDelay_timeout():
	if skip_text_effct == false:
		next_text +=1
		if next_text == 1:
			$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode("\n")
			$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode(death_text[1])
		if next_text == 2:
			$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode("\n")
			$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode(death_text[2])
		if next_text == 3:
			show_more_tr_text = 1
		if next_text == 4:
			$MarginContainer/VBoxContainer/MoreTraits/DialogText.append_bbcode("\n")
			$MarginContainer/VBoxContainer/MoreTraits/DialogText.append_bbcode(more_tr_text[1])
		if next_text == 5:
			pass
	#		show_less_tr_text = 1
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(less_tr_text[1])
	#		$MarginContainer/VBoxContainer/MoreTraits/DialogText.append_bbcode(", " + more_tr_text[2])
	#		$MarginContainer/VBoxContainer/MoreTraits/DialogText.append_bbcode(", " + more_tr_text[3])
		if next_text == 6:
			show_less_tr_text = 1
			$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
			$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(less_tr_text[1])
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(less_tr_text[1])
	#	if next_text == 7:
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(less_tr_text[2])
	#	if next_text == 8:
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(less_tr_text[3])
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(", " + less_tr_text[2])
	#		$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode(", " + less_tr_text[3])
	#	print ("started!!!")
#	page += 1
#	if $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() >= $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_total_character_count():
#	if page < death_text.size()-1 and $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() >= chars_in_last_line:
#	if page < death_text.size()-1:
#		print ("started!!!")
#		page += 1
#		$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode("\n")
#		$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode(death_text[page])
#		print(death_text[page])
#		show_death_text = 1
#	if page == death_text.size()-1 and $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() >= death_text[page].length()+80:
#		start_more_tr_text = 1
#	if page == death_text.size()-1 and $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() >= death_text[page].length()+130:
#		start_less_tr_text = 1

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			skip_text_effct = true
			if already_skipped_text == false:
				already_skipped_text = true
				$MarginContainer/VBoxContainer/DeathJoke/DialogText.set_bbcode("[center]"+death_text[0]+"\n"+death_text[1]+"\n"+death_text[2])
#				$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode(death_text[1])
#				$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode("\n")
#				$MarginContainer/VBoxContainer/DeathJoke/DialogText.append_bbcode(death_text[2])
				$MarginContainer/VBoxContainer/MoreTraits/DialogText.set_bbcode("[center]"+more_tr_text[0]+"\n"+more_tr_text[1])
#				$MarginContainer/VBoxContainer/MoreTraits/DialogText.append_bbcode(more_tr_text[1])
#				$MarginContainer/VBoxContainer/LessTraits/DialogText.append_bbcode("\n")
				$MarginContainer/VBoxContainer/LessTraits/DialogText.set_bbcode("[center]"+less_tr_text[0]+"\n"+less_tr_text[1])
				$MarginContainer/VBoxContainer/DeathJoke/DialogText.set_visible_characters(300)
				$MarginContainer/VBoxContainer/MoreTraits/DialogText.set_visible_characters(300)
				$MarginContainer/VBoxContainer/LessTraits/DialogText.set_visible_characters(300)
			if already_skipped_text == true:
				pass


func _card_index_to_card_code(card_index):
#	var index = abs(card_index)
	if card_index != null and card_index < playervars.cards_of_the_run.size()+1:
		var card_requested = playervars.cards_of_the_run.values()[card_index-1]
		var card_code = card_requested["card"]
	#	var card_code = globalvars.masterdeck[card_index].card
		return card_code
	else :
		pass

func find_trait_from_code(card_code):
#	var index = abs(card_index)
	if card_code != null:
		var card_code_string = globalvars._card_code_to_str(card_code)
		var trait = globalvars.masterdeck[card_code_string].trait
	#	var card_code = globalvars.masterdeck[card_index].card
		return trait
	else :
		pass

func find_joke_from_code(card_code):
#	var index = abs(card_index)
	if card_code != null:
		var card_code_string = globalvars._card_code_to_str(card_code)
		var joke = globalvars.masterdeck[card_code_string].deathjoke
	#	var card_code = globalvars.masterdeck[card_index].card
		return joke
	else :
		pass

func _pick_random_tt():
	randomize()
	var tooltips = globalvars.tooltips
#	print ("tooltips",tooltips)
	var tt_values=tooltips.values()
#	print ("tt_values",tt_values)
#	var tt_picked=tt_values[0].text
#	print ("tt_picked",tt_picked)
	var tt_size=tt_values.size()
#	print ("tt_size",tt_size)
	var tt_picked = tt_values[randi() % tt_values.size()].text
#	print ("word",word)
	return tt_picked




func _on_ShowTextDelay_timeout():
	if show_death_text == 1:
		if $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters() <= $MarginContainer/VBoxContainer/DeathJoke/DialogText.get_total_character_count():
			$MarginContainer/VBoxContainer/DeathJoke/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DeathJoke/DialogText.get_visible_characters()+1))
	if show_more_tr_text == 1:
		$MarginContainer/VBoxContainer/MoreTraits/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/MoreTraits/DialogText.get_visible_characters()+1))
	if show_less_tr_text == 1:
		$MarginContainer/VBoxContainer/LessTraits/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/LessTraits/DialogText.get_visible_characters()+1))

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
