extends Node2D

export(int) var color
export(int) var level
onready var animation_player = $AnimationPlayer
onready var player_keys = PlayerStats
onready var player_passed = $PlayerPassed/CollisionShape2D
var open = false
var door_code = {0: "yellow", 1: "blue", 2: "red"}

func _ready():
	player_passed.disabled = true
	animation_player.play("Idle")

func _on_PlayerEntered_area_entered(_area):
	if !open and player_keys.contain_this_key(door_code[color]):
		animation_player.play("Open")
		player_passed.set_deferred("disabled", false)
		open = true

func _on_PlayerPassed_area_entered(_area):
	print("Passou")
