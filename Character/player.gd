extends CharacterBody2D


@export var speed: float = 300
@export var jump_velocity: float = -400.0
var direction: Vector2 = Vector2(0,0)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var animation_locked: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left","right","up","down")
	if direction.x:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing()

func update_animation():
	if not animation_locked:
		if velocity == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")

func update_facing():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
