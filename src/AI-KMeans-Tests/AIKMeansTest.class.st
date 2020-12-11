Class {
	#name : #AIKMeansTest,
	#superclass : #TestCase,
	#category : #'AI-KMeans-Tests'
}

{ #category : #tests }
AIKMeansTest >> testFourPointsTwoClusters [
	| data expectedClusters kmeans |
	
	data := #((0 0)(0.5 0)(0.5 1)(1 1)).
	expectedClusters := #(1 1 2 2).
	
	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	
	self assert: kmeans clusters equals: expectedClusters.
	
]
