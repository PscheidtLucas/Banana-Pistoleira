extends Node2D

func _ready() -> void:
	# Começa a animação ao iniciar o jogo
	animate_label()

func animate_label() -> void:
	# FLUTUAR VERTICALMENTE
	var t := create_tween()
	t.set_loops()  # Faz a animação repetir infinitamente
	t.tween_property(self, "position:y", self.position.y - 30, 3.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "position:y", self.position.y, 3.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# PISCAR (modificando a opacidade)
	var blink := create_tween()
	blink.set_loops()
	blink.tween_interval(2)
	blink.tween_property(self, "modulate:a", 0.2, 0.2)\
		.set_trans(Tween.TRANS_LINEAR)
	blink.tween_property(self, "modulate:a", 1.0, 0.2)\
		.set_trans(Tween.TRANS_LINEAR)
	blink.tween_property(self, "modulate:a", 0.2, 0.2)\
		.set_trans(Tween.TRANS_LINEAR)
	blink.tween_property(self, "modulate:a", 1.0, 0.2)\
		.set_trans(Tween.TRANS_LINEAR)
	
