@tool
extends EditorPlugin

var ui


func _enable_plugin() -> void:
	pass
	# Add autoloads here.


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# プレビューもこの時点でどこかのUIにセットしたほうが良くない？
	ui = preload("res://addons/novellikesystem/json_convert.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, ui)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(ui)
	ui.free()
