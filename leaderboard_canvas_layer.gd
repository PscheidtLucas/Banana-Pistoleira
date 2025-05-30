extends CanvasLayer

@onready var v_box_scores: VBoxContainer = %VBoxScores
@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(func()->void:
		Leaderboard.score = 0
		get_tree().reload_current_scene())
	pass
	 #Testes com o leaderboard:
	#Leaderboard.reset_highscore()
	#Leaderboard.add_score("Arthur", 1200)
	#Leaderboard.add_score("Lucas", 1600)
	#Leaderboard.add_score("Marcela", 1400)
	#Leaderboard.add_score("Arthur", 120)
	#Leaderboard.add_score("Lucas", 160)
	#Leaderboard.add_score("Marcela", 140)
	#Leaderboard.add_score("Arthur", 12)
	#Leaderboard.add_score("Lucas", 6)
	#Leaderboard.add_score("Marcela", 4)
	#Leaderboard.add_score("Arthurio", 12)
	#Leaderboard.add_score("Lucas", 1)
	#Leaderboard.add_score("Marcela", 1)
	#update_leaderboard_display(Leaderboard.leaderboard)

# Atualiza a exibição do leaderboard na interface
func update_leaderboard_display(leaderboard: Array) -> void:
	for child in v_box_scores.get_children(): # Limpando os filhos anteriores de teste
		child.queue_free()

	for i in leaderboard.size():
		var entry = leaderboard[i] # Cada entrada é um dicionário com "name" e "score"
		
		# Cria um HBox para alinhar nome e pontuação lado a lado
		var hbox := HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Cria o Label com o nome do jogador (alinhado à esquerda)
		var name_label := Label.new()
		name_label.text = str(i + 1) + ". " + entry["name"]
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# Cria o Label com a pontuação (alinhado à direita)
		var score_label := Label.new()
		score_label.text = str(entry["score"])
		score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		# Adiciona os dois labels no HBox
		hbox.add_child(name_label)
		hbox.add_child(score_label)

		# Adiciona o HBox ao VBox principal
		v_box_scores.add_child(hbox)
