extends TextureProgress
onready var player_stats = PlayerStats
var p_percentage
export(int, "light", "slow") var type

func _ready():
	p_percentage = player_stats.lights_out_percentage if !type else player_stats.slow_mo_percentage
	value = p_percentage * (max_value - 0.1 * max_value)
	
func _physics_process(_delta):
	p_percentage = player_stats.lights_out_percentage if !type else player_stats.slow_mo_percentage
	if p_percentage != 0 and p_percentage != 1:
		value = p_percentage * (max_value - 0.1 * max_value)
