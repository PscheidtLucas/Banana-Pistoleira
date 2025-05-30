extends Label

var score: int = 0

func _ready() -> void:
	Leaderboard.score_changed.connect(func(new_score)->void:
		score += new_score
		text = "Score " + str(score))
