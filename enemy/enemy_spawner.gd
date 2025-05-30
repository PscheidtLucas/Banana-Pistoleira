extends Node2D

@onready var spawner_timer: Timer = $SpawnerTimer
@onready var spawner_pos: Marker2D = %SpawnerPos
@export var enemy_tscn : PackedScene
@onready var player: Player = %Player

# Posições horizontais entre as quais os inimigos podem nascer
var start_x_pos := 220
var final_x_pos := 1630

# Posição vertical onde os inimigos vão nascer
var y_position_to_spawn := 1080

# Quantidade de inimigos por wave
var enemies_per_wave := 3

# Contador de waves que já aconteceram
var wave_count := 0

# Controle para saber se o jogo ainda está rodando
var can_spawn := true

func _ready() -> void:
	#conectamos o sinal de "jogador morto" aqui para pausar o timer quando ele morrer e parar de spawnar inimigos
	player.player_died.connect(func()->void:
		spawner_timer.stop())
	#criamos um timer para dar uma folga pro jogador antes dos inimigos começarem a spawnar
	await get_tree().create_timer(0.5).timeout
	
	for i in enemies_per_wave:
		spawn_enemy()
	wave_count += 1
	enemies_per_wave += 1
	
	# Conectamos o sinal do timer
	spawner_timer.timeout.connect(_on_spawner_timer_timeout)
	# Começamos o timer
	spawner_timer.start()
	
	


func _on_spawner_timer_timeout() -> void:
	if not can_spawn:
		return
	
	# Spawna os inimigos da wave
	for i in enemies_per_wave:
		spawn_enemy()

	# Conta mais uma wave
	wave_count += 1
	
	# A cada 2 waves, aumentamos a quantidade de inimigos por wave 
	if wave_count % 1 == 0:
		enemies_per_wave += 1


func spawn_enemy() -> void:
	# Cria uma instância do inimigo
	var enemy = enemy_tscn.instantiate()
	enemy.player = player
	# Define uma posição aleatória no eixo X, dentro dos limites declarados
	var random_x = randf_range(start_x_pos, final_x_pos)
	enemy.global_position = Vector2(random_x, y_position_to_spawn)

	# Adiciona o inimigo à cena
	get_tree().current_scene.add_child(enemy)
