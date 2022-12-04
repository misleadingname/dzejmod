extends MarginContainer

func _ready():
	print(dzej.sceneGetList())

func select():
	$WindowDialog.rect_size.x = $WindowDialog/VBoxContainer.rect_size.x + 15
	$WindowDialog.rect_size.y = $WindowDialog/VBoxContainer.rect_size.y + 15
	$WindowDialog.popup_centered()


func onNewgame():
	select()
