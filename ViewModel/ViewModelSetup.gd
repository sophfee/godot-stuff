class_name ViewModelSetup
extends Resource


@export_category("Offset")
@export var ironsights_offset_position: Vector3 = Vector3(0, 0, 0);
@export var ironsights_offset_rotation: Vector3 = Vector3(0, 0, 0);
@export var base_offset_position: Vector3 = Vector3(0, 0, 0);
@export var base_offset_rotation: Vector3 = Vector3(0, 0, 0);
@export_category("Bob")
@export var bob_right: float = 4;
@export var bob_right_rate: float = 8.4;
@export var bob_up: float = 2.3;
@export var bob_up_rate: float = 16.8;
@export_category("Sway")
@export var sway_x_multiplier: float = 0.06;
@export var sway_x_yaw_multiplier: float = -.28;
@export var sway_x_roll_multiplier: float = -.28;
@export var sway_x_position_multiplier: float = -.02;
@export var sway_y_multiplier: float = 0.06;
@export var sway_y_position_multiplier: float = -.02;
@export var sway_y_pitch_multiplier: float = .20;
@export_category("Modifiers")
@export var ironsights_sway_multiplier: float = .2;