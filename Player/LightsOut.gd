extends Node2D

onready var has_lights_out = PlayerStats.has_lights_out
onready var cooldown = $Cooldown
onready var duration = $Duration
onready var lights_out_sound = $LightsOut
onready var player_stats = PlayerStats
var is_lights_out = false
var cooldown_sec = 30.0
var duration_sec = 3.0

func _ready():
	var _connect = player_stats.connect("has_lights_out_changed", self, "_update_power")
	if player_stats.lights_out_percentage < 1:
		cooldown.start(cooldown_sec * (1 - player_stats.lights_out_percentage))

func _physics_process(_delta):
	if !cooldown.is_stopped():
		player_stats.set_lights_out_percentage(stepify((0.01 + cooldown_sec - cooldown.get_time_left())/cooldown_sec, 0.01))
	
	if !duration.is_stopped():
		player_stats.set_lights_out_percentage(stepify(1 - (0.01 + duration_sec - duration.get_time_left())/duration_sec, 0.01))
	
func _update_power():
	has_lights_out = player_stats.has_lights_out

func apply_lights_out():
	if player_stats.lights_out_percentage > 0.15:
		if !is_lights_out:
			lights_out_sound.play()
			duration.start(duration_sec * player_stats.lights_out_percentage)
			cooldown.stop()
			player_stats.set_lights_out(true)
		
		else:
			get_parent().undo.play()
			cooldown.start(cooldown_sec * (1 - player_stats.lights_out_percentage))
			player_stats.set_lights_out(false)
			duration.stop()
			
		is_lights_out = not is_lights_out
	
func _on_Cooldown_timeout():
	is_lights_out = false

func _on_Duration_timeout():
	cooldown.start(cooldown_sec * (1 - player_stats.lights_out_percentage))
	player_stats.set_lights_out(false)
