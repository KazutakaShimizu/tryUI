//
//  MoveTextFieldViewController.swift
//  TryUI
//
//  Created by 清水一貴 on 2016/12/14.
//  Copyright © 2016年 清水一貴. All rights reserved.
//

import UIKit

class MoveTextFieldViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        createSampleView()
        textField.delegate = self
    }
    
//    minyやminxの座標系を調べる
//    これは位置とサイズを足して、そのviewの最小端をさす
    private func createSampleView(){
        var sampleView = UIView(frame: CGRect(x: 100, y: 0, width: 500, height: 500))
        print(sampleView.frame.maxX)
        print(sampleView.frame.minX)
        sampleView.backgroundColor = UIColor.red
        view.addSubview(sampleView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nofitiShow = Notification.Name.UIKeyboardWillShow
        let nofitiHide = Notification.Name.UIKeyboardWillHide
        
        // Notification の追加
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: nofitiShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: nofitiHide,
            object: nil
        )
    }
    
    func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            
//            keyboardframeにはキーボードの位置やサイズの情報が、animationDurationにはアニメーションの時間が入っている
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
//                スクロールビューの位置をリセット
                restoreScrollViewSize()
//                keyboardFrameはview全体での座標なので、それをスクロールビュー用に変換する
//                scrollViewの大きさが画面全体なら、ここはいらない
                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                
//                textFieldの最下端の位置 - キーボードの最上端の位置
//                つまりキーボードがtextfieldにかかっているかどうかのチェック
                let offsetY: CGFloat = textField.frame.maxY - convertedKeyboardFrame.minY
                if offsetY < 0 { return }
//                スクロールビューをスクロールさせる
                updateScrollViewSize(moveSize: offsetY, duration: animationDuration)
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        restoreScrollViewSize()
    }
    
    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.contentOffset = CGPoint(x: 0, y: moveSize)
        
        UIView.commitAnimations()
    }
    
    func restoreScrollViewSize() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}
