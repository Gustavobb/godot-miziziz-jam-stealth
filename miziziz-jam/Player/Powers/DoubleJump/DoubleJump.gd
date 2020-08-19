extends Node2D
onready var has_double_jump = PlayerStats.has_double_jump
onready var parent = get_parent()
var double_jump = false

func _ready():
	var _connect = PlayerStats.connect("has_double_jump_changed", self, "_update_power")
	
func apply_double_jump():
	parent.velocity.y = parent.JUMP_HEIGHT * 0.8

func _update_power():
	has_double_jump = PlayerStats.has_double_jump
