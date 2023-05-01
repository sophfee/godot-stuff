class_name WeaponInfo
extends Resource

## The basic values to make a weapon work.
@export_category("Basic")

## The text that is displayed to the end user
## when interacting with this weapon.
@export var display_name: String = "";

## The base damage that is influenced by several factors.
## Factors include penetration, falloff, and hit position.
@export var damage: float = 0;

@export var automatic: bool = false;

## The speed at which the weapon will be able to fire a round,
## if the Automatic flag is used, then this will fire at this
## rate until stopped or until it runs out of bullets.
@export var rounds_per_minute: float = 500;

## The maximum amount of bullets that can be held in the
## weapon at a given time, the "Can Chamber" property will
## allow for one additional bullet to be in the chamber of the weapon.
@export var magazine_size: int = 10;

## The type of ammunition this weapon will use.
@export var ammo_type: AmmoType;

@export var view_model: ViewModel;

## All information regarding the spread of a weapon influenced
## by many factors defined here.
@export_category("Spread")

## The base cone of spread, this value is actually divided by 100, so
## you can have more precise control over the cone angle.
@export var base_cone: float = 3.2;

## The minimum spread value, this correlates to a
## multiplier of the base cone.
@export var minimum: float = 0;

## The maximum spread value, this correlates to a
## multiplier of the base cone.
@export var maximum: float = 3;

## This is a regulation value of additive spread effects, it'll
## reduce the additive values by this number every second.
@export var recovery_rate: float = 0.1;

## The spread additional value that'll be recorded upon each
## time the weapon is fired.
@export var recoil_additive: float = 0.1;

## The spread multiplier value that'll be applied corresponding to
## the amount of recoil.
@export var recoil_multiplier: float = 1.1;

## A multiplier of the speed of the user normalized (1 = base speed)
@export var velocity_multiplier: float = 2;

## The spread multiplier when aiming down the sights.
@export var ironsight_multiplier: float = 0.5;

## The amount spread will be multiplied while the user is crouching.
@export var crouch_multiplier: float = 0.5;

## The multpplier applied when the user is in the air.
@export var air_multiplier: float = 3;

## The controller of all the audio played from your weapon.
@export_category("Sound")

@export var primary_fire: AudioStream;
@export var primary_empty: AudioStream;
@export var draw: AudioStream;
@export var holster: AudioStream;
@export var entering_ironsight: AudioStream;
@export var exiting_ironsight: AudioStream;
@export var reload: AudioStream;

@export_category("Animation")
@export var animation_idle: String = "firstperson_idle";
@export var animation_fire: String = "firstperson_shoot01";
