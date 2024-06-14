extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AsteroidsHitLabel.text = String(PreviousGameInfo.asteroids_hit) + " hit"
	$SpeedLabel.text = String(round(PreviousGameInfo.y_Speed)) + " m/s"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
