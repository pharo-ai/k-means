Class {
	#name : #BaselineOfKMeans,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIKMeans
}

{ #category : #baselines }
BaselineOfKMeans >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'KMeans' ].
]
