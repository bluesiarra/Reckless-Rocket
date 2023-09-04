extends KinematicBody2D





var x_topSpeed = 320
export var x_accel = 8
var tilt = 0


export var can_move = true
export var powerups = [false, false, false]



var cant_move_timer = 0

var start_pos

export var motion = Vector2.ZERO

var touch_position = null
var is_touch_held = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite

onready var nitro_timer = $NitroTimer
onready var xray_timer = $XrayTimer
onready var normal_flames = $particles/normal_flame_particles
onready var nitro_flames = $particles/nitro_particles
onready var smoke_burst = $particles/smoke_particles

func _ready():
	motion.y = -600
	
	nitro_timer.connect("timeout", self, "on_NitroOut")
	xray_timer.connect("timeout", self, "on_XRayOut")
	
	start_pos = position
	
	sprite.frame = PlayerSkinManager.frame
	collision_shape.position = PlayerSkinManager.collide_location
	collision_shape.shape.extents = PlayerSkinManager.collide_size

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
	
	get_node("/root/Game/HUD/DebugLabel").text = String(motion.y)
	
	
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
		
		smoke_burst.emitting = true
		
		cant_move_timer += delta
		if cant_move_timer > 1.5:
			can_move = true
			cant_move_timer = 0
	else:
		smoke_burst.emitting = false		
		if !powerups[0]:

			motion.y -= delta * 8
			normal_flames.emitting = true
			nitro_flames.emitting = false
		else:

			nitro_flames.emitting = true
			normal_flames.emitting = false
			motion.y -= delta * 32
	
	
	
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

	if Input.is_action_pressed("powerup_0"):
		nitro_timer.start()
		powerups[0] = true
		Input.action_release("powerup_0")
	
	if Input.is_action_pressed("powerup_1"):
		xray_timer.start()
		powerups[1] = true
		Input.action_release("powerup_1")
		
	
	tilt = motion.x / 12
	motion.x = clamp(motion.x, -x_topSpeed, x_topSpeed)
	motion.y = clamp(motion.y, -999999, 0)
	
	motion = move_and_slide(motion, Vector2(0, -1))
	
	for index in get_slide_count():
		
		var collision = get_slide_collision(index)
		var body = collision.collider
		if body.existing:

			if body.type == 2 and can_move:
				if body.position.x <= self.position.x:
					motion.x += x_accel * 30
				else:
					motion.x = x_accel * 30
				
				motion.y += 10
				can_move = false
				print("smoosh")
			if body.type == 1:
				Input.action_press("powerup_" + String(body.power_up))
			
			body.queue_free()
	
	self.rotation_degrees = 0 + tilt
	
	

func on_NitroOut():
	powerups[0] = false

func on_XRayOut():
	powerups[1] = false


