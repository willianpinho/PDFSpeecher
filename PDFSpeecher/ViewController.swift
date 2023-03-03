//
//  ViewController.swift
//  PDFSpeecher
//
//  Created by Willian Junior Peres de Pinho on 03/03/23.
//

import UIKit
import AVFoundation
import PDFKit

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let pdfView = PDFView()
    let selectPDFButton = UIButton()
    let speakButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPDFView()
        setupSelectPDFButton()
        setupSpeakButton()
        speechSynthesizer.delegate = self
    }
    
    func setupPDFView() {
        pdfView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 1.25)
        pdfView.backgroundColor = .black
        view.addSubview(pdfView)
    }
    
    func setupSelectPDFButton() {
        selectPDFButton.setTitle("Select PDF", for: .normal)
        selectPDFButton.frame = CGRect(x: 0, y: pdfView.frame.maxY + 20, width: view.frame.width, height: 50)
        selectPDFButton.addTarget(self, action: #selector(selectPDF), for: .touchUpInside)
        selectPDFButton.backgroundColor = UIColor(red: 0.2118, green: 0.2627, blue: 0.6078, alpha: 1.0)
        selectPDFButton.accessibilityLabel = "Select PDF"
        selectPDFButton.setTitleColor(.white, for: .normal)
        view.addSubview(selectPDFButton)
    }
    
    func setupSpeakButton() {
        speakButton.setTitle("Speak Text", for: .normal)
        speakButton.frame = CGRect(x: 0, y: selectPDFButton.frame.maxY + 20, width: view.frame.width, height: 50)
        speakButton.addTarget(self, action: #selector(speakPDF), for: .touchUpInside)
        speakButton.isEnabled = false
        speakButton.backgroundColor = UIColor(red: 0.9137, green: 0.502, blue: 0.1922, alpha: 1.0)
        speakButton.accessibilityLabel = "Speak"
        speakButton.setTitleColor(.white, for: .normal)
        speakButton.setTitle("No PDF", for: .disabled)
        speakButton.setTitleColor(.black, for: .disabled)
        view.addSubview(speakButton)
    }
    
    @objc func selectPDF() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
             UTType.pdf
        ], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc func speakPDF() {
        if speechSynthesizer.isSpeaking {
              if speechSynthesizer.isPaused {
                  speechSynthesizer.continueSpeaking()
              } else {
                  speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
              }
          } else {
              let text = pdfView.document?.string
              let speechUtterance = AVSpeechUtterance(string: text ?? "")
              speechUtterance.voice = AVSpeechSynthesisVoice(language: Locale.current.language.languageCode?.identifier)
              speechSynthesizer.speak(speechUtterance)
          }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            pdfView.document = PDFDocument(url: url)
            speakButton.isEnabled = true
        }
    }
}

