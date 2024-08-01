extends Node3D

@onready var debug_label : Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Label

@onready var camera : Camera3DShake = $Camera3D

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.target_fov -= 4
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.target_fov += 4

func _process(delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		camera.add_trauma(1.0 * delta)
	
	debug_label.text = "Shake: " + str(camera.get_shake()).pad_decimals(3)
	debug_label.text += "\nScale: " + str(camera.shake_scale)
	debug_label.text += "\nIntensity: " + str(camera.intensity)
	debug_label.text += "\nTrauma: " + str(camera._trauma).pad_decimals(3)
	debug_label.text += "\nTrauma Decay: " + str(camera.trauma_decay)
	debug_label.text += "\nPassive Trauma: " + str(camera.passive_trauma)
