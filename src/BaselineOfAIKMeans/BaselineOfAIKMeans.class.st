"
Baseline
"
Class {
	#name : #BaselineOfAIKMeans,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIKMeans
}

{ #category : #baselines }
BaselineOfAIKMeans >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"pharo-ai dependencies"
		spec
			baseline: 'AIEditDistances' 
			with: [ spec repository: 'github://pharo-ai/edit-distances/src' ].
		
		"Packages"
		spec
			package: 'AI-KMeans' with: [ spec requires: #( 'AIEditDistances' ) ];
			package: 'AI-KMeans-Tests' with: [ spec requires: #( 'AI-KMeans' ) ] ]
]
