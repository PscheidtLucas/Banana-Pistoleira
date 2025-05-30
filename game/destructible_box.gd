class_name Destructible extends CharacterBody2D

var health: int = 3
const CORACAO = preload("res://game/coracao.tscn")


func take_damage(amount: int):
	print("caixa tomou dano")
	health -= amount
	if health <= 0:
		var health_drop := CORACAO.instantiate()
		health_drop.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", health_drop)
		queue_free()
