extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var anim = $animacao as AnimatedSprite2D
var pulando := false
@onready var remote = $remote as RemoteTransform2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		pulando = true
	
	if is_on_floor():
		pulando = false
	else:
		pulando = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		anim.scale.x = direction
		if !pulando:
			anim.play("andando")
		elif pulando:
			anim.play("pulando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !pulando:
			anim.play("parado")
		else:
			anim.play("pulando")
	if position.y > 150:
		anim.play("morrer")
	if position.y > 800:
		position.y = -10
		position.x = 50
	move_and_slide()


func _on_dano_jogador_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		queue_free()
		get_tree().current_scene.reiniciar_fase()

func seguir_camera(camera):
	var caminho_camera = camera.get_path()
	remote.remote_path = caminho_camera
