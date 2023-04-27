class_name ViewModel
extends Node3D

@export_category("ViewModel Positions")
@export var ironsights_offset_position: Vector3 = Vector3(0, 0, 0);
@export var ironsights_offset_rotation: Vector3 = Vector3(0, 0, 0);
@export var base_offset_position: Vector3 = Vector3(0, 0, 0);
@export var base_offset_rotation: Vector3 = Vector3(0, 0, 0);
@export_category("Viewmodel Bobbing")
@export var bob_right: float = 4;
@export var bob_right_rate: float = 8.4;
@export var bob_up: float = 2.3;
@export var bob_up_rate: float = 16.8;
@export_category("Viewmodel Sway")
@export var sway_x_multiplier: float = 0.06;
@export var sway_x_yaw_multiplier: float = -.28;
@export var sway_x_roll_multiplier: float = -.28;
@export var sway_x_position_multiplier: float = -.02;
@export var sway_y_multiplier: float = 0.06;
@export var sway_y_position_multiplier: float = -.02;
@export var sway_y_pitch_multiplier: float = .20;
@export_category("Viewmodel Modifiers")
@export var ironsights_sway_multiplier: float = .2;
@onready var camera: Camera3D = $"../FirstPersonCamera";
@onready var pawn: CharacterBody3D = get_parent();
@onready var view_model: Node3D = get_child(0);

var curtime: float = 0;
var ironsights_alpha: float = 0
var mv: float = 0;
var xmv: float = 0;
var delta_x: float = 0
var delta_y: float = 0

func _ready():
	pass # Replace with function body.

func walk_bob(md: float) -> Vector3:
	var a: float = md * lerpf(1, ironsights_sway_multiplier, ironsights_alpha);
	var pos: Vector3 = Vector3(0, 0, 0);
	
	pos.x += sin(curtime * bob_right_rate) * (a * bob_right) + (a * 1.9);
	pos.y -= cos(curtime * bob_up_rate) * (a * bob_up) + (a * 1.32);
	pos.z += a * 6;
	
	return pos;

var _punch_pos: Vector3 = Vector3(0, 0, 0);
var _punch_ang: Vector3 = Vector3(0, 0, 0);

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
	_punch_ang = _punch_ang.lerp(Vector3.ZERO, delta * 16);
	camera.fov = lerpf(90, 60, ironsights_alpha);

func _process(delta: float):
	curtime += delta;
	
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
	
	_calculate_ironsights(delta);
	#rotation += Vector3(0,0,-2 * ironsights_alpha);
	
	position += walk_bob(fd)
