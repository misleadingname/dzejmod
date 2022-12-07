extends Node

enum {
	ARG_INT,
	ARG_FLOAT,
	ARG_STRING,
	ARG_BOOL,
	ARG_NULL
}

const valid = [
	["quit", [ARG_NULL]],
	["help", [ARG_NULL]],
	["echo", [ARG_STRING]],
	["version", [ARG_NULL]],

	["sv_map", [ARG_STRING]],
	["sv_phys_fps", [ARG_FLOAT]],
	["sv_get_addons", [ARG_NULL]],

	["cl_getvar", [ARG_STRING]],
	["cl_hello", [ARG_NULL]]
]

# SV

func sv_phys_fps(fps):
	Engine.iterations_per_second = int(fps)
	dzej.msg("Server physics set to " + fps + "fps")
	return true

func sv_map(map):
	dzej.msg("attemting to load map: " + map)

	dzej.targetScene = map + ".tscn"
	if(!ResourceLoader.exists(dzej.getAddonPath(dzej.addonMapFrom) + "maps/" + map + ".tscn")):
		dzej.msg("[ERROR] scene " + dzej.targetScene + " does not exist")
		return false

	var out = dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn")
	if(typeof(out) == TYPE_STRING && out == false):
		dzej.msg("error loading map: " + map)
		return false
	else:
		dzej.msg("map loaded: " + map)
		return true

func sv_get_addons():
	return dzej.addonRequestList()
# CL

func cl_hello():
	return "hello dzejmod console"

func cl_getvar(varname):
	return str(get(varname))

# GENERAL

func version():
	return "dzejmod 0.1 development version Work in progress.\nTEAM DZEJMOD\nhttps://dzejmod.tk"

func echo(text):
	return text

func help():
	var output : String
	for each in valid:
		for i in each:
			if i[0] is int:
				output += "\t"
				match i[0]:
					ARG_NULL:
						output += each[0]
					ARG_STRING:
						output += each[0] + " [string]"
					ARG_INT:
						output += each[0] + " [int]"
					ARG_FLOAT:
						output += each[0] + " [float]"
					_:
						output += "Value not implemented..."
				output += "\n"
	return output
