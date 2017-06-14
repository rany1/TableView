//
//  RootViewController.swift
//  TableView
//
//  Created by ran on 2017/6/8.
//  Copyright © 2017年 ran. All rights reserved.
//

import  UIKit
let urlPath="http://wthrcdn.etouch.cn/weather_mini?city=%E5%8D%97%E4%BA%AC";
class RootViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate{
    
    var dataArr = NSMutableArray();
    var _tableView:UITableView?;
    
    var _connection : NSURLConnection?;
    var _receiveData : NSMutableData?;
    override func viewDidLoad() {
        super.viewDidLoad();
              var rect:CGRect = self.view.bounds;
        _tableView=UITableView(frame: rect, style: .plain);
        _tableView?.delegate=self as! UITableViewDelegate;
        _tableView?.dataSource=self as! UITableViewDataSource;
        self.view.addSubview(_tableView!);
        
        
        downData();
        
    }
    func downData(){
        let url=NSURL(string: urlPath);
        let request=NSURLRequest(url: url as! URL);
        _connection=NSURLConnection(request: request as URLRequest, delegate: self)!;
        
    }
    public func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count;
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellid = "my cell id";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid);
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid);
        }
        let weather = dataArr.object(at: indexPath.row) as! Weather;
        cell?.detailTextLabel?.text = weather.date as! String;
        cell?.detailTextLabel?.textAlignment = .center;
        //print( high.replacingOccurrences(of: "", with: "Optional"));
        
        cell?.textLabel?.text =  "最高：\(weather.high as! NSString) 最低\(weather.low as! NSString) \(weather.type as! NSString)";
        //cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(6))
        //cell?.textLabel?.font = UIFont .systemFont(ofSize: CGFloat(8))
        
        cell?.textLabel?.sizeToFit();
  //var s=dataArr.object(at: indexPath.row) as? String;
        //cell?.textLabel?.text=s.date;
        return cell!;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("row \(indexPath.row) is click")
    }
    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse)
    {
        _receiveData=NSMutableData();
        
    }
    
    public func connection(_ connection: NSURLConnection, didReceive data: Data)
    {
        _receiveData?.append(data);
    }
    public func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        let data=NSString(data: _receiveData! as Data, encoding: String.Encoding.utf8.rawValue);
        //print(data);
        //let WeatherArr=try? JSONSerialization.data(withJSONObject: _receiveData! as Data,options:.prettyPrinted);
      
        let WeatherArr = try? JSONSerialization.jsonObject(with: _receiveData! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary;
        //print(WeatherArr);

        let tmp = WeatherArr??["data"] as! NSDictionary;
        let forecast = tmp["forecast"] as! NSArray;
        print(forecast);
        for index in 0...(forecast.count-1) {
            //let weather =  as! NSDictionary;
            let weatherIndex=forecast[index] as! NSDictionary;
            var tempWeather = Weather();
            tempWeather.date = weatherIndex["date"] as! NSString;
            tempWeather.high = weatherIndex["high"] as! NSString;
            tempWeather.low = weatherIndex["low"] as! NSString;
            tempWeather.type = weatherIndex["type"] as! NSString;

            dataArr.add(tempWeather);
            print(tempWeather.high);
        }
      
        
        _tableView?.reloadData();
        
    }
}
