extends CanvasLayer

@onready var player: Player = %Player
@onready var leaderboard_canvas_layer: CanvasLayer = $LeaderboardCanvasLayer
@onready var panel: Panel = $Panel
@onready var your_name: LineEdit = $Panel/YourName


func _ready() -> void:
	leaderboard_canvas_layer.hide()
	hide()
	player.player_died.connect(func()->void:
		await get_tree().create_timer(1.5).timeout
		show())

func _on_button_pressed() -> void:
	panel.hide()
	var name : String = your_name.text
	Leaderboard.add_score(name, Leaderboard.score)
	leaderboard_canvas_layer.update_leaderboard_display(Leaderboard.leaderboard)
	leaderboard_canvas_layer.show()
