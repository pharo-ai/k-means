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

{ #category : #'as yet unclassified' }
AIKMeans class >> numberOfClusters: anInteger [
	^ self new numberOfClusters: anInteger; yourself
]

{ #category : #training }
AIKMeans >> assignmentStep: aCollectionOfPoints [ 
	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the shortest distance to the point"
	| distances |
	
	self clusters: (aCollectionOfPoints collect: [ :point | 
		distances := self centroids collect: [ :centroid | 
			self distanceBetween: point and: centroid ].
		
		distances indexOf: distances min ]).
]

{ #category : #accessing }
AIKMeans >> centroids [
	^ centroids
]

{ #category : #accessing }
AIKMeans >> centroids: anObject [
	centroids := anObject
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
AIKMeans >> clusters: anObject [
	clusters := anObject
]

{ #category : #accessing }
AIKMeans >> clustersHistory [
	^ clustersHistory
]

{ #category : #training }
AIKMeans >> distanceBetween: firstPoint and: secondPoint [
	"Euclidean distance between two points"
	^ ((firstPoint - secondPoint) raisedTo: 2) sum sqrt
]

{ #category : #training }
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
	currentCentroids := self centroidsHistory last.
	previousCentroids := self centroidsHistory at: (self centroidsHistory size - 1).
	
	1 to: currentCentroids size do: [ :i |
		((self distanceBetween: (currentCentroids at: i) and: (previousCentroids at: i)) closeTo: 0)
			ifFalse: [ ^ false ] ].
		
	^ true
]

{ #category : #initialization }
AIKMeans >> initialize [ 
	super initialize.
	self initializeEmptyModel.
]

{ #category : #initialization }
AIKMeans >> initializeCentroids: aCollectionOfPoints [
	"Choose k points as centroids"
	self centroids: ((1 to: self numberOfClusters) collect: [ :i | 
		self chooseRandomCentroid: aCollectionOfPoints  ])
]

{ #category : #initialization }
AIKMeans >> initializeEmptyModel [
	clusters := OrderedCollection new.
	centroids := OrderedCollection new.
	
	centroidsHistory := OrderedCollection new.
	clustersHistory := OrderedCollection new.
	scoresHistory := OrderedCollection new.
]

{ #category : #accessing }
AIKMeans >> numberOfClusters [
	^ numberOfClusters
]

{ #category : #accessing }
AIKMeans >> numberOfClusters: anObject [
	numberOfClusters := anObject
]

{ #category : #evaluation }
AIKMeans >> score: aCollectionOfPoints [ 
	| point centroid |
	
	^ ((1 to: aCollectionOfPoints size) collect: [ :index |
		point := aCollectionOfPoints at: index.
		centroid := self centroids at: (self clusters at: index).
		self distanceBetween: point and: centroid ]) sum
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
	self clustersHistory add: self clusters copy.
	self centroidsHistory add: self centroids copy.
	self scoresHistory add: (self score: aCollectionOfPoints).
]

{ #category : #training }
AIKMeans >> updateStep: aCollectionOfPoints [
	"Update centroids by moving them to the center of each cluster (mean of all points in the cluster)"
	| pointsOfThisCentroid |
	
	self centroids: (self centroids withIndexCollect: [ :centroid :centroidIndex |
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex |
				(self clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].
			
		pointsOfThisCentroid isEmpty
			ifTrue: [ self chooseRandomCentroid: aCollectionOfPoints ]
			ifFalse: [ 1.0 / pointsOfThisCentroid size * pointsOfThisCentroid sum ] ]).
]
