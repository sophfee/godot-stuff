extends Camera3D

@export var Controller: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event):
	if (Controller == null):
		return
	
	if (event is InputEventMouseMotion):
		Controller.rotate_y( -(event.relative.x / 1250) );
		rotate_x( -(event.relative.y / 1250) );
		
		
@export var StepTime: float = .4
var StepTimeUntil: float = 0
var LastFootStepLeft: bool = false;

func OnFootstep(Leftfoot: bool, Velocity: float):
	print("Footstep Velocity: ", Velocity);
	if (Leftfoot):
		print("Left foot stepped!")
	else:
		print("Right foot stepped!")

func _process(delta:float):
	if (Controller.AbsoluteVelocity > 0.001):
		StepTimeUntil += delta
	
		if (StepTimeUntil >= StepTime):
			StepTimeUntil = 0
			LastFootStepLeft = !LastFootStepLeft;
			OnFootstep(LastFootStepLeft, Controller.AbsoluteVelocity)
