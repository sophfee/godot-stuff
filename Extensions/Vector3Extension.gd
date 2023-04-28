# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

extends Node

func forward(node: Node3D) -> Vector3:
	var rot := node.rotation as Vector3;
	var pitch: float = rot.x;
	var yaw: float = rot.y;
	var v: Vector3 = Vector3(
		cos(pitch) * sin(yaw),
		-sin(pitch),
		cos(pitch) * cos(yaw)
	);
	return v;
	
func right(node: Node3D) -> Vector3:
	var rot := node.rotation as Vector3;
	var yaw: float = rot.y;
	var v: Vector3 = Vector3(
		cos(yaw),
		0,
		-sin(yaw)
	);
	return v;

func up(node: Node3D) -> Vector3:
	return forward(node).cross(right(node));
