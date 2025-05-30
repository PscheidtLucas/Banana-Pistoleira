class_name Weapon extends Node2D

@export var bullet_scene: PackedScene

# Ângulo de spread da arma, quanto maior, mais imprecisa é a arma
@export_range(0.0, 360.0, 1.0, "radians_as_degrees") var random_angle := PI / 12.0

@export_range(100.0, 2000.0, 1.0) var max_range := 200.0
@export_range(100.0, 3000.0, 1.0) var max_bullet_speed := 1500.0
@onready var marker_2d: Marker2D = $Marker2D


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
			shoot()


# Faz a arma atirar uma vez, essa função é sobrescrita quando precisa de um comportamente diferente
func shoot() -> void:
	var bullet: Node = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = marker_2d.global_position
	bullet.global_rotation = marker_2d.global_rotation
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)
