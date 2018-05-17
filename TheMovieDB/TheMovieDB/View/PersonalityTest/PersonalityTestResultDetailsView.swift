//
//  PersonalityTestResultDetailsView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/9/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class PersonalityTestResultDetailsView: UIViewController {
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var labelChartTitle: UILabel!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var imageViewPersonalityType: UIImageView!
    @IBOutlet weak var textViewDescription: UITextView!
    
    let viewModel = PersonalityTestResultViewModel()
    var chartContainer: ChartGenericContainer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.personalityTestResult.localized
        setupBindings()
        setupData()
    }
    
    func setupBindings() {
        viewModel.chartTitle.bind(to: labelChartTitle.reactive.text)
        viewModel.chartPercentage.bind(to: labelPercentage.reactive.text)
        viewModel.descriptionText.bind(to: textViewDescription.reactive.text)
        viewModel.image.bind(to: imageViewPersonalityType.reactive.image)
    }
    
    func setupData(animated: Bool = true) {
        viewModel.loadData()
        setupChartContainer(animated: animated)
    }
    
    func setupChartContainer(animated: Bool = true) {
        viewChart.removeAllSubviews()
        chartContainer = ChartGenericContainer(size: viewChart.frame.size,
                                               chartType: viewModel.selectedChartType,
                                               chartItems: viewModel.chartContainerItems)
        
        if let chartContainer = chartContainer {
            chartContainer.chartDelegate = self
            chartContainer.chartLegendText = ""
            chartContainer.createChart(animated: animated)
            
            if let index = viewModel.userPersonalityTypeIndex {
                 chartContainer.highlightItem(at: index)
            }
            
            viewChart.addSubview(chartContainer)
        }
    }
    
    @IBAction func buttonShareAction(_ sender: UIBarButtonItem) {
        presentShareActivityController(image: takeScreenshot(shouldSave: false))
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        viewModel.setChartType(with: sender.selectedSegmentIndex)
        setupData()
    }
}

extension PersonalityTestResultDetailsView: ChartGenericContainerDelegate {
    func chartValueSelected(at index: Int) {
        viewModel.setSelectedChartItem(at: index)
    }
    
    func chartValueNothingSelected() {
        viewModel.setSelectedChartItem(at: viewModel.userPersonalityTypeIndex ?? 0)
        setupData(animated: false)
    }
}
