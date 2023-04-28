class_name AmmoType
extends Resource

@export var force: float = 10;
@export var penetration_scale: int = 0;
@export var display_name: String = "9x19mm";

func _init(p_force: float, p_penetration_scale: int, p_display_name: String):
    force = p_force;
    penetration_scale = p_penetration_scale;
    display_name = p_display_name;