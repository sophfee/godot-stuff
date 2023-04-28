# Copyright (c) 2023 - Nick S. - All Rights Reserved.
# ===================================================
# This file was shared publicly, please do not remove credit part.
# https://github.com/urnotnick/godot-stuff
# ===================================================

# If you use this code in any project, please put this somewhere in scripts where it is used:
# [DESCRIPTION OF CODE USED, FUNCTION/PURPOSE]
# Copyright (c) 2023 - Nick S.
# Source: https://github.com/urnotnick/godot-stuff (Link to specific file if applicable)

extends Node;
func assert_instance(node_instance: Node) -> Node:
	assert(node_instance, "Assertion of NULL instance.");
	return node_instance;
