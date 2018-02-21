//
//  UserTableViewController.swift
//  Instagram
//
//  Created by N Manisha Reddy on 2/16/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController ,UISearchBarDelegate{
    var usernames = [""]
    var users = [String: String]()
    var searchedArray = [""]
    var objectIds = [""]
    var isFollowing = ["" : true]
    var status = [""]
    var refresher:UIRefreshControl = UIRefreshControl()
    var isSearch = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func logout(_: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "logout", sender: self)
        
    }
    
    @objc func updateTable() {
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error)
            }
            else if let users = users {
                self.usernames.removeAll()
                self.objectIds.removeAll()
                self.isFollowing.removeAll()
                for user in users {
                    if let user = user as? PFUser {
                        if let username = user.username {
                            if let objectId = user.objectId {
                                let usernameElements = username.components(separatedBy: "@")
                                self.usernames.append(usernameElements[0])
                                self.objectIds.append(objectId)
//                                self.searchedArray = self.usernames

                                let query = PFQuery(className: "Following")
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("following", equalTo: objectId)
                                query.findObjectsInBackground(block: { (objects, error) in
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            self.isFollowing[objectId] = true
                                        }else {
                                            self.isFollowing[objectId] = false
                                            
                                        }
                                        if self.usernames.count == self.isFollowing.count{
                                        self.tableView.reloadData()
                                        self.refresher.endRefreshing()
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        refresher.addTarget(self, action: #selector(UserTableViewController.updateTable), for:UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        self.searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(isSearch) {
        return searchedArray.count
    }
        return usernames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell: cell, forRowAtIndexPath: indexPath as NSIndexPath)

               return cell
    }
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        if(isSearch){
            cell.textLabel?.text = searchedArray[forRowAtIndexPath.row]
//            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell.textLabel?.text = usernames[forRowAtIndexPath.row]
            if let followBool = isFollowing[objectIds[forRowAtIndexPath.row]] {
                if followBool {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }

        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = PFUser.query()
                query?.whereKey("username", notEqualTo: PFUser.current()?.username)
                query?.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for object in users {
                            if let user = object as? PFUser {
                                self.users[user.objectId!] = user.username!
                            }
                        }
                    }
        
                    let getFollowedUsersQuery = PFQuery(className: "Following")
                    getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()?.objectId)
                    getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                        if let followers = objects {
                            for follower in followers {
                                if let followedUser = follower["following"] {
                                    let query = PFQuery(className: "post")
                                    query.whereKey("userid", equalTo: followedUser)
                                    query.findObjectsInBackground(block: { (objects, error) in
                                        if let posts = objects {
                                            for post in posts {
                                                self.status.append(post["comment"] as! String)
                                            }
                                      
                                            if searchText.characters.count == 0 {
                                                self.isSearch = false;
                                                self.tableView.reloadData()
                                            } else {
                                                self.usernames.append(contentsOf: self.status)

                                                self.searchedArray = self.usernames.filter({ (text) -> Bool in
                                                    
                                                    let tmp: NSString = text as NSString
                                                    let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                                                    return range.location != NSNotFound
                                                })
                                                if(self.searchedArray.count == 0){
                                                    self.isSearch = false;
                                                } else {
                                                    self.isSearch = true;
                                                }
                                                self.tableView.reloadData()

                                        }
                                    
                                    }
                                })

                            
                                }
                            }
                        }
                    })
                    
                })
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let followBool = isFollowing[objectIds[indexPath.row]] {
            if followBool {
                isFollowing[objectIds[indexPath.row]] = false
                cell?.accessoryType = UITableViewCellAccessoryType.none
                let query = PFQuery(className: "Following")
                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                query.whereKey("following", equalTo: objectIds[indexPath.row])
                query.findObjectsInBackground(block: { (objects, error) in
                    if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                        }
                        }
                
                })

            } else {
                isFollowing[objectIds[indexPath.row]] = true

                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                let following = PFObject(className: "Following")
                following["follower"] = PFUser.current()?.objectId
                following["following"] = objectIds[indexPath.row]
                following.saveInBackground()

            }
        }
        
    }

   
}
