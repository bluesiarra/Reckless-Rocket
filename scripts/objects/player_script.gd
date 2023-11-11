extends KinematicBody2D

"""
player_script.gd

Runs movement and appearance code for the player rocket. 
"""

"Speed & Position Related"
export var y_Speed = 300 #Speed in which passing objects go at 
var star_scale = 1 #Star speed
var start_pos #save start position
export var motion = Vector2.ZERO #motion vector
var x_topSpeed = 400 
export var x_accel = 8
var tilt = 0

"Input Info"
var touch_position = null
var is_touch_held = false

"Asteroid Information"
export var powerups = [false, false, false] # a list of the possible powerups, 0 = nitro, 1 = xray, 2 = force
export var asteroids_hit = 0 #counter (not updated in this script but by the asteroid script
export var lives = 3 #lives

"Movement lock variables"
export var can_move = true 
var cant_move_timer = 0

#Generate an RNG 
var rng = RandomNumberGenerator.new()

"Objects"
onready var collision_shape = $CollisionShape2D
onready var sprite = $CollisionShape2D/Sprite
onready var camera = $Camera2D
onready var stars = $stars
onready var nitro_bg = $nitrolines
onready var force_bumper = $CollisionShape2D/ForceBumper

"Powerup Timers"
onready var nitro_timer = $NitroTimer
onready var xray_timer = $XrayTimer
onready var force_timer = $ForceTimer

"Flame Particles"
onready var normal_flames = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_flame")
onready var nitro_flames = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_nitro")
onready var smoke_burst = get_node("CollisionShape2D/particles/" + String(PlayerSkinManager.frame) + "_smoke")

"Screenshake"
onready var screen_shake_timer = $ScreenShakeTimer
export var screen_shaking = false

"Runs when program is loaded"
func _ready():
	stars.emitting = true #Make sure stars work!
	rng.randomize() #Random seed
	
	"Connect Timers"
	nitro_timer.connect("timeout", self, "on_NitroOut")
	xray_timer.connect("timeout", self, "on_XRayOut")
	force_timer.connect("timeout", self, "on_ForceOut")
	
	screen_shake_timer.connect("timeout", self, "screenShakeDone")
	
	start_pos = position #Set start position
	
	"Adapt to custom skin"
	sprite.frame = PlayerSkinManager.frame
	collision_shape.position = PlayerSkinManager.collide_location
	collision_shape.shape.extents = PlayerSkinManager.collide_size

"Get Input"
func _input(event):
	#I copied this from some random online forum and have no idea how it works
	if event is InputEventScreenTouch:
		if (event.pressed == true):
			is_touch_held = true
			
			touch_position = event.position
		else:
			is_touch_held = false
			touch_position = null
	elif event is InputEventScreenDrag:
		touch_position = event.position

"Runs every physics frame (WARNING: SPAGHETTI CODE INSIDE)"
func _physics_process(delta):

	star_scale = y_Speed / 300 #Stars!
	position.y = start_pos.y #Lock y position
	
	
	#Show and hide force bumper
	if powerups[2]:
		force_bumper.show()
	else:
		force_bumper.hide()
	
	"IF hit by asteroid"
	if !can_move:
		powerups = [false, false, false] #Disable powerups
		
		#Stop emitting flames
		normal_flames.emitting = false
		nitro_flames.emitting = false

		smoke_burst.emitting = true #make smoke
		nitro_bg.emitting = false
		
		cant_move_timer += delta #start timer
		
		#Timer manager
		if cant_move_timer > 1.5:
			can_move = true
			cant_move_timer = 0
	else:
		smoke_burst.emitting = false	#Turn off smoke
		if !powerups[0]:
			stars.speed_scale = star_scale #set star speed
			y_Speed += delta * 8 #increase speed
			
			#...?
			normal_flames.emitting = true
			nitro_flames.emitting = false
			nitro_bg.emitting = false
		else:
			stars.speed_scale = star_scale * 4
			nitro_flames.emitting = true
			normal_flames.emitting = false
			nitro_bg.emitting = true
			y_Speed += delta * 32
	
	"Extremely messy powerup activation code"
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
	
	"Screen shake"
	if screen_shaking:
		if can_move:
			camera.offset_h = 0.04 * rng.randf()
			camera.offset_v = 0.04 * rng.randf() 
		else:
			camera.offset_h = 0.07 * rng.randf()
			camera.offset_v = 0.07 * rng.randf() 
	
	"Send fake inputs"
	if (is_touch_held == true and touch_position != null):
			if touch_position.x < GameInfo.screen_size.x/2:

				Input.action_press("left")
			else:
				Input.action_press("right")
	else:
		Input.action_release("left")
		Input.action_release("right")
		
	"Use the aforementioned fake inputs to fly the rocket"
	if Input.is_action_pressed("left") and can_move:
		motion.x += -x_accel
	elif Input.is_action_pressed("right") and can_move:
		motion.x += x_accel
	elif can_move:
		#Gradually decrease x-velocity for satisfying tilt
		if abs(motion.x) > 0.2:
			motion.x = 0.94 * motion.x 
		else:
			motion.x = 0
	else:
		pass
	
	#Clamp motion x
	if can_move:
		motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
		
	tilt = motion.x / 12
	motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
	
	motion = move_and_slide(motion)
	
	collision_shape.rotation_degrees = 0 + tilt


"TIMER COMPLETED"

func on_NitroOut():
	powerups[0] = false

func on_XRayOut():
	powerups[1] = false

func on_ForceOut():
	powerups[2] = false

func screenShakeDone():
	screen_shaking = false

