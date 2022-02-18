Class {
	#name : #AIKMeansTest,
	#superclass : #TestCase,
	#category : #'AI-KMeans-Tests'
}

{ #category : #tests }
AIKMeansTest >> testAssignClusterToPoints [

	| kMeans |
	kMeans := AIKMeans numberOfClusters: 3.
	kMeans maxIterations: 5.
	kMeans centroids: #( #( 0.1 0.1 ) #( 0.4 0.4 ) #( 10 10 ) ).
	kMeans assignClusterToPoints: #( #( 0.1 0.1 ) #( 0.3 0.3 ) #( 9 9 ) ).
	self assert: kMeans clusters equals: #( 1 2 3 )
]

{ #category : #tests }
AIKMeansTest >> testCalculateAverage [

	| expected kmeans points |
	kmeans := AIKMeans numberOfClusters: 2.
	points := #( #( 1 2 3 ) #( 0 1 1 ) #( 0.5 1 0.5 ) #( 0.5 0.5 0.5 ) ).
	expected := #( 0.5 1.125 1.25 ).
	self assert: (kmeans calculateAverage: points) equals: expected
]

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
AIKMeansTest >> testExpectedCentroids [

	| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	self
		assertCollection: kmeans centroids
		hasSameElements: #( #( 0.25 0 ) #( 0.75 1 ) )
]

{ #category : #tests }
AIKMeansTest >> testFittingWithoutSettingNumberOfClusters [

	| data possibleClusters kmeans |
	
	data := #((0 0)(0.5 0)(0.5 1)(1 1)).
	
	possibleClusters := #(
		(1 1 2 2)
		(2 2 1 1)).
	
	kmeans := AIKMeans new.
	
	self should: [ kmeans fit: data ] raise: Error
	
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
AIKMeansTest >> testNumberOfCentroidsMatchExpectation [

	| data kmeans clusters |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	clusters := 2.

	kmeans := AIKMeans numberOfClusters: clusters.
	kmeans fit: data.

	self assert: (kmeans centroids size) equals: clusters
]

{ #category : #tests }
AIKMeansTest >> testScore [

	| data initCentroids kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	initCentroids := #( #( 0 0 ) #( 10 1 ) ).

	kmeans := AIKMeans numberOfClusters: 2.
	kmeans centroids: initCentroids.
	kmeans assignClusterToPoints: data.
	self assert: (kmeans score: data) closeTo: 0.5 + 2 sqrt + 1.11803
]

{ #category : #tests }
AIKMeansTest >> testScoreAfterFitting [

	| data kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kmeans := AIKMeans numberOfClusters: 2.
	kmeans fit: data.
	self assert: (kmeans score: data) equals: 1
]

{ #category : #tests }
AIKMeansTest >> testSettingBestCentroidsDontChangeTheCentroids [

	| data bestCentroids kmeans |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	bestCentroids := #( #( 0.75 1.0 ) #( 0.25 0.0 ) ).

	kmeans := AIKMeans numberOfClusters: 2.
	kmeans centroids: bestCentroids.
	kmeans fit: data.
	self assert: kmeans centroids equals: bestCentroids
]
