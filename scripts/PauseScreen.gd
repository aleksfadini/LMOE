extends Container
func _ready():
	var PlayButton = $PlayButton
	PlayButton.connect("pressed", $PlayButton, "_on_play")

func _on_play():
	print ("pressed")
	get_tree().set_pause(false)
	hide()
