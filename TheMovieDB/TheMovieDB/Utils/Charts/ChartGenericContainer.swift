//
//  ChartGenericContainer.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Charts

enum GenericChartType {
    case pie
    case halfPie
    case line
    case lineFilled
    case cubicLine
    case cubicLineFilled
    case horizontalBar
    case stackedBar
    case bubble
    case radar
}

struct ChartListItem {
    var leftText = ""
    var centerText = ""
    var rightText = ""
    var color = HexColor.text.color
    var object: Any? = nil
    var value: Double?
    var set: ChartMultiValuesSet? = nil
    
    init(leftText: String = "",
         centerText: String = "",
         rightText: String = "",
         rightTextAttributedString: NSAttributedString? = nil,
         color: UIColor? = nil,
         object: Any? = nil,
         value: Double? = nil,
         set: ChartMultiValuesSet? = nil) {
        
        self.leftText = leftText
        self.centerText = centerText
        self.rightText = rightText
        self.color = (color == nil) ? UIColor.clear : color!
        self.object = object
        self.value = value
        self.set = set
    }
}

//Object to use on each ChartListItem
struct ChartMultiValuesSet {
    var values = [Double]()
    var color: UIColor = HexColor.primary.color
    var title: String = ""
    var bottomValues = [String]()
    
    init(values: [Double], title: String = "", color: UIColor = HexColor.text.color, bottomValues: [String] = [String]()) {
        self.values = values
        self.title = title
        self.color = color
        self.bottomValues = bottomValues
    }
}

protocol ChartGenericContainerDelegate: class {
    func chartValueSelected(at index: Int)
    func chartValueNothingSelected()
}

//MARK: - Constants -

private let spaceForHorizontalBar: Double = 10.0
private let commonMargin: CGFloat = 8.0

//MARK: - Chart Generic Container View -

class ChartGenericContainer: UIView, ChartViewDelegate, IAxisValueFormatter, IValueFormatter {
    weak var chartDelegate: ChartGenericContainerDelegate?
    
    //MARK: - Properties -
    
    var chartType = GenericChartType.pie
    var chartItems = [ChartListItem]()
    var chartLegendText = "" //Chart bottom label text when it is available
    var isDashLine = false //Set dash line to chart
    var centerTextTitle = "" //Set title to chart center if it is available
    var size = CGSize.zero
    
    private var chartView: ChartViewBase?
    private var xBottomDescriptions = [String]()
    private var animationDuration: Double = 1.0
    
