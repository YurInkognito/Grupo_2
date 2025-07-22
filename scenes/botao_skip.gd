extends Button

func _on_pressed() -> void:
	$"/root/GlobalData".proxima_fase()
	Dialogic.end_timeline()
