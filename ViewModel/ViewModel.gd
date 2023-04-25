class_name ViewModel
extends Node3D

var AccelerationX: float = 0
var AccelerationY: float = 0

@export_category("Viewmodel Bobbing")
@export var BobRight: float = 4;
@export var BobRightRate: float = 8.4;
@export var BobUp: float = 2.3;
@export var BobUpRate: float = 16.8;

@export_category("Viewmodel Sway")
@export var SwayXMultiplier: float = 0.06;
@export var SwayXYawMultiplier: float = -.28;
@export var SwayXRollMultiplier: float = -.28;
@export var SwayXPositionMultiplier: float = -.02;
@export var SwayYMultiplier: float = 0.06;
@export var SwayYPositionMultiplier: float = -.02;
@export var SwayYPitchMultiplier: float = .20;

@export_category("Viewmodel Modifiers")
@export var SwayIronsightsMultiplier: float = .2;

var IronsightsTime: float = 0

# We store this so we can apply an ever so slight lerp to prevent jitter
var Movement: float = 0 

@onready var Camera: Camera3D = $"../FirstPersonCamera";
@onready var Player: CharacterBody3D = get_parent();

@onready var Model: Node3D = $weapon_m4a4;

var curtime: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func walk_bob(md: float) -> Vector3:
	var a: float = md * lerpf(1, SwayIronsightsMultiplier, IronsightsTime);
	var pos: Vector3 = Vector3(0, 0, 0);
	
	pos.x += sin(curtime * BobRightRate) * (a * BobRight);
	pos.y -= cos(curtime * BobUpRate) * (a * BobUp);
	return pos;

var _punch_pos: Vector3 = Vector3(0, 0, 0);
var _punch_ang: Vector3 = Vector3(0, 0, 0);

func punch(pos: Vector3, ang: Vector3) -> void:
	_punch_pos += pos;
	_punch_ang += ang;

func _input(event):
	if (event is InputEventMouseMotion):
		AccelerationX += deg_to_rad(event.relative.x * .06);
		AccelerationY += deg_to_rad(event.relative.y * .06);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	curtime += delta;
	
	if (Input.is_action_pressed("iron_sights")):
		IronsightsTime = lerpf(IronsightsTime, 1, delta * 10);
	else:
		IronsightsTime = lerpf(IronsightsTime, 0, delta * 10);
	
	AccelerationX = lerpf(AccelerationX, 0, delta * 7.5);
	AccelerationY = lerpf(AccelerationY, 0, delta * 7.5);
	
	var isight: float = lerpf(1, SwayIronsightsMultiplier, IronsightsTime);
	var sway_x: float = AccelerationX * isight;
	var sway_y: float = AccelerationY * isight;
	
	var rightVector := Axes.right(Player) as Vector3;
	var rd: float = rightVector.dot(Player.velocity.limit_length(6) / 6) * isight;
	var md: float = Player.velocity.limit_length(1).length() * .01;
	Movement = lerpf(Movement, md, delta * 18);
	var fd: float = Movement;
	rotation = Camera.rotation
	rotation += Vector3(
		sway_y * SwayYPitchMultiplier, 
		sway_x * SwayXYawMultiplier, 
		sway_x * SwayXRollMultiplier
	);
	rotation += Vector3(
		0,
		-(rd * .02),
		-(rd * .5)
	);
	
	position = Camera.position + Vector3(0.07, 0, 0);
	position -= (Camera.transform.basis * Model.position);
	position -= Axes.up(Camera) * .075
	position += (
		Camera.transform.basis * Vector3(
			sway_x * SwayXPositionMultiplier, 
			sway_y * SwayYPositionMultiplier, 
			(rd * .01)
		)
	);
	
	position += (Camera.transform.basis * Model.position) * IronsightsTime;
	position += (Camera.transform.basis * Vector3(-.071,-0.0295,.1)) * IronsightsTime;
	position += (Camera.transform.basis * _punch_pos);
	Camera.fov = lerpf(90, 60, IronsightsTime);
	#rotation += Vector3(0,0,-2 * IronsightsTime);
	
	position += walk_bob(fd)
