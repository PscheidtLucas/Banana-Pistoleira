extends Label

@onready var player: Player = %Player


func _ready() -> void:
	text = str(player.health)
	player.update_health.connect(func(new_health)->void:
		text = str(new_health))
