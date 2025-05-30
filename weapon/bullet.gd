extends Area2D

var speed: int = 500 #sobreescrito no script da arma
var max_range: float = 1000.0 #sobreescrito no script da arma

var _traveled_distance: float = 0.0

func _physics_process(delta: float) -> void:
	var distance:= speed * delta
	var motion := Vector2.RIGHT.rotated(rotation) * distance
	
	position += motion

	_traveled_distance += distance
	if _traveled_distance >= max_range:
		_destroy()
		
func _destroy() -> void:
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(self, "modulate:a", 0, 0.1)
	fade_out_tween.tween_callback(queue_free)
