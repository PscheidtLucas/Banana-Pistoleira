extends Node2D

func _process(_delta: float) -> void:
	var aim_direction := Vector2.ZERO
	aim_direction = global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1: # usamos 0.1 para que evitar movimentos desnecessários
		rotation = aim_direction.angle()

	z_index = 3
	if aim_direction.y < 0.0:
		z_index = 1
