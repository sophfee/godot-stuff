@icon("res://editor/icons/GameTime.svg")

# Simple class, place in the tree and access easily, contains a global float
# that holds the time elapsed since the scene has been booted up.
class_name GameTime
extends Node

var _curtime: float = 0;
func _process(delta):
	_curtime += delta;

var elapsed_time: float:
	get:
		return _curtime;
