# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove
# this credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================
class_name Combat3D
extends Node3D

@onready var _owner = get_parent_node_3d();
@export var starting_health: float = 100;
@export var maximum_health: float = 100;

# Private prop;
var _health: float = 100;
var health: float = 100:
	get:
		return (_health);

func _death(attacker: Combat3D) -> void:
	pass

func _take_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3) -> void:
	pass;

func _scale_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3) -> float:
	return 1.0;

# This has to be called within _process_physics, otherwise you get bad results.
func inflict_damage(attacker: Combat3D, damage: float, normal: Vector3, force: Vector3, pos: Vector3) -> void:
	get_parent_node_3d().apply_impulse(force);
	damage = _scale_damage(attacker, damage, normal, force);
	_health -= damage;
	_take_damage(attacker, damage, normal, force);
	if (_health <= 0):
		_death(attacker);
