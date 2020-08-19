extends Node

var has_yellow_key = false setget set_has_yellow_key
var has_blue_key = false setget set_has_blue_key
var has_red_key = false setget set_has_red_key
var past_level = 2 setget set_past_level
var entered_door = 0 setget set_entered_door

var has_dash = false setget set_has_dash
var has_double_jump = false setget set_has_double_jump
var has_slow_mo = false setget set_has_slow_mo

signal yellow_key_changed
signal blue_key_changed
signal red_key_changed
signal has_dash_changed
signal has_double_jump_changed
signal has_slow_mo_changed

func set_has_dash(value):
	has_dash = value
	emit_signal("has_dash_changed")

func set_has_double_jump(value):
	has_double_jump = value
	emit_signal("has_double_jump_changed")
	
func set_has_slow_mo(value):
	has_slow_mo = value
	emit_signal("has_slow_mo_changed")
	
func set_past_level(value):
	past_level = value
	
func set_entered_door(value):
	entered_door = value
	
func set_has_yellow_key(value):
	has_yellow_key = value
	emit_signal("yellow_key_changed")

func set_has_blue_key(value):
	has_blue_key = value
	emit_signal("blue_key_changed")
	
func set_has_red_key(value):
	has_red_key = value
	emit_signal("red_key_changed")
	
func contain_this_key(key_color):
	if key_color == "yellow": return has_yellow_key
	elif key_color == "red": return has_red_key
	elif key_color == "blue": return has_blue_key
	
func contain_this_power(power):
	if power == "double_jump": return has_double_jump
	elif power == "dash": return has_dash
	elif power == "slow_mo": return has_slow_mo
	elif power == "lights_out": return has_slow_mo

func got_key(key_color):
	if key_color == "yellow": set_has_yellow_key(true)
	elif key_color == "red": set_has_red_key(true)
	elif key_color == "blue": set_has_blue_key(true)

func got_power(power):
	if power == "double_jump": set_has_double_jump(true)
	elif power == "dash": set_has_dash(true)
	elif power == "slow_mo": set_has_slow_mo(true)
	elif power == "lights_out": set_has_slow_mo(true)
