Class {
	#name : #KMeans,
	#superclass : #Object,
	#instVars : [
		'numberOfClusters',
		'centroids',
		'clusters',
		'previousCentroids'
	],
	#category : #KMeans
}

{ #category : #'as yet unclassified' }
KMeans class >> numberOfClusters: anInteger [
	^ self new numberOfClusters: anInteger; yourself
]

{ #category : #training }
KMeans >> assignmentStep: aCollectionOfPoints [ 
	| distances |
	
	self clusters: (aCollectionOfPoints collect: [ :each | 
		distances := self centroids collect: [ :centroid | 
			each euclideanDistance: centroid ].
		
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
KMeans >> clusters [
	^ clusters
]

{ #category : #accessing }
KMeans >> clusters: anObject [
	clusters := anObject
]

{ #category : #training }
KMeans >> fit: aCollectionOfPoints [
	"Each point is an n-dimensional vector (collection of values)"
	self initializeCentroids: aCollectionOfPoints.
	self hasConverged whileFalse: [ self step: aCollectionOfPoints ].
]

{ #category : #training }
KMeans >> hasConverged [
	^ ((self centroids closeTo: previousCentroids) includes: false) not.
]

{ #category : #training }
KMeans >> initializeCentroids: aCollectionOfPoints [
	self centroids: (aCollectionOfPoints copyFrom: 1 to: self numberOfClusters).
	"must be different from centroids"
	previousCentroids := self centroids + 1.
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

{ #category : #training }
KMeans >> step: aCollectionOfPoints [
	self assignmentStep: aCollectionOfPoints.
	self updateStep: aCollectionOfPoints.
]

{ #category : #training }
KMeans >> updateStep: aCollectionOfPoints [
	| pointsOfThisCentroid |
	previousCentroids := self centroids copy.
	
	self centroids: (self centroids withIndexCollect: [ :centroid :centroidIndex |
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex |
				(self clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].
			
		1.0 / pointsOfThisCentroid size * pointsOfThisCentroid sum ]).
]
