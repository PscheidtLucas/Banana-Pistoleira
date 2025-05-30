class_name Bullet extends Area2D

@export var targets_player := false
var speed: int = 500 #sobreescrito no script da arma
var max_range: float = 1000.0 #sobreescrito no script da arma
var damage: int = 1

var _traveled_distance: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var distance:= speed * delta
	var motion := Vector2.RIGHT.rotated(rotation) * distance
	
	position += motion

	_traveled_distance += distance
	if _traveled_distance >= max_range:
		_destroy()
		
func _destroy() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if targets_player and body is Player:
			body.take_damage(damage)
			_destroy()
		elif not targets_player and (body is Enemy or body is Destructible):
			body.take_damage(damage)
			_destroy()
	else:
		print("nao tem take damage")
