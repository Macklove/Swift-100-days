import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var tempPetitions = [Petition]()
    var FiltredPetition = [Petition]()
    
    var urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self,action: #selector(ShowSourceFromWhere))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(RightBarButtonForText))

        performSelector(inBackground: #selector(FetchJson), with: nil)
    }
    
    @objc func FetchJson() {
        if let url = URL(string: urlString) {
             if let data = try? Data(contentsOf: url) {
                 parse(json: data)
                 return
                 }
             }
        performSelector(onMainThread: #selector(ShowError), with: nil, waitUntilDone: false)
    }
    
    

    @objc func RightBarButtonForText() {
        let ac = UIAlertController(title: "Для поиска введите текст.", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: GetBackAllPetitions))
        let searchAction = UIAlertAction(title: "Поиск", style: .default) {
            [weak self, weak ac] _ in
            guard let searchingWord = ac?.textFields?[0].text else { return }
            self?.FilteringPetitions(searchingWord)
         
        }
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
    
    
    func GetBackAllPetitions(_ action: UIAlertAction){
        tempPetitions = petitions
        tableView.reloadData()
    }
    
    func FilteringPetitions(_ word: String){
        FiltredPetition.removeAll()
        tempPetitions = petitions
        var found = 0
        var count = 0
        for petition in tempPetitions {
            if petition.body.contains(word) {
                FiltredPetition.append(tempPetitions[count].self)
                found += 1
            }
            count += 1
        }
        if found >= 1 {
            tempPetitions = FiltredPetition
            tableView.reloadData()
        }
    }
        
    
    @objc func ShowSourceFromWhere () {
        let ac = UIAlertController(title: "Источник", message: urlString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Полный", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func ShowError() {
        let ac = UIAlertController(title: "Ошибка подключения", message: "При установке соединения произошла ошибка. Пожалуйста, проверьте свое соединение и повторите попытку.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Полный", style: .default))
        present(ac, animated: true)
    }
    
    @objc func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tempPetitions = jsonPetitions.results
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(ShowError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = tempPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedPetition = tempPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
