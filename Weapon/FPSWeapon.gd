# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

class_name FPSWeapon
extends Node3D

@export_category("Weapon")
@export var weapon: WeaponInfo;
@export var _owner: PlayerNode;
@export var combat_object: Combat3D;
@export var view_model: ViewModel;

var camera: Camera3D;
var magazine: int = 30;
var trigger_released: bool = false;
var current_delay: float = 0;
var primary_fire_stream: AudioStreamPlayer3D;
var primary_empty_stream: AudioStreamPlayer3D;
var draw_stream: AudioStreamPlayer3D;
var animation_tree: AnimationTree;
var animgraph: AnimationNode;
var ironsights: bool = false:
	get: return get_ironsights();

@onready var animator: AnimationPlayer = find_child("AnimationPlayer");
@onready var damage: float = weapon.damage;
@onready var base_recoil: float = weapon.recoil_additive;
@onready var rounds_per_minute: float = weapon.rounds_per_minute;
@onready var automatic: bool = weapon.automatic;
@onready var primary_fire: AudioStream = weapon.primary_fire;
@onready var primary_empty: AudioStream = weapon.primary_empty;
@onready var draw: AudioStream = weapon.draw;
@onready var holster: AudioStream = weapon.holster;
@onready var entering_ironsight: AudioStream = weapon.entering_ironsight;
@onready var exiting_ironsight: AudioStream = weapon.exiting_ironsight;
@onready var reload: AudioStream = weapon.reload;
@onready var muzzle_flash_light: OmniLight3D = find_child("Flash", true);
@onready var muzzle_particle: MuzzleEffect = find_child("Particle", true);
@onready var idle_anim: String = weapon.animation_idle;
@onready var fire_anim: String = weapon.animation_fire;
@onready var ray_cast: RayCast3D = find_child("MuzzleRayCast");

func _mash(key: String) -> String:
	return "@" + name + "@@" + String.num(hash(self)) + "@&" + key; 

func _ready():
	# Assertions // Validation
	assert(primary_fire, "No primary fire sound effect associated, cannot load!");
	assert(primary_empty, "No empty sound effect associated, cannot load!");
	assert(animator, "No AnimationPlayer associated, cannot load!");
	assert(combat_object, "No Combat3D linked, cannot load!");
	assert(muzzle_particle, "No Muzzle Particle located, cannot load!");
	
	# Bone Attachment
	var bone_attach: Node3D = find_child("BoneAttachment3D");
	assert(bone_attach, "You need a BoneAttachment3D connected to your guns muzzle. Keep the name \"BoneAttachment3D\"");
	
	# Primary Fire
	primary_fire_stream = AudioStreamPlayer3D.new();
	primary_fire_stream.stream = primary_fire;
	primary_fire_stream.name = "Stream@PrimaryFire";
	bone_attach.add_child(primary_fire_stream);
	
	# Primary Empty
	primary_empty_stream = AudioStreamPlayer3D.new();
	primary_empty_stream.stream = primary_empty;
	primary_empty_stream.name = "Stream@PrimaryEmpty";
	bone_attach.add_child(primary_empty_stream);
	

func primary_attack() -> void:
	muzzle_flash();
	if (ironsights):
		var roll_p: float = randf_range(-0.03, 0.03);
		view_model.punch(
			Vector3(roll_p * .1,-.01, .04),
			Vector3(.03,  0, roll_p)
		);
	else:
		view_model.punch(
			Vector3(0, -.004, .06),
			Vector3(0,  0, randf_range(-0.1, 0.1))
		);
		#animation_tree.set("parameters/StateMachine/is_fire", true);
	
	primary_attack_sound();
	view_punch(Vector3(.01, 0, 0));
	
	fire_bullet(ray_cast);

func view_punch(punch: Vector3) -> void:
	
	# Ensure we have a camera.
	_owner.camera.rotation += (_owner.camera.transform.basis * punch);

func play_anim(anim_name: String) -> void:
	assert(animator, "You do not have a linked animator.");
	animator.play(anim_name);
	
func primary_attack_sound() -> void:
	assert(primary_fire);
	assert(primary_fire_stream);
	primary_fire_stream.play(0.0);
	


func can_primary_attack() -> bool:
	
	if (current_delay > 0.001):
		return false;
	
	if (!automatic && !trigger_released):
		return false;
	
	return true;

func fire_bullet(ray_caster: RayCast3D) -> void:
	var hit: bool = ray_caster.get_collider() != null;
	
	if (hit):
		var obj := ray_caster.get_collider().find_child("Combat3D") as Combat3D;
		
		if (obj == null):
			return;
		assert(combat_object);
		
		obj.inflict_damage(
			combat_object, 
			damage, 
			ray_caster.get_collision_normal(), 
			(ray_caster.to_global(Vector3.ZERO) - ray_caster.get_collision_point()).normalized() * -.8
		);

func muzzle_flash() -> void:
	muzzle_particle.emit();

func _physics_process(delta):
	current_delay = move_toward(current_delay, 0, delta);
	if (!can_primary_attack()):
		return;
	
	var act_pressed: bool = Input.is_action_pressed("prim_attack");
	var act_just_release: bool = Input.is_action_just_released("prim_attack");
	
	if (current_delay == 0 && !automatic && !trigger_released && (act_just_release || !act_pressed)):
		trigger_released = true;
	
	if (automatic):
		if (act_pressed):
			primary_attack();
			current_delay = (60 / rounds_per_minute);
			trigger_released = true;
	else:
		if (Input.is_action_just_pressed("prim_attack")):
			primary_attack();
			current_delay = (60 / rounds_per_minute);
			trigger_released = true;

@warning_ignore("unused_parameter")
func _process(delta: float):
	if (animation_tree):
		animation_tree.advance(delta);
	if (animgraph):
		if (current_delay == 0):
			var auto_is_fire = animation_tree.get("parameters/StateMachine/is_fire");
			if (auto_is_fire == null):
				return;
			
			if (auto_is_fire == false):
				return;
			
			animation_tree.set("parameters/StateMachine/is_fire", false);

func get_ironsights() -> bool:
	return (view_model.ironsights_alpha > 0.8);

func can_reload():
	var r: int = _owner.get_ammo(weapon.ammo_type);
	var n: int = (weapon.magazine_size - magazine);

	# Max
	if (n == 0):
		return false;

	# Min
	if (r <= 0):
		return false;
	
	return true;

func _reload():
	assert(weapon.ammo_type);

	if (!can_reload()):
		return false;
	
	var r: int = owner.get_ammo(weapon.ammo_type);
	var n: int = (weapon.magazine_size - magazine);
	var x: int = (r - n);

	if (x < 0):
		magazine += r;
		_owner.set_ammo(weapon.ammo_type, 0);
	else:
		magazine += n;
		_owner.take_ammo(weapon.ammo_type, x);
