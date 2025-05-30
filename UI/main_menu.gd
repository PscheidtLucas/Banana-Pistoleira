extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var can_change_scene: bool = true

func _ready() -> void:
	color_rect.modulate.a = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and can_change_scene:
		can_change_scene = false
		start_scene_transition("res://game/level_1.tscn")

func start_scene_transition(target_scene_path: String) -> void:

	# Cria o tween para fade out (ficar preto)
	var t := create_tween()
	t.tween_property(color_rect, "modulate:a", 1.0, 1.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_callback(Callable(self, "_on_fade_complete").bind(target_scene_path))

func _on_fade_complete(target_scene_path: String) -> void:
	get_tree().change_scene_to_file(target_scene_path)
