extends Node

enum {
	ARG_INT,
	ARG_FLOAT,
	ARG_STRING,
	ARG_BOOL,
	ARG_NULL
}

const valid = [
	["help", [ARG_NULL]],
	["echo", [ARG_STRING]],

	["cl_getvar" [ARG_STRING]],

	["cl_hello", [ARG_NULL]]
]

func cl_hello():
	return "hello dzejmod console"

func cl_getvar(varname):
	return get(varname)

func echo(text):
	return text

func help():
	return "FIXME: help"
			
