class_name FPSWeapon
extends Node3D

var Animator: AnimationPlayer;
var Camera: Camera3D;

var _releaseSinceLastFire: bool = false;
var _curdel: float = 0;
var flash_time: float = 0;

@export_category("Recoil")
@export var Kick: float = 1.0;
@export var Skeet: float = 1.0;
@export var Skew: float = 1.0;

@export_category("Stats")
@export var BaseRecoil: float = 0.46;
@export var RoundsPerMinute: float = 450;
@export var Automatic: bool = false;
@onready var VM: ViewModel = get_parent();
@onready var fire_sounds: AudioStreamPlayer3D = find_child("FireSounds", true);
@onready var muzzle_flash_light: OmniLight3D = find_child("Flash", true);
@onready var muzzle_particle: MuzzleEffect = find_child("Particle", true);

var ironsights: bool = false:
	get:
		return (VM.IronsightsTime > 0.8);

func _ready():
	pass # Replace with function body.

func primary_attack() -> void:
	pass;
	
func view_punch(punch: Vector3) -> void:
	
	# Ensure we have a camera.
	assert(Camera != null, "You do not have your Camera identified.");
	
	Camera.rotation += (Camera.transform.basis * punch);

func play_anim(anim_name: String) -> void:
	assert(Animator != null, "You do not have a linked animator.");
	Animator.play(anim_name);
	
func primary_attack_sound() -> void:
	assert(fire_sounds != null, "You do not have fire sounds setup with your weapon.");
	fire_sounds.play(0.0);
	
var bullet_hole_scene: Node = preload("res://private-shared/cago/decals/BulletHole.tscn").instantiate();

func can_primary_attack() -> bool:
	
	if (_curdel > 0.001):
		return false;
	
	if (!Automatic && !_releaseSinceLastFire):
		return false;
	
	return true;

func fire_bullet(ray_caster: RayCast3D):
	var hit: bool = ray_caster.get_collider() != null;
	
	if (hit):
		var rt: Node = find_parent("Main");
		assert(rt != null, "Failed to find main.");
		
		var bullet_hole: Node3D = bullet_hole_scene.duplicate();
		assert(bullet_hole != null, "Failed to create bullet hole.");
		rt.add_child(bullet_hole);
		
		bullet_hole.position = ray_caster.get_collision_point();
		bullet_hole.rotation = ray_caster.get_collision_normal();
		bullet_hole.rotation += (Axes.up(bullet_hole) * randf_range(0, 90));

func muzzle_flash() -> void:
	flash_time = 0.05;
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
	
	
	if (_curdel == 0 && !Automatic && !_releaseSinceLastFire && (act_just_release || !act_pressed)):
		_releaseSinceLastFire = true;
	
	if (Automatic):
		if (act_pressed):
			primary_attack();
			_curdel = (60 / RoundsPerMinute);
			_releaseSinceLastFire = true;
	else:
		if (Input.is_action_just_pressed("prim_attack")):
			primary_attack();
			print(60/RoundsPerMinute);
			_curdel = (60 / RoundsPerMinute);
			_releaseSinceLastFire = true;

@warning_ignore("unused_parameter")
func _process(delta):
	pass
