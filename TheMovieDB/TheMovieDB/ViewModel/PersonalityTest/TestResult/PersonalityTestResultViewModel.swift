//
//  PersonalityTestResultViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/9/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class PersonalityTestResultViewModel: ViewModel {

    // MARK: - Observables -
    
    var chartTitle = Observable<String?>(nil)
    var chartPercentage = Observable<String?>(nil)
    var descriptionText = Observable<String?>(nil)
    var image = Observable<UIImage?>(nil)
    
    // MARK: - Variables -
    
    var selectedChartType: GenericChartType = .radar
    private var arrayPersonalityTypes = Singleton.shared.arrayPersonalityTypes
    
    var userPersonalityTypeIndex: Int? {
        let index = arrayPersonalityTypes.index { (personalityType) -> Bool in
            return personalityType.id == Singleton.shared.userPersonalityType?.id
        }
        return index
    }
    
    private var selectedChartPersonalityType: PersonalityType? {
        didSet {
            chartTitle.value = selectedChartPersonalityType?.title
            chartPercentage.value = percentageFor(personalityType: selectedChartPersonalityType)
            descriptionText.value = selectedChartPersonalityType?.text
            image.value = UIImage(named: "\(selectedChartPersonalityType?.title ?? "")")
        }
    }

    // MARK: - Chart -
    
    var chartContainerItems: [ChartListItem] {
        var array = [ChartListItem]()
        
        var index = 0
        arrayPersonalityTypes.forEach { [weak self] (personalityType) in
            if let item = self?.createItem(from: personalityType, at: index) {
                array.append(item)
            }
            
            index += 1
        }
        
        return array
    }
    
    private func createItem(from object: PersonalityType, at index: Int) -> ChartListItem? {
        var item = ChartListItem()
        item.object = object
        item.color = UIColor(
            hexString: selectedChartType == .radar
                ? Singleton.shared.userPersonalityType?.color ?? ""
                : object.color ?? ""
        )
        
        var itemValue: Double = 0
        
        let dictionary = Singleton.shared.dictionaryAnswersCounts().filter { return $0.key == object.id }
        if let value = dictionary.values.first {
            itemValue = Double(value)
        }
        
        item.value = itemValue
        item.leftText = object.title ?? ""
        item.rightText = "\(object.title ?? "")\n\(percentageFor(personalityType: object))"
        
        return item
    }
    
    private func percentageFor(personalityType: PersonalityType?) -> String {
        var count: Double = 0
        let dictionary = Singleton.shared.dictionaryAnswersCounts().filter { return $0.key == personalityType?.id }
        if let value = dictionary.values.first {
            count = Double(value)
        }
        return "\(Int((count / Double(Singleton.shared.userAnsweredQuestions.count - 1)) * 100))%"
    }
    
    
    // MARK: - Service request -
    
    func loadData() {
        selectedChartPersonalityType = Singleton.shared.userPersonalityType
    }
    
    // MARK: - View Model -
    
    func setChartType(with index: Int) {
        selectedChartType = index == 0 ? .radar : .pie
    }
    
    func setSelectedChartItem(at index: Int) {
        selectedChartPersonalityType = arrayPersonalityTypes[index]
    }
}
