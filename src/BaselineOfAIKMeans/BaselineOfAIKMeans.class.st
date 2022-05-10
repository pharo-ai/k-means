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
		"Internal dependencies"
		spec
    		baseline: 'AIInternalEditDistances'
    		with: [ spec repository: 'github://pharo-ai/external-dependencies' ].
		
		"Packages"
		spec
			package: 'AI-KMeans';
			package: 'AI-KMeans-Tests' with: [ spec requires: #( 'AI-KMeans' ) ] ]
]
