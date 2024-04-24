extends Node

# map setup signals
signal on_map_tile_size_update(value: Vector2i)
signal on_map_path_update(value: Array[Vector2i])
signal on_tilemap_set

# map id signals
signal on_set_target(value: Vector2i)
signal on_poi_hover(value: Types.POI_TYPES)
signal on_tile_clicked(id: Vector2i)
signal on_horse_tile_changed(id: Vector2i)
signal on_factory_click(id: Vector2i)

# time signals
signal on_time_tick
signal on_time_changed

# factory signals
signal on_factory_queue_update(id: Vector2i)
signal on_factory_output_update(id: Vector2i)

#inventory signals
signal on_inventory_update

# gui signals
signal on_factory_gui_close(id: Vector2i)
signal on_wait_hud_display(id: Vector2i, recipe: Types.Recipe)
signal on_wait_hud_close
