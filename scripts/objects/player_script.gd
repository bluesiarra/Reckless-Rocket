extends KinematicBody2D





var x_topSpeed = 320
export var x_accel = 8
var tilt = 0

export var y_Speed = 200
export var can_move = true
export var powerups = [false, false, false]
export var powerups_timer = [true, false, false]

export var abc = 1
export var abc_def = 2
var cant_move_timer = 0

var start_pos

export var motion = Vector2.ZERO

var touch_position = null
var is_touch_held = false

onready var nitro_timer = $NitroTimer

onready var normal_flames = $particles/normal_flame_particals
onready var nitro_flames = $particles/nitro_particles


func _ready():
	nitro_timer.connect("timeout", self, "on_NitroOut")
		
	powerups_timer[0] = false
	start_pos = position

func _input(event):
	if event is InputEventScreenTouch:
		if (event.pressed == true):
			is_touch_held = true
			
			touch_position = event.position
		else:
			is_touch_held = false
			touch_position = null
	elif event is InputEventScreenDrag:
		touch_position = event.position
		
	
func _physics_process(delta):
	position.y = start_pos.y
	
	get_node("/root/Game/HUD/DebugLabel").text = ("FPS " + String(Engine.get_frames_per_second()))
	
	
	if (is_touch_held == true and touch_position != null):
		if touch_position.x < GameInfo.screen_size.x/2:

			Input.action_press("left")
		else:
			Input.action_press("right")
	else:
		Input.action_release("left")
		Input.action_release("right")

	
	if !can_move:
		normal_flames.emitting = false
		nitro_flames.emitting = false
		
		cant_move_timer += delta
		if cant_move_timer > 1.5:
			can_move = true
			cant_move_timer = 0
	else:
		if !powerups[0]:

			y_Speed += delta * 4
			normal_flames.emitting = true
			nitro_flames.emitting = false
		else:
			nitro_flames.emitting = true
			normal_flames.emitting = false
			y_Speed += delta * 20
	
	if Input.is_action_pressed("left") and can_move:
		motion.x += -x_accel
	elif Input.is_action_pressed("right") and can_move:
		motion.x += x_accel
	elif can_move:
		if abs(motion.x) > 2:
			motion.x = 0.9 * motion.x 
		else:
			motion.x = 0
	else:
		pass
	if can_move:
		motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)

	if powerups_timer[0]:
		nitro_timer.start()

			
		powerups[0] = true
		powerups_timer[0] = false
		
	tilt = motion.x / 16
	motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
	
	motion = move_and_slide(motion)
	
	self.rotation_degrees = 0 + tilt
	
	

func on_NitroOut():
	powerups[0] = false
	powerups_timer[0] = false



