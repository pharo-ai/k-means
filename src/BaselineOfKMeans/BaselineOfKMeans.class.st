Class {
	#name : #BaselineOfKMeans,
	#superclass : #BaselineOf,
	#category : #BaselineOfKMeans
}

{ #category : #baselines }
BaselineOfKMeans >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'KMeans' ].
]
