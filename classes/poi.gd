class_name POI

static func id3(id: Vector2i, map_id: int = 0) -> Vector3i:
	return Vector3i(id.x, id.y, map_id)

static func id2(id: Vector3i) -> Vector2i:
	return Vector2i(id.x, id.y)
