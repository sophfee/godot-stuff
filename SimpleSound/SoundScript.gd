class_name SoundScript
extends Node3D

var Sources: Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count(true):
		Sources.append(get_child(i, true));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
