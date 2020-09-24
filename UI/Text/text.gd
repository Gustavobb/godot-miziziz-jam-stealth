extends Sprite

func _ready():
	visible = true if !PlayerStats.has_dash else false
