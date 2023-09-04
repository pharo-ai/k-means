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
AIKMeansTest >> testChooseRandomCentroid [

	| points randomCentroids |
	points := #( #( 0 50 ) #( 10 1000 ) ).
	"Get 10 random centroids"
	randomCentroids := (1 to: 10) collect: [ :i |  kMeans chooseRandomCentroid: points ].

	randomCentroids do: [ :randomCentroid |
		self assert: randomCentroid size equals: 2.

		self assert: randomCentroid first <= 10.
		self assert: randomCentroid first >= 0.

		self assert: randomCentroid second <= 1000.
		self assert: randomCentroid second >= 50 ]
]

{ #category : #tests }
AIKMeansTest >> testDistanceBetweenAnd [

	self
		assert: (kMeans distanceBetween: #( 1 1 ) and: #( 2 2 ))
		closeTo: 2 sqrt. "The distance is two if we follow the euclidean distance"
	self
		assert: (kMeans distanceBetween: #( 0 0 ) and: #( 1 1 ))
		closeTo: 2 sqrt "Euclidean distance"
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

	| points |
	points := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	kMeans numberOfClusters: 3.
	kMeans initializeRandomCentroids: points.
	self assert: kMeans centroids size equals: 3.
	self denyCollection: kMeans centroids includesAny: points
]

{ #category : #tests }
AIKMeansTest >> testNearestCentroidToPoint [

	| centroids |
	centroids := #( #( 0 0 ) #( 1 1 ) #( 2 2 ) ).
	kMeans
		numberOfClusters: 3;
		centroids: centroids.

	self assert: (kMeans nearestCentroidToPoint: #( 1.5 1 )) equals: 2.
	self assert: (kMeans nearestCentroidToPoint: #( 0.5 0.2 )) equals: 1.
	self assert: (kMeans nearestCentroidToPoint: #( 1.5 1.7 )) equals: 3
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

	| data initCentroids initClusters expectedScore |
	data := #( #( 0 0 ) #( 5 2 ) #( 1 2 ) #( 1 1 ) ).
	initCentroids := #( #( 0 0 ) #( 4 7 ) ).
	initClusters := #(1 2 1 1).
	"The score is the sum of the euclidean distance to each point to its cluster (centroid)"
	expectedScore := 0 + 26 sqrt + 5 sqrt + 2 sqrt.

	kMeans numberOfClusters: 2.
	kMeans centroids: initCentroids.
	kMeans clusters: initClusters.
	self assert: (kMeans score: data) closeTo: expectedScore.
	
	"Second case"
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).
	initCentroids := #( #( 0 0 ) #( 10 1 ) ).
	initClusters := #(1 1 1 1).
	kMeans numberOfClusters: 2.
	kMeans centroids: initCentroids.
	kMeans clusters: initClusters .
	self assert: (kMeans score: data) closeTo: 0.25 sqrt + 1.25 sqrt + 2 sqrt
]

{ #category : #tests }
AIKMeansTest >> testScoreAfterFitting [

	| data |
	data := #( #( 0 0 ) #( 0.5 0 ) #( 0.5 1 ) #( 1 1 ) ).

	kMeans numberOfClusters: 2.
	kMeans fit: data.
	self assert: (kMeans score: data) equals: 1
]

{ #category : #tests }
AIKMeansTest >> testTransform [

	| points euclideanDistance |
	points := #( #( 0 0 ) #( 1 1 ) ).
	euclideanDistance := (1 + 1) sqrt.
	kMeans
		numberOfClusters: 2;
		centroids: #( #( 0 0 ) #( 1 1 ) ).

	self
		assert: (kMeans transform: points)
		equals: { { 0. euclideanDistance } . { euclideanDistance . 0 } }
]

{ #category : #tests }
AIKMeansTest >> testUpdateCentroids [

	| points initCentroids expectedFirstCentroid expectedSecondCentroid |
	points := #( #( 0 0 ) #( 1 1 ) #( 2 2 ) #( 6 6 ) #( 5 5 ) ).
	initCentroids := #( #( 0 0 ) #( 6 6 ) ).
	expectedFirstCentroid := { #( 0 0 ) . #( 1 1 ) . #( 2 2 ) } average.
	expectedSecondCentroid := { #( 6 6 ) . #( 5 5 ) } average.
	kMeans
		numberOfClusters: 2;
		clusters: #( 1 1 1 2 2 );
		centroids: initCentroids.
	kMeans updateCentroids: points.
	self denyCollection: kMeans centroids equals: initCentroids.
	self assertCollection: kMeans centroids equals: { expectedFirstCentroid . expectedSecondCentroid }.
]
