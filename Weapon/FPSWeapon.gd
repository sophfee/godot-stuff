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

var animator: AnimationPlayer;
var camera: Camera3D;
var ironsights: bool = false: get: return get_ironsights();
var magazine: int = 0;
var trigger_released: bool = false;
var current_delay: float = 0;
var primary_fire_stream: AudioStreamPlayer3D;
var primary_empty_stream: AudioStreamPlayer3D;
var draw_stream: AudioStreamPlayer3D;

@onready var damage: float = weapon.damage;
@onready var base_recoil: float = weapon.recoil_additive;
@onready var rounds_per_minute: float = weapon.rounds_per_minute;
@onready var automatic: bool = weapon.automatic;
@onready var primary_fire: AudioStream = weapon.primary_attack;
@onready var primary_empty: AudioStream = weapon.primary_empty;
@onready var draw: AudioStream = weapon.draw;
@onready var holster: AudioStream = weapon.holster;
@onready var entering_ironsight: AudioStream = weapon.entering_ironsight;
@onready var exiting_ironsight: AudioStream = weapon.exiting_ironsight;
@onready var reload: AudioStream = weapon.reload;
@onready var view_model: ViewModel = weapon.view_model;
@onready var muzzle_flash_light: OmniLight3D = find_child("Flash", true);
@onready var muzzle_particle: MuzzleEffect = find_child("Particle", true);
@onready var combat_object: Combat3D = get_parent_node_3d();

func get_ironsights() -> bool:
	return (view_model.ironsights_alpha > 0.8);

func _mash(key: String) -> String:
	return "@" + name + "@@" + String.num(hash(self)) + "@&" + key; 

func _ready():
	# Assertions // Validation
	assert(primary_fire);
	assert(primary_empty);
	assert(view_model);
	assert(combat_object);
	assert(muzzle_particle);
	
	# Bone Attachment
	var bone_attach: BoneAttachment3D = find_child("BoneAttachment3D");
	assert(bone_attach, "You need a BoneAttachment3D connected to your guns muzzle. Keep the name \"BoneAttachment3D\"");
	
	# Primary Fire
	primary_fire_stream = AudioStreamPlayer3D.new();
	primary_fire_stream.stream = primary_fire;
	primary_fire_stream.name = _mash("PRIMARYFIRESFX");
	bone_attach.add_child(primary_fire_stream);
	
	# Primary Empty
	primary_empty_stream = AudioStreamPlayer3D.new();
	primary_empty_stream.stream = primary_empty;
	primary_empty_stream.name = _mash("PRIMARYEMPTYSFX");
	bone_attach.add_child(primary_empty_stream);
	

func primary_attack() -> void:
	pass;
	
func view_punch(punch: Vector3) -> void:
	
	# Ensure we have a camera.
	assert(camera, "You do not have your camera identified.");
	
	camera.rotation += (camera.transform.basis * punch);

func play_anim(anim_name: String) -> void:
	assert(animator, "You do not have a linked animator.");
	animator.play(anim_name);
	
func primary_attack_sound() -> void:
	assert(primary_fire);
	assert(primary_fire_stream);
	primary_fire_stream.play(0.0);
	
var bullet_hole_scene: Node = preload("res://private-shared/cago/decals/BulletHole.tscn").instantiate();

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
			(ray_caster.to_global(Vector3.ZERO) - ray_caster.get_collision_point()).normalized() * -.8,
			ray_caster.get_collision_point() - ray_caster.get_collider().position
		);

func __fire_bullet(ray_caster: RayCast3D):
	var hit: bool = ray_caster.get_collider() != null;
	
	if (hit):
		
		var rt: Node = find_parent("BasePlate");
		assert(rt != null, "Failed to find main.");
		
		var bullet_hole: Node3D = bullet_hole_scene.duplicate();
		assert(bullet_hole != null, "Failed to create bullet hole.");
		rt.add_child(bullet_hole);
		
		bullet_hole.position = ray_caster.get_collision_point();
		bullet_hole.rotation = ray_caster.get_collision_normal();
		bullet_hole.rotation += (Vector3Extension.up(bullet_hole) * randf_range(0, 90));

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
func _process(delta):
	pass

func _reload():
	