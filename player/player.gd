class_name Player extends CharacterBody2D

@export var cooldown_dash: float = 2.0

# Variáveis resposáveis pela movimentação do persoangem:
var roll_speed: float = 900
var running_speed: float = 300
var current_speed : float = running_speed
var acceleration : float = 2100
var deceleration : float = 1850
var direction := Vector2.ZERO

# Declaramos um enum, ele funciona como um atalho legível para salvar as constantes resposáveis
# por controlar o estado do nosso personagem de forma centralizada em um único lugar:
enum States {IDLE, RUNNING, ROLLING, DYING, }
@export var current_state: States : set = set_state

# Váriaveis para acessar os nós filhos:
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var body_animated_sprite: AnimatedSprite2D = %BodyAnimatedSprite

# Função que é chamada toda vez que o current_state é alterado, 
# aqui é onde se controla as animações através de um match
func set_state(new_state: States) -> void:
	var previous_state: States = current_state
	current_state = new_state

	match current_state:
		States.IDLE:
			body_animated_sprite.animation = "idle"
		States.RUNNING:
			body_animated_sprite.animation = "run"
		States.ROLLING:
			body_animated_sprite.animation = "roll"
		States.DYING:
			body_animated_sprite.animation = "die"

func _ready() -> void:
	set_state(States.IDLE)
	
	# Conecta o sinal "timeout" do DashCooldownTimer a uma função que executa código responsável por
	# dar feedback visual e aduditivo pro jogador para ele saber quando pode dashar novamente.
	dash_cooldown_timer.timeout.connect(func () -> void:
		print("JÁ PODE DASHAR!"))

func _physics_process(delta: float) -> void:
	# Variável direction pega o Input do jogador:
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

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
	
	# Lógica para trocar de State:
	if current_state not in [States.DYING, States.ROLLING]:
		if velocity.length() <= 5:
			set_state(States.IDLE)
		else:
			set_state(States.RUNNING)
	print(current_state)

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
	if event.is_action_pressed("roll"):
		_roll()
