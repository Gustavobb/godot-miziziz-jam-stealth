extends Node

var has_yellow_key = false setget set_has_yellow_key
var has_blue_key = false setget set_has_blue_key
var has_red_key = false setget set_has_red_key

signal yellow_key_changed
signal blue_key_changed
signal red_key_changed

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

func got_key(key_color):
	if key_color == "yellow": set_has_yellow_key(true)
	elif key_color == "red": set_has_red_key(true)
	elif key_color == "blue": set_has_blue_key(true)
