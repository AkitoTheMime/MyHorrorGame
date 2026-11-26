extends Control

func _on_continue_pressed() -> void:
	get_tree().paused = false
	self.visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()
