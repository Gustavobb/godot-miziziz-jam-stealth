extends Node2D

onready var ray = $RayCast2D
onready var line = $Line2D
onready var work_timer = $Work
onready var stop_working_timer = $Stop
onready var siren = $Siren

export(float) var stop_working_time = 0
export(float) var work_time = 0

signal is_player
signal hit
signal stop_working
signal work

var collision_mask_cache

func _ready():
	ray.enabled = true
	work_timer.start(work_time)

func _physics_process(_delta):
	if ray.is_colliding(): 
		var mask_name = ray.get_collider().name
		if collision_mask_cache != mask_name:
			if mask_name == "Player":
				siren.play()
				emit_signal("is_player")
			emit_signal("hit", ray.get_collision_point())
			
		collision_mask_cache = mask_name

func _on_LaserSight_hit(point):
	line.set_point_position(1, Vector2(0, sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))))

func _on_Stop_timeout():
	emit_signal("work")
	work_timer.start(work_time)

func _on_Work_timeout():
	emit_signal("stop_working")
	stop_working_timer.start(stop_working_time)

func _on_LaserSight_stop_working():
	ray.set_deferred("enabled", false)
	line.set_point_position(1, Vector2.ZERO)
	collision_mask_cache = null

func _on_LaserSight_work():
	ray.set_deferred("enabled", true)
