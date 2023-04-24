extends Node3D

@export var AccelerationX: float = 0
@export var AccelerationY: float = 0

var IronsightsTime: float = 0

# We store this so we can apply an ever so slight lerp to prevent jitter
var Movement: float = 0 

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
	rotation += Vector3(AccelerationY * .2, (AccelerationX * -.28), AccelerationX * .2);
	rotation += Vector3(0, -(rd * .02), -(rd * .5));
	position = Camera.position + Vector3(0.07, 0, -.002);
	position -= Axes.up(Camera) * .1
	position += Vector3(AccelerationX * -.02, 0, (rd * .01));
	position += walk_bob(fd)
