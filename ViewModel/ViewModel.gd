extends Node3D

@export var AccelerationX: float = 0
@export var AccelerationY: float = 0

@onready var Camera: Camera3D = $"../FirstPersonCamera";
@onready var Player: CharacterBody3D = get_parent();

var curtime: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func walk_bob(md: float):
	var pos: Vector3 = Vector3(0, 0, 0);
	
	pos.x += sin(curtime * 8.4) * md;
	pos.y -= cos(curtime * 16.4) * (md * .4);
	return pos;

func _input(event):
	if (event is InputEventMouseMotion):
		AccelerationX += deg_to_rad(event.relative.x * .06);
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	curtime += delta;
	
	AccelerationX = lerpf(AccelerationX, 0, delta * 7.5);
	
	var rightVector: Vector3 = Player.rotation;
	rightVector.rotated(Vector3(0, 1, 0), 90);
	var rd: float = Player.velocity.normalized().dot(rightVector);
	var fd: float = Player.velocity.limit_length(1).length() * .01;
	
	
	rotation = Camera.rotation + Vector3(0, (AccelerationX * -.28) - (rd * .1), AccelerationX - (rd / 2));
	position = self.walk_bob(fd) + Vector3(AccelerationX * .02 + .07, 1.4, -.002);
