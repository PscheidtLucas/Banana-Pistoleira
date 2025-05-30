class_name Destructible extends StaticBody2D

var health: int = 3

func _ready() -> void:
	pass
	
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
