# godot-3d-camera-shake
> [!NOTE]
> This script was made for Godot 4

Minimalalist Camera3D script for a first person camera with realisitic camera shake and interpolated rotation, based off of an implementation discussed in this [GDC video](https://youtu.be/tu-Qe66AvtY?si=YpmcTn_-Flh5qUOh).

# Usage
Copy and paste the camera.gd script into your Godot project, and apply it to a Camera3D node. Tweak the following export properties to your preference:
* Camera Shake Scale
  * Describes the relationship between trauma and camera shake
* Shake Intensity
  * Vector3 describing intensity of camera shake on each axis
* Trauma Decay
  * The rate at which trauma decays
* Trauma Min
  * Minimum trauma. Change to a non-zero value for a found footage feel.
* Trauma Max
* Mouse Sensitivity
* Follow Speed
  * Speed at which the camera's rotation will interpolate to the camera's target rotation.
