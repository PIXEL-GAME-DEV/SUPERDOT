extends RigidBody3D


@export var _mouse_dpi: int = 1000


var gravity := Vector3.ZERO 

var _look := Vector3.ZERO

var _move := Vector3.ZERO

var _time_speed := 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%Orientation.global_basis = global_basis


func _process(_delta: float) -> void:
	gravity = get_gravity()
	
	var _basis_x = %Orientation.global_basis.x
	var _basis_y = %Orientation.global_basis.y
	var _basis_z = %Orientation.global_basis.z
	
	var _roll := Input.get_axis("-roll", "roll")
	_look.z = _roll / 60
	
	var _vector := Input.get_vector("-x", "x", "-z" ,"z")
	var _vertical := Input.get_axis("-y", "y")
	_move = Vector3(_vector.x, _vertical, _vector.y)
	
	%Orientation.rotate_object_local(Vector3.UP, _look.x)
	%Orientation.rotate_object_local(Vector3.RIGHT, _look.y)
	#%Orientation.rotate_object_local(Vector3.FORWARD, _look.z)
	
	var _plane := Plane(%Orientation.global_basis.z)
	
	var _angle = _basis_y.signed_angle_to(_plane.project(-gravity), -_basis_z)
	
	%Orientation.rotate_object_local(Vector3.FORWARD, _angle)
	
	%Camera3D.global_position = global_position + global_basis.y * 0.6
	%Camera3D.global_basis = %Orientation.global_basis


func _physics_process(_delta: float) -> void:
	gravity = get_gravity()
	apply_central_force(%Orientation.global_basis * _move * mass)
	apply_force(-gravity * mass, global_basis.y)
	apply_force(gravity * mass, -global_basis.y)
	
	_time_speed = remap(clampf(_look.length() + _move.length(), 0, 1), 0, 1, 0.1, 1)
	Engine.time_scale = _time_speed
	
	_look = Vector3.ZERO
	_move = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _mouse: Vector2 = -event.relative
		_look.x = _mouse.x / _mouse_dpi
		_look.y = _mouse.y / _mouse_dpi
