extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cur_skin = 0

var frame
var skin_name
var collide_size
var collide_location

var nitro_flame
var normal_flame
var flame_out

var skins = [
	{
		"frame": 0,
		"name": "Default Rocket",
		"collision_size": Vector2(105.5, 189),
		"collision_location": Vector2(0, -5),
		"owned": true
	}
]

func _ready():
	var new_skin_worked = new_skin(cur_skin)
	if !new_skin_worked:
		new_skin(0)

func new_skin(index):
	if skins[index]["owned"]:
		frame = skins[index]["frame"]
		skin_name = skins[index]["name"]
		collide_size = skins[index]["collision_size"]
		collide_location = skins[index]["collision_location"]
		return true
	else:
		return false

