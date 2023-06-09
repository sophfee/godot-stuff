# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

class_name ViewModel
extends Node3D

@export_category("View Model")
@export var viewmodel: ViewModelSetup;

@onready var ironsights_offset_position: Vector3 = viewmodel.ironsights_offset_position;
@onready var ironsights_offset_rotation: Vector3 = viewmodel.ironsights_offset_rotation;
@onready var base_offset_position: Vector3 = viewmodel.base_offset_position;
@onready var base_offset_rotation: Vector3 = viewmodel.base_offset_rotation;
@onready var sprint_offset_position: Vector3 = viewmodel.sprint_offset_position;
@onready var sprint_offset_rotation: Vector3 = Vector3(
	deg_to_rad(viewmodel.sprint_offset_rotation.x),
	deg_to_rad(viewmodel.sprint_offset_rotation.y),
	deg_to_rad(viewmodel.sprint_offset_rotation.z)
);
@onready var bob_right: float = viewmodel.bob_right;
@onready var bob_right_rate: float = viewmodel.bob_right_rate;
@onready var bob_up: float = viewmodel.bob_up;
@onready var bob_up_rate: float = viewmodel.bob_up_rate;
@onready var walking_offset_position: Vector3 = viewmodel.walking_offset;
@onready var sway_x_multiplier: float = viewmodel.sway_x_multiplier;
@onready var sway_x_yaw_multiplier: float = viewmodel.sway_x_yaw_multiplier;
@onready var sway_x_roll_multiplier: float = viewmodel.sway_x_roll_multiplier;
@onready var sway_x_position_multiplier: float = viewmodel.sway_x_position_multiplier;
@onready var sway_y_multiplier: float = viewmodel.sway_y_multiplier;
@onready var sway_y_position_multiplier: float = viewmodel.sway_y_position_multiplier;
@onready var sway_y_pitch_multiplier: float = viewmodel.sway_y_pitch_multiplier;
@onready var ironsights_sway_multiplier: float = viewmodel.ironsights_sway_multiplier;
@onready var pawn: PlayerNode = get_parent();
@onready var camera: Camera3D = pawn.camera;
@onready var view_model: Node3D = get_child(0);

var curtime: float = 0;
var ironsights_alpha: float = 0
var mv: float = 0;
var xmv: float = 0;
var delta_x: float = 0
var delta_y: float = 0
var _punch_pos: Vector3 = Vector3(0, 0, 0);
var _punch_ang: Vector3 = Vector3(0, 0, 0);
var _sprint_pos: Vector3 = Vector3(0, 0, 0);
var _sprint_ang: Vector3 = Vector3(0, 0, 0);
var _wallproximity: float = 0.0;
var _against_wall: bool = false;

func _ready():
	pass

func walk_bob(md: float) -> Vector3:
	var a: float = md * lerpf(1, ironsights_sway_multiplier, ironsights_alpha);
	var pos: Vector3 = Vector3(0, 0, 0);
	
	pos.x += sin(curtime * bob_right_rate) * (a * bob_right);
	pos.y -= cos(curtime * bob_up_rate) * (a * bob_up);
	
	pos += (walking_offset_position * a);
	
	return pos;

func punch(pos: Vector3, ang: Vector3) -> void:
	_punch_pos += pos;
	_punch_ang += ang;

func _input(event):
	if (event is InputEventMouseMotion):
		delta_x += deg_to_rad(event.relative.x * .06);
		delta_y += deg_to_rad(event.relative.y * .06);

func _calculate_ironsights(delta: float) -> void:
	position += (camera.transform.basis * view_model.position) * ironsights_alpha;
	position += (camera.transform.basis * ironsights_offset_position) * ironsights_alpha;
	position += (camera.transform.basis * _punch_pos);
	_punch_pos = _punch_pos.lerp(Vector3.ZERO, delta * 16);
	rotation += (camera.transform.basis * _punch_ang);
	rotation += (camera.transform.basis * ironsights_offset_rotation) * ironsights_alpha;
	_punch_ang = _punch_ang.lerp(Vector3.ZERO, delta * 16);
	camera.fov = lerpf(90, 60, ironsights_alpha);

@warning_ignore("unused_parameter")
func _calculate_wallproximity(delta: float) -> void:
	var view_port: Viewport = get_viewport();
	var scr_size: Vector2i = view_port.get_window().size;
	
	var hit_pos: Vector3 = camera.project_position(scr_size /2, 4);
	var dist_sqr: float = position.distance_squared_to(hit_pos);
	var x: bool = dist_sqr < (5 ^ 2);
	
	if (x):
		_wallproximity = dist_sqr / (5 ^ 2);
	else:
		_wallproximity = 0;
	
	if (x != _against_wall):
		print_debug("Against Wall State Change: ", x);
		_against_wall = x;

@warning_ignore("unused_parameter")
func _physics_process(delta):
	pass #_calculate_wallproximity(delta);

## This takes the given position in a local space and converts it to the camera's space.
## Useful for calculating the position of the viewmodel.
func to_camera_space(pos: Vector3) -> Vector3:
	return camera.transform.basis * pos;

func _process(delta: float):
	curtime += delta;
	
	if (!camera):
		camera = pawn.camera;
		return
	
	if (Input.is_action_pressed("iron_sights")):
		ironsights_alpha = lerpf(ironsights_alpha, 1, delta * 10);
	else:
		ironsights_alpha = lerpf(ironsights_alpha, 0, delta * 10);
	
	delta_x = lerpf(delta_x, 0, delta * 7.5);
	delta_y = lerpf(delta_y, 0, delta * 7.5);
	
	var isight: float = lerpf(1, ironsights_sway_multiplier, ironsights_alpha);
	var sway_x: float = delta_x * isight;
	var sway_y: float = delta_y * isight;
	
	var rightVector := Vector3Extension.right(pawn) as Vector3;
	var rd: float = rightVector.dot(pawn.velocity.limit_length(6) / 6) * isight;
	var md: float = pawn.velocity.limit_length(1).length() * .01;
	mv = lerpf(mv, md, delta * 18);
	var fd: float = mv;
	rotation = camera.rotation
	rotation += Vector3(
		sway_y * sway_y_pitch_multiplier, 
		sway_x * sway_x_yaw_multiplier, 
		sway_x * sway_x_roll_multiplier
	);
	rotation += Vector3(
		0,
		-(rd * .02),
		-(rd * .5)
	);
	
	position = camera.position + Vector3(0.07, 0, 0);
	position -= (camera.transform.basis * view_model.position);
	position -= Vector3Extension.up(camera) * .075
	position += (
		camera.transform.basis * Vector3(
			sway_x * sway_x_position_multiplier, 
			sway_y * sway_y_position_multiplier, 
			(rd * .01)
		)
	);
	
	#position += (camera.transform.basis * Vector3(0,0,_wallproximity));
	
	if (pawn._sprinting):
		_sprint_pos = _sprint_pos.lerp(sprint_offset_position, delta * 10);
		_sprint_ang = _sprint_ang.lerp(sprint_offset_rotation, delta * 10);
		
	else:
		_sprint_pos = _sprint_pos.lerp(Vector3(0, 0, 0), delta * 10);
		_sprint_ang = _sprint_ang.lerp(Vector3(0, 0, 0), delta * 10);

	position += (camera.transform.basis * _sprint_pos);
	rotation += (camera.transform.basis * _sprint_ang);
	_calculate_ironsights(delta);
	
	position += walk_bob(fd)
