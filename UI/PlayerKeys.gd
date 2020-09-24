extends Control

var player_keys = PlayerStats
onready var yellow_key = $MarginContainer/VBoxContainer/YellowKey
onready var blue_key = $MarginContainer/VBoxContainer/BlueKey
onready var red_key = $MarginContainer/VBoxContainer/RedKey

func _ready():
	var _connection = player_keys.connect("blue_key_changed", self, "blue_key_update")
	_connection = player_keys.connect("yellow_key_changed", self, "yellow_key_update")
	_connection = player_keys.connect("red_key_changed", self, "red_key_update")
	yellow_key.visible = true if player_keys.has_yellow_key else false
	blue_key.visible = true if player_keys.has_blue_key else false
	red_key.visible = true if player_keys.has_red_key else false

func blue_key_update():
	blue_key.visible = true if player_keys.has_blue_key else false

func yellow_key_update():
	yellow_key.visible = true if player_keys.has_yellow_key else false

func red_key_update():
	red_key.visible = true if player_keys.has_red_key else false
