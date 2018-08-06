extends Node
# pass signal for the swipe
signal _swiped
# maybe modify as a global variable, they can be set so they start with _
var game_size = Vector2(180,320)
var card_slide_from_top = 20 # amount of slide from the top
var card_slide_speed = 45 #slide speed from top
var card_acceleration = 1 # acceleration from top
var card_min_speed = 3
var center_position = Vector2(game_size.x/2, game_size.y/2)
var card_slide_from_side = 80 # how many pixels you can slide the card before it stops. Virtual max is 90 but bugs occur after 80
var area_of_non_choice = 0.95 # Represent the fraction of the card where the choicse show up. Has to be a factor from 0 to 0.5.
var area_of_choice = 0.5 # Represent the fraction of the card where the next card triggers. Has to be a factor from 0.5 to 1.
var snap_to_center_speed = 0.3 # represents the speed with which, when not dragging, the card goes back
#var max_drag_time = 2 # after that dragging is disabled, in secs
#var max_recover_drag_time = 0.1 # time to reenable dragging
#Vars used for code later
#Sets limit of sliding card to left and right
var slide_limit_left
var slide_limit_right
#Sels limit of area_of_non_choice
var width_of_non_choice
var width_of_choice
var non_choice_limit_left
var non_choice_limit_right
var choice_limit_left
var choice_limit_right
var dragging = false
var released = false
var chars_in_first_line = 0
var already_started = false 
# Sets vars to be exported
export var dialog_text = ["Mmmm.","Mumble."]
var page = 0
var left_choice_visible = 0
var right_choice_visible = 0
var right_blinking = 0
var left_blinking = 0
var TenthsTimer
var swipe_signal
var choice_made = false
#var textTween = $MarginContainer/VBoxContainer/HBoxContainer/TweenNode
#var drag_time = 0
#var recover_drag_time = 0
#var ignore_drag = false

func _ready():
#	var textTween = $MarginContainer/VBoxContainer/HBoxContainer/TweenNode
	#
	#	Background Setup
	#
	#Sets the background image centered
	$BGContainer/BGImage.position = center_position
	#
	#	Swipes Setup
	#
	#Sets limit of sliding card to left and right
	slide_limit_left = center_position.x-card_slide_from_side
	slide_limit_right = center_position.x+card_slide_from_side
	#Sels limit of area_of_non_choice
#	width_of_non_choice = card_slide_from_side*area_of_choice*2
#   It's 1-area of non choice because it's the area in which the choices do NOT appear
	width_of_non_choice = game_size.x*(1-area_of_non_choice)
	width_of_choice = game_size.x*area_of_choice
#	print (width_of_non_choice, "widthofnonC")
#	print (width_of_choice, "widthofC")
	non_choice_limit_left = center_position.x-width_of_non_choice/2
	non_choice_limit_right = center_position.x+width_of_non_choice/2	
	choice_limit_left = center_position.x-game_size.x/2+width_of_choice/2
	choice_limit_right = center_position.x+game_size.x/2-width_of_choice/2
#	print (non_choice_limit_left," and", non_choice_limit_right, "nonC limits")
#	print (choice_limit_left,"and", choice_limit_right, "C limits")
	# Sets dialog box
	$MarginContainer/VBoxContainer/DialogBox/DialogText.set_bbcode(dialog_text[page])
	# Initializes text animation
	$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(0)
	chars_in_first_line = $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()
#	print (chars_in_first_line)
	#Enables processing
	##########################################
	#
	#  Create a DragTimer that measure 10ths of seconds
	#
	#######################################
	TenthsTimer = Timer.new()
	TenthsTimer.connect("timeout", self, "_on_tenth_tick")
	add_child(TenthsTimer)
	TenthsTimer.wait_time = 0.3
#	TenthsTimer.start()
	set_process(true)
	set_process_input(true)
	
	
	#TESTINAREA
#	$MarginContainer/VBoxContainer/HBoxContainer/ChoiceRight/TweenNode.interpolate_property(self, "modulate:a", 0, 255, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	pass

