import UIKit
import CoreLocation

class WeatherViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var locationLab: UILabel!
    
    @IBOutlet weak var weatherImg: UIImageView!
    
    @IBOutlet weak var temperLab: UILabel!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLab: UILabel!
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //背部壁纸
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        navigationController?.topViewController.title = "天气查询"
        
        
        //加载标志
        loading.startAnimating()
            
        //定位精度为最高
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //
        if ios8() {
            locationManager.requestAlwaysAuthorization()
        }
        //开始定位
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //转化最后一个定位信息
        var location:CLLocation = locations[locations.count - 1] as! CLLocation
        
        if location.horizontalAccuracy > 0 {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
            //更新天气
            self.updateWeatherInfo(location.coordinate.latitude, longtitude: location.coordinate.longitude)
            
            //停止定位
            locationManager.stopUpdatingLocation()
        }
    }
    
    //更新天气
    func updateWeatherInfo(latitude:CLLocationDegrees,longtitude:CLLocationDegrees){
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat":latitude,"lon":longtitude,"cnt":0]
        Alamofire.manager.request(.GET, url, parameters: params).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, data, error) -> Void in
            if error == nil{
                println(data)
               self.updateUISuccess(data!)
            } else {
                self.loadingLab.text = "天气信息不可用"
            }
            
        }
    }
    
    func updateUISuccess(result:AnyObject){
        //加载标志
        loading.hidden = true
        loading.stopAnimating()
        loadingLab.hidden = true
        
        let json = JSON(result)
        //设置城市名
        let name = json["name"].stringValue
        locationLab.text = name
        //设置温度信息
        let temp = json["main"]["temp"].doubleValue
        var temper:Double
        if json["sys"]["country"].stringValue == "US" {
            temper = round(((temp - 273.15)*1.8)+32)
        }else {
            temper = round(temp - 273.15)
        }
        temperLab.text = "\(temper)℃"
        //temperLab.font = UIFont.boldSystemFontOfSize(50)
        
        var condition = json["weather"][0]["id"].intValue
        var sunrise = json["sys"]["sunrise"].doubleValue
        var sunset  = json["sys"]["sunset"].doubleValue
        
        var nightTime = false
        var now = NSDate().timeIntervalSince1970
        
        if (now < sunrise || now > sunset) {
            nightTime = true
        }
        
        updateWeatherIcon(condition, nightTime: nightTime)
    }
    
    func updateWeatherIcon(condition: Int,nightTime: Bool){
        if condition < 300 {
            if nightTime{
                weatherImg.image = UIImage(named: "tstorm1_night")
            }else{
                 weatherImg.image = UIImage(named: "tstorm1")
            }
        }else if condition < 500 {
            weatherImg.image = UIImage(named: "light_rain")
        }else if condition < 600 {
            weatherImg.image = UIImage(named: "shower3")
        }else if condition < 771 {
            if nightTime {
                weatherImg.image = UIImage(named: "fog_night")
            }else {
                weatherImg.image = UIImage(named: "fog")
            }
        }else if condition < 800 {
            weatherImg.image = UIImage(named: "tstorm3")
        }else if condition == 800 {
            if nightTime {
                weatherImg.image = UIImage(named: "sunny_night")
            }else {
                weatherImg.image = UIImage(named: "sunny")
            }
        }else if condition < 804 {
           weatherImg.image = UIImage(named: "overcast")
        }else if (condition >= 900 && condition<903 ) || (condition>904 && condition < 1000) {
            weatherImg.image = UIImage(named: "tstorm3")
        }else if condition == 903 {
            weatherImg.image = UIImage(named: "snow5")
        }else if condition == 904 {
            weatherImg.image = UIImage(named: "sunny")
        }else {
            weatherImg.image = UIImage(named: "dunno")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        loadingLab.text = "地理信息不可用"
    }
    
    func ios8() -> Bool{
        let iosversion = UIDevice.currentDevice().systemVersion as NSString
        
        return iosversion.doubleValue >= 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
