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

var hit = false

onready var player = get_node("../Player")
onready var sprite = get_node("Sprite")
onready var collide = get_node("CollisionShape2D")

onready var contact_particles = get_node("Contact")
onready var powerup_particles = get_node("PowerupParticle")

onready var xray = $XRayOverlay


func reload_asteroid():
	motion.x = 0
	hit = false
	rng.randomize()

	position.x = player.position.x + rng.randi_range(-GameInfo.screen_size.x,GameInfo.screen_size.x)
	

	speed = player.y_Speed
	angle_speed = rng.randf_range(15, 30)
	
	size = rng.randi_range(0, 1)
	if size == 0:
		collide.shape.extents = Vector2(250, 250)
	elif size == 1:
		collide.shape.extents = Vector2(200, 200)
	elif size == 2:
		collide.shape.extents = Vector2(150, 150)
	
	if size == 0:
		sprite.frame_coords.y = 0
		xray.scale = Vector2(2.5, 2.5)
	elif size == 1:
		sprite.frame_coords.y = rng.randi_range(1, 2)
		xray.scale = Vector2(2, 2)
	elif size == 2:
		sprite.frame_coords.y = 3	
		xray.scale = Vector2(1.5, 1.5)	
		

	if rng.randi_range(0, 100) > 60:
		type = 2
		sprite.frame_coords.x = 1

	else:
		sprite.frame_coords.x = 0
		if rng.randi_range(0, 100) > 75:
			type = 1
			power_up = rng.randi_range(0, 2)
		else:
			type = 0
	
	xray.frame_coords.y = type
	sprite.show()
# Called when the node enters the scene tree for the first time.
func _ready():
	reload_asteroid()

	


func _physics_process(delta):	
	motion.y = speed
	speed = player.y_Speed

	if player.powerups[1] and !hit:
		xray.show()
		
	else:
		xray.hide()

	self.rotation_degrees += angle_speed * delta
	if self.rotation_degrees >= 360:
		self.rotation_degrees = 0


	motion = move_and_slide(motion)
	
	for index in get_slide_count():
		
		var collision = get_slide_collision(index)
		var body = collision.collider
		if body.name == "Player" and !hit:
			hit = true
			Input.action_press("startscreenshake")


			if type == 2 and body.can_move:
				if !body.powerups[2]:
					body.lives += -1
					print(body.lives)
					body.can_move = false
					if body.position.x <= position.x:
						body.motion.x += -body.x_accel * 30
					else:
						body.motion.x = body.x_accel * 30
					body.y_Speed -= 60
				else:
					position.y = -0.3 * GameInfo.screen_size.y
					reload_asteroid()
					body.y_Speed -= 5
					contact_particles.emitting = true
					

				
			if type == 1 or type == 0:
				body.asteroids_hit += 1
				contact_particles.emitting = true
				body.y_Speed += -5
				if type == 1:
					powerup_particles.emitting = true
					Input.action_press("powerup_" + String(power_up))
				sprite.hide()
	
	if position.y > GameInfo.screen_size.y * 1.2:
		position.y = -0.5 * GameInfo.screen_size.y
		reload_asteroid()
	
	if contact_particles.emitting == false and hit:
		position.y = -0.3 * GameInfo.screen_size.y
		reload_asteroid()
	
						
