extends Sprite
#
#	This script is all self contained, it animates the BGImage once unless it receives a 
#	different parameter (repeat or still) to tweak the animation
#	You can change the speed of the animation in the FPS var
#
var timer
var frames_per_sec = 12
var timer_tick
export var bg_repeat = "once"
func _ready():
	timer_tick = float(1)/frames_per_sec
	self.frame = 0
	timer = Timer.new()
	timer.connect("timeout",self,"tick")
	add_child(timer)
	timer.wait_time = timer_tick
	timer.start()
	set_process(true)
	pass

func _process(delta):
#	print("fps tick", timer_tick)
	pass
	
func tick():
	if bg_repeat == "once":
		if self.frame < 11:
			self.frame = self.frame + 1
		else:
			self.frame = 11
	if bg_repeat == "repeat":
		if self.frame < 11:
			self.frame = self.frame + 1
		else:
			self.frame = 0			
	if bg_repeat == "still":
		self.frame = 0
	pass
