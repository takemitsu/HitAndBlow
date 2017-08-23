//
//  ViewController.swift
//  HitAndBlow
//
//  Created by takemitsu on 2017/08/21.
//  Copyright © 2017年 takemitsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var decideButton: UIButton!
    @IBOutlet weak var historyText: UITextView!
    
    
    var hbData:HbData = HbData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 入力履歴の枠線
        historyText.layer.borderColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0).cgColor
        historyText.layer.borderWidth = 1.0
        historyText.layer.masksToBounds = true
        historyText.layer.cornerRadius = 5.0
        // 編集できないように
        historyText.isEditable = false
        
        // 入力値が変化した場合のイベント登録
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: numberText)
        
        // ボタンは初期では無効
        decideButton.isEnabled = false
        
        // データ等を初期化
        self.initialize()
    }
    
    /// データやフィールドを初期化
    func initialize() {
        hbData.initialize()
        numberText.text = ""
        decideButton.isEnabled = false
        historyText.text = hbData.answerHistory.joined(separator: "\n")
        self.view.endEditing(true)
    }
    
    // 入力値が 4 桁以上入力できないように
    // 入力値が 4 桁の場合にボタンを有効化
    @objc private func textFieldDidChange(notification: NSNotification) {
        let textFieldString = notification.object as! UITextField
        if let text = textFieldString.text {
            if text.characters.count > 4 {
                numberText.text = text.substring(to: text.index(text.startIndex, offsetBy: 4))
            }
            if text.characters.count >= 4 {
                decideButton.isEnabled = true
            }
            else {
                decideButton.isEnabled = false
            }
        }
        else {
            decideButton.isEnabled = false
        }
    }
    
    /// 決定ボタン押下
    @IBAction func decideNumber(_ sender: UIButton) {
        self.view.endEditing(true)
        
        // 判定
        if hbData.isWin(ans: numberText.text!) {
            let alert = UIAlertController(title: "正解！", message: "\(hbData.answerCount)回目で正解しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            numberText.text = ""
            decideButton.isEnabled = false
        }
        historyText.text = hbData.answerHistory.joined(separator: "\n")
    }
    
    /// リセットボタン
    @IBAction func resetDatas(_ sender: UIButton) {
        // confirm
        let alert = UIAlertController(title: "リセットしますか？", message: "OKをタップすると隠された数字や履歴などがリセットされます", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (res) in
            print(res)
            self.initialize()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    /// 画面タップでキーボードを下げる
    @IBAction func tapGeneral(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

