# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

class_name Combat3D
extends Node3D

@export var starting_health: float = 100;
@export var maximum_health: float = 100;

# Private prop;
var _health: float = 100;
var health: float = 100:
	get:
		return (_health);

@warning_ignore("unused_parameter")
func _death(attacker: Combat3D) -> void:
	pass

@warning_ignore("unused_parameter")
func _take_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3) -> void:
	pass;

@warning_ignore("unused_parameter")
func _scale_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3) -> float:
	return 1.0;

# This has to be called within _process_physics, otherwise you get bad results.
func inflict_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3) -> void:
	get_parent_node_3d().apply_impulse(force);
	damage = _scale_damage(attacker, damage, normal, force);
	_health -= damage;
	_take_damage(attacker, damage, normal, force);
	if (_health <= 0):
		_death(attacker);
