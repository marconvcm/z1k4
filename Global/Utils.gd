extends Node

func clean_children(node: Node):
	while node.get_child_count() > 0: 
		var index = node.get_child_count() - 1 
		node.get_child(index).queue_free()