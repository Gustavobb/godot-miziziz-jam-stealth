extends Node2D

export(int) var color
onready var animation_player = $AnimationPlayer
onready var player_stats = PlayerStats
var key_code = {0: "yellow", 1: "blue", 2: "red"}

func _ready():
	animation_player.play("Idle")

func _on_Area2D_area_entered(_area):
	animation_player.play("Catch")
	player_stats.got_key(key_code[color])

func _on_pickup_animation_finished():
	queue_free()
