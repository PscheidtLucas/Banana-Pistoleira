class_name Coracao extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.health < 5 and body.health > 0:
		body.health += 1
		body.update_health.emit(body.health)
		queue_free()
