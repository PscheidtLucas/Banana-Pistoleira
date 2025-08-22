class_name Coracao extends Area2D

var picked: bool = false

func _on_body_entered(body: Node2D) -> void:
	if picked:
		return
	if body is Player and body.health < 5 and body.health > 0:
		picked = true
		body.health += 1
		body.update_health.emit(body.health)
		$HelathPickup.play()
		$Sprite2D.hide()
		await get_tree().create_timer(1).timeout
		queue_free()
