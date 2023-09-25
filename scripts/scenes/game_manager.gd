extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var world = $World

# Called when the node enters the scene tree for the first time.
func _ready():
	world.connect("game_done", self, "on_gamedone")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_gamedone():
	get_tree().change_scene("res://scenes/game_over.tscn")