func _process(delta):
#	print (ignore_drag, "ignore drag")
#	print ($BGContainer/BGImage.position.x)
	chars_in_first_line = $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()
	if already_started == false and $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters() >= ($MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()-4):
#		print("triggered")
		$MarginContainer/VBoxContainer/DialogBox/SecondSentenceDelay.start()
		already_started = true
#	print (chars_in_first_line)
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
	if($BGContainer/BGImage.position.y >= center_position.y+card_slide_from_top):
		pass
	#############################
	#
	# Reading Card Choice and Exiting Node
	# Also, animating choices
	#
	##############################
#	print ("position of card", $BGContainer/BGImage.position.x)
	if $BGContainer/BGImage.position.x >= non_choice_limit_left and $BGContainer/BGImage.position.x <= non_choice_limit_right:
		left_choice_visible = 0	
		right_choice_visible = 0
		left_blinking = 0
		right_blinking = 0
	if $BGContainer/BGImage.position.x < non_choice_limit_left:
		left_choice_visible = 1	
		right_choice_visible = 0
		left_blinking = 0
#		right_blinking = 0
		if $BGContainer/BGImage.position.x <= choice_limit_left:
			left_blinking = 1
		if $BGContainer/BGImage.position.x <= choice_limit_left and released == true:
			_on_choice_made("left")
#			swipe_signal = "left"
#			choice_made = true			
#			TenthsTimer.start()
#			left_blinking = 0
			#add extra feedback here, such as left choice Blinks!, or flag, blinking = 1 and 0 everywhere else
#			queue_free()
#			emit_signal("_swiped", "left")
	if $BGContainer/BGImage.position.x > non_choice_limit_right:
#		left_blinking = 0
		right_choice_visible = 1
		left_choice_visible = 0		
		right_blinking = 0
		if $BGContainer/BGImage.position.x >= choice_limit_right:
			right_blinking = 1
		if $BGContainer/BGImage.position.x >= choice_limit_right and released == true:
			_on_choice_made("right")
#			swipe_signal = "right"
#			choice_made = true
#			TenthsTimer.start()
#			queue_free()
#			emit_signal("_swiped", "right")
	#########################################
	#
	# Slide Card To Center When Not Dragging
	#
	#######################################
	if dragging == false:
		var distance_from_center = Vector2()
		distance_from_center = $BGContainer/BGImage.position-center_position
		var velocity = distance_from_center.x
		$BGContainer/BGImage.position.x -= velocity*snap_to_center_speed
#		print ($BGContainer/BGImage.position.x)
#	#########################################
#	#
#	# Disable Dragging after some tenths of Sec
#	#
#	#######################################
#	if dragging == true:
#		_on_tenth_tick(drag_time)
#		print(drag_time,"drag_time")
#		if drag_time >= max_drag_time*10:
#			dragging == false
#
#	# This keeps dragging disable for a tiny bit
#	if drag_time >= max_drag_time*10:
#		dragging == false
#		_on_tenth_tick(recover_drag_time)
#		if recover_drag_time >= max_recover_drag_time*10:
#			recover_drag_time = 0
#			drag_time = 0
		
	#############################
	#
	# Animate Choices
	#
	##############################
	var textL = $MarginContainer/VBoxContainer/HBoxContainer/ChoiceLeft/LeftText
	var textR = $MarginContainer/VBoxContainer/HBoxContainer/ChoiceRight/RightText
	var choiceL = $MarginContainer/VBoxContainer/HBoxContainer/ChoiceLeft
	var choiceR = $MarginContainer/VBoxContainer/HBoxContainer/ChoiceRight
	var textTween = $MarginContainer/VBoxContainer/HBoxContainer/TweenNode
	var ch_s_speed = 0.2 #choice show scroll speed in seconds
	var ch_h_speed = 0.1  #choice hide scroll speed in seconds
	var blink_speed = 0.3 #time for the blinking choice to start animating
	if left_choice_visible == 1:
