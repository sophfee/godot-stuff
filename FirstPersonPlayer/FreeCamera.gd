# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove
# this credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

extends Camera3D

@onready var controller: Player = get_parent();
@onready var footstep_stream: AudioStreamPlayer = $AudioStreamPlayer;

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event):
	if (controller == null):
		return
	
	if (event is InputEventMouseMotion):
		controller.rotate_y( -(event.relative.x / 1250) );
		rotate_x( -(event.relative.y / 1250) );
		
		
@export var footstep_interval: float = .4
var footstep_timer: float = 0
var footstep_lastfoot: bool = false;

func footstep(is_left_foot: bool, _character_velocity: float):
	if (is_left_foot):
		footstep_stream.play();
	else:
		footstep_stream.play();

func _process(delta:float):
	if (abs(controller.lateral_velocity) > 1):
		footstep_timer += delta
	
		if (footstep_timer >= footstep_interval):
			footstep_timer = 0
			footstep_lastfoot = !footstep_lastfoot;
			footstep(footstep_lastfoot, controller.lateral_velocity);
