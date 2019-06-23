//
//  ViewController.swift
//  Final Project
//
//  Created by Reia Min on 14/6/2019.
//  Copyright © 2019 Reia Min. All rights reserved.
//

import UIKit

struct Singer : Codable {
    var birthday : String
    var category : String
    var description: String
    var name : String
}

struct Album : Codable{
    var name: String
    var image: String
    var year: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var singerName: UILabel!
    @IBOutlet weak var singerCatecory: UILabel!
    @IBOutlet weak var singerDescription: UITextView!
    @IBOutlet weak var singerBirthday: UITextView!
    @IBOutlet weak var albumView: UICollectionView!
    
    let model = ["Sun Dance","Day Dream","Penny Rain","DAWN"]
    var information = Singer(birthday: "", category: "",description: "", name: "")
    var albums = [Album]()
    
    var clickIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Get Singer From Backend
        if let url = URL(string: "http://140.121.197.22:9000/singer?query=Aimer") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Singer.self, from: data)
                        print(res.description)
                        
                        
                        self.information = res
                        
                        DispatchQueue.main.async {
                            self.singerName.text = res.name
                            self.singerCatecory.text = res.category
                            self.singerDescription.text = res.description
                            self.singerBirthday.text = res.birthday
                        }
                      
                        
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
        
        //Get Album From Backend
        if let url = URL(string: "http://140.121.197.22:9000/album?query=Aimer") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode([Album].self, from: data)
                        print(res[0].name)
                        
                        self.albums = res
                        
                        DispatchQueue.main.async {
                            self.albumView.reloadData()
                            super.viewDidLoad()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
        
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let album = albums[indexPath.item]
        
        cell.albumName.text = album.name
        cell.albumYear.text = album.year
        

        var temp = album.image.components(separatedBy: ",")
        
        // Adding padding
        let remainder = temp[1].count % 4
        if remainder > 0
        {
            temp[1] = temp[1].padding(toLength: temp[1].count + 4 - remainder, withPad: "=", startingAt: 0)
        }
        
        //Convert Base64 Image
        let dataDecoded : Data = Data(base64Encoded: temp[1], options: .ignoreUnknownCharacters)!
        cell.albumCover.image = UIImage(data: dataDecoded)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        self.clickIndex = indexPath.item
        
        performSegue(withIdentifier: "showAlbum", sender: nil)
        
//        if let controller = storyboard?.instantiateViewController(withIdentifier: "albumPage") as? albumViewController {
//            controller.albumName = albums[indexPath.item].name
//            controller.singerName = singerName.text!
//            controller.albumCover = albums[indexPath.item].image
//            controller.albumYear = albums[indexPath.item].year
//
//            performSegue(withIdentifier: "showAlbum", sender: nil)
//            //present(controller, animated: true, completion: nil)
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var queryName = searchBar.text
        
        queryName = queryName?.replacingOccurrences(of: " ", with: "+")
        
        if let url = URL(string: "http://140.121.197.22:9000/singer?query="+queryName!) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Singer.self, from: data)
                        print(res.description)
                        
                        
                        self.information = res
                        
                        DispatchQueue.main.async {
                            self.singerName.text = res.name
                            self.singerCatecory.text = res.category
                            self.singerDescription.text = res.description
                            self.singerBirthday.text = res.birthday
                        }
                        
                        
                    } catch let error {
                        print(error)
                    }
                }
                }.resume()
        }
        
        //Get Album From Backend
        if let url = URL(string: "http://140.121.197.22:9000/album?query="+queryName!) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode([Album].self, from: data)
                        print(res[0].name)
                        
                        self.albums = res
                        
                        DispatchQueue.main.async {
                            self.albumView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
                }.resume()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        print(self.clickIndex)

        let controller = segue.destination as! albumViewController

        controller.albumName = albums[clickIndex].name
        controller.singerName = singerName.text!
        controller.albumCover = albums[clickIndex].image
        controller.albumYear = albums[clickIndex].year
    }

}

