extends Node2D

onready var animation_player = $AnimationPlayer
onready var player_stats = PlayerStats

signal game_finished

func _ready():
	animation_player.play("Idle")

func _on_Area2D_area_entered(_area):
	animation_player.play("Catch")
	emit_signal("game_finished")

func _on_pickup_animation_finished():
	queue_free()
