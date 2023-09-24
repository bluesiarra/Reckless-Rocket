extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0


var new_asteroid = preload("res://objects/Asteroid.tscn")
#var instanced = new_asteroid.instance()
onready var player = get_node("Player")
onready var game_timer = get_node("GameTimer")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.call_deferred("add_child", new_asteroid.instance())
	
	game_timer.connect("timeout", self, "gametimer_done")
	game_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	counter += delta
	if counter * player.y_Speed > 900:
		counter = 0
		self.call_deferred("add_child", new_asteroid.instance())

func gametimer_done():
	print(player.y_Speed)

#173
#183
