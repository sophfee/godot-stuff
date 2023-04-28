# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

class_name Player
extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const ACCELERATION: float = 10

@export_category("Footsteps")
@export var footstep_sfx: AudioStream;
var footstep_interval: float = .4;
var camera: Camera3D;
var footstep_stream: AudioStreamPlayer3D;
var footstep_timer: float = 0;
var footstep_lastfoot: bool = false;
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity");
var lateral_velocity: float: get: return get_lateral_velocity();
var _target_motion: Vector3;

func _ready():
	# check
	assert(footstep_sfx);

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

	camera = Camera3D.new();
	camera.position = Vector3(0, 1.5, 0);
	camera.rotation = Vector3(0, 0, 0);
	camera.fov = 75;
	camera.name = "@FirstPersonCamera";
	add_child(camera);

	footstep_stream = AudioStreamPlayer3D.new();
	footstep_stream.stream = footstep_sfx;
	footstep_stream.name = "@FootStepStream";
	add_child(footstep_stream);

func get_lateral_velocity() -> float:
	return abs(target_motion.x + target_motion.z)

func _input(event):
	assert(controller);
	
	if (event is InputEventMouseMotion):
		rotate_y( -(event.relative.x / 1250) );
		camerarotate_x( -(event.relative.y / 1250) );

func footstep(is_left_foot: bool, _character_velocity: float) -> void:
	if (is_left_foot):
		footstep_stream.play();
	else:
		footstep_stream.play();

func _process(delta):
	if (abs(lateral_velocity) > 1):
		footstep_timer += delta
	
		if (footstep_timer >= footstep_interval):
			footstep_timer = 0
			footstep_lastfoot = !footstep_lastfoot;
			footstep(footstep_lastfoot, controller.lateral_velocity);

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target_motion.x = lerpf(target_motion.x, direction.x * SPEED, delta * ACCELERATION )
	target_motion.z = lerpf(target_motion.z, direction.z * SPEED, delta * ACCELERATION )
	
	velocity = target_motion

	if (!is_on_floor()):
		velocity.y -= gravity;

	move_and_slide()
