extends TextureRect

export (Rect2) var Earth_Icon_Frame = Rect2(Vector2(0,0),Vector2(18,18)) setget set_Earth_Icon_frame_Rect2 #, get_my_var

func _ready():
#	var Icon_texture = get("texture")
##	Earth_Icon_Frame = value_Rect2
#	Icon_texture.set("region",value_Rect2)
	pass

func set_Earth_Icon_frame_Rect2(value_Rect2):
	Earth_Icon_Frame = value_Rect2
	var Icon_texture = get("texture")
#	print (Icon_texture,Icon_texture.get("region"))
	Icon_texture.set("region",value_Rect2)
	.hide()
	.show()
	
#func get_my_var():
##	var Icon_texture = get("texture")
###	Earth_Icon_Frame = value_Rect2
##	Icon_texture.set("region",Earth_Icon_Frame)
#	return Earth_Icon_Frame
