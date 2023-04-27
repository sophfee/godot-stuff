# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove
# this credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================
class_name FPSWeapon
extends Node3D

var animator: AnimationPlayer;
var camera: Camera3D;

var _releaseSinceLastFire: bool = false;
var _curdel: float = 0;
var flash_time: float = 0;

@export_category("Recoil")
@export var kick: float = 1.0;
@export var skeet: float = 1.0;
@export var skew: float = 1.0;

@export_category("Stats")
@export var damage: float = 6.0;
@export var base_recoil: float = 0.46;
@export var rounds_per_minute: float = 450;
@export var automatic: bool = false;

@export_category("Sound")
@export var primary_fire: AudioStream;
@export var primary_empty: AudioStream;
@export var draw: AudioStream;
@export var holster: AudioStream;
@export var entering_ironsight: AudioStream;
@export var exiting_ironsight: AudioStream;
@export var reload: AudioStream;
var _sfx_primary_fire: AudioStreamPlayer3D;
var _sfx_primary_empty: AudioStreamPlayer3D;
var _sfx_draw: AudioStreamPlayer3D;

@onready var view_model: ViewModel = get_parent();
@onready var fire_sounds: AudioStreamPlayer3D = find_child("FireSounds", true);
@onready var muzzle_flash_light: OmniLight3D = find_child("Flash", true);
@onready var muzzle_particle: MuzzleEffect = find_child("Particle", true);
@onready var combat_object: Combat3D = view_model.get_parent_node_3d().find_child("Combat3D");

var ironsights: bool = false:
	get:
		return (view_model.ironsights_alpha > 0.8);

func _mash(key: String) -> String:
	return "@" + name + "@@" + String.num(hash(self)) + "@&" + key; 

func _ready():
	print("called ready!")
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
	_sfx_primary_fire = AudioStreamPlayer3D.new();
	_sfx_primary_fire.stream = primary_fire;
	_sfx_primary_fire.name = _mash("PRIMARYFIRESFX");
	bone_attach.add_child(_sfx_primary_fire);
	
	# Primary Empty
	_sfx_primary_empty = AudioStreamPlayer3D.new();
	_sfx_primary_empty.stream = primary_empty;
	_sfx_primary_empty.name = _mash("PRIMARYEMPTYSFX");
	bone_attach.add_child(_sfx_primary_empty);
	

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
	assert(_sfx_primary_fire);
	_sfx_primary_fire.play(0.0);
	
var bullet_hole_scene: Node = preload("res://private-shared/cago/decals/BulletHole.tscn").instantiate();

func can_primary_attack() -> bool:
	
	if (_curdel > 0.001):
		return false;
	
	if (!automatic && !_releaseSinceLastFire):
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
	flash_time = 0.03;
	muzzle_particle.emit();
	muzzle_flash_light.visible = true;

func _physics_process(delta):
	if (flash_time == 0):
		muzzle_flash_light.visible = false;
	flash_time = move_toward(flash_time, 0, delta);
	
	_curdel = move_toward(_curdel, 0, delta);
	if (!can_primary_attack()):
		return;
	
	var act_pressed: bool = Input.is_action_pressed("prim_attack");
	var act_just_release: bool = Input.is_action_just_released("prim_attack");
	
	
	if (_curdel == 0 && !automatic && !_releaseSinceLastFire && (act_just_release || !act_pressed)):
		_releaseSinceLastFire = true;
	
	if (automatic):
		if (act_pressed):
			primary_attack();
			_curdel = (60 / rounds_per_minute);
			_releaseSinceLastFire = true;
	else:
		if (Input.is_action_just_pressed("prim_attack")):
			primary_attack();
			print(60/rounds_per_minute);
			_curdel = (60 / rounds_per_minute);
			_releaseSinceLastFire = true;

@warning_ignore("unused_parameter")
func _process(delta):
	pass
