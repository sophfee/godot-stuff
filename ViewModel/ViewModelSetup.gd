class_name ViewModelSetup
extends Resource


@export_category("Offset")
## The position of the weapon when it is being aimed down the sights.
@export var ironsights_offset_position: Vector3 = Vector3(0, 0, 0);

## The rotation of the weapon when it is being aimed down the sights.
@export var ironsights_offset_rotation: Vector3 = Vector3(0, 0, 0);

## The base position of the weapon.
@export var base_offset_position: Vector3 = Vector3(0, 0, 0);

## The base rotation of the weapon.
@export var base_offset_rotation: Vector3 = Vector3(0, 0, 0);

@export var sprint_offset_position: Vector3 = Vector3(0, 0, 0);

@export var sprint_offset_rotation: Vector3 = Vector3(0, 0, 0);

@export_category("Bob")

## The amount of bobbing on the right axis when moving.
@export var bob_right: float = 4;

## The rate of bobbing on the right axis when moving.
@export var bob_right_rate: float = 8.4;

## The amount of bobbing on the up axis when moving.
@export var bob_up: float = 2.3;

## The rate of bobbing on the up axis when moving.
@export var bob_up_rate: float = 16.8;

@export var walking_offset: Vector3 = Vector3(0, 0, 0);

@export_category("Sway")

## The amount of sway given the mouse movement.
@export var sway_x_multiplier: float = 0.06;

## The amount of yaw rotation given the sway on the X axis.
@export var sway_x_yaw_multiplier: float = -.28;

## The amount of roll rotation given the sway on the X axis.
@export var sway_x_roll_multiplier: float = -.28;

## The amount of positional sway given the mouse movement.
@export var sway_x_position_multiplier: float = -.02;

## The amount of sway given the mouse movement.
@export var sway_y_multiplier: float = 0.06;

## The amount of positional movement given the sway on the Y axis.
@export var sway_y_position_multiplier: float = -.02;

## The amount of pitch rotation given the sway on the Y axis.
@export var sway_y_pitch_multiplier: float = .20;

@export_category("Modifiers")

@export var ironsights_sway_multiplier: float = .2;