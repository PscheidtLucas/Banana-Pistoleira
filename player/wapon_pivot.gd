extends Node2D

@onready var weapon: Weapon = $WeaponAnchor/Weapon
@onready var marker_2d: Marker2D = $WeaponAnchor/Weapon/Marker2D

@onready var gunshot: AudioStreamPlayer2D = %Gunshot
@onready var gunshot_2: AudioStreamPlayer2D = %Gunshot2
@onready var gunshot_3: AudioStreamPlayer2D = %Gunshot3
@onready var gunshot_4: AudioStreamPlayer2D = %Gunshot4
@onready var gunshot_5: AudioStreamPlayer2D = %Gunshot5
@export var gun_muzzles: Array[Sprite2D]

func _ready() -> void:
	weapon.shot_fired.connect(play_shot_sound)
	weapon.shot_fired.connect(play_muzzle_effect)

func play_shot_sound() -> void:
	var gunshots = [gunshot, gunshot_2, gunshot_3, gunshot_4, gunshot_5]
	for sound in gunshots:
		if not sound.playing:
			sound.play()
			return

func play_muzzle_effect() -> void:
	for child in gun_muzzles:
		child.show()
	await get_tree().create_timer(0.1).timeout
	for child in gun_muzzles:
		child.hide()

func _process(_delta: float) -> void:
	var aim_direction = marker_2d.global_position.direction_to(get_global_mouse_position())
	var pivot_to_mouse_dir := global_position.direction_to(get_global_mouse_position())
	
	if pivot_to_mouse_dir.length() > 0.1: # usamos 0.1 para evitar movimentos desnecessários
		rotation = pivot_to_mouse_dir.angle()
	# ajuste da posicao da arma e marker caso ele esteja rotacionado:
	if pivot_to_mouse_dir.x < - 0.2:
		weapon.flip_v = true
		weapon.position.y = -20
		marker_2d.position.y = 55
		for child in gun_muzzles:
			child.position.y = 60

	elif pivot_to_mouse_dir.x > 0.2 :
		weapon.flip_v = false
		weapon.position.y = 20
		marker_2d.position.y = -60
		for child in gun_muzzles:
			child.position.y = -56
	
	z_index = 3
	if pivot_to_mouse_dir.y < 0.0:
		z_index = -1
