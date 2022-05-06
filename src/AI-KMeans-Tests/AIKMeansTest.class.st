Class {
	#name : #AIKMeansTest,
	#superclass : #TestCase,
	#instVars : [
		'kMeans'
	],
	#category : #'AI-KMeans-Tests'
}

{ #category : #running }
AIKMeansTest >> setUp [

	super setUp.

	kMeans := AIKMeans new
]

{ #category : #tests }
AIKMeansTest >> testAssignClusterToPoints [

	kMeans numberOfClusters: 3.
	kMeans maxIterations: 5.
	kMeans centroids: #( #( 0.1 0.1 ) #( 0.4 0.4 ) #( 10 10 ) ).
	kMeans assignClusterToPoints: #( #( 0.1 0.1 ) #( 0.3 0.3 ) #( 9 9 ) ).
	
	self assertCollection: kMeans clusters hasSameElements: #( 1 2 3 )
]

{ #category : #tests }
AIKMeansTest >> testCalculateAverage [

	| expected points |
	kMeans numberOfClusters: 2.
	points := #( #( 1 2 3 ) #( 0 1 1 ) #( 0.5 1 0.5 ) #( 0.5 0.5 0.5 ) ).
	expected := #( 0.5 1.125 1.25 ).

	self assert: (kMeans calculateAverage: points) equals: expected
]

{ #category : #tests }
AIKMeansTest >> testDistanceBetweenAnd [

	
	kMeans numberOfClusters: 2.

	self
		assert: (kMeans distanceBetween: #( -3.54 7 ) and: #( -11.64 9.9 ))
		closeTo: 8.603488.

	self
		assert: (kMeans distanceBetween: #( -5.1 4 -3.1 ) and: #( 4 5.9 -2.2 ))
		closeTo: 9.3397
]

{ #category : #tests }
AIKMeansTest >> testEmptyDataset [

	| data expectedClusters |
	data := #(  ).
	expectedClusters := OrderedCollection empty.

	kMeans numberOfClusters: 2.
	kMeans fit: data.

	self assert: kMeans clusters equals: expectedClusters
]

{ #category : #tests }
AIKMeansTest >> testExpectedCentroids [

	| data |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kMeans numberOfClusters: 2.
	kMeans fit: data.
	self
		assertCollection: kMeans centroids
		hasSameElements: #( #( 0.25 0 ) #( 0.75 1 ) )
]

{ #category : #tests }
AIKMeansTest >> testFittingWithoutSettingNumberOfClusters [

	| data |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	self should: [ kMeans fit: data ] raise: Error
]

{ #category : #tests }
AIKMeansTest >> testFourPointsTwoClusters [

	| data possibleClusters |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	possibleClusters := #( 1 1 2 2 ).

	kMeans numberOfClusters: 2.
	kMeans fit: data.
	
	self assertCollection: possibleClusters hasSameElements: kMeans clusters
]

{ #category : #tests }
AIKMeansTest >> testInitializeCentroidsKMeansPlusPlus [

	| groupOne groupTwo groupThree points |
	groupOne := #( #( 1 50 ) #( 1 51 ) #( 2 50 ) #( 2 51 ) ).
	groupTwo := #( #( 1000 1 ) #( 1000 2 ) #( 1100 1 ) #( 1100 2 ) ).
	groupThree := #( #( 100 100 ) #( 100 101 ) #( 101 100 ) #( 101 101 ) ).
	
	points := groupOne , groupTwo , groupThree.
	
	kMeans numberOfClusters: 3.
	kMeans initializeCentroidsKMeansPlusPlus: points.
	
	"the centroids must contain one item of each of the groups. The centroids should not have two points of the same group."
	
	self assertCollection: groupOne includesAny: kMeans centroids.
	self assertCollection: groupTwo includesAny: kMeans centroids.
	self assertCollection: groupThree includesAny: kMeans centroids
]

{ #category : #tests }
AIKMeansTest >> testInitializeRandomCentroids [

	kMeans := AIKMeans numberOfClusters: 3.
	
]

{ #category : #tests }
AIKMeansTest >> testPredict [

	| data |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kMeans numberOfClusters: 2.
	kMeans fit: data.
	self
		assertCollection: #( 1 1 2 2 )
		hasSameElements: (kMeans predict: data)
]

{ #category : #tests }
AIKMeansTest >> testScore [

	| data initCentroids |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	initCentroids := #( #( 0 0 ) #( 10 1 ) ).

	kMeans numberOfClusters: 2.
	kMeans centroids: initCentroids.
	kMeans assignClusterToPoints: data.
	self assert: (kMeans score: data) closeTo: 0.5 + 2 sqrt + 1.11803
]

{ #category : #tests }
AIKMeansTest >> testScoreAfterFitting [

	| data |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kMeans numberOfClusters: 2.
	kMeans fit: data.
	self assert: (kMeans score: data) equals: 1
]
