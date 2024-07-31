class_name Camera3DShake
extends Camera3D

enum ShakeScale {
	LINEAR = 1,
	SQUARED = 2,
	CUBED = 3
}

const MIN_TRAUMA : float = 0.0
const MAX_TRAUMA : float = 1.0

@export var shake_scale : ShakeScale = ShakeScale.CUBED
@export var intensity : Vector3 = Vector3.ONE
@export_range(MIN_TRAUMA, MAX_TRAUMA, 0.01) var trauma_decay : float = 0.5
@export_range(MIN_TRAUMA, MAX_TRAUMA, 0.01) var passive_trauma : float = 0.0

@export_range(0.0, 1.0, 0.01) var mouse_sensitivity : float = 0.01
@export_range(0.0, 100.0, 0.01, "or_greater") var follow_weight : float = 10.0

var target_fov : float = fov
var target_rotation : Vector3 = Vector3.ZERO
var _shake : float = 0.0

@onready var _trauma : float = passive_trauma
@onready var _noise : FastNoiseLite = FastNoiseLite.new()

func add_trauma(amount : float) -> void:
	_trauma = minf(_trauma + amount, MAX_TRAUMA)

func _camera_shake() -> void:
	_shake = pow(_trauma, shake_scale)
	
	var ticks : int = Time.get_ticks_msec()
	
	target_rotation.x += (_shake * _noise.get_noise_2d(_noise.seed * 1, ticks) * intensity.x)
	target_rotation.y += (_shake * _noise.get_noise_2d(_noise.seed * 2, ticks) * intensity.y)
	target_rotation.z += (_shake * _noise.get_noise_2d(_noise.seed * 3, ticks) * intensity.z)

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
	if _trauma:
		_trauma = maxf(_trauma - trauma_decay * delta, passive_trauma)
		_camera_shake()
	
	# Clamp the camera's x rotation to be within the range -90° to 90°
	target_rotation.x = clamp(target_rotation.x, -PI/2, PI/2)
	
	# Gradually reset the camera's z rotation
	target_rotation.z = lerpf(target_rotation.z, 0.0, follow_weight * delta)
	
	rotation = lerp(rotation, target_rotation, follow_weight * delta)
	fov = lerp(fov, target_fov, 10.0 * delta)
