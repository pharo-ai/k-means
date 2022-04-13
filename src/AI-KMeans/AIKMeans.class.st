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
		'maxIterations',
		'performedIterations',
		'previousCentroids',
		'rand',
		'bestScore',
		'bestCentroids',
		'timesToRun'
	],
	#category : #'AI-KMeans-Core'
}

{ #category : #accessing }
AIKMeans class >> defaultMaxIterations [

	^ 300
]

{ #category : #defaults }
AIKMeans class >> defaultNumberOfTimesItIsRun [
	^ 5
]

{ #category : #'instance creation' }
AIKMeans class >> numberOfClusters: anInteger [

	^ self new
		numberOfClusters: anInteger;
		yourself
]

{ #category : #training }
AIKMeans >> assignClusterToPoint: aPoint [

	| min minIndex |
	minIndex := 1.
	min := self distanceBetween: aPoint and: (centroids at: 1).

	2 to: centroids size do: [ :j | 
		| centroid distance |
		centroid := centroids at: j.
		distance := self distanceBetween: aPoint and: centroid.
		distance < min ifTrue: [ 
			min := distance.
			minIndex := j ] ].

	^ minIndex
]

{ #category : #training }
AIKMeans >> assignClusterToPoints: aCollectionOfPoints [

	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the shortest distance to the point"
	"Do not rewrite the code. It is like that for performance."

	"| distances |
	clusters := (aCollectionOfPoints collect: [ :point | 
		distances := centroids collect: [ :centroid | self distanceBetween: point and: centroid ].
		distances indexOf: distances min ])"

	clusters := Array new: aCollectionOfPoints size.
	
	1 to: aCollectionOfPoints size do: [ :i | 
		| point minIndex |
		point := aCollectionOfPoints at: i.
		minIndex := self assignClusterToPoint: point.
		clusters at: i put: minIndex ]
]

{ #category : #training }
AIKMeans >> calculateAverage: pointsOfThisCentroid [

	"This is the same as doing `pointsOfThisCentroid average`.
	But written this way is faster"
	
	^ (1 to: pointsOfThisCentroid first size) collect: [ :i | 
		((pointsOfThisCentroid sum: [ :e | e at: i ]) / pointsOfThisCentroid size) asFloat ]
]

{ #category : #accessing }
AIKMeans >> centroids [

	^ centroids
]

{ #category : #accessing }
AIKMeans >> centroids: aCollectionOfPoints [

	bestCentroids := aCollectionOfPoints.
	centroids := aCollectionOfPoints.
	self assignClusterToPoints: aCollectionOfPoints.
	bestScore := self score: aCollectionOfPoints
]

{ #category : #training }
AIKMeans >> chooseRandomCentroid: aCollectionOfPoints [

	"Choose a random point as centroids"
	"The code is like that for performance. Do not rewrite it"

	"| axis min max |
	
	^ (1 to: aCollectionOfPoints anyOne size) collect: [ :i |
		axis := aCollectionOfPoints collect: [ :point | point at: i ].
	
		min := axis min.
		max := axis max.
		
		rand nextBetween: min and: max ]"

	| min max pointDimension result |
	pointDimension := aCollectionOfPoints anyOne size.
	result := Array new: pointDimension.
	
	1 to: pointDimension do: [ :i | 
		max := aCollectionOfPoints first at: i.
		min := aCollectionOfPoints first at: i.
		
		1 to: aCollectionOfPoints size do: [ :j | 
			| point coordinate |
			point := aCollectionOfPoints at: j.
			coordinate := point at: i.
			coordinate > max ifTrue: [ max := coordinate ].
			coordinate < min ifTrue: [ min := coordinate ] ].
		result at: i put: (rand nextBetween: min and: max) ].
	
	^ result
]

{ #category : #accessing }
AIKMeans >> clusters [

	^ clusters
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
		diff := (firstPoint at: i) asFloat - (secondPoint at: i) asFloat.
		sum := sum + (diff * diff) ].
	^ sum sqrt
]

{ #category : #api }
AIKMeans >> fit: aCollectionOfPoints [

	aCollectionOfPoints ifEmpty: [ ^ self ].

	timesToRun timesRepeat: [ self run: aCollectionOfPoints ].

	"We keep the best centroids after running the algo n-times"
	centroids := bestCentroids.
	self assignClusterToPoints: aCollectionOfPoints
]

{ #category : #testing }
AIKMeans >> hasConverged [

	centroids
		with: previousCentroids
		do: [ :current :previous | 
			((self distanceBetween: current and: previous) closeTo: 0) ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #testing }
AIKMeans >> hasReachedMaxIterations [

	^ performedIterations >= maxIterations
]

{ #category : #testing }
AIKMeans >> hasToStopIterating [

	^ self hasConverged or: [ self hasReachedMaxIterations ]
]

{ #category : #initialization }
AIKMeans >> initialize [

	super initialize.
	self initializeEmptyModel.

	rand := Random new.
	maxIterations := self class defaultMaxIterations.
	timesToRun := self class defaultNumberOfTimesItIsRun
]

{ #category : #initialization }
AIKMeans >> initializeCentroids: aCollectionOfPoints [

	"Choose k points as centroids"

	centroids := (1 to: numberOfClusters) collect: [ :i | 
		self chooseRandomCentroid: aCollectionOfPoints ]
]

{ #category : #initialization }
AIKMeans >> initializeEmptyModel [

	clusters := OrderedCollection new.
	centroids := OrderedCollection new.
	performedIterations := 0
]

{ #category : #accessing }
AIKMeans >> maxIterations: anInteger [

	maxIterations := anInteger
]

{ #category : #accessing }
AIKMeans >> numberOfClusters: anObject [

	numberOfClusters := anObject
]

{ #category : #api }
AIKMeans >> predict: aCollectionOfPoints [

	| predictions |
	predictions := OrderedCollection new.
	1 to: aCollectionOfPoints size do: [ :index | 
		predictions add: (self assignClusterToPoint: (aCollectionOfPoints at: index)) ].
	^ predictions
]

{ #category : #training }
AIKMeans >> run: aCollectionOfPoints [

	| score |
	self initializeEmptyModel.
	"Each point is an n-dimensional vector (collection of values)"
	self initializeCentroids: aCollectionOfPoints.

	"We must run it at least twice"
	2 timesRepeat: [ self step: aCollectionOfPoints ].
	[ self hasToStopIterating ] whileFalse: [ self step: aCollectionOfPoints ].

	"The best centroid points are the ones that minimize the score.
	The score is the sum of the mean square errors of the points and its closest centroid."
	score := self score: aCollectionOfPoints.
	bestScore ifNil: [ bestScore := score ].
	bestCentroids ifNil: [ bestCentroids := centroids copy ].
	bestScore > score ifTrue: [ 
		bestCentroids := centroids copy.
		bestScore := score ]
]

{ #category : #'api - evaluation' }
AIKMeans >> score: aCollectionOfPoints [

	| point centroid distances |
	distances := (1 to: aCollectionOfPoints size) collect: [ :index | 
		point := aCollectionOfPoints at: index.
		centroid := centroids at: (clusters at: index).
		
		self distanceBetween: point and: centroid ].
	
	^ distances sum
]

{ #category : #training }
AIKMeans >> step: aCollectionOfPoints [

	self assignClusterToPoints: aCollectionOfPoints.
	self updateCentroids: aCollectionOfPoints.

	performedIterations := performedIterations + 1
]

{ #category : #accessing }
AIKMeans >> timesToRun: anInteger [

	timesToRun := anInteger
]

{ #category : #training }
AIKMeans >> updateCentroids: aCollectionOfPoints [

	"Update centroids by moving them to the center of each cluster (mean of all points in the cluster)"

	| pointsOfThisCentroid |

	previousCentroids := centroids.

	centroids := centroids withIndexCollect: [ :centroid :centroidIndex | 
		pointsOfThisCentroid := (1 to: aCollectionOfPoints size)
			select: [ :pointIndex | (clusters at: pointIndex) = centroidIndex ]
			thenCollect: [ :pointIndex | aCollectionOfPoints at: pointIndex ].

		pointsOfThisCentroid isEmpty
			ifTrue: [ self chooseRandomCentroid: aCollectionOfPoints ]
			ifFalse: [ "pointsOfThisCentroid average" self calculateAverage: pointsOfThisCentroid ] ]
]
