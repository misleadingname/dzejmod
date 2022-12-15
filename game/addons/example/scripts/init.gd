extends Node # This is the base class for the initScript node.

# Every script needs a "onLoad(scene)" function, which is called when dzejmod is ready to initalise addons.
func onLoad(scene):
	dzej.msg("Hello World!")
	dzej.lpShowNotification("Here's a notification!")

	return true # Return true to indicate that the script has been loaded successfully.