extends Control

var player_powers = PlayerStats
onready var dash = $HBoxContainer/VBoxContainer/Dash
onready var double_jump = $HBoxContainer/VBoxContainer/DoubleJump
onready var slow_mo = $HBoxContainer/VBoxContainer/SlowMo
onready var lights_out = $HBoxContainer/VBoxContainer/LightsOut
onready var slow_mo_pb = $HBoxContainer/VBoxContainer2/SlowMoProgressBar
onready var lights_out_pb = $HBoxContainer/VBoxContainer2/LightsOutProgressBar

func _ready():
	var _connection = player_powers.connect("has_dash_changed", self, "dash_power_update")
	_connection = player_powers.connect("has_double_jump_changed", self, "double_jump_power_update")
	_connection = player_powers.connect("has_slow_mo_changed", self, "slow_mo_power_update")
	_connection = player_powers.connect("has_lights_out_changed", self, "lights_out_power_update")
	dash.visible = true if player_powers.has_dash else false
	double_jump.visible = true if player_powers.has_double_jump else false
	slow_mo.visible = true if player_powers.has_slow_mo else false
	lights_out.visible = true if player_powers.has_lights_out else false
	slow_mo_pb.visible = true if slow_mo.visible else false
	lights_out_pb.visible = true if lights_out.visible else false
	
func dash_power_update():
	dash.visible = true if player_powers.has_dash else false

func double_jump_power_update():
	double_jump.visible = true if player_powers.has_double_jump else false

func slow_mo_power_update():
	slow_mo.visible = true if player_powers.has_slow_mo else false
	slow_mo_pb.visible = true if slow_mo.visible else false

func lights_out_power_update():
	lights_out.visible = true if player_powers.has_lights_out else false
	lights_out_pb.visible = true if lights_out.visible else false
