Class {
	#name : #BaselineOfAIKMeans,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIKMeans
}

{ #category : #baselines }
BaselineOfAIKMeans >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'AI-KMeans';
			package: 'AI-KMeans-Tests' with: [ spec requires: #('AI-KMeans') ]  ].
]
