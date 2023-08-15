extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var screen_size = get_viewport().get_visible_rect().size

var rng = RandomNumberGenerator.new()

var type 
var power_up = 0

var motion = Vector2.ZERO

var angle_speed 
var speed

var start_pos

onready var player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng.randomize()
	
	position.x = player.position.x + rng.randi_range(-screen_size.x/2, screen_size.x/2)
	position.y = -0.5 * screen_size.y
	
	speed = player.y_Speed
	
	start_pos = position
	
	angle_speed = rng.randf_range(0.5, 1.5)

	type = rng.randi_range(0, 2) #0 is weak, 1 is strong 2 is powerup
	
	if type == 2:
		power_up = rng.randi_range(1, 3) #1 is nitro, 2 is xray, 3 is force
	
	if type == 0:
		speed = speed * 1.2
	
	if type == 1:
		speed = speed * 0.8




func _process(delta):
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
				queue_free()
			if type == 1:
				if body.position.x <= self.position.x:
					body.motion.x = -abs(body.motion.x) * 4
				else:
					body.motion.x = abs(body.motion.x) * 4
				body.can_move = false
	
	if position.y > screen_size.y * 1.5:
		queue_free()
	
			
	
						
