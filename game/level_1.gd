extends Node2D

@onready var color_rect: ColorRect = $PlacarEVida/ColorRect

var can_change_scene: bool = true

func _ready() -> void:
	color_rect.modulate.a = 1.0
	tween()


func tween() -> void:
	# Cria o tween para fade out (ficar preto)
	var t := create_tween()
	t.tween_property(color_rect, "modulate:a", 0.0, 1.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
