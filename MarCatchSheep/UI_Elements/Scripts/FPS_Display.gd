extends Label

func _ready():
	self.visible = Lists.show_fps

func _process(_delta):
	self.set_text("FPS: " + str(Engine.get_frames_per_second()))
