# godot-3d-camera-shake
> [!NOTE]
> This script was made for Godot 4

Minimalist Camera3D script with realisitic camera shake and interpolated rotation, based off of an implementation discussed in this [GDC video](https://www.youtube.com/watch?v=tu-Qe66AvtY).

# Usage
Copy and paste the camera.gd script into your Godot project, and apply it to a Camera3D node. Tweak the following export properties to your preference:
* Shake Scale
  * The power that trauma is raised to in order to calculate camera shake. 
* Intensity
  * Vector3 describing the intensity of the camera shake on each axis.
* Trauma Decay
  * The rate at which trauma decays
* Passive Trauma
  * The minimum amount of trauma. Set to a non-zero value for a found footage feel.
* Mouse Sensitivity
* Follow Weight
  * The weight for interpolating the camera's actual rotation to it's target rotation
