extends Weapon

@onready var timer: Timer = $Timer
@onready var array_of_fires : Array[Sprite2D] = [$Marker2D/Sprite2D,$Marker2D/Sprite2D2,$Marker2D/Sprite2D3]

func _ready() -> void:
	randomize()
	timer.wait_time += randf_range(-0.5, 0.5)
	timer.start()
	timer.timeout.connect(func()-> void:
		shoot())

# Reescrevemos a função physics process para não atirar quando é pressionado o botão do mouse, porque extendemos de Weapon
func _physics_process(delta: float) -> void:
	pass

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate() 
	bullet.scale *= 1.5
	bullet.modulate = Color.SADDLE_BROWN
	bullet.global_position = marker_2d.global_position
	bullet.global_rotation = marker_2d.global_rotation
	bullet.max_range = max_range * 2
	bullet.speed = max_bullet_speed / 2
	bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)
	bullet.targets_player = true
	
	get_tree().current_scene.add_child(bullet)
	
	for sprite in array_of_fires:
		sprite.show()
	await get_tree().create_timer(0.13).timeout
	for sprite in array_of_fires:
		sprite.hide()
		
	
