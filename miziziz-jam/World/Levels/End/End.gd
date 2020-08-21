extends Node2D

func _input(event):
	if event.is_action_pressed("restart"): 
		$Select.play()
		SceneChange.change_scene("res://World/Levels/Level1.tscn", 0.5)
