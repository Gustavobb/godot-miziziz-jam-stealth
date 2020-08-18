extends "res://Effects/Particles/Particle.gd"

var initial_y_direction
onready var parent = get_parent()

func _ready():
	initial_y_direction = get_process_material().direction.y
	
func create_particle():
	.create_particle()
	get_process_material().direction.y = -initial_y_direction if parent.rotation_degrees == 180 else initial_y_direction
