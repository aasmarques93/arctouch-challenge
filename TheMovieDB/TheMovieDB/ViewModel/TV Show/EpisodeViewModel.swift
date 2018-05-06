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
    var photo = Observable<UIImage?>(#imageLiteral(resourceName: "default-image"))
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)

    // MARK: Objects
    var episode: Episodes?
    var tvShowDetail: TVShowDetail?

    private var imagesList = [EpisodeImage]() { didSet { setupPhotos() } }
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
        loadImageData()
    }

    private func getImages() {
        guard imagesList.isEmpty else {
            return
        }

        serviceModel.getImages(from: tvShowDetail?.id,
                               season: episode?.seasonNumber,
                               episode: episode?.episodeNumber) { [unowned self] (object) in

            guard let object = object as? EpisodeImagesList, let results = object.results else {
                return
            }
            self.imagesList = results
        }
    }

    private func loadImageData() {
        guard let _ = photo.value else {
            return
        }

        ServiceModel().loadImage(path: episode?.stillPath ?? "", handlerData: { [weak self] (data) in
            guard let strongSelf = self, let data = data as? Data else {
                return
            }
            
            strongSelf.photo.value = UIImage(data: data)
        })
    }

    // MARK: - Photos -

    func presentPhotos() {
        if photos.isEmpty { return }
        PhotosComponent.present(photos: photos)
    }

    func setupPhotos() {
        photos = [Photo]()
        for image in imagesList {
            serviceModel.loadImage(path: image.filePath) { [weak self] (data) in
                guard let strongSelf = self else {
                    return
                }
                
                if let data = data as? Data {
                    strongSelf.photos.append(Photo(image: UIImage(data: data)))
                }
            }
        }
    }
}
