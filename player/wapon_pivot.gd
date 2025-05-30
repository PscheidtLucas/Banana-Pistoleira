extends Node2D

@onready var weapon: Weapon = $WeaponAnchor/Weapon
@onready var marker_2d: Marker2D = $WeaponAnchor/Weapon/Marker2D


func _process(_delta: float) -> void:
	var aim_direction := Vector2.ZERO
	aim_direction = global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1: # usamos 0.1 para que evitar movimentos desnecessários
		rotation = aim_direction.angle()

	if aim_direction.x < 0.0:
		weapon.flip_v = true
		weapon.position.y = 20
		marker_2d.position.y = 24
	else:
		weapon.flip_v = false
		weapon.position.y = 0
		marker_2d.position.y = 0
	
	z_index = 3
	if aim_direction.y < 0.0:
		z_index = -1