#		right_blinking = 0
		right_choice_visible = 0
		textTween.interpolate_property(textL, "rect_position", textL.get('rect_position'), Vector2(16,0), ch_s_speed, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		textTween.interpolate_property(choiceL, "modulate:a", choiceL.get('modulate:a'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.start()
	if left_choice_visible == 0 and choice_made == false:
#		left_blinking = 0
		textTween.interpolate_property(textL, "rect_position", textL.get('rect_position'), Vector2(-52,0), ch_h_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceL, "modulate:a", choiceL.get('modulate:a'), 0, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.start()
	if right_choice_visible == 1 and choice_made == false:
#		left_blinking = 0
		left_choice_visible = 0
		textTween.interpolate_property(textR, "rect_position", textR.get('rect_position'), Vector2(0,0), ch_s_speed, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		textTween.interpolate_property(choiceR, "modulate:a", choiceR.get('modulate:a'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.start()
	if right_choice_visible == 0 and choice_made == false:
#		right_blinking = 0
		# script is a little buggy for some reason, so we are going to stop things from sliding manually on this next line here
		textR.margin_right = 68
#		textTween.interpolate_property(textR, "rect_scale", textR.get("rect_scale"), Vector2(1,1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		# (end of special bug patch)
		textTween.interpolate_property(textR, "rect_position", textR.get('rect_position'), Vector2(52,0), ch_h_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceR, "modulate:a", choiceR.get('modulate:a'), 0, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.start()
	if left_blinking == 1:
		textTween.interpolate_property(choiceL, "modulate:b", choiceL.get('modulate:b'), 0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceL, "modulate:g", choiceL.get('modulate:g'), 0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(textL, "rect_scale", textL.get("rect_scale"), Vector2(4,4), blink_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#		textTween.interpolate_property(textL, "rect_position", textL.get("rect_position"), textL.get("rect_position")+Vector2(-textR.get("rect_size").x*1.5,textR.get("rect_size").y*1.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		textTween.start()
	if left_blinking == 0 and choice_made == false:
		textTween.interpolate_property(choiceL, "modulate:b", choiceL.get('modulate:b'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceL, "modulate:g", choiceL.get('modulate:g'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(textL, "rect_scale", textL.get("rect_scale"), Vector2(1,1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		textTween.interpolate_property(textL, "rect_position", textL.get("rect_position"), Vector2(5,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		textTween.start()
	if right_blinking == 1:
		textTween.interpolate_property(textR, "rect_position", textR.get('rect_position'), Vector2(-180,10), blink_speed, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		textTween.interpolate_property(choiceR, "modulate:b", choiceR.get('modulate:b'), 0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceR, "modulate:g", choiceR.get('modulate:g'), 0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(textR, "rect_scale", textR.get("rect_scale"), Vector2(4,4), blink_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#		textTween.interpolate_property(textR, "rect_scale", textR.get("rect_scale"), Vector2(textR.get("rect_scale").x,textR.get("rect_scale").y*2 ), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		textTween.interpolate_property(textR, "rect_position", textR.get("rect_position"), textR.get("rect_position")+Vector2(-textR.get("rect_size").x*3,textR.get("rect_size").y*1.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		textTween.start()	
	if right_blinking == 0 and choice_made == false:
#		textTween.interpolate_property(textR, "rect_position", textR.get('rect_position'), Vector2(0,0), 0.4, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		textTween.interpolate_property(choiceR, "modulate:b", choiceR.get('modulate:b'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(choiceR, "modulate:g", choiceR.get('modulate:g'), 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		textTween.interpolate_property(textR, "rect_scale", textR.get("rect_scale"), Vector2(1,1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		textTween.interpolate_property(textR, "rect_position", textR.get("rect_position"), Vector2(8,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		textTween.start()	


	pass

#########################################
#
# Handling Left/Right swipe and move with mouse
#
#######################################
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
#			if ignore_drag == false:
			dragging = true
			released = false
		else:
			dragging = false
			released = true
	elif event is InputEventMouseMotion and dragging:
		var rel_x = event.relative.x
		$BGContainer/BGImage.position.x += rel_x
			#if card to the right, only let it come back (not that useful)
		if $BGContainer/BGImage.position.x >= slide_limit_right:
			if rel_x > 0:
				$BGContainer/BGImage.position.x = slide_limit_right
			if rel_x <= 0:
				$BGContainer/BGImage.position.x += rel_x
		if $BGContainer/BGImage.position.x <= slide_limit_left:
			#if card to the left, only let it come back (not that useful)
			if rel_x < 0:
				$BGContainer/BGImage.position.x = slide_limit_left
			if rel_x >= 0:
				$BGContainer/BGImage.position.x += rel_x
####################################
# timers for Dialg boxes
func _on_SecondSentenceDelay_timeout():
#	print ("started!!!")
#	page += 1
#	if $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters() >= $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count():
	if page < dialog_text.size()-1 and $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters() >= chars_in_first_line:
#		print ("started!!!")
		page += 1
		$MarginContainer/VBoxContainer/DialogBox/DialogText.append_bbcode("\n")
		$MarginContainer/VBoxContainer/DialogBox/DialogText.append_bbcode(dialog_text[page])
#		chars_in_first_line = $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()
#		$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(chars_in_first_line)

func _on_ShowTextDelay_timeout():
#	var already_started = false 
	if page < dialog_text.size()-1 and $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters() < chars_in_first_line:
		$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()+1))
	if page >= dialog_text.size()-1:
		$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()+1))
#	print("tot", $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count() ,"visible",$MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters())
#	if already_started == false and $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters() >= ($MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()-4):
#		print("triggered")
##		$MarginContainer/VBoxContainer/DialogBox/SecondSentenceDelay.start()
#		already_started = true
		
			
			
#	chars_in_first_line = $MarginContainer/VBoxContainer/DialogBox/DialogText.get_total_character_count()
#	$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()+1))
#	var visible_characters = $MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()
#	print ("vis", visible_characters)
#	print ("line", chars_in_first_line)
#	if visible_characters < chars_in_first_line :
#		$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()+1))
#	else :
#		$MarginContainer/VBoxContainer/DialogBox/DialogText.set_visible_characters(($MarginContainer/VBoxContainer/DialogBox/DialogText.get_visible_characters()+1))
#		print("start") 
#		$MarginContainer/VBoxContainer/DialogBox/SecondSentenceDelay.start()
func _on_choice_made(direction):
	swipe_signal = direction
	choice_made = true
	var FadeTween = $MarginContainer/VBoxContainer/HBoxContainer/TweenNode
	var BGImageBelow = $BGContainer/BGImage
	FadeTween.interpolate_property(BGImageBelow, "modulate:a", BGImageBelow.get('modulate:a'), 0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	FadeTween.interpolate_property(BGImageBelow, "scale", Vector2(1,1), Vector2(2,2), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	FadeTween.start()
	print("working")
	#this leaves the choice blinking while chargin the next card
	if swipe_signal == "left":
		left_blinking = 1
	if swipe_signal == "right":
		right_blinking = 1
	TenthsTimer.start()

func _on_tenth_tick():
#	var FadeTween = $MarginContainer/VBoxContainer/HBoxContainer/TweenNode
#	var BGImageBelow = $BGContainer/BGImage
#	FadeTween.interpolate_property(BGImageBelow, "modulate:a", BGImageBelow.get('modulate:a'), 1, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
#	FadeTween.interpolate_property(BGImageBelow, "scale", Vector2(1,1), Vector2(2,2), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
#	FadeTween.start()
#	print("working")
#	#this leaves the choice blinking while chargin the next card
#	if swipe_signal == "left":
#		left_blinking = 1
#	if swipe_signal == "right":
#		right_blinking = 1
	queue_free()
	emit_signal("_swiped", swipe_signal)
#	#########################################
#	#
#	# Disable Dragging after some tenths of Sec
#	#
#	#######################################
#	if dragging == true:
#		drag_time+=1
#		print(drag_time,"drag_time")
#		if drag_time >= max_drag_time*10:
#			ignore_drag = true			
#	# This turns dragging back on after a tiny bit
#	if drag_time >= max_drag_time*10:
#		recover_drag_time += 1
#		if recover_drag_time >= max_recover_drag_time*10:
#			recover_drag_time = 0
#			drag_time = 0
#			ignore_drag = false

