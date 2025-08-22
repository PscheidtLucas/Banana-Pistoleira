extends Camera2D

@export var shake_decay: float = 5.0 # velocidade que o shake desaparece
@export var max_offset: float = 20.0 # deslocamento máximo em pixels
@export var max_roll: float = 0.05 # rotação máxima em radianos

var trauma: float = 0.0
var trauma_power: float = 2.0 # curva do efeito

@onready var weapon: Weapon = $"../WaponPivot/WeaponAnchor/Weapon"
@onready var player: Player = $".."


func _ready() -> void:
	weapon.shot_fired.connect(func(): add_trauma(0.65))
	player.took_damage.connect(func(): add_trauma(2.8))
	player.hat_back.connect(func(): add_trauma(0.7))
	Signals.hat_hit.connect(func(): add_trauma(0.65))


func _process(delta: float) -> void:
	if trauma > 0:
		trauma = max(trauma - shake_decay * delta, 0)
		var amount := pow(trauma, trauma_power)

		# valores aleatórios entre -1 e 1
		var rand_x := randf_range(-1.0, 1.0)
		var rand_y := randf_range(-1.0, 1.0)
		var rand_rot := randf_range(-1.0, 1.0)

		offset = Vector2(rand_x, rand_y) * max_offset * amount
		rotation = rand_rot * max_roll * amount
	else:
		offset = Vector2.ZERO
		rotation = 0.0


func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)
