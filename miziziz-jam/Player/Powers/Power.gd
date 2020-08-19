extends Node2D

export(int) var power
onready var animation_player = $AnimationPlayer
onready var player_stats = PlayerStats
var power_code = {0: "double_jump", 1: "dash", 2: "slow_mo", 3: "lights_out"}

func _ready():
	animation_player.play("Idle")

func _on_Area2D_area_entered(_area):
	animation_player.play("Catch")
	player_stats.got_power(power_code[power])

func _on_pickup_animation_finished():
	queue_free()
