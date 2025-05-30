extends Weapon

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(func()-> void:
		shoot())

# Reescrevemos a função physics process para não atirar quando é pressionado o botão do mouse, porque extendemos de Weapon
func _physics_process(delta: float) -> void:
	pass

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate() 
	

	bullet.global_position = marker_2d.global_position
	bullet.global_rotation = marker_2d.global_rotation
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)
	bullet.targets_player = true
	
	get_tree().current_scene.add_child(bullet)
