Class {
	#name : #AIKMeansVisualizer,
	#superclass : #Object,
	#instVars : [
		'xLabel',
		'yLabel'
	],
	#category : #'AI-KMeans-Visualization'
}

{ #category : #building }
AIKMeansVisualizer >> buildChartX: x y: y [

	^ RSCompositeChart new
		  add: (RSScatterPlot new x: x y: y);
		  xlabel: xLabel;
		  ylabel: yLabel;
		  yourself
]

{ #category : #building }
AIKMeansVisualizer >> buildChartX: x y: y clusters: aClustersArray [

	| chart plot colors |
	chart := self buildChartX: x y: y.
	chart build.

	colors := self colorPalette.
	plot := chart plots first.
	plot ellipses doWithIndex: [ :e :i | e color: (colors at: (aClustersArray at: i)) ].
	^ chart
]

{ #category : #building }
AIKMeansVisualizer >> buildDataFrameChart: aDataFrame xColumn: xColumnName yColumn: yColumnName [

	| chart x y |
	x := (aDataFrame column: xColumnName) asArray.
	y := (aDataFrame column: yColumnName) asArray.
	xLabel := xColumnName.
	yLabel := yColumnName.
	chart := self buildChartX: x y: y.
	chart build.
	^ chart
]

{ #category : #building }
AIKMeansVisualizer >> buildDataFrameChart: aDataFrame xColumn: xColumnName yColumn: yColumnName clusters: aClustersArray [

	| chart x y |
	x := (aDataFrame column: xColumnName) asArray.
	y := (aDataFrame column: yColumnName) asArray.
	xLabel := xColumnName.
	yLabel := yColumnName.
	chart := self buildChartX: x y: y clusters: aClustersArray.
	^ chart
]

{ #category : #building }
AIKMeansVisualizer >> colorPalette [

	^ NSScale google20 range
]

{ #category : #initialization }
AIKMeansVisualizer >> initialize [

	xLabel := 'X'.
	yLabel := 'Y'
]

{ #category : #ploting }
AIKMeansVisualizer >> plotData: aDataFrame xColumn: xColumnName yColumn: yColumnName [

	| chart |
	chart := self buildDataFrameChart: aDataFrame xColumn: xColumnName yColumn: yColumnName.
	^ chart canvas open
]

{ #category : #ploting }
AIKMeansVisualizer >> plotData: aDataFrame xColumn: xColumnName yColumn: yColumnName clusters: aClustersArray [

	| chart |
	chart := self buildDataFrameChart: aDataFrame
		         xColumn: xColumnName
		         yColumn: yColumnName
		         clusters: aClustersArray.
	^ chart canvas open
]

{ #category : #accessing }
AIKMeansVisualizer >> xLabel: anObject [

	xLabel := anObject
]

{ #category : #accessing }
AIKMeansVisualizer >> yLabel: anObject [

	yLabel := anObject
]
