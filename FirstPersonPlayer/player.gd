extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var Camera: Camera3D = $FirstPersonCamera;


@export var Motion: Vector3;

@export var AbsoluteVelocity:float:
	get:
		return Motion.x + Motion.z

func _process(delta):
	# Add the gravity.
	velocity.y -= 400;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	Motion.x = lerpf(Motion.x, direction.x * SPEED, delta * ACCELERATION )
	Motion.z = lerpf(Motion.z, direction.z * SPEED, delta * ACCELERATION )
	
	velocity = Motion

	move_and_slide()
