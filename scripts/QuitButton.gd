extends TextureButton


func _ready():
	connect("pressed", self, "_on_quit")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_quit():
	get_tree().change_scene("res://scenes/Epitaph.tscn") # back to menu

