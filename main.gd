extends Node3D

@onready var debug_label : Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Label

@onready var camera : FirstPersonCamera = $Camera3D

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event.is_action_pressed("ui_accept"):
		camera.add_trauma(0.1)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.target_fov -= 4
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.target_fov += 4
	

func _process(delta) -> void:
	debug_label.text = "mouse_sensitivity=" + str(camera.mouse_sensitivity)
	debug_label.text += "\nfollow_speed=" + str(camera.follow_speed)
	
	debug_label.text += "\n\nshake=" + str(camera.shake).pad_decimals(3)
	debug_label.text += "\nscale=" + str(camera.camera_shake_scale)
	debug_label.text += "\nshake_intensity=" + str(camera.shake_intensity)
	
	debug_label.text += "\n\ntrauma=" + str(camera.trauma).pad_decimals(3)
	debug_label.text += "\ntrauma_decay=" + str(camera.trauma_decay)
	debug_label.text += "\ntrauma_min=" + str(camera.trauma_min)
	debug_label.text += "\ntrauma_max=" + str(camera.trauma_max)
