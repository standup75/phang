"use strict"

class Tree
	constructor: (rootId) ->
		@tree =
			node:
				id: rootId
				children: []
		@cursor = @tree.node
		@visitIndex = 0 # avoid circular explorations
	addChild: (id, move, previousNode = @cursor) ->
		@path = null  if @path
		node = @getNode id
		@cursor = node
		for child in previousNode.children
			return  if child.node.id is id
		previousNode.children.push
			move: move
			node: node
	getNode: (id) ->
		getChildRec = (child, id) =>
			node = child.node
			return child  if node.id is id
			for c in node.children
				childNode = c.node
				if childNode.visitIndex isnt @visitIndex
					childNode.visitIndex = @visitIndex
					leaf = getChildRec c, id
					return leaf  if leaf
			null
		child = getChildRec @tree, id
		@visitIndex++
		if child
			child.node
		else
			id: id
			children: []
	findPath: ->
		return @path  if @path
		findPathRec = (child) =>
			node = child.node
			return []  unless node.children.length
			return null  if node.visitIndex is @visitIndex
			node.visitIndex = @visitIndex
			tail = null
			for child in node.children
				childTail = findPathRec child
				tail = childTail  if !tail or tail.length > childTail.length
			tail.unshift child  if tail
			tail
		@path = findPathRec @tree
		@visitIndex++
		@path = @path.map (child) -> child.move

module.exports = Tree