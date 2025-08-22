class_name Bullet extends Area2D

@export var targets_player := false
var speed: int = 500 #sobreescrito no script da arma
var max_range: float = 1000.0 #sobreescrito no script da arma
var damage: int = 1
var start_pos: Vector2

var _traveled_distance: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if not targets_player:
		start_pos = global_position

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
		elif not targets_player:
			if body is Enemy:
				body.flash_white()
				body.take_damage(damage)
			elif body is Destructible:
				body.take_damage(damage, start_pos.direction_to(global_position))
				_destroy()
	else:
		print("nao tem take damage")


func _on_area_entered(area: Area2D) -> void:
	if not targets_player:
		if area.is_in_group("headshot"):
			if area.get_parent() is Enemy:
				print("headshot")
				area.get_parent().head_shot()
				area.get_parent().take_damage(damage*3)
				
				_destroy()
