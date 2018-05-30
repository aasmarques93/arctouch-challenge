//
//  SeasonDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class EpisodeViewModel: ViewModel {    
    // MARK: Service Model
    let serviceModel = EpisodesServiceModel()

    // MARK: Observables
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)

    // MARK: Objects
    var episode: Episodes?
    var tvShowDetail: TVShowDetail?

    private var arrayImages = [EpisodeImage]() { didSet { setupPhotos() } }
    private var photos = [Photo]()
    
    init(_ object: Episodes, tvShowDetail: TVShowDetail?) {
        self.episode = object
        self.tvShowDetail = tvShowDetail
    }
    
    func loadData() {
        title.value = "Episode \(valueDescription(episode?.episodeNumber)) - \(valueDescription(episode?.name))"
        date.value = "Air Date: \(valueDescription(episode?.airDate))"
        overview.value = valueDescription(episode?.overview)

        getImages()
    }

    private func getImages() {
        guard arrayImages.isEmpty else {
            return
        }

        serviceModel.getImages(from: tvShowDetail?.id,
                               season: episode?.seasonNumber,
                               episode: episode?.episodeNumber) { [weak self] (object) in

            guard let results = object.results else {
                return
            }
            self?.arrayImages = results
        }
    }

    var imageUrl: URL? {
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: episode?.stillPath ?? ""))
    }

    // MARK: - Photos -

    func presentPhotos() {
        if photos.isEmpty { return }
        PhotosComponent.present(photos: photos)
    }

    func setupPhotos() {
        photos = [Photo]()
        for image in arrayImages {
            Singleton.shared.serviceModel.loadImage(path: image.filePath) { [weak self] (data) in
                guard let data = data as? Data else {
                    return
                }
                
                self?.photos.append(Photo(image: UIImage(data: data)))
            }
        }
    }
}
