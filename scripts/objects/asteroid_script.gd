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

var size

var start_x = 0

onready var player = get_node("../Player")
onready var sprite = $Sprite
onready var collide = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	
	position.x = player.position.x + rng.randi_range(-GameInfo.screen_size.x, GameInfo.screen_size.x)
	start_x = position.x
	position.y = -0.5 * GameInfo.screen_size.y
	
	speed = player.y_Speed
	angle_speed = rng.randf_range(0.5, 2.5)
	
	size = rng.randi_range(0, 1)
	if size == 0:
		collide.shape.extents = Vector2(250, 250)
	elif size == 1:
		collide.shape.extents = Vector2(200, 200)
	
	sprite.frame_coords.y = size
		
	
	if rng.randi_range(0, 100) > 50:
		type = 2
		sprite.frame_coords.x = 1
		
	else:
		type = rng.randi_range(0, 1)
		sprite.frame_coords.x = 0
		if rng.randi_range(0, 100) > 75:
			type = 1
			power_up = 0
		else:
			type = 0
	
	sprite.show()

	


func _physics_process(delta):	
	motion.y = speed
	position.x = start_x
	
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
				Input.action_press("powerup_" + String(power_up))
			queue_free()
	
	if position.y > GameInfo.screen_size.y * 1.5:
		queue_free()
	
			
	
						
