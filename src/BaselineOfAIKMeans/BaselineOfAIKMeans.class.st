Class {
	#name : #BaselineOfAIKMeans,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIKMeans
}

{ #category : #baselines }
BaselineOfAIKMeans >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"External dependencies"
		spec
			baseline: 'AINormalization'
			with: [ spec repository: 'github://pharo-ai/normalization/src' ].

		"Packages"
		spec 
			package: 'AI-KMeans' with: [ spec requires: #('AINormalization') ];
			package: 'AI-KMeans-Tests' with: [ spec requires: #('AI-KMeans') ] ].
	
	"Patches for older versions of Pharo"
	spec for: #'pharo8.x' do: [
		spec package: 'AI-KMeans-OldPharo' ].
]
