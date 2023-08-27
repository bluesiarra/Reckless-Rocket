extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var rng = RandomNumberGenerator.new()

var type 
var power_up = 0

var motion = Vector2.ZERO

var angle_speed 
var speed

var start_pos

onready var player = get_node("../Player")
onready var sprite = $Sprite

var powerup_asteroids = ["res://art/objects/asteroids/powerup/size256.png"]
var weak_asteroids = ["res://art/objects/asteroids/weak/size256.png"]
var strong_asteroids = ["res://art/objects/asteroids/strong/size256.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng.randomize()
	
	position.x = player.position.x + rng.randi_range(-GameInfo.screen_size.x, GameInfo.screen_size.x)
	position.y = -0.5 * GameInfo.screen_size.y
	
	speed = player.y_Speed
	angle_speed = rng.randf_range(0.5, 1.5)
	
	start_pos = position
	
	
	
	if rng.randi_range(0, 100) > 20:
		type = 2
	else:
		type = rng.randi_range(0, 1)
	type = rng.randi_range(0, 2) #0 is weak, 1 is strong 2 is powerup
	


	
	if type == 1:
		power_up = 1
		#power_up = rng.randi_range(1, 3) #1 is nitro, 2 is xray, 3 is force
		sprite.texture = load(powerup_asteroids[rng.randi_range(0, len(powerup_asteroids) - 1)])
	
	if type == 0:
		speed = speed * 1.2
	
	if type == 2:
		speed = speed * 0.8
		sprite.texture = load(strong_asteroids[rng.randi_range(0, len(strong_asteroids) - 1)])



func _process(delta):
	speed = player.y_Speed
	position.x = start_pos.x
	motion.y = speed
	
	self.rotation_degrees += angle_speed
	if self.rotation_degrees >= 360:
		self.rotation_degrees = 0
	motion = move_and_slide(motion)
	

	
	for index in get_slide_count():
		
		var collision = get_slide_collision(index)
		var body = collision.collider
		if body.name == "Player":
			if type == 0:
				body.y_Speed += -5

			if type == 2 and body.can_move:
				if body.position.x <= self.position.x:
					body.motion.x += -body.x_accel * 30
				else:
					body.motion.x = body.x_accel * 30
				
				body.y_Speed -= 60
				body.can_move = false
			if type == 1:
				body.y_Speed += -5
				body.powerups_timer[power_up - 1] = true
			
			queue_free()
	
	if position.y > GameInfo.screen_size.y * 1.5:
		queue_free()
	
			
	
						
