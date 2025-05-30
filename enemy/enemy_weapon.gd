extends Weapon

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(func()-> void:
		shoot())

# Reescrevemos a função physics process para não atirar quando é pressionado o botão do mouse, porque extendemos de Weapon
func _physics_process(delta: float) -> void:
	pass
