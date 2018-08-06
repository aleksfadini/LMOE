extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Connect Buttons
	var StartButton = $CenterContainer/VBoxContainer/StartButtonContainer.get_child(0)
	StartButton.connect("pressed", self, "_on_StartButton_pressed")
	var HelpButton = $CenterContainer/VBoxContainer/HelpButtonContainer.get_child(0)
	HelpButton.connect("pressed", self, "_on_HelpButton_pressed")
	var TrophiesButton = $CenterContainer/VBoxContainer/TrophiesButtonContainer.get_child(0)
	$CenterContainer/VBoxContainer/TrophiesButtonContainer.get_child(1).set_bbcode("[center]trophies")
	TrophiesButton.connect("pressed", self, "_on_TrophiesButton_pressed")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/MainGame.tscn")

func _on_HelpButton_pressed():
#	get_tree().queue_free()
	var HelpScreen = load("res://scenes/Help.tscn")
	var instanced_node = HelpScreen.instance()
#	get_tree().add_child(HelpScreen)
	var StartMenu = $CenterContainer.get_parent()
#	StartMenu.change_scene(HelpScreen)
	var ChildNode=StartMenu.get_child(0)
	StartMenu.remove_child(ChildNode)
	print(StartMenu)
	StartMenu.add_child(instanced_node)
	
func _on_TrophiesButton_pressed():
#	get_tree().queue_free()
	var TrophiesScreen = load("res://scenes/Trophies.tscn")
	var instanced_node = TrophiesScreen.instance()
#	get_tree().add_child(HelpScreen)
	var StartMenu = $CenterContainer.get_parent()
#	StartMenu.change_scene(HelpScreen)
	var ChildNode=StartMenu.get_child(0)
	StartMenu.remove_child(ChildNode)
	print(StartMenu)
	StartMenu.add_child(instanced_node)
	
