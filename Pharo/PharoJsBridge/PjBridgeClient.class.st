"
I represent a bridge client i.e. javascript interpreter and code that talks to a bridge.
"
Class {
	#name : #PjBridgeClient,
	#superclass : #Object,
	#instVars : [
		'bridge',
		'codeGenerator',
		'exporter',
		'appClass'
	],
	#category : #'PharoJsBridge-Kernel'
}

{ #category : #'instance creation' }
PjBridgeClient class >> appClass: pjAppClass [
	^self new
		appClass: pjAppClass;
		yourself
]

{ #category : #accessing }
PjBridgeClient >> appClass [
	^ appClass ifNil: [self defaultAppClass ]
]

{ #category : #accessing }
PjBridgeClient >> appClass: aPharoJsAppClass [
	appClass := aPharoJsAppClass.
	exporter := self exporterClass new.
	self codeGenerator: self codeGeneratorClass new.

]

{ #category : #accessing }
PjBridgeClient >> bridge [
	^ bridge
]

{ #category : #accessing }
PjBridgeClient >> bridge: aBridge [
	bridge := aBridge.
	self codeGenerator bridge: self bridge

]

{ #category : #accessing }
PjBridgeClient >> codeGenerator [
	^ codeGenerator
]

{ #category : #accessing }
PjBridgeClient >> codeGenerator: aCodeGenerator [
	| decoratedAppClass |
	codeGenerator := aCodeGenerator.
	decoratedAppClass := codeGenerator decorateAppClass: appClass.
	exporter appClass: decoratedAppClass.
]

{ #category : #'initialization-release' }
PjBridgeClient >> codeGeneratorClass [
	self codeGenerator ifNil: [^PjClientCodeGenerator].
	^self codeGenerator species 
	"Allows keeping the behavior upon reseting the client in the bridge. See PjBridge>>#resetClient"
]

{ #category : #'initialization-release' }
PjBridgeClient >> defaultAppClass [
	self subclassResponsibility
]

{ #category : #accessing }
PjBridgeClient >> exporter [
	^ exporter
]

{ #category : #'initialization-release' }
PjBridgeClient >> exporterClass [
	self subclassResponsibility
]

{ #category : #accessing }
PjBridgeClient >> jsGlobalNames [
	^ (self appClass allSharedPoolsRecursive select: #isJavascriptGlobalsPool)
			flatCollectAsSet: #classVarNames
]

{ #category : #'initialization-release' }
PjBridgeClient >> reset [
	self appClass: self appClass.
	self bridge: self bridge.
	"Ensure transpiler is reset correctly.
	Transpiler is driven by exporter"
	String streamContents: [ :aStream | self exporter writeJsCodeOn: aStream ] 
]

{ #category : #accessing }
PjBridgeClient >> server [
	^self bridge server
]

{ #category : #accessing }
PjBridgeClient >> shouldStartJsInterpreter [
	^ self bridge shouldStartJsInterpreter
		
]

{ #category : #activity }
PjBridgeClient >> start [
	self shouldStartJsInterpreter ifTrue: [ self startJsInterpreter ]
]

{ #category : #activity }
PjBridgeClient >> startJsInterpreter [
	"start javascript interpreter"
	self subclassResponsibility
]

{ #category : #activity }
PjBridgeClient >> startTimeout [
	^2 seconds
]

{ #category : #activity }
PjBridgeClient >> stop [
	"stop javascript interpreter"
	self server isWebSocketConnected ifFalse: [ ^self ].
	self bridge websocketDelegateClassName ifNil: [ ^self ].
	self bridge sendMessage: self bridge websocketDelegateClassName, '._terminate()'.

]

{ #category : #accessing }
PjBridgeClient >> title [
	^ self appClass title
]

{ #category : #accessing }
PjBridgeClient >> websocketDelegateClassName [
	^self codeGenerator websocketDelegateClassName
]

{ #category : #accessing }
PjBridgeClient >> withClientLogging [
	self codeGenerator: self codeGenerator withClientLogging.

]
