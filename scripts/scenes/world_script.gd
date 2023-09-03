extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0

onready var player = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	var new_asteroid = load("res://objects/Asteroid.tscn").instance()
	add_child(new_asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta
	
	if counter * player.y_Speed > 500:
		counter = 0
		var new_asteroid = load("res://objects/Asteroid.tscn").instance()
		add_child(new_asteroid)

