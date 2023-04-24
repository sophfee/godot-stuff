extends Node3D

@export var AccelerationX: float = 0
@export var AccelerationY: float = 0

@onready var Camera: Camera3D = $"../FirstPersonCamera";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_vm_pos(Position: Vector3):
	
	return Position;

func _input(event):
	if (event is InputEventMouseMotion):
		AccelerationX += deg_to_rad(event.relative.x * .06);
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	AccelerationX = lerpf(AccelerationX, 0, delta * 9);
	rotation = Camera.rotation + Vector3(0, AccelerationX, 0);
	position = Vector3(AccelerationX * -.2, 1.5, -2);
