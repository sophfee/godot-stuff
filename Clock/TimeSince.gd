# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

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
