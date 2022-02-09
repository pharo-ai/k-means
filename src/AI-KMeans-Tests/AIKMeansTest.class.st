Class {
	#name : #AIKMeansTest,
	#superclass : #TestCase,
	#category : #'AI-KMeans-Tests'
}

{ #category : #tests }
AIKMeansTest >> testDistanceBetweenAnd [

	| kMeans |
	kMeans := AIKMeans numberOfClusters: 2.

	self
		assert: (kMeans distanceBetween: #( -3.54 7 ) and: #( -11.64 9.9 ))
		closeTo: 8.603488.

	self
		assert: (kMeans distanceBetween: #( -5.1 4 -3.1 ) and: #( 4 5.9 -2.2 ))
		closeTo: 9.3397
]

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
AIKMeansTest >> testFittingWithoutSettingNumberOfClusters [
	| data possibleClusters kmeans |
	
	data := #((0 0)(0.5 0)(0.5 1)(1 1)).
	
	possibleClusters := #(
		(1 1 2 2)
		(2 2 1 1)).
	
	kmeans := AIKMeans new.
	
	self should: [ kmeans fit: data ] raise: NumberOfClustersNotSetException
	
]

{ #category : #tests }
AIKMeansTest >> testFourPointsTwoClusters [

	| data possibleClusters kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	possibleClusters := #( #( 1 1 2 2 ) #( 2 2 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	self assert: (possibleClusters includes: kmeans clusters)
]

{ #category : #tests }
AIKMeansTest >> testInconsistentNumberOfClusters [

	| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 'number'.
	self should: [ kmeans fit: data ] raise: Error
]

{ #category : #tests }
AIKMeansTest >> testNumberOfClustersCantBeNegative [

	| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: -2.
	self should: [ kmeans fit: data ] raise: Error
]

{ #category : #tests }
AIKMeansTest >> testNumberOfClustersCantBeSuperiorToNbData [

	"| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 5.
	self should: [ kmeans fit: data ] raise: Error"
	self skip.
]

{ #category : #tests }
AIKMeansTest >> testNumberOfClustersCantBeZero [

	| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 0.
	self should: [ kmeans fit: data ] raise: Error
]

{ #category : #tests }
AIKMeansTest >> testNumberOfClustersCentersMatchExpectation [

	| data kmeans nbClusters |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	nbClusters := 2.

	kmeans := AIKMeans numberOfClusters: nbClusters.
	kmeans fit: data.

	self assert: (kmeans centroids size) equals: nbClusters
]
