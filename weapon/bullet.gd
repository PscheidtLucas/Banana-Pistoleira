extends Area2D

var speed: int = 500
var max_range: float = 1000.0

var _traveled_distance: float = 0.0
var _direction: Vector2 = Vector2(1, 0).rotated(rotation)

func _physics_process(delta: float) -> void:
	var distance:= speed * delta
	position += distance * _direction 

	_traveled_distance += distance
	if _traveled_distance >= max_range:
		_destroy()
		
func _destroy() -> void:
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(self, "modulate:a", 0, 0.3)
	fade_out_tween.tween_callback(queue_free)
