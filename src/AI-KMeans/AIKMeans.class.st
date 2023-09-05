"
K-Means is a clustering, unsupervised machine learning algorithm.

Please refer to the Pharo wiki for more information [Pharo wiki](https://github.com/pharo-ai/wiki).

We used some comments from [scikitlearn](https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html#sklearn.cluster.KMeans.transform) in our code.
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
		'timesToRun',
		'euclideanDistance'
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
AIKMeans >> assignClusterToPoints: aCollectionOfPoints [
	"Assign clusters to each point. We choose the cluster whose centroid minimizes has the
	shortest distance to the point"

	clusters := aCollectionOfPoints collect: [ :aPoint | self nearestCentroidToPoint: aPoint ]
]

{ #category : #accessing }
AIKMeans >> centroids [

	^ centroids
]

{ #category : #accessing }
AIKMeans >> centroids: aCollectionOfPoints [

	centroids := aCollectionOfPoints
]

{ #category : #training }
AIKMeans >> chooseRandomCentroid: aCollectionOfPoints [
	"Algorithm:
	
	- Take the min and max value for each dimension of the point. If the point is a normal X,Y
	point, take the min and max X value, and the min and max Y value.
	- Choose a random number between the min and max range for each point dimension. "

	| min max pointDimension |
	pointDimension := aCollectionOfPoints first size.

	^ (1 to: pointDimension)
		  collect: [ :i |
			  max := aCollectionOfPoints max: [ :point | point at: i ].
			  min := aCollectionOfPoints min: [ :point | point at: i ].
			  rand nextBetween: min and: max ]
		  as: Array
]

{ #category : #accessing }
AIKMeans >> clusters [

	^ clusters
]

{ #category : #accessing }
AIKMeans >> clusters: aCollection [
	"Used for testing"

	clusters := aCollection
]

{ #category : #training }
AIKMeans >> distanceBetween: firstPoint and: secondPoint [
	"It follows the Euclidean distance between two points formula."
	
	^ euclideanDistance distanceBetween: firstPoint and: secondPoint
	
	"The code is not idiomatic because of performance. We see that writting this instead of 
	(firstPoint - secondPoint raisedTo: 2) sum sqrt
	is about 30% fastest."

	"| sum |
	sum := 0.
	1 to: firstPoint size do: [ :i | 
		| diff |
		diff := (firstPoint at: i) asFloat - (secondPoint at: i) asFloat.
		sum := sum + (diff * diff) ].
	^ sum sqrt"
]

{ #category : #api }
AIKMeans >> fit: aCollectionOfPoints [

	| score bestScore bestCentroids |
	aCollectionOfPoints ifEmpty: [ ^ self ].
	bestScore := Float infinity.

	timesToRun timesRepeat: [
		self kMeansAlgorithm: aCollectionOfPoints.

		"The best centroid points are the ones that minimize the score.
		The score is the sum of the mean square errors of the points and its cluster."
		score := self score: aCollectionOfPoints.
		bestScore > score ifTrue: [
			bestCentroids := centroids.
			bestScore := score ] ].

	"We keep the best centroids after running the algo timesToRun-times"
	centroids := bestCentroids.
	self assignClusterToPoints: aCollectionOfPoints
]

{ #category : #testing }
AIKMeans >> hasConverged [

	centroids with: previousCentroids do: [ :current :previous |
		((self distanceBetween: current and: previous) closeTo: 0) ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #testing }
AIKMeans >> hasReachedMaxIterations [

	^ performedIterations >= maxIterations
]

{ #category : #initialization }
AIKMeans >> initialize [

	super initialize.

	clusters := OrderedCollection new.
	centroids := OrderedCollection new.
	previousCentroids := OrderedCollection new.
	performedIterations := 0.

	rand := Random new.
	euclideanDistance := AIEuclideanDistance new.
	maxIterations := self class defaultMaxIterations.
	timesToRun := self class defaultNumberOfTimesItIsRun
]

{ #category : #training }
AIKMeans >> initializeCentroidsKMeansPlusPlus: points [

	" The k-means++ is an algorithm for initializing the centroids. It was proposed in 2007 by Arthur et Vassilvitskii. 
	
	1. Choose the first centroid to be a random point.
	2. Calculate the distance of all the point to the choosen clusters. Keep the min distance of a point to the choosen clusters.
	3. Choose the next cluster the point being the farest being the one with the most probability of being choose.
	4. Repeat Steps 2 and 3 k centroids are selected"

	| firstCentroid |
	firstCentroid := points atRandom.
	centroids := OrderedCollection with: firstCentroid.
	
	[ centroids size < numberOfClusters ] whileTrue: [
		| distances pointWithMaxDistance |
		distances := points collect: [ :aPoint | 
			centroids min: [ :aCentroid | self distanceBetween: aPoint and: aCentroid ] ].
		pointWithMaxDistance := points at: distances argmax.
		centroids add: pointWithMaxDistance ]
]

{ #category : #training }
AIKMeans >> initializeRandomCentroids: aCollectionOfPoints [

	centroids := (1 to: numberOfClusters) collect: [ :i | 
		self chooseRandomCentroid: aCollectionOfPoints ]
]

{ #category : #training }
AIKMeans >> kMeansAlgorithm: aCollectionOfPoints [

	performedIterations := 0.
	"Initialize the centrois using the k-means++ algorithm"
	self initializeCentroidsKMeansPlusPlus: aCollectionOfPoints.

	[
	self assignClusterToPoints: aCollectionOfPoints.
	self updateCentroids: aCollectionOfPoints.
	performedIterations := performedIterations + 1 ] 
		doWhileFalse: [ self hasConverged or: [ self hasReachedMaxIterations ] ].
]

{ #category : #accessing }
AIKMeans >> maxIterations: anInteger [

	maxIterations := anInteger
]

{ #category : #training }
AIKMeans >> nearestCentroidToPoint: aPoint [

	| minDistance nearestCentroidIndex |	
	minDistance := self distanceBetween: aPoint and: (centroids first).
	nearestCentroidIndex := 1.

	centroids doWithIndex: [ :centroid :i | 
		| distance |
		distance := self distanceBetween: aPoint and: centroid.
		distance < minDistance ifTrue: [ 
			minDistance := distance.
			nearestCentroidIndex := i ] ].

	^ nearestCentroidIndex
]

{ #category : #accessing }
AIKMeans >> numberOfClusters: anObject [

	numberOfClusters := anObject
]

{ #category : #api }
AIKMeans >> predict: aCollectionOfPoints [
	"Asign each point to the closest centroid (in other words, cluster the points)"

	^ aCollectionOfPoints collect: [ :point | self nearestCentroidToPoint: point ]
]

{ #category : #api }
AIKMeans >> score: aCollectionOfPoints [
	"The score is the sum of the mean square errors of the points and its cluster."

	| point centroid distances |
	distances := (1 to: aCollectionOfPoints size) collect: [ :index |
		point := aCollectionOfPoints at: index.
		centroid := centroids at: (clusters at: index).
		self distanceBetween: point and: centroid ].
	^ distances sum
]

{ #category : #accessing }
AIKMeans >> timesToRun: anInteger [

	timesToRun := anInteger
]

{ #category : #api }
AIKMeans >> transform: aCollectionOfPoints [
	"Transform X to a cluster-distance space.
	Compute the distance matrix between each point to each of the centroids"

	^ aCollectionOfPoints collect: [ :aPoint |
		  centroids collect: [ :aCentroid | self distanceBetween: aPoint and: aCentroid ] ]
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
			ifFalse: [ pointsOfThisCentroid average ] ]
]
