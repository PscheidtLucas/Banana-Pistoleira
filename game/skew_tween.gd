class_name SkewTween extends Node

@export var node_to_tween: Node2D
@export_range(0, 20, 1.0, "degrees" ) var amount_to_skew : float
@export var tween_duration : float = 0.6

func _ready() -> void:
	if node_to_tween == null:
		node_to_tween = get_parent()
	start_tween()
	
func start_tween() -> void:
	var skew_tween := create_tween()
	skew_tween.set_loops()
	skew_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	skew_tween.tween_property(node_to_tween, "skew", deg_to_rad(amount_to_skew), tween_duration)
	skew_tween.tween_property(node_to_tween, "skew", -deg_to_rad(amount_to_skew), tween_duration)
	
