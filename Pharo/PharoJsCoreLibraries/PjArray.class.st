"
I represent the Javascript Array type.  I am the implementation for Arrays and OrderedCollections, since Javascript Arrays act pretty-much like Smalltalk OrderedCollections.
"
Class {
	#name : #PjArray,
	#superclass : #PjObject,
	#traits : 'PjTArray + PjTExtensionClass + PjTCollection',
	#classTraits : 'PjTArray classTrait + PjTExtensionClass classTrait + PjTCollection classTrait',
	#category : #'PharoJsCoreLibraries-Kernel'
}

{ #category : #'pharoJs support' }
PjArray class >> jsTranspilationImportMethods [
	<pharoJsSkip>
	^ self jsTranspilationImportMethodsCollection,
	{
		Array -> #( isArray ).
		SequenceableCollection -> #(
			doWithIndex: withIndexDo: 
			allButFirst allButFirst: allButLast allButLast:
			copyFrom:to: copyReplaceFrom:to:with: copyWith: copyWithFirst: copyWithoutIndex: from:to:put: grownBy: replaceFrom:to:with:
		).
	} 
]

{ #category : #enumerating }
PjArray >> add: x [
	^ self addLast: x
]

{ #category : #enumerating }
PjArray >> addFirst: x [
	<javascript: 'this.unshift(x);return x'>
]

{ #category : #enumerating }
PjArray >> addLast: x [
	<javascript: 'this.push(x);return x'>
]

{ #category : #enumerating }
PjArray >> at: i put: x [
	<javascript: 'return this[i-1]=x'>
]

{ #category : #removing }
PjArray >> remove: oldObject ifAbsent: absentBlock [
	| index |
	index := self findIndex: [ : each | oldObject = each ].
	index >= 0 ifTrue: [ ^ self removeAt: index + 1].
	^ absentBlock value
]

{ #category : #removing }
PjArray >> removeAt: aNumber [
	<javascript: 'var result=this[aNumber-1];this.splice(aNumber - 1,1);return result'>

]

{ #category : #removing }
PjArray >> removeFirst [
	<javascript: 'return this.shift()'>
]

{ #category : #removing }
PjArray >> removeLast [
	<javascript: 'return this.pop()'>
]

{ #category : #accessing }
PjArray >> replaceFrom: start to: stop with: replacement startingAt: repStart [
	<javascript: '
	for(var mine=stop-1,other=mine+repStart-start;
		mine>=start-1;
		--other,--mine
		)this[mine]=replacement[other];return this'>
]