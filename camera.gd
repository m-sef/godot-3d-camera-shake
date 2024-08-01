class_name Camera3DShake
extends Camera3D

enum ShakeScale {
	LINEAR = 1,
	SQUARED = 2,
	CUBED = 3
}

#region Constants
const MIN_TRAUMA : float = 0.0
const MAX_TRAUMA : float = 1.0
const MIN_MOUSE_SENSITIVITY : float = 0.0
const MAX_MOUSE_SENSITIVITY : float = 1.0
const MIN_FOLLOW_WEIGHT : float = 0.001
const MIN_SHAKE : float = 0.0
const MAX_SHAKE : float = 1.0
const UINT_MAX : int = 0x7fffffff
#endregion
#region Exports
@export var shake_scale : ShakeScale = ShakeScale.CUBED

@export var intensity : Vector3 = Vector3.ONE :
	set = set_shake_intensity, get = get_shake_intensity

@export_range(MIN_TRAUMA, MAX_TRAUMA, 0.01) var trauma_decay : float = 0.5 :
	set = set_trauma_decay, get = get_trauma_decay

@export_range(MIN_TRAUMA, MAX_TRAUMA, 0.01) var passive_trauma : float = 0.0

@export_range(MIN_MOUSE_SENSITIVITY, MAX_MOUSE_SENSITIVITY) var mouse_sensitivity : float = 0.01 :
	set = set_mouse_sensitivity, get = get_mouse_sensitivity

@export var follow_weight : float = 10.0 :
	set = set_follow_weight, get = get_follow_weight
#endregion
#region Public Variables
var target_fov : float = fov :
	set = set_target_fov, get = get_target_fov

var target_rotation : Vector3 = Vector3.ZERO :
	set = set_target_rotation, get = get_target_rotation

var shake : float = 0.0 :
	set = set_shake, get = get_shake
#endregion
#region Private Variables
@onready var _trauma : float = passive_trauma
@onready var _noise : FastNoiseLite = FastNoiseLite.new()
#endregion
#region Set Functions
func set_shake_intensity(value : Vector3) -> void:
	intensity = value

func set_trauma_decay(value : float) -> void:
	trauma_decay = clampf(value, MIN_TRAUMA, MAX_TRAUMA)

func set_mouse_sensitivity(value : float) -> void:
	mouse_sensitivity = clampf(value, MIN_MOUSE_SENSITIVITY, MAX_MOUSE_SENSITIVITY)

func set_follow_weight(value : float) -> void:
	follow_weight = maxf(MIN_FOLLOW_WEIGHT, value)

func set_target_fov(value : float) -> void:
	target_fov = value

func set_target_rotation(value : Vector3) -> void:
	target_rotation = value

func set_shake(value : float):
	shake = clampf(value, MIN_SHAKE, MAX_SHAKE)
#endregion
#region Get Functions
func get_shake_intensity() -> Vector3:
	return intensity

func get_trauma_decay() -> float:
	return trauma_decay

func get_mouse_sensitivity() -> float:
	return mouse_sensitivity

func get_follow_weight() -> float:
	return follow_weight

func get_target_fov() -> float:
	return target_fov

func get_target_rotation() -> Vector3:
	return target_rotation

func get_shake() -> float:
	return shake
#endregion

func add_trauma(amount : float) -> void:
	_trauma = minf(_trauma + amount, MAX_TRAUMA)

func clear_trauma() -> void:
	_trauma = passive_trauma

func _camera_shake() -> void:
	shake = pow(_trauma, shake_scale)
	
	var tick : int = Time.get_ticks_msec()
	
	target_rotation.x += (shake * _noise.get_noise_2d(_noise.seed * 1, tick) * intensity.x)
	target_rotation.y += (shake * _noise.get_noise_2d(_noise.seed * 2, tick) * intensity.y)
	target_rotation.z += (shake * _noise.get_noise_2d(_noise.seed * 3, tick) * intensity.z)

func _ready() -> void:
	randomize()
	# HACK Applying a bitmask to the seed to prevent it from being a negative value
	# When the seed is negative, the camera shake acts unpredictably
	_noise.set_seed(randi() % UINT_MAX)
	_noise.set_noise_type(FastNoiseLite.TYPE_PERLIN)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_rotation.x += -event.relative.y * mouse_sensitivity
		target_rotation.y += -event.relative.x * mouse_sensitivity

func _physics_process(delta : float) -> void:
	if _trauma:
		_trauma = maxf(_trauma - trauma_decay * delta, passive_trauma)
		_camera_shake()
	
	# Clamp the camera's x rotation to be within the range -90° to 90°
	target_rotation.x = clamp(target_rotation.x, -PI/2, PI/2)
	
	# Gradually reset the camera's z rotation
	target_rotation.z = lerpf(target_rotation.z, 0.0, follow_weight * delta)
	
	rotation = lerp(rotation, target_rotation, follow_weight * delta)
	fov = lerp(fov, target_fov, 10.0 * delta)
