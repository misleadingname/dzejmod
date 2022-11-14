extends WindowDialog

onready var inputBox = $LineEdit
onready var outputBox = $TextEdit

func _on_LineEdit_text_entered(new_text):
	outputBox.text += "$" + new_text + "\n"
	inputBox.text = ""

	dzej.root.call_deferred(new_text)