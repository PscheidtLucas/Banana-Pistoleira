class_name Destructible extends CharacterBody2D

var health: int = 3

func _ready() -> void:
	pass
	
func take_damage(amount: int):
	print("caixa tomou dano")
	health -= amount
	if health <= 0:
		queue_free()
