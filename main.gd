extends Node3D

const MOUSE_SENSITIVITY : float = 0.004

@onready var debug_label : Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var camera : ShakyCamera3D = $Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.target_fov -= 4
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.target_fov += 4
	
	if event is InputEventMouseMotion:
		camera.target_rotation.x += -event.relative.y * MOUSE_SENSITIVITY
		camera.target_rotation.y += -event.relative.x * MOUSE_SENSITIVITY


func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_accept"):
		camera.add_trauma(1.0 * delta)
	
	debug_label.text =  "Camera Shake         : %s\n" % str(camera.get_shake()).pad_decimals(3)
	debug_label.text += "Camera Trauma        : %s\n" % str(camera._trauma).pad_decimals(3)
	debug_label.text += "Camera Trauma Decay  : %s\n" % str(camera.trauma_decay).pad_decimals(3)
	debug_label.text += "Camera Passive Trauma: %s\n" % str(camera.passive_trauma).pad_decimals(3)
