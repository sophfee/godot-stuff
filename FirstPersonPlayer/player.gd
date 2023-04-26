class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var Camera: Camera3D = $FirstPersonCamera;

var target_motion: Vector3;

var lateral_velocity:float:
	get:
		return target_motion.x + target_motion.z

func _process(delta):
	# Add the gravity.
	velocity.y -= 10;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target_motion.x = lerpf(target_motion.x, direction.x * SPEED, delta * ACCELERATION )
	target_motion.z = lerpf(target_motion.z, direction.z * SPEED, delta * ACCELERATION )
	
	velocity = target_motion

	move_and_slide()
