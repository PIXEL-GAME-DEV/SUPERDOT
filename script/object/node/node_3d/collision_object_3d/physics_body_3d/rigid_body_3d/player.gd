extends RigidBody3D


@export var _mouse_dpi: int = 1000


var _look := Vector3.ZERO

var _move := Vector3.ZERO

var _time_speed := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%Orientation.global_basis = global_basis


func _process(_delta: float) -> void:
	var _roll := Input.get_axis("-roll", "roll")
	_look.z = _roll / 60
	
	var _vector := Input.get_vector("-x", "x", "-z" ,"z")
	var _vertical := Input.get_axis("-y", "y")
	_move = Vector3(_vector.x, _vertical, _vector.y)
	
	%Orientation.rotate_object_local(Vector3.UP, _look.x)
	%Orientation.rotate_object_local(Vector3.RIGHT, _look.y)
	%Orientation.rotate_object_local(Vector3.FORWARD, _look.z)
	
	%Camera3D.global_basis = %Orientation.global_basis


func _physics_process(_delta: float) -> void:
	var _gravity = get_gravity()
	apply_central_force(%Orientation.global_basis * _move * mass)
	apply_force(-_gravity * mass, global_basis.y)
	apply_force(_gravity * mass, -global_basis.y)
	
	_time_speed = remap(clampf(_look.length() + _move.length(), 0, 1), 0, 1, 0.1, 1)
	Engine.time_scale = _time_speed
	
	_look = Vector3.ZERO
	_move = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _mouse: Vector2 = -event.relative
		_look.x = _mouse.x / _mouse_dpi
		_look.y = _mouse.y / _mouse_dpi
