Class {
	#name : #KMeans,
	#superclass : #Object,
	#instVars : [
		'numberOfClusters',
		'centroids',
		'clusters',
		'centroidsHistory',
		'clustersHistory',
		'scoresHistory'
	],
	#category : #KMeans
}

{ #category : #'as yet unclassified' }
KMeans class >> numberOfClusters: anInteger [
	^ self new numberOfClusters: anInteger; yourself
]

{ #category : #training }
KMeans >> assignmentStep: aCollectionOfPoints [ 
	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the shortest distance to the point"
	| distances |
	
	self clusters: (aCollectionOfPoints collect: [ :point | 
		distances := self centroids collect: [ :centroid | 
			self distanceBetween: point and: centroid ].
		
		distances indexOf: distances min ]).
]

{ #category : #accessing }
KMeans >> centroids [
	^ centroids
]

{ #category : #accessing }
KMeans >> centroids: anObject [
	centroids := anObject
]

{ #category : #accessing }
KMeans >> centroidsHistory [
	^ centroidsHistory
]

{ #category : #accessing }
KMeans >> clusters [
	^ clusters
]

{ #category : #accessing }
KMeans >> clusters: anObject [
	clusters := anObject
]

{ #category : #accessing }
KMeans >> clustersHistory [
	^ clustersHistory
]

{ #category : #training }
KMeans >> distanceBetween: firstPoint and: secondPoint [
	"Euclidean distance between two points"
	^ ((firstPoint - secondPoint) raisedTo: 2) sum sqrt
]

{ #category : #training }
KMeans >> fit: aCollectionOfPoints [
	"Each point is an n-dimensional vector (collection of values)"
	self initializeCentroids: aCollectionOfPoints.
	self initializeHistories.
	
	"We must run it at least twice"
	2 timesRepeat: [
		self step: aCollectionOfPoints ].
	
	[ self hasConverged ] whileFalse: [
		self step: aCollectionOfPoints ].
]

{ #category : #training }
KMeans >> hasConverged [
	| currentCentroids previousCentroids |
	currentCentroids := self centroidsHistory last.
	previousCentroids := self centroidsHistory at: (self centroidsHistory size - 1).
	^ ((currentCentroids closeTo: previousCentroids) includes: false) not.
]

{ #category : #training }
KMeans >> initializeCentroids: aCollectionOfPoints [
	"Choose k points as centroids"
	self centroids: (aCollectionOfPoints copyFrom: 1 to: self numberOfClusters).
]

{ #category : #training }
KMeans >> initializeHistories [
	centroidsHistory := OrderedCollection new.
	clustersHistory := OrderedCollection new.
	scoresHistory := OrderedCollection new.
]

{ #category : #accessing }
KMeans >> numberOfClusters [
	^ numberOfClusters
]

{ #category : #accessing }
KMeans >> numberOfClusters: anObject [
	numberOfClusters := anObject
]

{ #category : #evaluation }
KMeans >> score: aCollectionOfPoints [ 
	| point centroid |
	
	^ ((1 to: aCollectionOfPoints size) collect: [ :index |
		point := aCollectionOfPoints at: index.
		centroid := self centroids at: (self clusters at: index).
		point euclideanDistance: centroid ]) sum
]

{ #category : #accessing }
KMeans >> scoresHistory [
	^ scoresHistory
]

{ #category : #training }
KMeans >> step: aCollectionOfPoints [
	self assignmentStep: aCollectionOfPoints.
	self updateStep: aCollectionOfPoints.
	self updateHistory: aCollectionOfPoints.
]

{ #category : #training }
KMeans >> updateHistory: aCollectionOfPoints [ 
	"Save clusters, centroids, and score to the history"
	self clustersHistory add: self clusters copy.
	self centroidsHistory add: self centroids copy.
	self scoresHistory add: (self score: aCollectionOfPoints).
]

{ #category : #training }
KMeans >> updateStep: aCollectionOfPoints [
	"Update centroids by moving them to the center of each cluster (mean of all points in the cluster)"
	| pointsOfThisCentroid |
	
	self centroids: (self centroids withIndexCollect: [ :centroid :centroidIndex |
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex |
				(self clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].
			
		1.0 / pointsOfThisCentroid size * pointsOfThisCentroid sum ]).
]
