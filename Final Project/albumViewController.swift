//
//  albumViewController.swift
//  Final Project
//
//  Created by Reia Min on 16/6/2019.
//  Copyright © 2019 Reia Min. All rights reserved.
//

import UIKit

class albumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let model = ["1","2","3","4","5"]
    
    var singerName : String = "Aimer"
    var albumName : String = "Sun Dance"
    var albumCover : String = ""
    var albumYear : String = ""
    
    var songs = [String]()
    
    @IBOutlet weak var albumNamePanel: UILabel!
    @IBOutlet weak var albumYearPanel: UILabel!
    @IBOutlet weak var albumCoverImage: UIImageView!
    @IBOutlet weak var songsTable: UITableView!
    
    override func viewDidLoad() {
        

        // Do any additional setup after loading the view.
        print(singerName)
        print(albumName)
        print(albumYear)
        
        albumNamePanel.text = albumName
        albumYearPanel.text = albumYear
        
        var temp = albumCover.components(separatedBy: ",")

        // Adding padding
        let remainder = temp[1].count % 4
        if remainder > 0
        {
            temp[1] = temp[1].padding(toLength: temp[1].count + 4 - remainder, withPad: "=", startingAt: 0)
        }

        //Convert Base64 Image
        let dataDecoded : Data = Data(base64Encoded: temp[1], options: .ignoreUnknownCharacters)!
        albumCoverImage.image = UIImage(data: dataDecoded)
        
        //http://192.168.126.1:9000/albumDetail?singer=Aimer&album=Sun+Dance
        //Get Album Detail Information From Backend
        albumName = albumName.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: ("http://140.121.197.22:9000/albumDetail?singer="+singerName+"&album="+albumName)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode([String].self, from: data)
                        print(res[0])
                        
                        self.songs = res
                        
                        DispatchQueue.main.async {
                            self.songsTable.reloadData()
                            //self.songsTable.setNeedsLayout()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "Row", for: indexPath) as! TableViewCell
        
        row.songNumber.text = "#" + String(indexPath.item)
        row.songName.text = songs[indexPath.item]
        
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
