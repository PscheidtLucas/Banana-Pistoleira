extends Node

var score:= 0

var leaderboard: Array = []
var save_path: String = "user://leaderboard.save"
const MAX_ENTRIES := 10

signal score_changed(new_score)

func _ready():
	score_changed.connect(func(new_score)->void:
		score += new_score)
	score = 0
	load_leaderboard()

func add_score(name: String, score: int) -> void:
	# Adiciona a nova pontuação
	leaderboard.append({ "name": name, "score": score })

	# Ordena do maior pro menor
	leaderboard.sort_custom(func(a, b): return a["score"] > b["score"])

	# Limita ao máximo de entradas
	if leaderboard.size() > MAX_ENTRIES:
		leaderboard.resize(MAX_ENTRIES)

	save_leaderboard()

func save_leaderboard() -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(leaderboard)  # Salva o array inteiro direto
	file.close()


func load_leaderboard() -> void:
	if FileAccess.file_exists(save_path):
		var file := FileAccess.open(save_path, FileAccess.READ)
		var loaded = file.get_var()
		if loaded is Array:
			leaderboard = loaded
		file.close()
	else:
		leaderboard = []

func reset_highscore()->void:
	leaderboard = []
	save_leaderboard()
