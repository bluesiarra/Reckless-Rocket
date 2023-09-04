extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var rng = RandomNumberGenerator.new()

export var type = -1
export var power_up = 0

export var existing = true

var angle_speed 

var start_pos

onready var player = get_node("../Player")
onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	position.x = player.position.x + rng.randi_range(-GameInfo.screen_size.x, GameInfo.screen_size.x)
	position.y = player.position.y - GameInfo.screen_size.y
	
	angle_speed = rng.randf_range(0.5, 2.5)
	
	start_pos = position
	
	
	
	if rng.randi_range(0, 100) > 50:
		type = 2
		sprite.frame = 1
	else:
		if rng.randi_range(0, 100) > 75:
			type = 1
			power_up = 0
		else:
			sprite.frame = 0

		

	


func _physics_process(delta):
	#if player.powerups[1]:
		
	
	self.rotation_degrees += angle_speed
	if self.rotation_degrees >= 360:
		self.rotation_degrees = 0
	
	
	if position.y > GameInfo.screen_size.y * 1.5 or !existing:
		queue_free()
	
			
	
						
