"
K-Means is a clustering, unsupervised machine learning algorithm.

Please refer to the Pharo wiki for more information [Pharo wiki](https://github.com/pharo-ai/wiki)
"
Class {
	#name : #AIKMeans,
	#superclass : #Object,
	#instVars : [
		'numberOfClusters',
		'centroids',
		'clusters',
		'centroidsHistory',
		'clustersHistory',
		'scoresHistory',
		'maxIterations',
		'performedIterations',
		'previousCentroids'
	],
	#category : #'AI-KMeans'
}

{ #category : #accessing }
AIKMeans class >> defaultMaxIterations [

	^ 300
]

{ #category : #'instance creation' }
AIKMeans class >> numberOfClusters: anInteger [

	^ self new
		numberOfClusters: anInteger;
		yourself
]

{ #category : #training }
AIKMeans >> assignClusterToPoints: aCollectionOfPoints [

	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the shortest distance to the point"

	| distances |
	
	clusters := (aCollectionOfPoints collect: [ :point | 
		distances := centroids collect: [ :centroid | self distanceBetween: point and: centroid ].

		distances indexOf: distances min ])
]

{ #category : #accessing }
AIKMeans >> centroids: aCollectionOfPoints [

	centroids := aCollectionOfPoints
]

{ #category : #accessing }
AIKMeans >> centroidsHistory [

	^ centroidsHistory
]

{ #category : #training }
AIKMeans >> chooseRandomCentroid: aCollectionOfPoints [

	"Choose a random point as centroids"
	
	| rand axis min max |
	
	^ (1 to: aCollectionOfPoints anyOne size) collect: [ :i |
		axis := aCollectionOfPoints collect: [ :point | point at: i ].
	
		min := axis min.
		max := axis max.
	
		rand := Random new.
		rand nextBetween: min and: max ]
]

{ #category : #accessing }
AIKMeans >> clusters [

	^ clusters
]

{ #category : #accessing }
AIKMeans >> clustersHistory [

	^ clustersHistory
]

{ #category : #training }
AIKMeans >> distanceBetween: firstPoint and: secondPoint [

	"It follows the Euclidean distance between two points formula.
	The code is not idiomatic because of performance. We see that writting this instead of 
	(firstPoint - secondPoint raisedTo: 2) sum sqrt
	is about 30% fastest."

	| sum |
	sum := 0.
	1 to: firstPoint size do: [ :i | 
		| diff |
		diff := (firstPoint at: i) - (secondPoint at: i).
		sum := sum + (diff * diff) ].
	^ sum sqrt
]

{ #category : #api }
AIKMeans >> fit: aCollectionOfPoints [

	self initializeEmptyModel.
	aCollectionOfPoints ifEmpty: [ ^ self ].

	"Each point is an n-dimensional vector (collection of values)"
	self initializeCentroids: aCollectionOfPoints.
	
	"We must run it at least twice"
	2 timesRepeat: [
		self step: aCollectionOfPoints ].
	
	[ self hasConverged ] whileFalse: [
		self step: aCollectionOfPoints ].
]

{ #category : #training }
AIKMeans >> hasConverged [
	
	(performedIterations >= maxIterations) ifTrue: [ ^ true ].

	centroids
		with: previousCentroids
		do: [ :current :previous | 
			((self distanceBetween: current and: previous) closeTo: 0) ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #initialization }
AIKMeans >> initialize [

	super initialize.
	self initializeEmptyModel.
	maxIterations := self class defaultMaxIterations
]

{ #category : #initialization }
AIKMeans >> initializeCentroids: aCollectionOfPoints [

	"If the centroids were already initialized by the user, do not assign them a random value."
	centroids ifNotEmpty: [ ^ self ].
	
	"Choose k points as centroids"
	centroids := (1 to: numberOfClusters) collect: [ :i | 
		self chooseRandomCentroid: aCollectionOfPoints ]
]

{ #category : #initialization }
AIKMeans >> initializeEmptyModel [

	clusters := OrderedCollection new.
	centroids := OrderedCollection new.
	
	performedIterations := 0.

	centroidsHistory := OrderedCollection new.
	clustersHistory := OrderedCollection new.
	scoresHistory := OrderedCollection new
]

{ #category : #accessing }
AIKMeans >> maxIterations: anInteger [ 
	maxIterations := anInteger
]

{ #category : #accessing }
AIKMeans >> numberOfClusters: anObject [

	numberOfClusters := anObject
]

{ #category : #evaluation }
AIKMeans >> score: aCollectionOfPoints [

	| point centroid distances |
	
	distances := (1 to: aCollectionOfPoints size) collect: [ :index | 
		point := aCollectionOfPoints at: index.
		centroid := centroids at: (clusters at: index).
		
		self distanceBetween: point and: centroid ].

	^ distances sum
]

{ #category : #accessing }
AIKMeans >> scoresHistory [

	^ scoresHistory
]

{ #category : #training }
AIKMeans >> step: aCollectionOfPoints [

	self assignClusterToPoints: aCollectionOfPoints.
	self updateCentroids: aCollectionOfPoints.
	"self updateHistory: aCollectionOfPoints."

	performedIterations := performedIterations + 1
]

{ #category : #training }
AIKMeans >> updateCentroids: aCollectionOfPoints [

	"Update centroids by moving them to the center of each cluster (mean of all points in the cluster)"
	
	| pointsOfThisCentroid |
	
	previousCentroids := centroids deepCopy.
	
	centroids := (centroids withIndexCollect: [ :centroid :centroidIndex |
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex | (clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].
			
		pointsOfThisCentroid isEmpty
			ifTrue: [ self chooseRandomCentroid: aCollectionOfPoints ]
			ifFalse: [ pointsOfThisCentroid average ] ]).
]

{ #category : #training }
AIKMeans >> updateHistory: aCollectionOfPoints [

	"Save clusters, centroids, and score to the history"

	clustersHistory add: clusters.
	centroidsHistory add: centroids.
	scoresHistory add: (self score: aCollectionOfPoints)
]
