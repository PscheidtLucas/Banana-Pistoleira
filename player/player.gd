class_name Player extends CharacterBody2D

@export var cooldown_dash: float = 2.0

# Variáveis resposáveis pela movimentação do persoangem:
var roll_speed: float = 900
var running_speed: float = 300
var current_speed : float = running_speed
var acceleration : float = 3000
var deceleration : float = 2200
var direction := Vector2.ZERO

var health:int = 5
signal player_died
signal update_health (health)

# Declaramos um enum, ele funciona como um atalho legível para salvar as constantes resposáveis
# por controlar o estado do nosso personagem de forma centralizada em um único lugar:
enum States {IDLE, RUNNING, ROLLING, DYING, }
@export var current_state: States : set = set_state

# enum para controlar os estados do chapéu:
enum HatStates {SHOW_IDLE, THROW, COMING_BACK}
var hat_current_state: HatStates = HatStates.SHOW_IDLE : set = set_hat_state
# Hide idle é para ser quando o chapéu não foi lançado e a banana está rolando

var chapeu_original_pos : Vector2 #variável da posição inicial do chapéu

# Váriaveis para acessar os nós filhos:
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var body_animated_sprite: AnimatedSprite2D = %BodyAnimatedSprite
@onready var chapeu_area: Area2D = %ChapeuArea

# Função que é chamada toda vez que o current_state é alterado, 
# aqui é onde se controla as animações através de um match
func set_state(new_state: States) -> void:
	var previous_state: States = current_state
	current_state = new_state

	match current_state:
		States.IDLE:
			body_animated_sprite.play("idle")
		States.RUNNING:
			body_animated_sprite.play("run")
		States.ROLLING:
			body_animated_sprite.play("roll")
			if hat_current_state == HatStates.SHOW_IDLE:
				%ChapeuArea.hide()
				await get_tree().create_timer(0.5).timeout
				%ChapeuArea.show()
		States.DYING:
			body_animated_sprite.play("die")

func set_hat_state(new_state: HatStates) -> void:
	hat_current_state = new_state
	if hat_current_state == HatStates.SHOW_IDLE:
		chapeu_area.can_damage = false
		%ChapeuSprite.play("idle")
	else:
		chapeu_area.can_damage = true
		%ChapeuSprite.play("voando")

			

func _ready() -> void:
	player_died.connect(_on_player_died)
	
	chapeu_original_pos = chapeu_area.position
	set_state(States.IDLE)
	
	# Conecta o sinal "timeout" do DashCooldownTimer a uma função que executa código responsável por
	# dar feedback visual e aduditivo pro jogador para ele saber quando pode dashar novamente.
	dash_cooldown_timer.timeout.connect(func () -> void:
		print("JÁ PODE DASHAR!"))

func _physics_process(delta: float) -> void:
	# Variável direction pega o Input do jogador:
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

	# Inverte o sprite horizontalmente baseado na direção
	if direction.x < -0.1:
		body_animated_sprite.flip_h = true
		%ChapeuSprite.flip_h = true
	elif direction.x > 0.1:
		body_animated_sprite.flip_h = false
		%ChapeuSprite.flip_h = false


	# Checagem para ver se tem input do jogador, se tiver e for maior que 1.0,
	# precisamos normalizar, e então, aceleramos até a "velocidade * direção"
	if direction.length() > 0.0:
		if direction.length() > 1.0:
			direction = direction.normalized()
		velocity = velocity.move_toward(direction * current_speed, acceleration * delta)
	# Se não tiver input, desaceleramos até o Vetor(0,0)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	# Função da classe CharacterBody2D responsável por fazer com que 
	# o personagem se movimente através da velocidade:
	move_and_slide()

	# Lógica do lançamento do chapéu:
	if hat_current_state == HatStates.THROW:
		chapeu_area.global_position = chapeu_area.global_position.move_toward(get_global_mouse_position(), 400*delta)
	elif hat_current_state == HatStates.COMING_BACK:
		chapeu_area.global_position = chapeu_area.global_position.move_toward(global_position, 400*delta)
		
		if chapeu_area.global_position.distance_to(global_position) <= 50:
			hat_current_state = HatStates.SHOW_IDLE
			chapeu_area.global_position = global_position
			chapeu_area.position =  chapeu_original_pos 

	
	# Lógica para trocar de State:
	if current_state not in [States.DYING, States.ROLLING]:
		if velocity.length() <= 5:
			set_state(States.IDLE)
		else:
			set_state(States.RUNNING)


# Controla a rolagem do personagem, deixando ele mais rápido por 0.2 segundos, e, depois, volta a velocidade anterior
func _roll() -> void:
	var old_speed: float = current_speed
	if dash_cooldown_timer.is_stopped():
		set_state(States.ROLLING)
		dash_cooldown_timer.start(cooldown_dash)
		current_speed = roll_speed
		await get_tree().create_timer(0.4).timeout
		set_state(States.IDLE if velocity.length() < 5 else States.RUNNING)
		current_speed = old_speed

# Função que é chamada toda vez que algum input é pressionado, usamos para 
# checar quando o botão de rolar é apertado para, então, chamar a função roll
func _input(event: InputEvent) -> void:
	if current_state not in [States.DYING, States.ROLLING]:
		if event.is_action_pressed("roll"):
			_roll()
		if event.is_action_pressed("special"):
			throw_hat()
		
func throw_hat():
	if hat_current_state == HatStates.SHOW_IDLE:
		hat_current_state = HatStates.THROW
		await get_tree().create_timer(2).timeout
		hat_current_state = HatStates.COMING_BACK
	
func take_damage(amount: int):
	health -= amount
	update_health.emit(health)
	if health <= 0 and current_state != States.DYING:
		current_state = States.DYING
		player_died.emit()
		

# Lógica para quando o player morre ele parar de atirar, andar e esconder o chapeu
func _on_player_died():
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	chapeu_area.can_damage = false
	chapeu_area.hide()
	chapeu_area.set_deferred("monitorable", false)
	chapeu_area.set_deferred("monitorable", false)
	$WaponPivot.hide()
	$WaponPivot/WeaponAnchor/Weapon.set_physics_process(false)
	
