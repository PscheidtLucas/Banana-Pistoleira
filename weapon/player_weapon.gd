class_name PlayerWeapon extends Weapon

@export var spread_decay_time: float = 0.5 # tempo que leva pra "resetar" a precisão
@export var extra_spread_per_shot: float = 0.1 # o quanto aumenta a imprecisão por tiro rápido
@export var max_extra_spread: float = 0.6 # limite máximo de spread acumulado

var current_extra_spread: float = 0.0
var last_shot_time: float = -999.0


func shoot() -> void:
	var now := Time.get_ticks_msec() / 1000.0 # segundos
	if now - last_shot_time < spread_decay_time:
		# atirou rápido demais → aumenta spread
		current_extra_spread = clamp(current_extra_spread + extra_spread_per_shot, 0.0, max_extra_spread)
	else:
		# passou tempo suficiente → reseta
		current_extra_spread = 0.0

	last_shot_time = now

	shot_fired.emit()
	var bullet: Bullet = bullet_scene.instantiate()

	bullet.global_position = marker_2d.global_position
	bullet.global_rotation = marker_2d.global_rotation
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	
	# aplica spread base + spread acumulado
	var total_spread := current_extra_spread
	bullet.rotation += randf_range(-total_spread / 2.0, total_spread / 2.0)

	bullet.targets_player = false
	get_tree().current_scene.add_child(bullet)
