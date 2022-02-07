"
This is a custom exception to raise when the number of clusters has been not set in the K-means algorithm
"
Class {
	#name : #NumberOfClustersNotSetException,
	#superclass : #Exception,
	#category : #'AI-KMeans-Exceptions'
}

{ #category : #signaling }
NumberOfClustersNotSetException >> signal [

	self messageText: 'The numbers of clusters has not been set.'.
	
	^ super signal
]
