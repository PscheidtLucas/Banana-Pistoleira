extends Area2D

var hat_damage: int = 3
var can_damage : bool = false #variável de controle alterada no script do player para dar dano somente quando o chapéu estiver voando


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func(body: Node2D)->void:
		if body is Enemy or body is Destructible:
			if can_damage:
				body.take_damage(hat_damage))
