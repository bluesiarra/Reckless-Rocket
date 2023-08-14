extends KinematicBody2D



onready var screen_size = get_viewport().get_visible_rect().size

var x_topSpeed = 320
var x_accel = 8
var tilt = 0

var start_pos

export var motion = Vector2.ZERO
func _ready():
	start_pos = position

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		if event.position.x < (0.5 * screen_size.x):
			Input.action_press("left")
		if event.position.x > (0.5 * screen_size.x):
			Input.action_press("right")

func _process(delta):
	position.y = start_pos.y
	
	if Input.is_action_pressed("left"):
		motion.x += -x_accel
	elif Input.is_action_pressed("right"):
		motion.x += x_accel
	else:
		
		if abs(motion.x) > 2:
			motion.x = 0.9 * motion.x 
		else:
			motion.x = 0
		
	tilt = motion.x / 16
	motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
	
	motion = move_and_slide(motion)
	
	self.rotation_degrees = 0 + tilt
