extends KinematicBody2D





var x_topSpeed = 400
export var x_accel = 8
var tilt = 0

export var y_Speed = 300
export var can_move = true
export var powerups = [false, false, false]
export var asteroids_hit = 0

var rng = RandomNumberGenerator.new()

var cant_move_timer = 0

var start_pos

export var motion = Vector2.ZERO

var touch_position = null
var is_touch_held = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $CollisionShape2D/Sprite
onready var camera = $Camera2D
onready var stars = $stars
onready var nitro_bg = $nitrolines
onready var force_bumper = $CollisionShape2D/ForceBumper

var star_scale = 1

onready var nitro_timer = $NitroTimer
onready var xray_timer = $XrayTimer
onready var force_timer = $ForceTimer

onready var normal_flames = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_flame")
onready var nitro_flames = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_nitro")
onready var smoke_burst = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_smoke")

onready var screen_shake_timer = $ScreenShakeTimer
export var screen_shaking = false
func _ready():
	stars.emitting = true
	rng.randomize()
	nitro_timer.connect("timeout", self, "on_NitroOut")
	xray_timer.connect("timeout", self, "on_XRayOut")
	force_timer.connect("timeout", self, "on_ForceOut")
	
	start_pos = position
	
	sprite.frame = PlayerSkinManager.frame
	collision_shape.position = PlayerSkinManager.collide_location
	collision_shape.shape.extents = PlayerSkinManager.collide_size

	screen_shake_timer.connect("timeout", self, "screenShakeDone")
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

	star_scale = y_Speed / 300
	position.y = start_pos.y
	

	
	
	if (is_touch_held == true and touch_position != null):
		if touch_position.x < GameInfo.screen_size.x/2:

			Input.action_press("left")
		else:
			Input.action_press("right")
	else:
		Input.action_release("left")
		Input.action_release("right")

	if powerups[2]:
		force_bumper.show()
	else:
		force_bumper.hide()
	
	if !can_move:
		powerups = [false, false, false]
		
		normal_flames.emitting = false
		nitro_flames.emitting = false
		
		smoke_burst.emitting = true
		nitro_bg.emitting = false
		
		cant_move_timer += delta
		
		if cant_move_timer > 1.5:
			can_move = true
			cant_move_timer = 0
	else:
		smoke_burst.emitting = false		
		if !powerups[0]:
			stars.speed_scale = star_scale
			y_Speed += delta * 8
			normal_flames.emitting = true
			nitro_flames.emitting = false
			nitro_bg.emitting = false
		else:
			stars.speed_scale = star_scale * 4
			nitro_flames.emitting = true
			normal_flames.emitting = false
			nitro_bg.emitting = true
			y_Speed += delta * 32
	
	
	
	if Input.is_action_pressed("left") and can_move:
		motion.x += -x_accel
	elif Input.is_action_pressed("right") and can_move:
		motion.x += x_accel
	elif can_move:
		if abs(motion.x) > 0.2:
			motion.x = 0.94 * motion.x 
		else:
			motion.x = 0
	else:
		pass
	if can_move:
		motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)

	if Input.is_action_pressed("powerup_0"):
		nitro_timer.start()
		powerups[0] = true
		Input.action_release("powerup_0")
	
	if Input.is_action_pressed("powerup_1"):
		xray_timer.start()
		powerups[1] = true
		Input.action_release("powerup_1")
		
	if Input.is_action_pressed("powerup_2"):
		force_timer.start()
		powerups[2] = true
		Input.action_release("powerup_2")

	if Input.is_action_pressed("startscreenshake"):
		screen_shaking = true
		screen_shake_timer.start()
		Input.action_release("startscreenshake")
	
	if screen_shaking:
		if can_move:
			camera.offset_h = 0.04 * rng.randf()
			camera.offset_v = 0.04 * rng.randf() 
		else:
			camera.offset_h = 0.07 * rng.randf()
			camera.offset_v = 0.07 * rng.randf() 
		
	tilt = motion.x / 12
	motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
	
	motion = move_and_slide(motion)
	
	collision_shape.rotation_degrees = 0 + tilt
	

func on_NitroOut():
	powerups[0] = false

func on_XRayOut():
	powerups[1] = false

func on_ForceOut():
	powerups[2] = false

func screenShakeDone():
	screen_shaking = false

