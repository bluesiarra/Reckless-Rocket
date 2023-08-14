extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta
	
	if counter >= 2:
		counter = 0
		var new_asteroid = load("res://objects/Asteroid.tscn").instance()
		var loaded_asteroid = add_child(new_asteroid)
		print(loaded_asteroid)
