extends WindowDialog

onready var inputBox = $LineEdit
onready var outputBox = $TextEdit

func _ready():
	self.visible = true
	dzej.consoleVisible = true

func _on_LineEdit_text_entered(new_text):
	outputBox.append_text("$" + new_text)
	inputBox.text = ""
