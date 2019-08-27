Extension { #name : #Random }

{ #category : #'*KMeans' }
Random >> nextBetween: lowerBound and: higherBound [
	^ lowerBound + (self next * (higherBound - lowerBound)).
]
