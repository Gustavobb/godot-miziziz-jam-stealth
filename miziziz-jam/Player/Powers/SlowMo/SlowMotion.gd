extends Node2D

onready var cooldown = $Cooldown
onready var duration_timer = $Duration
onready var has_slow_mo = PlayerStats.has_slow_mo
onready var slow_mo_audio = $SlowMo
onready var player_stats = PlayerStats
const END_VALUE = 1
var is_active = false
var time_start
var duration_ms
var cooldown_sec = 20.0
var start_value

func apply_slow():
	start()
	
func start(duration = 6, strenght = 0.6):
	if player_stats.slow_mo_percentage > 0.15:
		if !is_active:
			slow_mo_audio.play()
			duration_timer.start(2.5 * player_stats.slow_mo_percentage)
			time_start = OS.get_ticks_msec()
			duration_ms = int(duration * player_stats.slow_mo_percentage * 1000)
			start_value = 1 - strenght
			Engine.time_scale = start_value
		
		else:
			Engine.time_scale = END_VALUE
			cooldown.start(cooldown_sec * (1 - player_stats.slow_mo_percentage))
			get_parent().undo.play()
			
		is_active = not is_active
	
func _physics_process(_delta):
	if !cooldown.is_stopped():
			player_stats.set_slow_mo_percentage(stepify((0.01 + cooldown_sec - cooldown.get_time_left())/cooldown_sec, 0.01))
			
	if is_active:
		if !duration_timer.is_stopped():
			#print(stepify(1 - (0.01 + 2.5 - duration_timer.get_time_left())/2.5, 0.01))
			player_stats.set_slow_mo_percentage(stepify(1 - (0.01 + 2.5 - duration_timer.get_time_left())/2.5, 0.01))
			
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			cooldown.start(cooldown_sec * (1 - player_stats.slow_mo_percentage))
			is_active = false
			value = END_VALUE
			
		Engine.time_scale = value

func circl_ease_in(t, b, c, d):
	t /= d
	t -= 1
	return c * sqrt(1 - t * t) + b;
	
func _ready():
	Engine.time_scale = 1
	var _connect = player_stats.connect("has_slow_mo_changed", self, "_update_power")
	if player_stats.slow_mo_percentage < 1:
		cooldown.start(cooldown_sec * (1 - player_stats.slow_mo_percentage))

func _on_Cooldown_timeout():
	is_active = false

func _update_power():
	has_slow_mo = player_stats.has_slow_mo
