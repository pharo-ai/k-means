Class {
	#name : #AIKMeansTest,
	#superclass : #TestCase,
	#category : #'AI-KMeans-Tests'
}

{ #category : #tests }
AIKMeansTest >> testEmptyDataset [
	| data expectedClusters kmeans |
	
	data := #().
	expectedClusters := OrderedCollection empty.
	
	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	
	self assert: kmeans clusters equals: expectedClusters.
	
]

{ #category : #tests }
AIKMeansTest >> testFourPointsTwoClusters [
	| data possibleClusters kmeans |
	
	data := #((0 0)(0.5 0)(0.5 1)(1 1)).
	
	possibleClusters := #(
		(1 1 2 2)
		(2 2 1 1)).
	
	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	
	self assert: (possibleClusters includes: kmeans clusters).
	
]
