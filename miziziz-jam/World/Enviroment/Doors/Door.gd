extends Node2D

export(int) var color
export(int) var level = 1
onready var animation_player = $AnimationPlayer
onready var player_stats = PlayerStats
onready var player_passed = $PlayerPassed/CollisionShape2D
onready var spawn_point = $SpawnPoint
onready var spawn_point_value
var door_code = {0: "yellow", 1: "blue", 2: "red"}

signal player_passed

func _ready():
	spawn_point_value = spawn_point.position + position
	player_passed.disabled = true
	animation_player.play("Idle")

func _on_PlayerEntered_area_entered(_area):
	if player_stats.contain_this_key(door_code[color]):
		animation_player.play("Open")
		player_passed.set_deferred("disabled", false)

func _on_PlayerPassed_area_entered(_area):
	player_stats.set_entered_door(color)
	emit_signal("player_passed", level)

func _on_PlayerEntered_area_exited(_area):
	if player_stats.contain_this_key(door_code[color]): animation_player.play("Close")
