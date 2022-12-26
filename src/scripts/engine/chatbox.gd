extends Control

onready var chatOutput = $VBox/ChatOutput
onready var chatInput = $VBox/ChatInput

onready var chatKey = InputMap.get_action_list("engine_chat")[0].as_text()

func _ready():
	chatInput.placeholder_text = "Press " + chatKey + " to chat..."

	addText("Welcome to Dzejmod!\nWe're playing " + dzej.targetGamemode + " on " + dzej.targetScene + ".\n\nEnjoy your stay!")
	
func addText(text : String):
	chatOutput.add_text(text + "\n")

func _input(event):
	if(event.is_action_pressed("engine_chat")):
		if(chatInput.editable):
			dzej.lpMouseLock(true)
			dzej.chatting = false

			chatInput.editable = false
			chatInput.placeholder_text = "Press " + chatKey + " to chat..."
			
			var strippedText = chatInput.text.strip_edges()

			if(strippedText != ""):
				dzej.mpSendChat(strippedText)
				chatInput.text = ""
		else:
			dzej.lpMouseLock(false)

			dzej.chatting = true

			chatInput.grab_focus()
			chatInput.editable = true
			chatInput.placeholder_text = "Press " + chatKey + " to send a message..."

	if(event.is_action_pressed("ui_cancel")):
		if(chatInput.editable):
			dzej.lpMouseLock(true)
			dzej.chatting = false

			chatInput.editable = false
			chatInput.placeholder_text = "Press " + chatKey + " to chat..."
