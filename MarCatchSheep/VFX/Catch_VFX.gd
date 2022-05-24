extends AnimatedSprite


func _on_SmokeSprite_animation_finished():
	self.queue_free()
