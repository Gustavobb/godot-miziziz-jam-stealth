extends Node2D

var door_code = {0: "yellow", 1: "blue", 2: "red"}
var level_int = "" 
var found_player = false
onready var player_stats = PlayerStats
onready var player = $YSort/Player
onready var doors = $YSort/Doors

func _ready():
	_get_level_name()
	_spawn_player()
	_draw_keys()
	_draw_power()
	

func _spawn_player():
	for door in doors.get_children():
		if door.level == player_stats.past_level:
			player.position = door.spawn_point_value

func _get_level_name():
	for letter in str(get_name()):
		if letter.is_valid_integer():
			level_int = "%s%s"%[level_int, letter]
	
	level_int = int(level_int)
	
func _draw_keys():
	if player_stats.has_yellow_key and has_node("YSort/Keys/YellowKey"): $YSort/Keys/YellowKey.queue_free() 
	if player_stats.has_blue_key and has_node("YSort/Keys/BlueKey"): $YSort/Keys/BlueKey.queue_free() 
	if player_stats.has_red_key and has_node("YSort/Keys/RedKey"): $YSort/Keys/RedKey.queue_free() 
	
func _draw_power():
	if player_stats.has_double_jump and has_node("YSort/Powers/DoubleJumpPowerUp"): $YSort/Powers/DoubleJumpPowerUp.queue_free() 
	if player_stats.has_dash and has_node("YSort/Powers/DashPowerUp"): $YSort/Powers/DashPowerUp.queue_free() 
	if player_stats.has_slow_mo and has_node("YSort/Powers/SlowMoPowerUp"): $YSort/Powers/SlowMoPowerUp.queue_free() 

func _player_passed(level):
	if !found_player:
		player_stats.set_past_level(level_int)
		SceneChange.change_scene("res://World/Levels/Level%s.tscn"%str(level), 0.0)
		
func _on_YellowDoor_player_passed(level):
	_player_passed(level)

func _on_LaserSight_is_player():
	found_player = true
	$YSort/Player/Camera2D/ScreenShake.start()
	SceneChange.change_scene("res://World/Levels/Level%s.tscn"%str(level_int), 0.5)

func _on_Enemie_is_player():
	found_player = true
	$YSort/Player/Camera2D/ScreenShake.start()
	SceneChange.change_scene("res://World/Levels/Level%s.tscn"%str(level_int), 0.5)

func _on_BlueDoor_player_passed(level):
	_player_passed(level)
