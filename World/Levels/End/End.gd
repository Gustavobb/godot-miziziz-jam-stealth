extends Node2D

onready var player = PlayerStats

func _ready():
	player.set_entered_door(0)
	player.set_past_level(0)
	player.set_has_blue_key(false)
	player.set_has_yellow_key(false)
	player.set_has_red_key(false)
	player.set_has_lights_out(false)
	player.set_has_dash(false)
	player.set_has_slow_mo(false)
	player.set_has_double_jump(false)
	player.set_lights_out(false)
	player.set_lights_out_percentage(1.0)
	player.set_slow_mo_percentage(1.0)
	
func _input(event):
	if event.is_action_pressed("restart"): 
		$Select.play()
		SceneChange.change_scene("res://World/Levels/Level1.tscn", 0.5)
