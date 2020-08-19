extends Node2D

export(int) var DASH_POWER = 800
const ghost_sprite = preload("res://Effects/GhostSprite.tscn")

onready var dash_timer = $DashTimer
onready var ghost_timer = $GhostTimer
onready var dash_cooldown = $DashCooldown
onready var player = get_parent()
onready var has_dash = PlayerStats.has_dash

var is_dashing = false
var can_dash = true

func apply_dash():
	ghost_timer.start()
	dash_timer.start()
	is_dashing = true
	can_dash = false
	player.velocity.x = -DASH_POWER if player.sprite.flip_h else DASH_POWER

func _on_DashTimer_timeout():
	player.velocity.x = 0
	is_dashing = false
	dash_cooldown.start()
	ghost_timer.stop()

func _on_DashCooldown_timeout():
	can_dash = true

func _on_GhostTimer_timeout():
	var ghost_sprite_instance = ghost_sprite.instance()
	get_parent().add_child(ghost_sprite_instance)
	ghost_sprite_instance.frame = player.sprite.frame
	ghost_sprite_instance.flip_h = player.sprite.flip_h
	ghost_sprite_instance.scale.y = player.sprite.scale.y
	ghost_sprite_instance.position = self.position
