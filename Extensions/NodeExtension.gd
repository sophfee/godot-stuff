# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove
# this credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================
extends Node;
func assert_instance(node_instance: Node) -> Node:
	assert(node_instance != null, "Assertion of NULL instance.");
	return node_instance;
