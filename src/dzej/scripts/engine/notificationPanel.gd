extends PanelContainer

onready var anim = $AnimationPlayer
onready var label = $notifText

func displaynotif(text, timeout):
	dzej.msg("[LP_" + str(self) + "] Displaying notification: " + str(text))
	label.text = str(text)
	anim.play("notifAnimation")
	yield(get_tree().create_timer(int(timeout)), "timeout")
	anim.play("notifAnimationHide")
	yield(get_tree().create_timer(0.4), "timeout")
	dzej.msg("[LP_" + str(self) + "] Time to die!!!! :D")
	self.queue_free()
