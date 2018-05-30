//
//  PersonalityTestResultViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/9/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class PersonalityTestResultViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Observables
    var chartTitle = Observable<String?>(nil)
    var chartPercentage = Observable<String?>(nil)
    var descriptionText = Observable<String?>(nil)
    var image = Observable<UIImage?>(nil)
    
    // MARK: Objects
    private var arrayPersonalityTypes = Singleton.shared.arrayPersonalityTypes
    
    private let userPersonalityType = Singleton.shared.userPersonalityType
    private let userAnsweredQuestions = Singleton.shared.userAnsweredQuestions
    private var userPersonality: UserPersonality?

    // MARK: Variables
    var selectedChartType: GenericChartType = .radar
    
    var userPersonalityTypeIndex: Int? {
        let index = arrayPersonalityTypes.index { (personalityType) -> Bool in
            guard let userPersonality = userPersonality else {
                return personalityType.id == userPersonalityType?.id
            }
            return personalityType.id == userPersonality.personalityTypeId
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
    
    // MARK: - Life cycle -

    init(userPersonality: UserPersonality? = Singleton.shared.user.personality) {
        self.userPersonality = userPersonality
    }
    
    // MARK: - Chart -
    
    var chartContainerItems: [ChartListItem] {
        var array = [ChartListItem]()
        
        var index = 0
        arrayPersonalityTypes.forEach { [weak self] (personalityType) in
            if let item = self?.createItem(from: personalityType) {
                array.append(item)
            }
            
            index += 1
        }
        
        return array
    }
    
    private func createItem(from personalityType: PersonalityType) -> ChartListItem? {
        var item = ChartListItem()
        item.object = personalityType
        item.color = UIColor(
            hexString: selectedChartType == .radar
                ? userPersonalityType?.color ?? userPersonality?.color ?? ""
                : personalityType.color ?? ""
        )
        
        item.value = itemValueFor(personalityType: personalityType)
        item.leftText = personalityType.title ?? ""
        item.rightText = "\(personalityType.title ?? "")\n\(percentageFor(personalityType: personalityType))"
        
        return item
    }
    
    private func itemValueFor(personalityType: PersonalityType) -> Double {
        var itemValue: Double = 0
        
        if let userPersonality = userPersonality {
            itemValue = percentageFor(userPersonality: userPersonality, personalityType: personalityType)
        } else {
            let dictionary = Singleton.shared.dictionaryAnswersCounts(at: userAnsweredQuestions).filter { $0.key == personalityType.id }
            if let value = dictionary.values.first {
                itemValue = Double(value)
            }
        }
        
        return itemValue
    }
    
    private func percentageFor(personalityType: PersonalityType?) -> String {
        guard let userPersonality = userPersonality else {
            var count: Double = 0
            let dictionary = Singleton.shared.dictionaryAnswersCounts(at: userAnsweredQuestions).filter { $0.key == personalityType?.id }
            if let value = dictionary.values.first {
                count = Double(value)
            }
            return "\(Int((count / Double(userAnsweredQuestions.count - 1)) * 100))%"
        }
        
        return "\(Int(percentageFor(userPersonality: userPersonality, personalityType: personalityType) * 10))%"
    }
    
    private func percentageFor(userPersonality: UserPersonality, personalityType: PersonalityType?) -> Double {
        guard let personalityType = personalityType else {
            return 0
        }
        
        var percentage: Float = 0
        
        if personalityType.title == Titles.comedy.rawValue { percentage = userPersonality.comedyPercentage ?? 0 }
        if personalityType.title == Titles.action.rawValue { percentage = userPersonality.actionPercentage ?? 0 }
        if personalityType.title == Titles.drama.rawValue { percentage = userPersonality.dramaPercentage ?? 0 }
        if personalityType.title == Titles.thriller.rawValue { percentage = userPersonality.thrillerPercentage ?? 0 }
        if personalityType.title == Titles.documentary.rawValue { percentage = userPersonality.documentaryPercentage ?? 0 }
        
        return Double(percentage / 10)
    }
    
    // MARK: - Service request -
    
    func loadData() {
        selectedChartPersonalityType = userPersonalityType
    }
    
    // MARK: - View Model -
    
    func setChartType(with index: Int) {
        selectedChartType = index == 0 ? .radar : .pie
    }
    
    func setSelectedChartItem(at index: Int) {
        selectedChartPersonalityType = arrayPersonalityTypes[index]
    }
}
