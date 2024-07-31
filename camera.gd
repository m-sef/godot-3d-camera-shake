class_name FirstPersonCamera
extends Camera3D

enum ShakeScale {
	LINEAR = 1,
	SQUARED = 2,
	CUBED = 3
}

@export_category("Camera Shake")
@export var camera_shake_scale : ShakeScale = ShakeScale.CUBED
@export var shake_intensity : Vector3 = Vector3.ONE
@export_range(0, 1, 0.01) var trauma_decay : float = 0.5
@export_range(0, 1, 0.01) var trauma_min : float = 0.0
@export_range(0, 1, 0.01) var trauma_max : float = 1.0

@export_category("Mouse")
@export_range(0, 1, 0.01) var mouse_sensitivity : float = 0.01
@export var follow_speed : float = 10.0

var shake : float = 0.0
var target_fov : float = fov
var target_rotation : Vector3 = Vector3.ZERO

@onready var trauma : float = trauma_min
@onready var _noise : FastNoiseLite = FastNoiseLite.new()

func add_trauma(amount : float) -> void:
	trauma = minf(trauma + amount, trauma_max)

func _shake() -> void:
	shake = pow(trauma, camera_shake_scale)
	
	var ticks : int = Time.get_ticks_msec()
	
	target_rotation.x += (shake * _noise.get_noise_2d(_noise.seed * 1, ticks) * shake_intensity.x)
	target_rotation.y += (shake * _noise.get_noise_2d(_noise.seed * 2, ticks) * shake_intensity.y)
	target_rotation.z += (shake * _noise.get_noise_2d(_noise.seed * 3, ticks) * shake_intensity.z)

func _ready() -> void:
	randomize()
	# HACK Applying a bitmask to the seed to prevent it from being a negative value
	# When the seed is negative, the camera shake acts unpredictably
	_noise.set_seed(randi() % 0x7fffffff)
	_noise.set_noise_type(FastNoiseLite.TYPE_PERLIN)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_rotation.x += -event.relative.y * mouse_sensitivity
		target_rotation.y += -event.relative.x * mouse_sensitivity

func _physics_process(delta : float) -> void:
	if trauma:
		trauma = maxf(trauma - trauma_decay * delta, trauma_min)
		_shake()
	
	# Clamp the camera's x rotation to be within the range -90° to 90°
	target_rotation.x = clamp(target_rotation.x, -PI/2, PI/2)
	
	# Gradually reset the camera's z rotation
	target_rotation.z = lerpf(target_rotation.z, 0.0, follow_speed * delta)
	
	rotation = lerp(rotation, target_rotation, follow_speed * delta)
	fov = lerp(fov, target_fov, 10.0 * delta)
