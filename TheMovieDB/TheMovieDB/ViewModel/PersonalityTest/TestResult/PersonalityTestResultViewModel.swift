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
    var isChartTypeSelectionHidden = Observable<Bool>(false)
    
    // MARK: - Variables -
    
    var selectedChartType: GenericChartType = .radar
    private var arrayPersonalityTypes = Singleton.shared.arrayPersonalityTypes
    
    var userPersonalityType: PersonalityType?
    var userAnsweredQuestions: [Answer]
    var userFriendPersonality: UserPersonality?
    
    var userPersonalityTypeIndex: Int? {
        let index = arrayPersonalityTypes.index { (personalityType) -> Bool in
            guard let userFriendPersonality = userFriendPersonality else {
                return personalityType.id == userPersonalityType?.id
            }
            return personalityType.id == userFriendPersonality.personalityTypeId
        }
        return index
    }
    
    private var selectedChartPersonalityType: PersonalityType? {
        didSet {
            chartTitle.value = selectedChartPersonalityType?.title
            chartPercentage.value = percentageFor(personalityType: selectedChartPersonalityType)
            descriptionText.value = selectedChartPersonalityType?.text
            image.value = UIImage(named: "\(selectedChartPersonalityType?.title ?? "")")
            isChartTypeSelectionHidden.value = userFriendPersonality != nil
        }
    }

    init(userPersonalityType: PersonalityType? = Singleton.shared.userPersonalityType,
         userAnsweredQuestions: [Answer] = Singleton.shared.userAnsweredQuestions,
         userFriendPersonality: UserPersonality? = nil) {
        
        self.userPersonalityType = userPersonalityType
        self.userAnsweredQuestions = userAnsweredQuestions
        self.userFriendPersonality = userFriendPersonality
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
                ? userPersonalityType?.color ?? userFriendPersonality?.color ?? ""
                : personalityType.color ?? ""
        )
        
        item.value = itemValueFor(personalityType: personalityType)
        item.leftText = personalityType.title ?? ""
        item.rightText = "\(personalityType.title ?? "")\n\(percentageFor(personalityType: personalityType))"
        
        return item
    }
    
    private func itemValueFor(personalityType: PersonalityType) -> Double {
        var itemValue: Double = 0
        
        if let userFriendPersonality = userFriendPersonality {
            itemValue = percentageFor(userFriendPersonality: userFriendPersonality, personalityType: personalityType)
        } else {
            let dictionary = Singleton.shared.dictionaryAnswersCounts(at: userAnsweredQuestions).filter { $0.key == personalityType.id }
            if let value = dictionary.values.first {
                itemValue = Double(value)
            }
        }
        
        return itemValue
    }
    
    private func percentageFor(personalityType: PersonalityType?) -> String {
        guard let userFriendPersonality = userFriendPersonality else {
            var count: Double = 0
            let dictionary = Singleton.shared.dictionaryAnswersCounts(at: userAnsweredQuestions).filter { $0.key == personalityType?.id }
            if let value = dictionary.values.first {
                count = Double(value)
            }
            return "\(Int((count / Double(userAnsweredQuestions.count - 1)) * 100))%"
        }
        
        return "\(Int(percentageFor(userFriendPersonality: userFriendPersonality, personalityType: personalityType) * 10))%"
    }
    
    private func percentageFor(userFriendPersonality: UserPersonality, personalityType: PersonalityType?) -> Double {
        guard let personalityType = personalityType else {
            return 0
        }
        
        var percentage: Float = 0
        
        if personalityType.title == Titles.comedy.rawValue { percentage = userFriendPersonality.comedyPercentage ?? 0 }
        if personalityType.title == Titles.action.rawValue { percentage = userFriendPersonality.actionPercentage ?? 0 }
        if personalityType.title == Titles.drama.rawValue { percentage = userFriendPersonality.dramaPercentage ?? 0 }
        if personalityType.title == Titles.thriller.rawValue { percentage = userFriendPersonality.thrillerPercentage ?? 0 }
        if personalityType.title == Titles.documentary.rawValue { percentage = userFriendPersonality.documentaryPercentage ?? 0 }
        
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
