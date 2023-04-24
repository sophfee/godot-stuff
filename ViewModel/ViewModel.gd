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

func walk_bob(md: float):
	var pos: Vector3 = Vector3(0, 0, 0);
	
	pos.x += sin(curtime * BobRightRate) * (md * BobRight);
	pos.y -= cos(curtime * BobUpRate) * (md * BobUp);
	return pos;

func _input(event):
	if (event is InputEventMouseMotion):
		AccelerationX += deg_to_rad(event.relative.x * .06);
		AccelerationY += deg_to_rad(event.relative.y * .06);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	curtime += delta;
	
	AccelerationX = lerpf(AccelerationX, 0, delta * 7.5);
	AccelerationY = lerpf(AccelerationY, 0, delta * 7.5);
	
	var rightVector := Axes.right(Player) as Vector3;
	var rd: float = rightVector.dot(Player.velocity.limit_length(6) / 6);
	var md: float = Player.velocity.limit_length(1).length() * .01;
	Movement = lerpf(Movement, md, delta * 18);
	var fd: float = Movement;
	rotation = Camera.rotation
	rotation += Vector3(
		AccelerationY * SwayYPitchMultiplier, 
		AccelerationX * SwayXYawMultiplier, 
		AccelerationX * SwayXRollMultiplier
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
			AccelerationX * SwayXPositionMultiplier, 
			AccelerationY * SwayYPositionMultiplier, 
			(rd * .01)
		)
	);
	position += walk_bob(fd)
