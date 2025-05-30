class_name Enemy extends CharacterBody2D

@onready var animated_enemy_sprite_2d: AnimatedSprite2D = %AnimatedEnemySprite2D
@onready var weapon_pivot: Node2D = %WeaponPivot
@onready var enemy_weapon: Sprite2D = %EnemyWeapon

var chase_distance_min = 350
var chase_distance_max = 500
var health: int = 3
var score_points_value : int = 10

var player: Player = null
var speed: int = 250

enum States {CHASE, DIE, SHOOT}
var current_state: States = States.CHASE: set = set_state

signal die(score_points_value)

func set_state(new_state: States) -> void:
	var previous_state: States = current_state
	current_state = new_state

	match current_state:
		States.CHASE:
			animated_enemy_sprite_2d.play("chase")
		States.DIE:
			animated_enemy_sprite_2d.play("die")
		States.SHOOT:
			animated_enemy_sprite_2d.play("shoot")


func _ready() -> void:
	player = %Player 	# O síbolo % serve para pegar o nó do jogador por ele conta com um nome único e a gente ter marcado
						# ele como "Access as unique name"

func _physics_process(delta: float) -> void:
	if player == null:
		return
	elif current_state != States.DIE:
		var direction_to_player: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player: float = global_position.distance_to(player.global_position)
		
		# Lógica para espelhar a sprite
		if direction_to_player.x < 0 and animated_enemy_sprite_2d.flip_h == false:
			animated_enemy_sprite_2d.flip_h = true
		elif direction_to_player.x >= 0 and animated_enemy_sprite_2d.flip_h == true:
			animated_enemy_sprite_2d.flip_h = false
			
		# Lógica de movimentação do inimigo, segue o jogador se a distância até ele for maior que chase_distance_max,
		# e para de seguir caso a distância seja menor que chase_distance_min. Essa margem de erro evita travamentos
		# indesejados.
		if distance_to_player > chase_distance_max:
			if current_state != States.CHASE:
				current_state = States.CHASE
			velocity = speed * direction_to_player 
		elif distance_to_player < chase_distance_min:
			if current_state != States.SHOOT:
				current_state = States.SHOOT
			velocity = Vector2.ZERO
		move_and_slide()

func _process(_delta: float) -> void:
	# Lógica da rotação da mira:
	var aim_direction := Vector2.ZERO
	if player != null:
		aim_direction = global_position.direction_to(player.global_position+Vector2(-56,0))
	if aim_direction.length() > 0.1: # usamos 0.1 para que evitar movimentos desnecessários
		weapon_pivot.rotation = aim_direction.angle()
	# mudamos o z index para 3 caso y seja menor q zero para que a arma apareça a frente do inimigo caso ela esteja abaixo dele
	weapon_pivot.z_index = 3
	if aim_direction.y < 0.0:
		weapon_pivot.z_index = 1
	if global_position.direction_to(player.global_position).x < 0:
		weapon_pivot.position.x = -74
	else:
		weapon_pivot.position.x = 74
		
		
func take_damage(amount: int):
	health -= amount
	if health <= 0 and current_state != States.DIE:
		current_state = States.DIE
		if enemy_weapon.has_node("Timer"):
			enemy_weapon.get_node("Timer").stop()
		die.emit(score_points_value)
		await get_tree().create_timer(2).timeout
		queue_free()

	
