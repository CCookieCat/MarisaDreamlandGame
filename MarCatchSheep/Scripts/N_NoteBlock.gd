extends KinematicBody2D

signal reset_combo()
signal block_caught()
signal bonus_caught()
signal damage_player()

export var type = 0

export var FALL_SPEED = 200
export var ACCELERATION = 1000

var direction = Vector2.DOWN
var velocity = Vector2.ZERO

var caught = false

func _physics_process(delta):
	match type:
		0: # NORMAL
			velocity = calc_velocity(FALL_SPEED, ACCELERATION, delta)
		1: # SPECIAL
			velocity = calc_velocity(FALL_SPEED * 1.5, ACCELERATION, delta)
		2: # BOMB
			velocity = calc_velocity(FALL_SPEED * 0.8, ACCELERATION, delta)
	velocity = move_and_slide(velocity)

func calc_velocity(fall_speed, acceleration, delta):
	return velocity.move_toward(direction * fall_speed, acceleration * delta)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	if type == 0 && !caught:
		emit_signal("reset_combo")

func _on_Area2D_body_entered(_body):
	match type:
		0:
			emit_signal("block_caught")
			caught = true
		1:
			emit_signal("bonus_caught")
		2:
			emit_signal("damage_player")
	$SFX_Playback.play()
	self.hide()

func _on_VisibilityNotifier2D_screen_entered():
	self.connect("reset_combo", get_tree().get_root().get_node("Main"), "_on_combo_reset")
	self.connect("block_caught", get_tree().get_root().get_node("Main"), "_on_block_caught")
	self.connect("bonus_caught", get_tree().get_root().get_node("Main"), "_on_bonus_caught")
	self.connect("damage_player", get_tree().get_root().get_node("Main"), "_on_damage_player")

func set_sprite(texture):
	$NoteAnimation.animation = texture
	var b_explosion_sound = load("res://MarCatchSheep/SFX/BombSound03.ogg")
	$SFX_Playback.stream = b_explosion_sound

func set_special_material(material):
	$NoteAnimation.material = material

func _on_SFX_Playback_finished():
	self.queue_free()