    //MARK: - Initialization -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(size: CGSize, chartType: GenericChartType, chartItems: [ChartListItem]) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.size = size
        self.chartType = chartType
        self.chartItems = chartItems
    }
    
    func createChart(animated: Bool = true) {
        switch chartType {
        case .pie,
             .halfPie:
            addSubview(createPieChart(size: size, isHalf: chartType == .halfPie, animated: animated))
        case .line,
             .cubicLine,
             .cubicLineFilled,
             .lineFilled:
            addSubview(createLineChart(size: size, type: chartType, animated: animated))
        case .horizontalBar:
            addSubview(createHorizontalBarChart(size: size, animated: animated))
        case .stackedBar:
            addSubview(createStackedBarChart(size: size, animated: animated))
        case .bubble:
            addSubview(createBubbleChart(size: size, animated: animated))
        case .radar:
            addSubview(createRadarChart(size: size, animated: animated))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Stacked Bar Chart -
    
    private func createStackedBarChart(size: CGSize, animated: Bool = true) -> UIView {
        //Constants
        let bottomLabelHeight: CGFloat = 40.0
        let bottomPadding: CGFloat = 16.0 //Space between container bottom and label bottom
        let disclosureIndicatorMargin: CGFloat = 16.0 //Space to appear the disclosure indicator
        
        let chartFrame = CGRect(x: 0,
                                y: 0,
                                width: size.width - disclosureIndicatorMargin,
                                height: size.height - bottomLabelHeight - bottomPadding)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let chartView = setupBarChartView(frame: chartFrame)
        let bottomLabel = UILabel(frame: CGRect(x: 0, y: chartFrame.size.height, width: size.width, height: bottomLabelHeight))
        
        chartView.data = getBarChartData()
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
        
        //Bottom Label
        bottomLabel.baselineAdjustment = .alignCenters
        bottomLabel.attributedText = getStackedBarLegendAttributedString()
        bottomLabel.textAlignment = .center
        container.addSubview(bottomLabel)
        
        if animated {
            chartView.animate(xAxisDuration: animationDuration, yAxisDuration: animationDuration, easingOption: .easeOutBack)
        }
        
        self.chartView = chartView
        container.addSubview(chartView)
        return container
    }
    
    private func setupBarChartView(frame: CGRect) -> BarChartView {
        let chartView = BarChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.noDataText = Messages.emptySearch.localized
        chartView.delegate = self
        chartView.pinchZoomEnabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.isUserInteractionEnabled = false
        
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = self
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = chartItems.count
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11.0)
        chartView.xAxis.labelTextColor = HexColor.text.color
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.fitBars = true
        return chartView
    }
    
    private func getBarChartData() -> BarChartData {
        let stackedBarFont: CGFloat = 11.0 //Font of the items' value
        let barWidth: Double = 7.0
        
        var yVals = [BarChartDataEntry]()
        var grayVals = [BarChartDataEntry]()
        var yColors = [UIColor]()
        
        var i = 0
        chartItems.forEach { (item) in
            yColors.append(item.color)
            
            let xValue = Double(i) * spaceForHorizontalBar
            let yValue = (item.value != nil) ? item.value! : 0
            
            let entry = BarChartDataEntry(x: xValue, y: yValue)
            yVals.append(entry)
            
            let sumColoredValues = yVals.reduce(0, { $0 + $1.y })
            let grayEntry = BarChartDataEntry(x: xValue, y: sumColoredValues)
            grayVals.append(grayEntry)
            
            i += 1
        }
        
        let dataSet = BarChartDataSet(values: yVals, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = yColors
        
        let grayDataSet = BarChartDataSet(values: grayVals, label: "")
        grayDataSet.drawValuesEnabled = false
        grayDataSet.colors = [HexColor.text.color]
        
        let barData = BarChartData(dataSets: [grayDataSet, dataSet])
        barData.barWidth = barWidth
        barData.setValueFont(UIFont.systemFont(ofSize: stackedBarFont, weight: UIFont.Weight.light))
        barData.highlightEnabled = false
        
        return barData
    }
    
    private func getStackedBarLegendAttributedString() -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let firstLabel = "◉"
        let middleLabel = chartLegendText
        
        let string = "\(firstLabel) \(middleLabel)"
        
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20.0)])
        
        
        attributedString.addAttributesFrom(string: string, substring: firstLabel)
        attributedString.addAttributesFrom(string: string,
                                           substring: "\(middleLabel)",
                                           color: HexColor.text.color,
                                           font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light))
        
        return attributedString
    }
    
    //MARK: - Bubble Chart -
    
    private func createBubbleChart(size: CGSize, animated: Bool = true) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let chartView = setupBubbleChartView(frame: frame)
        chartView.data = getBubbleChartData()
        
        return chartView
    }
    
    private func setupBubbleChartView(frame: CGRect) -> BubbleChartView {
        let chartView = BubbleChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.noDataText = Messages.emptySearch.localized
        chartView.delegate = self
        chartView.chartDescription = nil
        chartView.pinchZoomEnabled = true
        chartView.setScaleEnabled(true)
        chartView.dragEnabled = true
        chartView.isMultipleTouchEnabled = true
        chartView.drawGridBackgroundEnabled = false
        
        chartView.legend.form = .line
        chartView.legend.wordWrapEnabled = true
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont.systemFont(ofSize: 12.0)
        chartView.legend.textColor = HexColor.text.color
        chartView.legend.horizontalAlignment = .center
        chartView.legend.verticalAlignment = .bottom
        chartView.legend.orientation = .horizontal
        chartView.legend.direction = .leftToRight
        
        chartView.leftAxis.valueFormatter = self //Left Labels
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.removeAllLimitLines()
        chartView.leftAxis.valueFormatter = self
        chartView.leftAxis.drawGridLinesEnabled = true
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xBottomDescriptions)
        chartView.xAxis.labelTextColor = HexColor.text.color
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        
        return chartView
    }
    
    private func getBubbleChartData() -> BubbleChartData {
        var dataSets = [BubbleChartDataSet]()
        
        chartItems.forEach { (item) in
            guard let set = item.set else {
                return
            }
            
            let dataSet = BubbleChartDataSet()
            dataSet.colors = [item.color]
            dataSet.drawValuesEnabled = true
            
            //Bubble entry with x, y and size (z)
            if set.values.count == 3 {
                let info = set.title
                let xValue = set.values[0]
                let yValue = set.values[1]
                let zValue = set.values[2]
                let entry = BubbleChartDataEntry(x: xValue, y: yValue, size: CGFloat(zValue), data: info as AnyObject)
                dataSet.values = [entry]
                dataSet.label = item.leftText
            }
            
            dataSets.append(dataSet)
        }
        
        let data = BubbleChartData(dataSets: dataSets)
        data.setDrawValues(false)
        data.setValueTextColor(HexColor.text.color)
        
        return data
    }
    
    // MARK: - Line Chart -
    
    private func createLineChart(size: CGSize, type: GenericChartType, animated: Bool = true) -> UIView {
        //Constants
        let topPadding: CGFloat = commonMargin * 2 //Space between container bottom and label bottom
        
        //Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let chartFrame = CGRect(x: 0, y: topPadding, width: size.width, height: size.height - topPadding)
        
        //Views
        let container = UIView(frame: frame)
        let chartView = setupLineChartView(frame: chartFrame)
        chartView.data = getLineChartData(chartView: chartView, type: type)
        
        if animated {
            chartView.animate(xAxisDuration: animationDuration, yAxisDuration: animationDuration, easingOption: .easeOutBack)
        }
        
        self.chartView = chartView
        container.addSubview(chartView)
        return container
    }
    
    private func setupLineChartView(frame: CGRect) -> LineChartView {
        let chartView = LineChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.noDataText = Messages.emptySearch.localized
        chartView.delegate = self
        chartView.chartDescription = nil
        
        chartView.legend.form = .line
        chartView.legend.font = UIFont.systemFont(ofSize: 12.0)
        chartView.legend.textColor = HexColor.text.color
        chartView.legend.horizontalAlignment = .center
        chartView.legend.verticalAlignment = .bottom
        chartView.legend.orientation = .horizontal
        
        chartView.extraRightOffset = commonMargin*4
        
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        chartView.drawBordersEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.leftAxis.axisLineColor = HexColor.text.color
        chartView.leftAxis.labelTextColor = HexColor.text.color
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11.0)
        chartView.leftAxis.valueFormatter = self //Left Labels
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.drawLabelsEnabled = true
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xBottomDescriptions)
        chartView.xAxis.labelTextColor = HexColor.text.color
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        
        return chartView
    }
    
    private func createLineDataSet(values: [ChartDataEntry], label: String, color: UIColor, type: GenericChartType) -> LineChartDataSet {
        let lineWidth: CGFloat = 2.0
        let fillAlpha: CGFloat = 0.15
        
        let lineSet = LineChartDataSet(values: values, label: label)
        
        lineSet.axisDependency = .left
        lineSet.setColor(color)
        lineSet.lineWidth = lineWidth
        lineSet.drawFilledEnabled = true
        lineSet.drawCircleHoleEnabled = false
        lineSet.circleRadius = 3.0
        lineSet.circleColors = [color]
        lineSet.drawCirclesEnabled = (values.count == 1)
        
        lineSet.mode = type == .cubicLine || type == .cubicLineFilled ? .cubicBezier : .linear
        lineSet.fillColor = type == .lineFilled || type == .cubicLineFilled ? color : UIColor.clear
        lineSet.fillAlpha = type == .lineFilled || type == .cubicLineFilled ? fillAlpha : 0
        
        if isDashLine { lineSet.lineDashLengths = [CGFloat(5), CGFloat(5)] }
        
        return lineSet
    }
    
    private func getLineChartData(chartView: LineChartView, type: GenericChartType) -> LineChartData {
        xBottomDescriptions = [String]()
        var dataSets = [LineChartDataSet]()
        
        chartItems.forEach { (item) in
            guard let set = item.set else {
                return
            }
            
            var lineValues = [ChartDataEntry]()
            var index = 0
            set.values.forEach { (value) in
                lineValues.append(ChartDataEntry(x: Double(index), y: value))
                index += 1
            }
            
            if xBottomDescriptions.isEmpty { xBottomDescriptions.append(contentsOf: set.bottomValues) }
            
            chartView.legend.enabled = set.title != ""
            dataSets.append(createLineDataSet(values: lineValues,
                                              label: set.title.capitalized,
                                              color: set.color,
                                              type: type))
        }
        
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        
        return data
    }
    
    //MARK: - Pie Chart -
    
    private func createPieChart(size: CGSize, isHalf: Bool = false, animated: Bool = true) -> UIView {
        //Constants
        let topPadding: CGFloat = commonMargin * 2 //Space between container bottom and label bottom
        
        //Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let chartFrame = CGRect(x: 0, y: topPadding, width: size.width, height: size.height - topPadding)
        
        //Views
        let container = UIView(frame: frame)
        let chartView = setupPieChartView(frame: chartFrame)
        chartView.data = getPieChartData()
        
        //Half Pie
        if isHalf {
            chartView.maxAngle = 180.0
            chartView.rotationAngle = 180.0
        }
        
        chartView.reloadInputViews()
        
        //Circle Center Text
        if chartItems.count > 0 {
            setCenterText(with: chartItems.first, showLeftText: isHalf)
        }
        
        if animated {
            chartView.animate(xAxisDuration: animationDuration, yAxisDuration: animationDuration, easingOption: .easeOutBack)
        }
        self.chartView = chartView
        container.addSubview(chartView)
        return container
    }
    
    private func setupPieChartView(frame: CGRect) -> PieChartView {
        let chartView = PieChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.center = CGPoint(x: self.center.x, y: self.center.y + commonMargin*2)
        chartView.noDataText = Messages.emptySearch.localized
        chartView.delegate = self
        chartView.holeRadiusPercent = 0.68
        chartView.holeColor = HexColor.primary.color
        chartView.chartDescription?.text = ""
        chartView.legend.enabled = false
        chartView.layoutMargins = UIEdgeInsets.zero
        
        return chartView
    }
    
    private func getPieChartData() -> PieChartData {
        //Colors of items
        var colors = [UIColor]()
        
        var yVals = [ChartDataEntry]()
        var xVals = [String]()
        var i = 0
        
        chartItems.forEach { (item) in
            xVals.append("")
            yVals.append(BarChartDataEntry(x: Double(i), y: item.value ?? Double(10)))
            
            colors.append(item.color)
            i += 1
        }
        
        let dataSet = PieChartDataSet(values: yVals, label: "")
        dataSet.sliceSpace = 0.2
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.multiplier = 1
        numberFormatter.percentSymbol = "%"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
        data.setValueTextColor(UIColor.clear)
        
        return data
    }
    
    //MARK: - Horizontal Bar Chart -
    
    private func createHorizontalBarChart(size: CGSize, animated: Bool = true) -> UIView {
        //Constants
        let horizontalBarFont: CGFloat = 13.0 //Font of the items' value
        let bottomLabelHeight: CGFloat = 12.0
        let bottomLabelFontSize: CGFloat = 11.0
        let bottomPadding: CGFloat = 16.0 //Space between container bottom and label bottom
        
        //Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let chartFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height - bottomLabelHeight - bottomPadding)
        let bottomLabelFrame = CGRect(x: 0, y: chartFrame.size.height, width: size.width - commonMargin, height: bottomLabelHeight)
        
        //Views
        let container = UIView(frame: frame)
        let bottomLabel = UILabel(frame: bottomLabelFrame)
        let chartView = setupHorizontalBarChartView(frame: chartFrame)
        
        chartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: horizontalBarFont)
        chartView.data = getHorizontalBarData()
        
        //Bottom Label
        if chartLegendText.count > 0 {
            bottomLabel.text = chartLegendText
            bottomLabel.font = UIFont.systemFont(ofSize: bottomLabelFontSize)
            bottomLabel.textAlignment = .right
            bottomLabel.isHidden = false
        } else {
            bottomLabel.isHidden = true
        }
        
        if animated {
            chartView.animate(xAxisDuration: animationDuration, yAxisDuration: animationDuration, easingOption: .easeOutBack)
        }
        
        self.chartView = chartView
        
        container.addSubview(bottomLabel)
        container.addSubview(chartView)
        return container
    }
    
    private func setupHorizontalBarChartView(frame: CGRect) -> HorizontalBarChartView {
        let chartView = HorizontalBarChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.noDataText = Messages.emptySearch.localized
        chartView.delegate = self
        chartView.pinchZoomEnabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.isUserInteractionEnabled = false
        
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = self
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(chartItems.count, force: true)
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.fitBars = true
        
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
        
        return chartView
    }
    
    private func getHorizontalBarData() -> BarChartData {
        let horizontalBarFont: CGFloat = 13.0 //Font of the items' value
        let barWidth: Double = 9.0
        
        var yVals = [BarChartDataEntry]()
        var yColors = [UIColor]()
        
        if chartItems.count > 0 {
            for i in 0..<chartItems.count {
                guard let value = chartItems[i].value else {
                    continue
                }
                
                let entry = BarChartDataEntry(x: Double(i) * spaceForHorizontalBar, y: value)
                yVals.append(entry)
                
                //Positive or Negative Color
                yColors.append(value < 0 ? HexColor.accent.color : HexColor.primary.color)
            }
        }
        
        let dataSet = BarChartDataSet(values: yVals, label: "")
        dataSet.colors = yColors
        dataSet.valueColors = [HexColor.text.color]
        
        let barData = BarChartData(dataSet: dataSet)
        barData.barWidth = barWidth
        barData.setValueFormatter(self)
        barData.setValueFont(UIFont.systemFont(ofSize: horizontalBarFont, weight: UIFont.Weight.light))
        barData.highlightEnabled = false
        
        return barData
    }
    
    // MARK: - Radar Chart -
    
    private func createRadarChart(size: CGSize, animated: Bool = true) -> UIView {
        //Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        //Views
        let container = UIView(frame: frame)
        let chartView = setupRadarChart(frame: frame)
        chartView.data = getRadarData()
        
        if animated {
            chartView.animate(xAxisDuration: animationDuration, yAxisDuration: animationDuration, easingOption: .easeOutBack)
        }
        
        self.chartView = chartView
        container.addSubview(chartView)
        return container
    }
    
    private func setupRadarChart(frame: CGRect) -> RadarChartView {
        let alpha: CGFloat = 0.7, lineWidth: CGFloat = 2.0
        
        let chartView = RadarChartView(frame: frame)
        
        chartView.backgroundColor = HexColor.primary.color
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.webLineWidth = lineWidth
        chartView.innerWebLineWidth = lineWidth
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.webAlpha = alpha
        
        let font = UIFont.systemFont(ofSize: 14)
        
        let legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.font = font
        legend.xEntrySpace = 7
        legend.yEntrySpace = 5
        legend.textColor = HexColor.text.color
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = font
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = HexColor.text.color
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = font
        yAxis.setLabelCount(chartItems.count, force: true)
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = Double(chartItems.count)
        yAxis.drawLabelsEnabled = false
        
        return chartView
    }
    
    private func getRadarData() -> RadarChartData {
        let alpha: CGFloat = 0.7, lineWidth: CGFloat = 2.0
        
        var dataEntry = [RadarChartDataEntry]()
        var color = HexColor.secondary.color
        
        chartItems.forEach { (item) in
            guard let value = item.value else {
                return
            }
            
            dataEntry.append(RadarChartDataEntry(value: value))
            color = item.color
        }
        
        let dataSet = RadarChartDataSet(values: dataEntry, label: "")
        dataSet.setColor(UIColor.clear)
        dataSet.fillColor = color
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = alpha
        dataSet.lineWidth = lineWidth
        dataSet.drawHighlightCircleEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        
        let radarData = RadarChartData(dataSet: dataSet)
        radarData.setValueFont(UIFont.systemFont(ofSize: 17))
        radarData.setDrawValues(false)
        radarData.setValueTextColor(HexColor.secondary.color)
        
        return radarData
    }
    
    //MARK: - Chart Text -
    
    private func setCenterText(with item: ChartListItem?, showLeftText: Bool = false) {
        guard let chartView = chartView as? PieChartView, let item = item else {
            return
        }
        
        var string = ""
        if showLeftText { string += "\(item.leftText)\n" }
        string += item.rightText

        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        
        attributedString.addAttributesFrom(string: string, substring: string)
        chartView.centerAttributedText = attributedString

    }
    
    //MARK: - Chart View Delegate -
    
    func highlightItem(at index: Int) {
        let highlight = Highlight(x: Double(index), dataSetIndex: 0, stackIndex: 0)
        chartView?.highlightValue(highlight)
        let item = chartItems[index]
        setCenterText(with: item)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartDelegate?.chartValueSelected(at: Int(highlight.x))
        
        guard chartType == .pie, Int(highlight.x) < chartItems.count else {
            return
        }
        
        let item = chartItems[Int(highlight.x)]
        setCenterText(with: item)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartDelegate?.chartValueNothingSelected()
        setCenterText(with: chartItems.first)
    }
    
    //MARK: - Value Formatters -
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(value)"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch chartType {
        case .line,
             .cubicLine,
             .lineFilled,
             .cubicLineFilled:
            
            return "\(value)"
        case .horizontalBar,
             .stackedBar:
            
            let index = Int(value / spaceForHorizontalBar)
            if index < chartItems.count { return chartItems[index].leftText }
        case .radar:
            if Int(value) < chartItems.count { return chartItems[Int(value)].leftText }
        default: break
        }
        
        return ""
    }
}

extension NSMutableAttributedString {
    func addAttributesFrom(string: String, substring: String,
                           color: UIColor = HexColor.text.color,
                           font: UIFont = UIFont.systemFont(ofSize: 12),
                           alignment: NSTextAlignment = .center) {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        addAttributes([NSAttributedStringKey.foregroundColor: color,
                       NSAttributedStringKey.paragraphStyle: paragraph],
                      range: (string as NSString).range(of: substring))
    }
}
