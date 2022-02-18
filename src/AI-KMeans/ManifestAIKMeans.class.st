"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAIKMeans,
	#superclass : #PackageManifest,
	#category : #'AI-KMeans-Manifest'
}

{ #category : #'code-critics' }
ManifestAIKMeans class >> ruleGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#AIKMeans #run: #false)) #'2022-02-18T11:46:16.166114+01:00') )
]

{ #category : #'code-critics' }
ManifestAIKMeans class >> ruleMinMaxRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'AI-KMeans')) #'2022-02-16T13:46:50.041614+01:00') )
]

{ #category : #'code-critics' }
ManifestAIKMeans class >> ruleReGuardClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#AIKMeans #run: #false)) #'2022-02-18T11:46:06.596082+01:00') )
]

{ #category : #'code-critics' }
ManifestAIKMeans class >> ruleToDoCollectRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'AI-KMeans')) #'2022-02-16T13:46:24.390506+01:00') )
]

{ #category : #'code-critics' }
ManifestAIKMeans class >> ruleToDoRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'AI-KMeans')) #'2022-02-16T13:46:27.571916+01:00') )
]
