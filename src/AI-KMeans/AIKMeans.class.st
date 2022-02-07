Class {
	#name : #AIKMeans,
	#superclass : #Object,
	#instVars : [
		'numberOfClusters',
		'centroids',
		'clusters',
		'centroidsHistory',
		'clustersHistory',
		'scoresHistory'
	],
	#category : #'AI-KMeans'
}

{ #category : #'instance creation' }
AIKMeans class >> numberOfClusters: anInteger [

	^ self new
		  numberOfClusters: anInteger;
		  yourself
]

{ #category : #training }
AIKMeans >> assignmentStep: aCollectionOfPoints [

	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the shortest distance to the point"

	| distances |
	
	clusters := (aCollectionOfPoints collect: [ :point | 
		distances := centroids collect: [ :centroid | self distanceBetween: point and: centroid ].

		distances indexOf: distances min ])
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

	"Euclidean distance between two points"

	^ (firstPoint - secondPoint raisedTo: 2) sum sqrt
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

	| currentCentroids previousCentroids |
	currentCentroids := centroidsHistory last.
	previousCentroids := centroidsHistory nextToLast.

	currentCentroids
		with: previousCentroids
		do: [ :current :previous | 
			((self distanceBetween: current and: previous) closeTo: 0)
				ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #initialization }
AIKMeans >> initialize [

	super initialize.
	self initializeEmptyModel
]

{ #category : #initialization }
AIKMeans >> initializeCentroids: aCollectionOfPoints [

	"Choose k points as centroids"

	centroids := ((1 to: self numberOfClusters) collect: [ :i | 
		self chooseRandomCentroid: aCollectionOfPoints ])
]

{ #category : #initialization }
AIKMeans >> initializeEmptyModel [

	clusters := OrderedCollection new.
	centroids := OrderedCollection new.

	centroidsHistory := OrderedCollection new.
	clustersHistory := OrderedCollection new.
	scoresHistory := OrderedCollection new
]

{ #category : #accessing }
AIKMeans >> numberOfClusters [

	"Please use this accessor always whenever is necessary to access the numberOfClusters instance variable.
	It is needed to raise the exception in case that the class has been instantiated without declaring the number of clusters."

	self flag: 'See comment of the method.'.

	numberOfClusters ifNil: [ NumberOfClustersNotSetException signal ].

	^ numberOfClusters
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

	self assignmentStep: aCollectionOfPoints.
	self updateStep: aCollectionOfPoints.
	self updateHistory: aCollectionOfPoints.
]

{ #category : #training }
AIKMeans >> updateHistory: aCollectionOfPoints [

	"Save clusters, centroids, and score to the history"

	clustersHistory add: clusters.
	centroidsHistory add: centroids.
	scoresHistory add: (self score: aCollectionOfPoints)
]

{ #category : #training }
AIKMeans >> updateStep: aCollectionOfPoints [

	"Update centroids by moving them to the center of each cluster (mean of all points in the cluster)"
	
	| pointsOfThisCentroid |
	
	centroids := (centroids withIndexCollect: [ :centroid :centroidIndex |
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex | (clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].
			
		pointsOfThisCentroid isEmpty
			ifTrue: [ self chooseRandomCentroid: aCollectionOfPoints ]
			ifFalse: [ 1.0 / pointsOfThisCentroid size * pointsOfThisCentroid sum ] ]).
]
