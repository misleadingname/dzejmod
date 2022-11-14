extends Node

var commands = {
	"cl_hello": "dzej.hello()",
}

func addCommand(command : String, function : String):
	if(!commands.has(command)):
		commands[command] = function
		return "[con] Command added: " + command + " -> " + function
	else:
		return "[con] unable to define command. command already exists."