class_name FPSWeapon
extends Node3D

var Animator: AnimationPlayer;
var Camera: Camera3D;

var _releaseSinceLastFire: bool = false;
var _curdel: float = 0;
var _delay: float = 0;

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
@onready var muzzle_flash_light: SpotLight3D = find_child("MuzzleFlash", true);

var ironsights: bool = false:
	get:
		return (VM.IronsightsTime > 0.8);

func rpm_to_delay(f_rpm: float) -> float:
	return (f_rpm / 60);

func _ready():
	pass # Replace with function body.

func primary_attack() -> void:
	pass;
	
func view_punch(punch: Vector3) -> void:
	
	# Ensure we have a camera.
	assert(Camera != null, "You do not have your Camera identified.");
	
	Camera.rotation += (Camera.transform.basis * punch);

func play_anim(name: String) -> void:
	assert(Animator != null, "You do not have a linked animator.");
	Animator.play(name);
	
func primary_attack_sound() -> void:
	assert(fire_sounds != null, "You do not have fire sounds setup with your weapon.");
	fire_sounds.play(0.0);

func can_primary_attack() -> bool:
	
	if (_curdel > 0.001):
		return false;
	
	if (!Automatic && !_releaseSinceLastFire):
		return false;
	
	return true;

func _physics_process(delta):
	if (muzzle_flash_light):
		muzzle_flash_light.visible = false;

func _process(delta):
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
