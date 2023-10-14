extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0

signal game_done


onready var player = get_node("Player")
onready var game_timer = get_node("GameTimer")

onready var battery_shell = get_node("/root/Game/HUD/BatteryShell")
onready var battery_1 = get_node("/root/Game/HUD/BatteryShell/Sec1")
onready var battery_2 = get_node("/root/Game/HUD/BatteryShell/Sec2")
onready var battery_3 = get_node("/root/Game/HUD/BatteryShell/Sec3")

onready var hud_time_label = get_node("/root/Game/HUD/TimeLabel")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if GameInfo.game_mode == "timed":
		game_timer.connect("timeout", self, "gametimer_done")
		game_timer.start()
		hud_time_label.show()
		battery_shell.hide()
		battery_1.hide()
		battery_2.hide()
		battery_3.hide()
	elif GameInfo.game_mode == "lives":
		hud_time_label.hide()
		battery_shell.show()
		battery_1.show()
		battery_2.show()
		battery_3.show()
		player.lives = 3
		
func end_game():
	PreviousGameInfo.y_Speed = player.y_Speed
	PreviousGameInfo.asteroids_hit = player.asteroids_hit
	emit_signal("game_done")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Send player speed to HUD
	get_node("/root/Game/HUD/SpeedLabel").text = String(int(round(player.y_Speed))) + " m/s"
	get_node("/root/Game/HUD/AsteroidLabel").text = String(int(round(player.asteroids_hit)))
	if GameInfo.game_mode == "timed":
		if game_timer.time_left == 60:
			hud_time_label.text = "01:" + String(int(round(game_timer.time_left - 60)))
		elif game_timer.time_left < 60 and game_timer.time_left > 10:
			hud_time_label.text = "00:" + String(int(round(game_timer.time_left)))
		else:
			hud_time_label.text = String(int(round(game_timer.time_left))) + "s"
	elif GameInfo.game_mode == "lives":
		battery_1.hide()
		battery_2.hide()
		battery_3.hide()
		if player.lives >= 1:
			battery_1.show()
			if player.lives >= 2:
				battery_2.show()
				if player.lives >= 3:
					battery_3.show()
		else:
			end_game()
func gametimer_done():
	end_game()
