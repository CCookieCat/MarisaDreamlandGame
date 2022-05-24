extends KinematicBody2D

onready var viewport = get_viewport_rect().size
onready var collider_halfsize = Vector2(16,16) # $ColliderPivot/CollisionShape2D.shape.extents

export var MAX_SPEED = 80
export var DASH_SPEED = 260
export var ACCELERATION = 500
export var FRICTION = 500
export var DASH_FRICTION = 500

var daze_timer_wait_time = 0.5
var dash_usable = true
var velocity = Vector2.ZERO

enum {
	NORMAL, DASH, DAZE
}
var movement = NORMAL

func _ready():
	$Daze_Timer.wait_time = daze_timer_wait_time

func _input(event):
	if event.is_action_pressed("dash") && dash_usable:
		movement = DASH
	if event.is_action_released("dash") && dash_usable:
		movement = NORMAL

func _physics_process(delta):
	global_position.x = clamp(global_position.x, collider_halfsize.x, viewport.x - (collider_halfsize.x * 2))
	var input_vector = Vector2.ZERO
	
	match movement:
		NORMAL:
			velocity = calc_velocity(input_vector, MAX_SPEED, FRICTION, delta)
		DASH:
			velocity = calc_velocity(input_vector, DASH_SPEED, DASH_FRICTION, delta)
		DAZE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

func calc_velocity(input_vector, max_speed, friction, delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
		if input_vector.x < 0:
			$Sprite.flip_h = true
			$Position2D.scale.x = -1
		if input_vector.x > 0:
			$Sprite.flip_h = false
			$Position2D.scale.x = 1
			
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	return velocity

func _inflict_daze(mercy):
	if mercy:
		$Daze_Timer.wait_time = 1/sqrt(mercy)
	movement = DAZE
	dash_usable = false
	print($Daze_Timer.wait_time)
	$Daze_Timer.start()

func _on_Daze_Timer_timeout():
	$Daze_Timer.wait_time = daze_timer_wait_time
	dash_usable = true
	movement = NORMAL
