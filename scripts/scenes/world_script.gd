extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0

signal game_done

var new_asteroid = preload("res://objects/Asteroid.tscn")

onready var player = get_node("Player")
onready var game_timer = get_node("GameTimer")

onready var hud_time_label = get_node("/root/Game/HUD/TimeLabel")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.call_deferred("add_child", new_asteroid.instance())
	
	if GameInfo.game_mode == "timed":
		game_timer.connect("timeout", self, "gametimer_done")
		game_timer.start()
		hud_time_label.show()

	hud_time_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Send player speed to HUD
	get_node("/root/Game/HUD/SpeedLabel").text = String(int(round(player.y_Speed))) + " m/s"
	if GameInfo.game_mode == "timed":
		if game_timer.time_left == 60:
			hud_time_label.text = "01:" + String(int(round(game_timer.time_left - 60)))
		elif game_timer.time_left < 60 and game_timer.time_left > 10:
			hud_time_label.text = "00:" + String(int(round(game_timer.time_left)))
		else:
			hud_time_label.text = String(int(round(game_timer.time_left))) + "s"
		
	counter += delta
	if counter * player.y_Speed > 900:
		counter = 0
		new_asteroid.call_deferred("instance")


func gametimer_done():
	PreviousGameInfo["y_Speed"] = player.y_Speed
	emit_signal("game_done")
