Extension { #name : #Random }

{ #category : #'*AI-KMeans-OldPharo' }
Random >> nextBetween: lowerBound and: higherBound [
	"Answer a random float number from the range [lowerBound, higherBound)"
	^ lowerBound + (self next * (higherBound - lowerBound))
]
