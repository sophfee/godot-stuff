extends Node

func forward(node: Node3D) -> Vector3:
	var rot := node.rotation as Vector3;
	var pitch: float = rot.x;
	var yaw: float = rot.y;
	var v: Vector3 = Vector3(
		cos(pitch) * sin(yaw),
		-sin(pitch),
		cos(pitch) * cos(yaw)
	);
	return v;
	
func right(node: Node3D) -> Vector3:
	var rot := node.rotation as Vector3;
	var yaw: float = rot.y;
	var v: Vector3 = Vector3(
		cos(yaw),
		0,
		-sin(yaw)
	);
	return v;

func up(node: Node3D) -> Vector3:
	return forward(node).cross(right(node));
