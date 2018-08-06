extends RichTextLabel


func _ready():

	##########################################
	#
	#  Create a timer for chars
	#
	#######################################
	self.set_visible_characters(0)
	$TextTimer.connect("timeout", self, "_text_timer_tick")

func _text_timer_tick():
	
	self.set_visible_characters(self.get_visible_characters()+1)